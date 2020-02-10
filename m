Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73390157C72
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgBJNhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbgBJMfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:01 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862D820873;
        Mon, 10 Feb 2020 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338099;
        bh=iW2erDbgdHRSyYnWrC6Cbf3Cy5uDHy6bDSkEM2YR5mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZyfcLKVk/3TBlBpS80Z1E5xoAqbKUjQAZJocWAyh2CF92lEgbTMp23xXLzazq+Ev
         1mPsvaXCjHpjM83ZY5RiHKjuOK4EHpExX35FcMQUJbowTtGbc0fls1IMaXcb8Nby5k
         m/XLzdyOD9/igN5dyALhXnm2A5/Lo7sAhTWA5DHo=
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
Subject: [PATCH 4.19 015/195] net_sched: fix an OOB access in cls_tcindex
Date:   Mon, 10 Feb 2020 04:31:13 -0800
Message-Id: <20200210122307.161447010@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -333,12 +333,31 @@ tcindex_set_parms(struct net *net, struc
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
 
 		if (tcindex_alloc_perfect_hash(net, cp) < 0)
 			goto errout;
-		for (i = 0; i < cp->hash; i++)
+		for (i = 0; i < min(cp->hash, p->hash); i++)
 			cp->perfect[i].res = p->perfect[i].res;
 		balloc = 1;
 	}
@@ -350,15 +369,6 @@ tcindex_set_parms(struct net *net, struc
 	if (old_r)
 		cr = r->res;
 
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
@@ -376,16 +386,6 @@ tcindex_set_parms(struct net *net, struc
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
 


