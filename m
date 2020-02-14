Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AFB15E512
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390574AbgBNQjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403862AbgBNQXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E40924762;
        Fri, 14 Feb 2020 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697387;
        bh=tGdP8o+5wmH2dix7IVUCYODW9Z+SAHSKNrxu6lyRy8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjdcrBQvlKIyWMI+UyT/PK84KAKSNdCo4yGu8Ow472xnMkWb+Y8MncRnBJ3DvRflX
         no4nykr5OpEt3LhoW+c9+H1s+URzr96MZv9h0DDYGazqn52O/0zicr7zf9beeQAIfI
         w8e13oMJlT93SWC9HxW07ldo2/r5AHyYobVE/IoY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 083/141] udf: Fix free space reporting for metadata and virtual partitions
Date:   Fri, 14 Feb 2020 11:20:23 -0500
Message-Id: <20200214162122.19794-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit a4a8b99ec819ca60b49dc582a4287ef03411f117 ]

Free space on filesystems with metadata or virtual partition maps
currently gets misreported. This is because these partitions are just
remapped onto underlying real partitions from which keep track of free
blocks. Take this remapping into account when counting free blocks as
well.

Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Reported-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 03369a89600e0..4abdba453885e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2460,17 +2460,29 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
-	struct udf_sb_info *sbi;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
+	unsigned int part = sbi->s_partition;
+	int ptype = sbi->s_partmaps[part].s_partition_type;
+
+	if (ptype == UDF_METADATA_MAP25) {
+		part = sbi->s_partmaps[part].s_type_specific.s_metadata.
+							s_phys_partition_ref;
+	} else if (ptype == UDF_VIRTUAL_MAP15 || ptype == UDF_VIRTUAL_MAP20) {
+		/*
+		 * Filesystems with VAT are append-only and we cannot write to
+ 		 * them. Let's just report 0 here.
+		 */
+		return 0;
+	}
 
-	sbi = UDF_SB(sb);
 	if (sbi->s_lvid_bh) {
 		struct logicalVolIntegrityDesc *lvid =
 			(struct logicalVolIntegrityDesc *)
 			sbi->s_lvid_bh->b_data;
-		if (le32_to_cpu(lvid->numOfPartitions) > sbi->s_partition) {
+		if (le32_to_cpu(lvid->numOfPartitions) > part) {
 			accum = le32_to_cpu(
-					lvid->freeSpaceTable[sbi->s_partition]);
+					lvid->freeSpaceTable[part]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
@@ -2479,7 +2491,7 @@ static unsigned int udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	map = &sbi->s_partmaps[sbi->s_partition];
+	map = &sbi->s_partmaps[part];
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
 					       map->s_uspace.s_bitmap);
-- 
2.20.1

