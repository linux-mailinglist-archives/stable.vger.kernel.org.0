Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C31F185
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfEOLSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbfEOLSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13EB020818;
        Wed, 15 May 2019 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919124;
        bh=oe99d7vc85xmRQGK6bO7FO1KcDpjQDJBJgR0TSKQnkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXBZaqfE296ii74nLUQHVRpF+Ijw7/FWaCpN4lB0s/OO2wJq9y5xA0BExDoKqrXLC
         F8PcZU9zw2epRdHaecFEk4h70uGFhfXYDCslBXgUHMFFYI1Oayw/i6Ivlup+17cJ+S
         hcJkNhVGUZpUKsi5+VrhSHQIa1QDyg11MxpqLEj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 076/115] net_sched: fix two more memory leaks in cls_tcindex
Date:   Wed, 15 May 2019 12:55:56 +0200
Message-Id: <20190515090704.931641411@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1db817e75f5b9387b8db11e37d5f0624eb9223e0 ]

struct tcindex_filter_result contains two parts:
struct tcf_exts and struct tcf_result.

For the local variable 'cr', its exts part is never used but
initialized without being released properly on success path. So
just completely remove the exts part to fix this leak.

For the local variable 'new_filter_result', it is never properly
released if not used by 'r' on success path.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/sched/cls_tcindex.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 52829fdc280b3..75c7c7cc74999 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -322,9 +322,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		  struct nlattr *est, bool ovr)
 {
 	struct tcindex_filter_result new_filter_result, *old_r = r;
-	struct tcindex_filter_result cr;
 	struct tcindex_data *cp = NULL, *oldp;
 	struct tcindex_filter *f = NULL; /* make gcc behave */
+	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
 
@@ -363,13 +363,10 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	cp->h = p->h;
 
 	err = tcindex_filter_result_init(&new_filter_result);
-	if (err < 0)
-		goto errout1;
-	err = tcindex_filter_result_init(&cr);
 	if (err < 0)
 		goto errout1;
 	if (old_r)
-		cr.res = r->res;
+		cr = r->res;
 
 	if (tb[TCA_TCINDEX_HASH])
 		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
@@ -460,8 +457,8 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (tb[TCA_TCINDEX_CLASSID]) {
-		cr.res.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
-		tcf_bind_filter(tp, &cr.res, base);
+		cr.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
+		tcf_bind_filter(tp, &cr, base);
 	}
 
 	if (old_r && old_r != r) {
@@ -473,7 +470,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	oldp = p;
-	r->res = cr.res;
+	r->res = cr;
 	tcf_exts_change(&r->exts, &e);
 
 	rcu_assign_pointer(tp->root, cp);
@@ -492,6 +489,8 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 				; /* nothing */
 
 		rcu_assign_pointer(*fp, f);
+	} else {
+		tcf_exts_destroy(&new_filter_result.exts);
 	}
 
 	if (oldp)
@@ -504,7 +503,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	else if (balloc == 2)
 		kfree(cp->h);
 errout1:
-	tcf_exts_destroy(&cr.exts);
 	tcf_exts_destroy(&new_filter_result.exts);
 errout:
 	kfree(cp);
-- 
2.20.1



