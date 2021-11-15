Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24C245243D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbhKPBgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242478AbhKOSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902446337F;
        Mon, 15 Nov 2021 18:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999586;
        bh=yKqXr6mODswJgskukADQbM0G2tcBrHQqkCQdQhr7CAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAyARwDrzwKsk9V7P/OloGrrS30J7xRTFdNfVLuHQfv/co6nJI9k2R41LE7Z8WwtJ
         hfroyo85QrDTF97UJKl0DWdj70OtoVd78AefqZUL6cNS/Se0npA9ddE4BZGNrSQOMc
         Ekj50Qh/azzYjRjqQQj+t9FaWo2VBEH8nlIfke84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 350/849] net: net_namespace: Fix undefined member in key_remove_domain()
Date:   Mon, 15 Nov 2021 17:57:13 +0100
Message-Id: <20211115165432.081003222@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit aed0826b0cf2e488900ab92193893e803d65c070 ]

The key_domain member in struct net only exists if we define CONFIG_KEYS.
So we should add the define when we used key_domain.

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b5a767eddd5f..073db7d0fa790 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -477,7 +477,9 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:
@@ -609,7 +611,9 @@ static void cleanup_net(struct work_struct *work)
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
 		dec_net_namespaces(net->ucounts);
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(net->user_ns);
 		net_drop_ns(net);
 	}
-- 
2.33.0



