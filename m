Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6716266420
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIKQby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgIKPTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81EC6223C8;
        Fri, 11 Sep 2020 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829130;
        bh=28sTi4CQh5jzkQmikquEFW4FGLEVT7HhCFTfebhfdqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKaQZWmC9BueIKxxtvPVK4sdxI0JsATirjQsNHc9VAjdVSUCCyZGrB5R1qKK4WK94
         jaDVNgAjDZ2E2ZwSRpMfWxJUiBdC80Anr9kLOWTfIy3P1djYmWf9qDvnooIRezJC0e
         58FVNEUhnQrkxPh3lFMRx3EEcNqLTsre0B/ODI7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Sherwood <rsher@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 71/71] net: disable netpoll on fresh napis
Date:   Fri, 11 Sep 2020 14:46:55 +0200
Message-Id: <20200911122508.482650346@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
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
@@ -5188,13 +5188,14 @@ void netif_napi_add(struct net_device *d
 		pr_err_once("netif_napi_add() called with weight %d on device %s\n",
 			    weight, dev->name);
 	napi->weight = weight;
-	list_add(&napi->dev_list, &dev->napi_list);
 	napi->dev = dev;
 #ifdef CONFIG_NETPOLL
 	spin_lock_init(&napi->poll_lock);
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
@@ -178,7 +178,7 @@ static void poll_napi(struct net_device
 {
 	struct napi_struct *napi;
 
-	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
 		if (napi->poll_owner != smp_processor_id() &&
 		    spin_trylock(&napi->poll_lock)) {
 			poll_one_napi(napi);


