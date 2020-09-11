Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBEB2660DD
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIKOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgIKNVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:21:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 139CA223EA;
        Fri, 11 Sep 2020 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829142;
        bh=UAs3Q/Zz9F5+9bZ42uUtir1voEsU5TfKbTq5cMt4HEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZz12LH5l7veTMDSJjDe3roefZRkQpr+qBcPF+3wWb4Ao4pZRsFdm3WS9oW7nypoW
         wiJpJU2wE/68XTJivVsTOz+jDtLMEGsdp6/x44JdgGquTKpLqncZu2Fh3WSTBas3bK
         1TnE8+Fu0fAtoVKl/e1SeKXK7dqMvAjJlsxUrKyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Sherwood <rsher@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 12/12] net: disable netpoll on fresh napis
Date:   Fri, 11 Sep 2020 14:47:06 +0200
Message-Id: <20200911122459.015758062@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 96e97bc07e90f175a8980a22827faf702ca4cb30 ]

napi_disable() makes sure to set the NAPI_STATE_NPSVC bit to prevent
netpoll from accessing rings before init is complete. However, the
same is not done for fresh napi instances in netif_napi_add(),
even though we expect NAPI instances to be added as disabled.

This causes crashes during driver reconfiguration (enabling XDP,
changing the channel count) - if there is any printk() after
netif_napi_add() but before napi_enable().

To ensure memory ordering is correct we need to use RCU accessors.

Reported-by: Rob Sherwood <rsher@fb.com>
Fixes: 2d8bff12699a ("netpoll: Close race condition between poll_one_napi and napi_disable")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c     |    3 ++-
 net/core/netpoll.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5532,12 +5532,13 @@ void netif_napi_add(struct net_device *d
 		pr_err_once("netif_napi_add() called with weight %d on device %s\n",
 			    weight, dev->name);
 	napi->weight = weight;
-	list_add(&napi->dev_list, &dev->napi_list);
 	napi->dev = dev;
 #ifdef CONFIG_NETPOLL
 	napi->poll_owner = -1;
 #endif
 	set_bit(NAPI_STATE_SCHED, &napi->state);
+	set_bit(NAPI_STATE_NPSVC, &napi->state);
+	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
 }
 EXPORT_SYMBOL(netif_napi_add);
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -179,7 +179,7 @@ static void poll_napi(struct net_device
 	struct napi_struct *napi;
 	int cpu = smp_processor_id();
 
-	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
 		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
 			poll_one_napi(napi);
 			smp_store_release(&napi->poll_owner, -1);


