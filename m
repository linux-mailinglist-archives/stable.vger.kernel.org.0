Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D786E6E05
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjDRVXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjDRVW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD2993D9;
        Tue, 18 Apr 2023 14:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF00160C83;
        Tue, 18 Apr 2023 21:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A2AC433D2;
        Tue, 18 Apr 2023 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852965;
        bh=sYI9UsazVjKjOWKIveWz3xOGXDtYBaYr8EkQP9p+ssg=;
        h=Date:To:From:Subject:From;
        b=RM4UPjzkRQJtQCGkqaZBVF8rY3jf0wCW5lLVV7cI9Y6f2CTXVoP5Jptce8sSSxhA1
         HoprECgGXAGoUc3AoKc8V2zspjNcz2ksMLKNvc6Czp+AlFFx5KZQ7MNU6U3V1WrGvK
         LQrQUO+xuDwZxKKkqSSQktTGLNnntnh6J/U2lyVw=
Date:   Tue, 18 Apr 2023 14:22:44 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rick.p.edgecombe@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-make-maple-state-reusable-after-mas_empty_area_rev.patch removed from -mm tree
Message-Id: <20230418212245.11A2AC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make maple state reusable after mas_empty_area_rev()
has been removed from the -mm tree.  Its filename was
     maple_tree-make-maple-state-reusable-after-mas_empty_area_rev.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: make maple state reusable after mas_empty_area_rev()
Date: Fri, 14 Apr 2023 10:57:26 -0400

Stop using maple state min/max for the range by passing through pointers
for those values.  This will allow the maple state to be reused without
resetting.

Also add some logic to fail out early on searching with invalid
arguments.

Link: https://lkml.kernel.org/r/20230414145728.4067069-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-maple-state-reusable-after-mas_empty_area_rev
+++ a/lib/maple_tree.c
@@ -4965,7 +4965,8 @@ not_found:
  * Return: True if found in a leaf, false otherwise.
  *
  */
-static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
+static bool mas_rev_awalk(struct ma_state *mas, unsigned long size,
+		unsigned long *gap_min, unsigned long *gap_max)
 {
 	enum maple_type type = mte_node_type(mas->node);
 	struct maple_node *node = mas_mn(mas);
@@ -5030,8 +5031,8 @@ static bool mas_rev_awalk(struct ma_stat
 
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset = offset;
-		mas->min = min;
-		mas->max = min + gap - 1;
+		*gap_min = min;
+		*gap_max = min + gap - 1;
 		return true;
 	}
 
@@ -5307,6 +5308,9 @@ int mas_empty_area(struct ma_state *mas,
 	unsigned long *pivots;
 	enum maple_type mt;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas))
 		mas_start(mas);
 	else if (mas->offset >= 2)
@@ -5361,6 +5365,9 @@ int mas_empty_area_rev(struct ma_state *
 {
 	struct maple_enode *last = mas->node;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas)) {
 		mas_start(mas);
 		mas->offset = mas_data_end(mas);
@@ -5380,7 +5387,7 @@ int mas_empty_area_rev(struct ma_state *
 	mas->index = min;
 	mas->last = max;
 
-	while (!mas_rev_awalk(mas, size)) {
+	while (!mas_rev_awalk(mas, size, &min, &max)) {
 		if (last == mas->node) {
 			if (!mas_rewind_node(mas))
 				return -EBUSY;
@@ -5395,17 +5402,9 @@ int mas_empty_area_rev(struct ma_state *
 	if (unlikely(mas->offset == MAPLE_NODE_SLOTS))
 		return -EBUSY;
 
-	/*
-	 * mas_rev_awalk() has set mas->min and mas->max to the gap values.  If
-	 * the maximum is outside the window we are searching, then use the last
-	 * location in the search.
-	 * mas->max and mas->min is the range of the gap.
-	 * mas->index and mas->last are currently set to the search range.
-	 */
-
 	/* Trim the upper limit to the max. */
-	if (mas->max <= mas->last)
-		mas->last = mas->max;
+	if (max <= mas->last)
+		mas->last = max;
 
 	mas->index = mas->last - size + 1;
 	return 0;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


