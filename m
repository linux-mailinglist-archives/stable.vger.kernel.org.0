Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879C76D8C76
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjDFBHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDFBHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C27E7EC5;
        Wed,  5 Apr 2023 18:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9A86429C;
        Thu,  6 Apr 2023 01:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A663AC433EF;
        Thu,  6 Apr 2023 01:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743225;
        bh=OuxK0USvona3H4ggOimygifJStv3YIXlK4DCzGnCwA4=;
        h=Date:To:From:Subject:From;
        b=N0oCNEb4V2+to00BcYr8r7Q8rwWx9HJl0FwpgEHGxcg4AyITr2YF79QoHzqMAiFyl
         CGxLiv6PoufhVmOH3lQQV5KjBgMDKIkY9hoTBFIwwZmL4HmtZznJfyGdQDYgG9A0U3
         fPRMkO0OwTYqNluWeqbwhRxhpB3pe+5WuxtiPqwc=
Date:   Wed, 05 Apr 2023 18:07:05 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch removed from -mm tree
Message-Id: <20230406010705.A663AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix get wrong data_end in mtree_lookup_walk()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix get wrong data_end in mtree_lookup_walk()
Date: Tue, 14 Mar 2023 20:42:01 +0800

if (likely(offset > end))
	max = pivots[offset];

The above code should be changed to if (likely(offset < end)), which is
correct.  This affects the correctness of ma_data_end().  Now it seems
that the final result will not be wrong, but it is best to change it. 
This patch does not change the code as above, because it simplifies the
code by the way.

Link: https://lkml.kernel.org/r/20230314124203.91572-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230314124203.91572-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk
+++ a/lib/maple_tree.c
@@ -3941,18 +3941,13 @@ static inline void *mtree_lookup_walk(st
 		end = ma_data_end(node, type, pivots, max);
 		if (unlikely(ma_dead_node(node)))
 			goto dead_node;
-
-		if (pivots[offset] >= mas->index)
-			goto next;
-
 		do {
-			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
-
-		if (likely(offset > end))
-			max = pivots[offset];
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
+		} while (++offset < end);
 
-next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
 		if (unlikely(ma_dead_node(node)))
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch

