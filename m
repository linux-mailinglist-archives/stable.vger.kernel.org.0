Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A8278803
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgIYMwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgIYMwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C757E2072E;
        Fri, 25 Sep 2020 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038324;
        bh=b5Wpjm1up6q4L0/jfnwWLFD4gMn0/33WnX8MqxYW5Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBgMc2II8oGDvDy8CnpJ2vkBd5hPAxjKVbDC6bCciyA+q8T6WnfZMR5KIAkVr0iPT
         GYvTPjZhS3PXXDeelKQObkbKha3f7GxY3rAXfgSCYhZ6ZyNfRKNmqITCIufx9MeNvC
         46P58bNjHuLFHLQYXoOks+F/Tr4t7IVnPYw1Wldk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
Subject: [PATCH 5.4 27/43] tipc: Fix memory leak in tipc_group_create_member()
Date:   Fri, 25 Sep 2020 14:48:39 +0200
Message-Id: <20200925124727.715131470@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit bb3a420d47ab00d7e1e5083286cab15235a96680 ]

tipc_group_add_to_tree() returns silently if `key` matches `nkey` of an
existing node, causing tipc_group_create_member() to leak memory. Let
tipc_group_add_to_tree() return an error in such a case, so that
tipc_group_create_member() can handle it properly.

Fixes: 75da2163dbb6 ("tipc: introduce communication groups")
Reported-and-tested-by: syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
Cc: Hillf Danton <hdanton@sina.com>
Link: https://syzkaller.appspot.com/bug?id=048390604fe1b60df34150265479202f10e13aff
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/group.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -273,8 +273,8 @@ static struct tipc_member *tipc_group_fi
 	return NULL;
 }
 
-static void tipc_group_add_to_tree(struct tipc_group *grp,
-				   struct tipc_member *m)
+static int tipc_group_add_to_tree(struct tipc_group *grp,
+				  struct tipc_member *m)
 {
 	u64 nkey, key = (u64)m->node << 32 | m->port;
 	struct rb_node **n, *parent = NULL;
@@ -291,10 +291,11 @@ static void tipc_group_add_to_tree(struc
 		else if (key > nkey)
 			n = &(*n)->rb_right;
 		else
-			return;
+			return -EEXIST;
 	}
 	rb_link_node(&m->tree_node, parent, n);
 	rb_insert_color(&m->tree_node, &grp->members);
+	return 0;
 }
 
 static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
@@ -302,6 +303,7 @@ static struct tipc_member *tipc_group_cr
 						    u32 instance, int state)
 {
 	struct tipc_member *m;
+	int ret;
 
 	m = kzalloc(sizeof(*m), GFP_ATOMIC);
 	if (!m)
@@ -314,8 +316,12 @@ static struct tipc_member *tipc_group_cr
 	m->port = port;
 	m->instance = instance;
 	m->bc_acked = grp->bc_snd_nxt - 1;
+	ret = tipc_group_add_to_tree(grp, m);
+	if (ret < 0) {
+		kfree(m);
+		return NULL;
+	}
 	grp->member_cnt++;
-	tipc_group_add_to_tree(grp, m);
 	tipc_nlist_add(&grp->dests, m->node);
 	m->state = state;
 	return m;


