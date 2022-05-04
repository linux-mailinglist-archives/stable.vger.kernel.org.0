Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35AE51947E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 03:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245703AbiEDBzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 21:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343657AbiEDBw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 21:52:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE29244A3A;
        Tue,  3 May 2022 18:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F9461987;
        Wed,  4 May 2022 01:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817C5C385A9;
        Wed,  4 May 2022 01:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651628888;
        bh=1sRYRjLbt8trZsAxQP405ve5/+hZRzhVT+rXdU002IU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZIqODaO4EeJ3AGQlFrE98zItIkLii9TzICBsRd4HttDYp3pWa1CS91mDp0ZUG6rw7
         0CfC61X+QTB8CfkhI0IfKJTrK1XkCVKDbALRtn1/jIDPB5DgnezjcBpdxiqCgiSSQq
         RYy0Sr5k8tF72NreVxLBMxbHzhHejpdQD7l1ztACPs4V7bzwugXp19PXHC0yLQuLEw
         Zqphrb0YORYhyJR/9DFSPDwVegg6iCuFN3kzs+NeOaUfToWmH4IvpL7jbcKERBjYhU
         us+cOa1ec/2irqMEf8UQ3DkvRfQ/CKtyYEZQD26cQhblA2dk3l3Tz1Vrlsmix1UJY1
         FKD8FhW6pSJqQ==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH v2] f2fs: fix deadloop in foreground GC
Date:   Wed,  4 May 2022 09:47:55 +0800
Message-Id: <20220504014755.1727-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215914

The root cause is: in a very small sized image, it's very easy to
exceed threshold of foreground GC, if we calculate free space and
dirty data based on section granularity, in corner case,
has_not_enough_free_secs() will always return true, result in
deadloop in f2fs_gc().

So this patch refactors has_not_enough_free_secs() as below to fix
this issue:
1. calculate needed space based on block granularity, and separate
all blocks to two parts, section part, and block part, comparing
section part to free section, and comparing block part to free space
in openned log.
2. account F2FS_DIRTY_NODES, F2FS_DIRTY_IMETA and F2FS_DIRTY_DENTS
as node block consumer;
3. account F2FS_DIRTY_DENTS as data block consumer;

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
v2:
- fix performance regression
 fs/f2fs/segment.h | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 8a591455d796..c38263dbc5ca 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -575,11 +575,10 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
 	return GET_SEC_FROM_SEG(sbi, reserved_segments(sbi));
 }
 
-static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
+static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi,
+			unsigned int node_blocks, unsigned int dent_blocks)
 {
-	unsigned int node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
-					get_pages(sbi, F2FS_DIRTY_DENTS);
-	unsigned int dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
+
 	unsigned int segno, left_blocks;
 	int i;
 
@@ -605,19 +604,28 @@ static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
 static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi,
 					int freed, int needed)
 {
-	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
-	int dent_secs = get_blocktype_secs(sbi, F2FS_DIRTY_DENTS);
-	int imeta_secs = get_blocktype_secs(sbi, F2FS_DIRTY_IMETA);
+	unsigned int total_node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
+					get_pages(sbi, F2FS_DIRTY_DENTS) +
+					get_pages(sbi, F2FS_DIRTY_IMETA);
+	unsigned int total_dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
+	unsigned int node_secs = total_node_blocks / BLKS_PER_SEC(sbi);
+	unsigned int dent_secs = total_dent_blocks / BLKS_PER_SEC(sbi);
+	unsigned int node_blocks = total_node_blocks % BLKS_PER_SEC(sbi);
+	unsigned int dent_blocks = total_dent_blocks % BLKS_PER_SEC(sbi);
+	unsigned int free, need_lower, need_upper;
 
 	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		return false;
 
-	if (free_sections(sbi) + freed == reserved_sections(sbi) + needed &&
-			has_curseg_enough_space(sbi))
+	free = free_sections(sbi) + freed;
+	need_lower = node_secs + dent_secs + reserved_sections(sbi) + needed;
+	need_upper = need_lower + node_blocks ? 1 : 0 + dent_blocks ? 1 : 0;
+
+	if (free > need_upper)
 		return false;
-	return (free_sections(sbi) + freed) <=
-		(node_secs + 2 * dent_secs + imeta_secs +
-		reserved_sections(sbi) + needed);
+	else if (free <= need_lower)
+		return true;
+	return !has_curseg_enough_space(sbi, node_blocks, dent_blocks);
 }
 
 static inline bool f2fs_is_checkpoint_ready(struct f2fs_sb_info *sbi)
-- 
2.32.0

