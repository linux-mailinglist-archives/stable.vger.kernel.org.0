Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2917D12F0CE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgABWSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgABWSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B055D2253D;
        Thu,  2 Jan 2020 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003524;
        bh=TiQKsBH6qvvSVNlJLrbTeIM1B76u/SMbKkb611bLAdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmFkZBhdCnsUMRBhY8QlRG0RlVJTImvjV+ekEHeQd38xCKYi/65FbLKrMiHlW6Idt
         CpYxcnlKWfm3DNaSHMz9tuc7XTbJOKCH0Af5mNKpJnkCXh5n1mfHUNJrjGDAB8FU5N
         DXRjDDhP4f4luPFHLnK7Igj80nAaQwW74TJSqR7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 177/191] gtp: fix wrong condition in gtp_genl_dump_pdp()
Date:   Thu,  2 Jan 2020 23:07:39 +0100
Message-Id: <20200102215848.247649694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 94a6d9fb88df43f92d943c32b84ce398d50bf49f ]

gtp_genl_dump_pdp() is ->dumpit() callback of GTP module and it is used
to dump pdp contexts. it would be re-executed because of dump packet size.

If dump packet size is too big, it saves current dump pointer
(gtp interface pointer, bucket, TID value) then it restarts dump from
last pointer.
Current GTP code allows adding zero TID pdp context but dump code
ignores zero TID value. So, last dump pointer will not be found.

In addition, this patch adds missing rcu_read_lock() in
gtp_genl_dump_pdp().

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -38,7 +38,6 @@ struct pdp_ctx {
 	struct hlist_node	hlist_addr;
 
 	union {
-		u64		tid;
 		struct {
 			u64	tid;
 			u16	flow;
@@ -1232,43 +1231,46 @@ static int gtp_genl_dump_pdp(struct sk_b
 				struct netlink_callback *cb)
 {
 	struct gtp_dev *last_gtp = (struct gtp_dev *)cb->args[2], *gtp;
+	int i, j, bucket = cb->args[0], skip = cb->args[1];
 	struct net *net = sock_net(skb->sk);
-	struct gtp_net *gn = net_generic(net, gtp_net_id);
-	unsigned long tid = cb->args[1];
-	int i, k = cb->args[0], ret;
 	struct pdp_ctx *pctx;
+	struct gtp_net *gn;
+
+	gn = net_generic(net, gtp_net_id);
 
 	if (cb->args[4])
 		return 0;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(gtp, &gn->gtp_dev_list, list) {
 		if (last_gtp && last_gtp != gtp)
 			continue;
 		else
 			last_gtp = NULL;
 
-		for (i = k; i < gtp->hash_size; i++) {
-			hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid) {
-				if (tid && tid != pctx->u.tid)
-					continue;
-				else
-					tid = 0;
-
-				ret = gtp_genl_fill_info(skb,
-							 NETLINK_CB(cb->skb).portid,
-							 cb->nlh->nlmsg_seq,
-							 cb->nlh->nlmsg_type, pctx);
-				if (ret < 0) {
+		for (i = bucket; i < gtp->hash_size; i++) {
+			j = 0;
+			hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i],
+						 hlist_tid) {
+				if (j >= skip &&
+				    gtp_genl_fill_info(skb,
+					    NETLINK_CB(cb->skb).portid,
+					    cb->nlh->nlmsg_seq,
+					    cb->nlh->nlmsg_type, pctx)) {
 					cb->args[0] = i;
-					cb->args[1] = pctx->u.tid;
+					cb->args[1] = j;
 					cb->args[2] = (unsigned long)gtp;
 					goto out;
 				}
+				j++;
 			}
+			skip = 0;
 		}
+		bucket = 0;
 	}
 	cb->args[4] = 1;
 out:
+	rcu_read_unlock();
 	return skb->len;
 }
 


