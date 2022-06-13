Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24B5492B3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352880AbiFMLUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353748AbiFMLT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E164B3B54E;
        Mon, 13 Jun 2022 03:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A6FB80E94;
        Mon, 13 Jun 2022 10:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D559C34114;
        Mon, 13 Jun 2022 10:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116895;
        bh=fAjevsgNN7Ppv3gJX01w6oeiKWkS74OX2dtq+OkZRa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0VQ/ZwNJKQ+ACIkGRKVFsPb6hE1K/yp9Pfrh8NTEh2agspP1eG9MpEakKwFGMIK4
         2fr0wQ5FvnURFOqbrkUQ222XRDpmLnSohuOwq4MBFu7zXqDhsSeb9cLv7VV787PtbJ
         pVPHuI/WrTzSDNFy9ya8OEnBUH8SQEONcp98AhqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 212/411] f2fs: fix deadloop in foreground GC
Date:   Mon, 13 Jun 2022 12:08:05 +0200
Message-Id: <20220613094935.011737155@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Chao Yu <chao@kernel.org>

commit cfd66bb715fd11fde3338d0660cffa1396adc27d upstream.

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
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -542,11 +542,10 @@ static inline int reserved_sections(stru
 	return GET_SEC_FROM_SEG(sbi, (unsigned int)reserved_segments(sbi));
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
 
@@ -572,19 +571,28 @@ static inline bool has_curseg_enough_spa
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
+	need_upper = need_lower + (node_blocks ? 1 : 0) + (dent_blocks ? 1 : 0);
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


