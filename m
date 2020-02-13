Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7511D15C77E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgBMQLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgBMPW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:27 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ADDB246B3;
        Thu, 13 Feb 2020 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607346;
        bh=l9hB4+9/zkuZYMyXcbFNWryaHYe4kQ5IsGe3sUPuSJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5xU8peBdsMmyDmzxIUy/JpdaFmCl571d01v1SUIfckZYaPMPT/uo3QgXaVQc/8ED
         1vxQY6Ekjpuxca0U7Z8/iM3yZS4Ju34mGUclPNeONCreiHxQsq0QO8LDqERgGUieSv
         ZvMoaSdyuI4kdJkJgp4nWaIKTtPLfMCgHNK8NeR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
Subject: [PATCH 4.4 07/91] net_sched: fix an OOB access in cls_tcindex
Date:   Thu, 13 Feb 2020 07:19:24 -0800
Message-Id: <20200213151824.160265523@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 599be01ee567b61f4471ee8078870847d0a11e8e ]

As Eric noticed, tcindex_alloc_perfect_hash() uses cp->hash
to compute the size of memory allocation, but cp->hash is
set again after the allocation, this caused an out-of-bound
access.

So we have to move all cp->hash initialization and computation
before the memory allocation. Move cp->mask and cp->shift together
as cp->hash may need them for computation too.

Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_tcindex.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -267,6 +267,25 @@ tcindex_set_parms(struct net *net, struc
 	cp->fall_through = p->fall_through;
 	cp->tp = tp;
 
+	if (tb[TCA_TCINDEX_HASH])
+		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
+
+	if (tb[TCA_TCINDEX_MASK])
+		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
+
+	if (tb[TCA_TCINDEX_SHIFT])
+		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
+
+	if (!cp->hash) {
+		/* Hash not specified, use perfect hash if the upper limit
+		 * of the hashing index is below the threshold.
+		 */
+		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
+			cp->hash = (cp->mask >> cp->shift) + 1;
+		else
+			cp->hash = DEFAULT_HASH_SIZE;
+	}
+
 	if (p->perfect) {
 		int i;
 
@@ -274,7 +293,7 @@ tcindex_set_parms(struct net *net, struc
 				      sizeof(*r) * cp->hash, GFP_KERNEL);
 		if (!cp->perfect)
 			goto errout;
-		for (i = 0; i < cp->hash; i++)
+		for (i = 0; i < min(cp->hash, p->hash); i++)
 			tcf_exts_init(&cp->perfect[i].exts,
 				      TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 		balloc = 1;
@@ -286,15 +305,6 @@ tcindex_set_parms(struct net *net, struc
 	if (old_r)
 		cr.res = r->res;
 
-	if (tb[TCA_TCINDEX_HASH])
-		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
-
-	if (tb[TCA_TCINDEX_MASK])
-		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
-
-	if (tb[TCA_TCINDEX_SHIFT])
-		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-
 	err = -EBUSY;
 
 	/* Hash already allocated, make sure that we still meet the
@@ -312,16 +322,6 @@ tcindex_set_parms(struct net *net, struc
 	if (tb[TCA_TCINDEX_FALL_THROUGH])
 		cp->fall_through = nla_get_u32(tb[TCA_TCINDEX_FALL_THROUGH]);
 
-	if (!cp->hash) {
-		/* Hash not specified, use perfect hash if the upper limit
-		 * of the hashing index is below the threshold.
-		 */
-		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
-			cp->hash = (cp->mask >> cp->shift) + 1;
-		else
-			cp->hash = DEFAULT_HASH_SIZE;
-	}
-
 	if (!cp->perfect && !cp->h)
 		cp->alloc_hash = cp->hash;
 


