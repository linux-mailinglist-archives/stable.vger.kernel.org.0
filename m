Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B332C0A36
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbgKWMmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbgKWMlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EB992065E;
        Mon, 23 Nov 2020 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135314;
        bh=h7/Xx0WvMMsdZKjUT9fOgCQnebkFs0C7WZHTgd+ngwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrMZARUqW6ex1eqcWGYLeljfORwV66PKokibTZ2rZHFDWijeZiRPO4U6O+a9Rmo2A
         cbYBfK1ewE2qYMS1igkIZ3iFzyCXV4/v7p8KScE3lK5BJ1kHMju1NqPpXrTfeBK1Rl
         zY1DDElUZ1UQQk9uYRY7UiM3NJjX5GPIFbWtzWCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 024/252] netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
Date:   Mon, 23 Nov 2020 13:19:34 +0100
Message-Id: <20201123121836.764577872@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 866358ec331f8faa394995fb4b511af1db0247c8 ]

The current NetLabel code doesn't correctly keep track of the netlink
dump state in some cases, in particular when multiple interfaces with
large configurations are loaded.  The problem manifests itself by not
reporting the full configuration to userspace, even though it is
loaded and active in the kernel.  This patch fixes this by ensuring
that the dump state is properly reset when necessary inside the
netlbl_unlabel_staticlist() function.

Fixes: 8cc44579d1bd ("NetLabel: Introduce static network labels for unlabeled connections")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/160484450633.3752.16512718263560813473.stgit@sifl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_unlabeled.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1166,12 +1166,13 @@ static int netlbl_unlabel_staticlist(str
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
-	u32 iter_bkt;
-	u32 iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
+	u32 skip_addr4 = cb->args[2];
+	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
 	struct list_head *iter_list;
 	struct netlbl_af4list *addr4;
 #if IS_ENABLED(CONFIG_IPV6)
+	u32 skip_addr6 = cb->args[3];
 	struct netlbl_af6list *addr6;
 #endif
 
@@ -1182,7 +1183,7 @@ static int netlbl_unlabel_staticlist(str
 	rcu_read_lock();
 	for (iter_bkt = skip_bkt;
 	     iter_bkt < rcu_dereference(netlbl_unlhsh)->size;
-	     iter_bkt++, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0) {
+	     iter_bkt++) {
 		iter_list = &rcu_dereference(netlbl_unlhsh)->tbl[iter_bkt];
 		list_for_each_entry_rcu(iface, iter_list, list) {
 			if (!iface->valid ||
@@ -1190,7 +1191,7 @@ static int netlbl_unlabel_staticlist(str
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < cb->args[2])
+				if (iter_addr4++ < skip_addr4)
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1203,10 +1204,12 @@ static int netlbl_unlabel_staticlist(str
 					goto unlabel_staticlist_return;
 				}
 			}
+			iter_addr4 = 0;
+			skip_addr4 = 0;
 #if IS_ENABLED(CONFIG_IPV6)
 			netlbl_af6list_foreach_rcu(addr6,
 						   &iface->addr6_list) {
-				if (iter_addr6++ < cb->args[3])
+				if (iter_addr6++ < skip_addr6)
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1219,8 +1222,12 @@ static int netlbl_unlabel_staticlist(str
 					goto unlabel_staticlist_return;
 				}
 			}
+			iter_addr6 = 0;
+			skip_addr6 = 0;
 #endif /* IPv6 */
 		}
+		iter_chain = 0;
+		skip_chain = 0;
 	}
 
 unlabel_staticlist_return:


