Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA85974FA
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbiHQRWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 13:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiHQRWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 13:22:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44589F1BE
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 10:22:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-335cf0fd1a4so16909967b3.11
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 10:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=dSzSreqSgeWTr7IT3H9o9mfUnYWShCnFurU/IX78wck=;
        b=dTD3RFmREPolvh67EVgPCaiqfPyrzjLIQk3j7COquerAm7hUK1GISZwu7LhnAsS8rx
         9pHHdZosMxN0Q3SK3B5q37DPVuCJNtYYzBL6nVkLxz21xZhJitWg0GXoCxrcnTgN8Jwc
         Cr5luIxno/kD6ed4ki0W2eh7XGjQc8VFXxqH3HJvH6A2OuDxGL/lXQ3owGk29+tpha+2
         ZvsP4zzvlWLcA3uxDoxEtMWgbPdjTjufGW0fS4h0583eJL0YVXB6neXzbAJP86uUXlIq
         9xzV/+A/HP2bIMAMWJIsATEziLl0Gk+d/FJLCiZColNnBniWGGmvtH2DhvD94kXfi14T
         PTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=dSzSreqSgeWTr7IT3H9o9mfUnYWShCnFurU/IX78wck=;
        b=0R5A7URXYVqUPqNhLvdel596iMB3BUQmc9UNGKVxCxlOPX2t9oc5bXq51bkEFWPQkX
         XuuhX5O24Yx6TRI0hHkgEVzsGHSk37iBfNmqTUTpVHWcHbwE53MeGc75/X0tlxk/3Xop
         QdLXgpXQHhVE7QI1yRNfbc2ikz/Cdy19bMWevkdhojGMzQT2hUq8M86V9cm+0O0hlfoO
         U0ZLBpZCowBgN+QYFzIRVlnZbRMYPiQ6q04nm7MDOHiFu5LxK/oPlGkFB+8i3z2OGFkx
         +ZKVz2APN232+6aUSMXUNO4W2JfW8rjZESOfS5wuntzNNmfHsn9gIMucAxVHuBWsQ4a4
         IWgg==
X-Gm-Message-State: ACgBeo3n8lbcRuySMcFckEQOzrXoYwiZHVi7BJm1tEhqioS/8jobrUcN
        RCpjjNGApAmV+W9SO2K787bYMft9c4TXdg==
X-Google-Smtp-Source: AA6agR7jpqI5gHh0L3BshFzAgkpfAr7thcx3wVGMnmFl2krsRkYhz8IM1V25L53py8VgBd9yt3hx4SPwZCczSg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a5b:ac9:0:b0:67b:4ba1:cde7 with SMTP id
 a9-20020a5b0ac9000000b0067b4ba1cde7mr21506046ybr.70.1660756929175; Wed, 17
 Aug 2022 10:22:09 -0700 (PDT)
Date:   Wed, 17 Aug 2022 17:21:39 +0000
Message-Id: <20220817172139.3141101-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] Revert "memcg: cleanup racy sum avoidance code"
From:   Shakeel Butt <shakeelb@google.com>
To:     "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Greg Thelen <gthelen@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 96e51ccf1af33e82f429a0d6baebba29c6448d0f.

Recently we started running the kernel with rstat infrastructure on
production traffic and begin to see negative memcg stats values.
Particularly the 'sock' stat is the one which we observed having
negative value.

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 18446744073708724224

Re-run after couple of seconds

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 53248

For now we are only seeing this issue on large machines (256 CPUs) and
only with 'sock' stat. I think the networking stack increase the stat on
one cpu and decrease it on another cpu much more often. So, this
negative sock is due to rstat flusher flushing the stats on the CPU that
has seen the decrement of sock but missed the CPU that has increments. A
typical race condition.

For easy stable backport, revert is the most simple solution. For long
term solution, I am thinking of two directions. First is just reduce the
race window by optimizing the rstat flusher. Second is if the reader
sees a negative stat value, force flush and restart the stat collection.
Basically retry but limited.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: stable@vger.kernel.org # 5.15
---
 include/linux/memcontrol.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce55b1c0..6257867fbf95 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -987,19 +987,30 @@ static inline void mod_memcg_page_state(struct page *page,
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	return READ_ONCE(memcg->vmstats.state[idx]);
+	long x = READ_ONCE(memcg->vmstats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
+	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(pn->lruvec_stats.state[idx]);
+	x = READ_ONCE(pn->lruvec_stats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
-- 
2.37.1.595.g718a3a8f04-goog

