Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870A3C153F
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbfI2OCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730172AbfI2OCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857132082F;
        Sun, 29 Sep 2019 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765738;
        bh=FmS9RSxkmpcM7EGZeoMX6FT8PZ2H3HMXCjeWmc83o0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0eLajewpU0Bz1mHNxgASY85myK02DUWUpBPQLa58invLSGmB7kKc7ruUdwhSS810
         LZjHhkfhUF539kUWaBno0lzaO/rMw4FuO+LqHEQj57EQHi/ZR/SK53GfwS64lrZXwm
         VAaDBAgkng5zG8ucU6GlRhGyKo9p7Vh4V+ldRD6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 45/45] net/rds: An rds_sock is added too early to the hash table
Date:   Sun, 29 Sep 2019 15:56:13 +0200
Message-Id: <20190929135035.016426398@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

[ Upstream commit c5c1a030a7dbf8dd4e1fa4405ae9a89dc1d2a8db ]

In rds_bind(), an rds_sock is added to the RDS bind hash table before
rs_transport is set.  This means that the socket can be found by the
receive code path when rs_transport is NULL.  And the receive code
path de-references rs_transport for congestion update check.  This can
cause a panic.  An rds_sock should not be added to the bind hash table
before all the needed fields are set.

Reported-by: syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/bind.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/rds/bind.c b/net/rds/bind.c
index 0f4398e7f2a7a..05464fd7c17af 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -239,34 +239,30 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	}
 
-	sock_set_flag(sk, SOCK_RCU_FREE);
-	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
-	if (ret)
-		goto out;
-
-	if (rs->rs_transport) { /* previously bound */
+	/* The transport can be set using SO_RDS_TRANSPORT option before the
+	 * socket is bound.
+	 */
+	if (rs->rs_transport) {
 		trans = rs->rs_transport;
 		if (trans->laddr_check(sock_net(sock->sk),
 				       binding_addr, scope_id) != 0) {
 			ret = -ENOPROTOOPT;
-			rds_remove_bound(rs);
-		} else {
-			ret = 0;
+			goto out;
 		}
-		goto out;
-	}
-	trans = rds_trans_get_preferred(sock_net(sock->sk), binding_addr,
-					scope_id);
-	if (!trans) {
-		ret = -EADDRNOTAVAIL;
-		rds_remove_bound(rs);
-		pr_info_ratelimited("RDS: %s could not find a transport for %pI6c, load rds_tcp or rds_rdma?\n",
-				    __func__, binding_addr);
-		goto out;
+	} else {
+		trans = rds_trans_get_preferred(sock_net(sock->sk),
+						binding_addr, scope_id);
+		if (!trans) {
+			ret = -EADDRNOTAVAIL;
+			pr_info_ratelimited("RDS: %s could not find a transport for %pI6c, load rds_tcp or rds_rdma?\n",
+					    __func__, binding_addr);
+			goto out;
+		}
+		rs->rs_transport = trans;
 	}
 
-	rs->rs_transport = trans;
-	ret = 0;
+	sock_set_flag(sk, SOCK_RCU_FREE);
+	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
 
 out:
 	release_sock(sk);
-- 
2.20.1



