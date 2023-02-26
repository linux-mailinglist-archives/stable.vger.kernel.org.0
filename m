Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0179B6A2D8F
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBZDoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjBZDnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:43:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5299715CA7;
        Sat, 25 Feb 2023 19:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0233B80B8A;
        Sun, 26 Feb 2023 03:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77E6C4339B;
        Sun, 26 Feb 2023 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383000;
        bh=wbH97Sj2eZvNELWtv+807G/ZnXgNxOb0xgxdJ/csU94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlqyKZnHVHk+1a14uoouIjzqitlOh6fczjZ24cDqoBLR4OW66WqDOUUKLB0zkB+fo
         5akmWwfHeEPawNuoU4uRLeyX6GaaEfWs8gaXcQeQOHWLntsOLbEl5045kX91FgKDro
         K6Yjh/8TI3o7Ke4kETiO6Gt/+o+0RPT45AKTyOuWHsFKHSKnX6c8bALpSzy25SBaZq
         efCjyV8XIn/y2FM0K0F9KbP2iVGxmNNUw4Hjx03KrMgEKAKzbuX+z3V4OfkgkoF7wP
         MG9Lr9ySYwzSq6ic4mxs36XkkqQ0I4kDI8D88vw6jsdtoZ3hEye3ZubC/3e4vo9e4R
         B/i1fU3z22i+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 14/21] btrfs: scrub: improve tree block error reporting
Date:   Sat, 25 Feb 2023 22:42:49 -0500
Message-Id: <20230226034256.771769-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 28232909ba43561887508a6ef46d7f33a648f375 ]

[BUG]
When debugging a scrub related metadata error, it turns out that our
metadata error reporting is not ideal.

The only 3 error messages are:

- BTRFS error (device dm-2): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 1
  Showing we have metadata generation mismatch errors.

- BTRFS error (device dm-2): unable to fixup (regular) error at logical 7110656 on dev /dev/mapper/test-scratch1
  Showing which tree blocks are corrupted.

- BTRFS warning (device dm-2): checksum/header error at logical 24772608 on dev /dev/mapper/test-scratch2, physical 3801088: metadata node (level 1) in tree 5
  Showing which physical range the corrupted metadata is at.

We have to combine the above 3 to know we have a corrupted metadata with
generation mismatch.

And this is already the better case, if we have other problems, like
fsid mismatch, we can not even know the cause.

[CAUSE]
The problem is caused by the fact that, scrub_checksum_tree_block()
never outputs any error message.

It just return two bits for scrub: sblock->header_error, and
sblock->generation_error.

And later we report error in scrub_print_warning(), but unfortunately we
only have two bits, there is not really much thing we can done to print
any detailed errors.

[FIX]
This patch will do the following to enhance the error reporting of
metadata scrub:

- Add extra warning (ratelimited) for every error we hit
  This can help us to distinguish the different types of errors.
  Some errors can help us to know what's going wrong immediately,
  like bytenr mismatch.

- Re-order the checks
  Currently we check bytenr first, then immediately generation.
  This can lead to false generation mismatch reports, while the fsid
  mismatches.

Here is the new output for the bug I'm debugging (we forgot to
writeback tree blocks for commit roots):

 BTRFS warning (device dm-2): tree block 24117248 mirror 1 has bad fsid, has b77cd862-f150-4c71-90ec-7baf0544d83f want 17df6abf-23cd-445f-b350-5b3e40bfd2fc
 BTRFS warning (device dm-2): tree block 24117248 mirror 0 has bad fsid, has b77cd862-f150-4c71-90ec-7baf0544d83f want 17df6abf-23cd-445f-b350-5b3e40bfd2fc

Now we can immediately know it's some tree blocks didn't even get written
back, other than the original confusing generation mismatch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 49 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 196c4c6ed1ed8..c5d8dc112fd58 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2036,20 +2036,33 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	 * a) don't have an extent buffer and
 	 * b) the page is already kmapped
 	 */
-	if (sblock->logical != btrfs_stack_header_bytenr(h))
+	if (sblock->logical != btrfs_stack_header_bytenr(h)) {
 		sblock->header_error = 1;
-
-	if (sector->generation != btrfs_stack_header_generation(h)) {
-		sblock->header_error = 1;
-		sblock->generation_error = 1;
+		btrfs_warn_rl(fs_info,
+		"tree block %llu mirror %u has bad bytenr, has %llu want %llu",
+			      sblock->logical, sblock->mirror_num,
+			      btrfs_stack_header_bytenr(h),
+			      sblock->logical);
+		goto out;
 	}
 
-	if (!scrub_check_fsid(h->fsid, sector))
+	if (!scrub_check_fsid(h->fsid, sector)) {
 		sblock->header_error = 1;
+		btrfs_warn_rl(fs_info,
+		"tree block %llu mirror %u has bad fsid, has %pU want %pU",
+			      sblock->logical, sblock->mirror_num,
+			      h->fsid, sblock->dev->fs_devices->fsid);
+		goto out;
+	}
 
-	if (memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
-		   BTRFS_UUID_SIZE))
+	if (memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid, BTRFS_UUID_SIZE)) {
 		sblock->header_error = 1;
+		btrfs_warn_rl(fs_info,
+		"tree block %llu mirror %u has bad chunk tree uuid, has %pU want %pU",
+			      sblock->logical, sblock->mirror_num,
+			      h->chunk_tree_uuid, fs_info->chunk_tree_uuid);
+		goto out;
+	}
 
 	shash->tfm = fs_info->csum_shash;
 	crypto_shash_init(shash);
@@ -2062,9 +2075,27 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	}
 
 	crypto_shash_final(shash, calculated_csum);
-	if (memcmp(calculated_csum, on_disk_csum, sctx->fs_info->csum_size))
+	if (memcmp(calculated_csum, on_disk_csum, sctx->fs_info->csum_size)) {
 		sblock->checksum_error = 1;
+		btrfs_warn_rl(fs_info,
+		"tree block %llu mirror %u has bad csum, has " CSUM_FMT " want " CSUM_FMT,
+			      sblock->logical, sblock->mirror_num,
+			      CSUM_FMT_VALUE(fs_info->csum_size, on_disk_csum),
+			      CSUM_FMT_VALUE(fs_info->csum_size, calculated_csum));
+		goto out;
+	}
+
+	if (sector->generation != btrfs_stack_header_generation(h)) {
+		sblock->header_error = 1;
+		sblock->generation_error = 1;
+		btrfs_warn_rl(fs_info,
+		"tree block %llu mirror %u has bad generation, has %llu want %llu",
+			      sblock->logical, sblock->mirror_num,
+			      btrfs_stack_header_generation(h),
+			      sector->generation);
+	}
 
+out:
 	return sblock->header_error || sblock->checksum_error;
 }
 
-- 
2.39.0

