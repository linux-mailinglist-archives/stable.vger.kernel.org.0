Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571462C0AFA
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgKWMeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729972AbgKWMeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E506920857;
        Mon, 23 Nov 2020 12:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134858;
        bh=X7IQTV06GLMc7S6Z3Guj6ByADsUUblVu0PjW5khw4Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9SY+XDcPnjGsYZXGTcl7OD01MiuNsuqwDJi9FQKuRhpw3Df/oTqY0Ls937sLUeqP
         YperxYqXVmuH5YSmSYSXITjYEBFKCD17V+FJnbMGDqXxiTGVGKopf+pTwZf8KFC46O
         b5x+MryQ3X3Fnh8fZ9tIXKjYsH8FpHqla+r9B6L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 016/158] netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
Date:   Mon, 23 Nov 2020 13:20:44 +0100
Message-Id: <20201123121820.719867109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
@@ -1165,12 +1165,13 @@ static int netlbl_unlabel_staticlist(str
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
 
@@ -1181,7 +1182,7 @@ static int netlbl_unlabel_staticlist(str
 	rcu_read_lock();
 	for (iter_bkt = skip_bkt;
 	     iter_bkt < rcu_dereference(netlbl_unlhsh)->size;
-	     iter_bkt++, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0) {
+	     iter_bkt++) {
 		iter_list = &rcu_dereference(netlbl_unlhsh)->tbl[iter_bkt];
 		list_for_each_entry_rcu(iface, iter_list, list) {
 			if (!iface->valid ||
@@ -1189,7 +1190,7 @@ static int netlbl_unlabel_staticlist(str
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < cb->args[2])
+				if (iter_addr4++ < skip_addr4)
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1202,10 +1203,12 @@ static int netlbl_unlabel_staticlist(str
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
@@ -1218,8 +1221,12 @@ static int netlbl_unlabel_staticlist(str
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


