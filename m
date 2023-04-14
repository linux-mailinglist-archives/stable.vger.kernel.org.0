Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89C66E2AA3
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 21:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjDNTcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 15:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDNTcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 15:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B5246B7;
        Fri, 14 Apr 2023 12:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AB0644C6;
        Fri, 14 Apr 2023 19:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67605C433EF;
        Fri, 14 Apr 2023 19:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681500719;
        bh=CHnb+YS/pi56jwb915hk8PW2Bo6vHKUIU6aKlydhZho=;
        h=Date:To:From:Subject:From;
        b=0T0WjsfNKJ1AxD49se+bS0rD9gbiV0g4uytJ1wIlhSCb4UNqo8sa4Z8glVQueUmaL
         ZxuhX4PHqKeV5LJfD8aA0m24iOxld6lLaBnbdaBRhvaoyRApQPZANzvrUfVA8l8Ug1
         e5EhVNMEGQS0xFoBSBkY2bmTu8zIELMW5qqvljyI=
Date:   Fri, 14 Apr 2023 12:31:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rick.p.edgecombe@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_empty_area-search.patch added to mm-hotfixes-unstable branch
Message-Id: <20230414193159.67605C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_empty_area() search
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_empty_area-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_empty_area-search.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_empty_area() search
Date: Fri, 14 Apr 2023 10:57:27 -0400

The internal function of mas_awalk() was incorrectly skipping the last
entry in a node, which could potentially be NULL.  This is only a problem
for the left-most node in the tree - otherwise that NULL would not exist.

Fix mas_awalk() by using the metadata to obtain the end of the node for
the loop and the logical pivot as apposed to the raw pivot value.

Link: https://lkml.kernel.org/r/20230414145728.4067069-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_empty_area-search
+++ a/lib/maple_tree.c
@@ -5056,10 +5056,10 @@ static inline bool mas_anode_descend(str
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char offset;
-	unsigned long *gaps;
-	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
-	void __rcu **slots = ma_slots(mas_mn(mas), type);
+	unsigned char offset, data_end;
+	unsigned long *gaps, *pivots;
+	void __rcu **slots;
+	struct maple_node *node;
 	bool found = false;
 
 	if (ma_is_dense(type)) {
@@ -5067,13 +5067,15 @@ static inline bool mas_anode_descend(str
 		return true;
 	}
 
-	gaps = ma_gaps(mte_to_node(mas->node), type);
+	node = mas_mn(mas);
+	pivots = ma_pivots(node, type);
+	slots = ma_slots(node, type);
+	gaps = ma_gaps(node, type);
 	offset = mas->offset;
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < mt_slots[type]; offset++) {
-		pivot = mas_safe_pivot(mas, pivots, offset, type);
-		if (offset && !pivot)
-			break;
+	data_end = ma_data_end(node, type, pivots, mas->max);
+	for (; offset <= data_end; offset++) {
+		pivot = mas_logical_pivot(mas, pivots, offset, type);
 
 		/* Not within lower bounds */
 		if (mas->index > pivot)
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch
mm-mempolicy-fix-use-after-free-of-vma-iterator.patch
maple_tree-make-maple-state-reusable-after-mas_empty_area_rev.patch
maple_tree-fix-mas_empty_area-search.patch
mm-mmap-regression-fix-for-unmapped_area_topdown.patch

