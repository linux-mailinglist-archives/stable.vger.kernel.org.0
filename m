Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89790167628
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbgBUIJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731886AbgBUIJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1255A2073A;
        Fri, 21 Feb 2020 08:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272572;
        bh=veonelLyHYVdZEaWEmcvfnbE3w0QTXWIx3ruw3NtQm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZ81LAOTFdQcvqeUQlg3Rmttgy+tjynMK41j8hFE4sbNtxzwarVchKZKc57xfxdQO
         6ylnM2sMbp0cTRBctF1IqTofQoiIwhy7DBFhcC+vh54egxBNGAadIliaGwGKC/M8xp
         VcVNuE8zJQlCuJgQkjLeH4rNikEZLdmFBCTtXz7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/344] udf: Fix free space reporting for metadata and virtual partitions
Date:   Fri, 21 Feb 2020 08:39:53 +0100
Message-Id: <20200221072406.685900460@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 008bf96b1732d..4baa1ca91e9be 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2491,17 +2491,29 @@ static unsigned int udf_count_free_table(struct super_block *sb,
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
@@ -2510,7 +2522,7 @@ static unsigned int udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	map = &sbi->s_partmaps[sbi->s_partition];
+	map = &sbi->s_partmaps[part];
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
 					       map->s_uspace.s_bitmap);
-- 
2.20.1



