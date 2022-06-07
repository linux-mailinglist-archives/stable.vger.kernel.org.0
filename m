Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986FC540AF2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352932AbiFGSWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353026AbiFGSRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09E5ED8FE;
        Tue,  7 Jun 2022 10:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DBDEB82367;
        Tue,  7 Jun 2022 17:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A7CC341C0;
        Tue,  7 Jun 2022 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624375;
        bh=bz7qy5pyPwBaKyQbQUEyFWt3Wa2amBmgS37YeKLnmoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQcNHrdq+8T53a4G6pHd7SRHZK9R5LAPWxzJIPgqD0NJ775GkULIEiQyXSrY/5+gU
         WuHgJx8A/LaZiGUUjs+iuktnS+XpcgYil7Zaxj1435skPFyRvvhk3JREV0AfwqFzlk
         1qOgZP4T+Xx4WyN4c+KLEFdyKLK7QQYE9ipEcahsBpPT9VCQI1P4AcNV1VaOwuLrnJ
         EMu5GAQaqLLx6Hnpc7Bha1bpNr3PYcBuPRS4LXUjVnHBLdgTlumjHzlJwgDUactq8Y
         0th/8brEaNN8hxlCIsfey2tVPmufh+Z9cXG+xG9iuZjYXqQg81BhEua3/hAwqXgZfP
         rgrip51HB8qog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 68/68] nodemask: Fix return values to be unsigned
Date:   Tue,  7 Jun 2022 13:48:34 -0400
Message-Id: <20220607174846.477972-68-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 0dfe54071d7c828a02917b595456bfde1afdddc9 ]

The nodemask routines had mixed return values that provided potentially
signed return values that could never happen. This was leading to the
compiler getting confusing about the range of possible return values
(it was thinking things could be negative where they could not be). Fix
all the nodemask routines that should be returning unsigned
(or bool) values. Silences:

 mm/swapfile.c: In function ‘setup_swap_info’:
 mm/swapfile.c:2291:47: error: array subscript -1 is below array bounds of ‘struct plist_node[]’ [-Werror=array-bounds]
  2291 |                                 p->avail_lists[i].prio = 1;
       |                                 ~~~~~~~~~~~~~~^~~
 In file included from mm/swapfile.c:16:
 ./include/linux/swap.h:292:27: note: while referencing ‘avail_lists’
   292 |         struct plist_node avail_lists[]; /*
       |                           ^~~~~~~~~~~

Reported-by: Christophe de Dinechin <dinechin@redhat.com>
Link: https://lore.kernel.org/lkml/20220414150855.2407137-3-dinechin@redhat.com/
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nodemask.h | 38 +++++++++++++++++++-------------------
 lib/nodemask.c           |  4 ++--
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 567c3ddba2c4..2c39663c3407 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -42,11 +42,11 @@
  * void nodes_shift_right(dst, src, n)	Shift right
  * void nodes_shift_left(dst, src, n)	Shift left
  *
- * int first_node(mask)			Number lowest set bit, or MAX_NUMNODES
- * int next_node(node, mask)		Next node past 'node', or MAX_NUMNODES
- * int next_node_in(node, mask)		Next node past 'node', or wrap to first,
+ * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
+ * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
+ * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
  *					or MAX_NUMNODES
- * int first_unset_node(mask)		First node not set in mask, or 
+ * unsigned int first_unset_node(mask)	First node not set in mask, or
  *					MAX_NUMNODES
  *
  * nodemask_t nodemask_of_node(node)	Return nodemask with bit 'node' set
@@ -153,7 +153,7 @@ static inline void __nodes_clear(nodemask_t *dstp, unsigned int nbits)
 
 #define node_test_and_set(node, nodemask) \
 			__node_test_and_set((node), &(nodemask))
-static inline int __node_test_and_set(int node, nodemask_t *addr)
+static inline bool __node_test_and_set(int node, nodemask_t *addr)
 {
 	return test_and_set_bit(node, addr->bits);
 }
@@ -200,7 +200,7 @@ static inline void __nodes_complement(nodemask_t *dstp,
 
 #define nodes_equal(src1, src2) \
 			__nodes_equal(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_equal(const nodemask_t *src1p,
+static inline bool __nodes_equal(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
@@ -208,7 +208,7 @@ static inline int __nodes_equal(const nodemask_t *src1p,
 
 #define nodes_intersects(src1, src2) \
 			__nodes_intersects(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_intersects(const nodemask_t *src1p,
+static inline bool __nodes_intersects(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
@@ -216,20 +216,20 @@ static inline int __nodes_intersects(const nodemask_t *src1p,
 
 #define nodes_subset(src1, src2) \
 			__nodes_subset(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_subset(const nodemask_t *src1p,
+static inline bool __nodes_subset(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_empty(src) __nodes_empty(&(src), MAX_NUMNODES)
-static inline int __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define nodes_full(nodemask) __nodes_full(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_full(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_full(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
@@ -260,15 +260,15 @@ static inline void __nodes_shift_left(nodemask_t *dstp,
           > MAX_NUMNODES, then the silly min_ts could be dropped. */
 
 #define first_node(src) __first_node(&(src))
-static inline int __first_node(const nodemask_t *srcp)
+static inline unsigned int __first_node(const nodemask_t *srcp)
 {
-	return min_t(int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
+	return min_t(unsigned int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
 }
 
 #define next_node(n, src) __next_node((n), &(src))
-static inline int __next_node(int n, const nodemask_t *srcp)
+static inline unsigned int __next_node(int n, const nodemask_t *srcp)
 {
-	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
+	return min_t(unsigned int, MAX_NUMNODES, find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
 /*
@@ -276,7 +276,7 @@ static inline int __next_node(int n, const nodemask_t *srcp)
  * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
  */
 #define next_node_in(n, src) __next_node_in((n), &(src))
-int __next_node_in(int node, const nodemask_t *srcp);
+unsigned int __next_node_in(int node, const nodemask_t *srcp);
 
 static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 {
@@ -296,9 +296,9 @@ static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 })
 
 #define first_unset_node(mask) __first_unset_node(&(mask))
-static inline int __first_unset_node(const nodemask_t *maskp)
+static inline unsigned int __first_unset_node(const nodemask_t *maskp)
 {
-	return min_t(int,MAX_NUMNODES,
+	return min_t(unsigned int, MAX_NUMNODES,
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
@@ -436,11 +436,11 @@ static inline int num_node_state(enum node_states state)
 
 #define first_online_node	first_node(node_states[N_ONLINE])
 #define first_memory_node	first_node(node_states[N_MEMORY])
-static inline int next_online_node(int nid)
+static inline unsigned int next_online_node(int nid)
 {
 	return next_node(nid, node_states[N_ONLINE]);
 }
-static inline int next_memory_node(int nid)
+static inline unsigned int next_memory_node(int nid)
 {
 	return next_node(nid, node_states[N_MEMORY]);
 }
diff --git a/lib/nodemask.c b/lib/nodemask.c
index 3aa454c54c0d..e22647f5181b 100644
--- a/lib/nodemask.c
+++ b/lib/nodemask.c
@@ -3,9 +3,9 @@
 #include <linux/module.h>
 #include <linux/random.h>
 
-int __next_node_in(int node, const nodemask_t *srcp)
+unsigned int __next_node_in(int node, const nodemask_t *srcp)
 {
-	int ret = __next_node(node, srcp);
+	unsigned int ret = __next_node(node, srcp);
 
 	if (ret == MAX_NUMNODES)
 		ret = __first_node(srcp);
-- 
2.35.1

