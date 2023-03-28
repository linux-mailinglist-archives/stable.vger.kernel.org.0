Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8FB6CC47D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbjC1PFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjC1PFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B8EB7E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B2D617E5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F12C4339B;
        Tue, 28 Mar 2023 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015825;
        bh=vTMdydJMScue0jW5F1Pj1giYTXUw2X+6eHRRQ0ndXJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmQsMJR5q8P0/SlFtcHEG8yBvsryOCV326lR8m3lMQxbBttnR0dDhPcEL0lN++6KP
         6j7SNV4RwywxQ6dX6DLQ21aUWVac+fkWggVMTN1K3yECToGrRQB0CONXXndVrltpz5
         aLLy9955hoMOalOYMvVQx+G/t8F0ks/DnH4Veg4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Snild Dolkow <snild@sony.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 190/224] maple_tree: fix mas_skip_node() end slot detection
Date:   Tue, 28 Mar 2023 16:43:06 +0200
Message-Id: <20230328142625.293678580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 0fa99fdfe1b38da396d0b2d1496a823bcd0ebea0 upstream.

Patch series "Fix mas_skip_node() for mas_empty_area()", v2.

mas_empty_area() was incorrectly returning an error when there was room.
The issue was tracked down to mas_skip_node() using the incorrect
end-of-slot count.  Instead of using the nodes hard limit, the limit of
data should be used.

mas_skip_node() was also setting the min and max to that of the child
node, which was unnecessary.  Within these limits being set, there was
also a bug that corrupted the maple state's max if the offset was set to
the maximum node pivot.  The bug was without consequence unless there was
a sufficient gap in the next child node which would cause an error to be
returned.

This patch set fixes these errors by removing the limit setting from
mas_skip_node() and uses the mas_data_end() for slot limits, and adds
tests for all failures discovered.


This patch (of 2):

mas_skip_node() is used to move the maple state to the node with a higher
limit.  It does this by walking up the tree and increasing the slot count.
Since slot count may not be able to be increased, it may need to walk up
multiple times to find room to walk right to a higher limit node.  The
limit of slots that was being used was the node limit and not the last
location of data in the node.  This would cause the maple state to be
shifted outside actual data and enter an error state, thus returning
-EBUSY.

The result of the incorrect error state means that mas_awalk() would
return an error instead of finding the allocation space.

The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
data end point and continue walking the tree up until it is safe to move
to a node with a higher limit.

The walk up the tree also sets the maple state limits so remove the buggy
code from mas_skip_node().  Setting the limits had the unfortunate side
effect of triggering another bug if the parent node was full and the there
was no suitable gap in the second last child, but room in the next child.

mas_skip_node() may also be passed a maple state in an error state from
mas_anode_descend() when no allocations are available.  Return on such an
error state immediately.

Link: https://lkml.kernel.org/r/20230307180247.2220303-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230307180247.2220303-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Snild Dolkow <snild@sony.com>
  Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Tested-by: Snild Dolkow <snild@sony.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5088,35 +5088,21 @@ static inline bool mas_rewind_node(struc
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
-	unsigned long *pivots;
-	enum maple_type mt;
+	if (mas_is_err(mas))
+		return false;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
-
-	mas->offset = ++slot;
-	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	} while (mas->offset >= mas_data_end(mas));
 
+	mas->offset++;
 	return true;
 }
 


