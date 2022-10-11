Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826835FB555
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJKOx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiJKOwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC99A9FE;
        Tue, 11 Oct 2022 07:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98DBC611C9;
        Tue, 11 Oct 2022 14:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE2FC433D7;
        Tue, 11 Oct 2022 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499865;
        bh=CVnALvBuDhhOTk8a0gz9QtP4swLjci7y0g7qcMBKSic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFx4FGZm2C0Fb5qLWSbmiw4znJCauaKww0KaJUGQHsLn2kPvIqm3YQdd6WRdccB46
         WLbsn4UYI3y67JFfaBA8qPRaDHaB3+Y80sTCz7LPEUeZakLETCXk6MUGMpIZDnKSB+
         7lK1lo28XBMqBxbjctptFRS3v6XEVnN/ou9Bie3Qz812GY5XA1YWw0q7aVW+FwH/JC
         e04E6xwccoETnDGDhv5tt2hXHG6A0Bt9G3D1xl25+7OUJvdZBQZSfQuhxnftu/N0OP
         F7rEek5PKQPQ5TKNhLUexko8qsQh2BWgG7p2u6OVVE+nUN+2uZ1tm5XwUzRYtwJfxj
         z8UeuaqLmFHZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 31/46] btrfs: scrub: properly report super block errors in system log
Date:   Tue, 11 Oct 2022 10:49:59 -0400
Message-Id: <20221011145015.1622882-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e69bf81c9a339f1b2c041b112a6fbb9f60fc9340 ]

[PROBLEM]

Unlike data/metadata corruption, if scrub detected some error in the
super block, the only error message is from the updated device status:

  BTRFS info (device dm-1): scrub: started on devid 2
  BTRFS error (device dm-1): bdev /dev/mapper/test-scratch2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
  BTRFS info (device dm-1): scrub: finished on devid 2 with status: 0

This is not helpful at all.

[CAUSE]
Unlike data/metadata error reporting, there is no visible report in
kernel dmesg to report supper block errors.

In fact, return value of scrub_checksum_super() is intentionally
skipped, thus scrub_handle_errored_block() will never be called for
super blocks.

[FIX]
Make super block errors to output an error message, now the full
dmesg would looks like this:

  BTRFS info (device dm-1): scrub: started on devid 2
  BTRFS warning (device dm-1): super block error on device /dev/mapper/test-scratch2, physical 67108864
  BTRFS error (device dm-1): bdev /dev/mapper/test-scratch2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
  BTRFS info (device dm-1): scrub: finished on devid 2 with status: 0
  BTRFS info (device dm-1): scrub: started on devid 2

This fix involves:

- Move the super_errors reporting to scrub_handle_errored_block()
  This allows the device status message to show after the super block
  error message.
  But now we no longer distinguish super block corruption and generation
  mismatch, now all counted as corruption.

- Properly check the return value from scrub_checksum_super()
- Add extra super block error reporting for scrub_print_warning().

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3afe5fa50a63..0fe7c4882e1f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -729,6 +729,13 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	dev = sblock->sectors[0]->dev;
 	fs_info = sblock->sctx->fs_info;
 
+	/* Super block error, no need to search extent tree. */
+	if (sblock->sectors[0]->flags & BTRFS_EXTENT_FLAG_SUPER) {
+		btrfs_warn_in_rcu(fs_info, "%s on device %s, physical %llu",
+			errstr, rcu_str_deref(dev->name),
+			sblock->sectors[0]->physical);
+		return;
+	}
 	path = btrfs_alloc_path();
 	if (!path)
 		return;
@@ -804,7 +811,7 @@ static inline void scrub_put_recover(struct btrfs_fs_info *fs_info,
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 {
 	struct scrub_ctx *sctx = sblock_to_check->sctx;
-	struct btrfs_device *dev;
+	struct btrfs_device *dev = sblock_to_check->sectors[0]->dev;
 	struct btrfs_fs_info *fs_info;
 	u64 logical;
 	unsigned int failed_mirror_index;
@@ -825,13 +832,15 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	fs_info = sctx->fs_info;
 	if (sblock_to_check->sectors[0]->flags & BTRFS_EXTENT_FLAG_SUPER) {
 		/*
-		 * if we find an error in a super block, we just report it.
+		 * If we find an error in a super block, we just report it.
 		 * They will get written with the next transaction commit
 		 * anyway
 		 */
+		scrub_print_warning("super block error", sblock_to_check);
 		spin_lock(&sctx->stat_lock);
 		++sctx->stat.super_errors;
 		spin_unlock(&sctx->stat_lock);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS);
 		return 0;
 	}
 	logical = sblock_to_check->sectors[0]->logical;
@@ -840,7 +849,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	is_metadata = !(sblock_to_check->sectors[0]->flags &
 			BTRFS_EXTENT_FLAG_DATA);
 	have_csum = sblock_to_check->sectors[0]->have_csum;
-	dev = sblock_to_check->sectors[0]->dev;
 
 	if (!sctx->is_dev_replace && btrfs_repair_one_zone(fs_info, logical))
 		return 0;
@@ -1762,7 +1770,7 @@ static int scrub_checksum(struct scrub_block *sblock)
 	else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		ret = scrub_checksum_tree_block(sblock);
 	else if (flags & BTRFS_EXTENT_FLAG_SUPER)
-		(void)scrub_checksum_super(sblock);
+		ret = scrub_checksum_super(sblock);
 	else
 		WARN_ON(1);
 	if (ret)
@@ -1901,23 +1909,6 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	if (memcmp(calculated_csum, s->csum, sctx->fs_info->csum_size))
 		++fail_cor;
 
-	if (fail_cor + fail_gen) {
-		/*
-		 * if we find an error in a super block, we just report it.
-		 * They will get written with the next transaction commit
-		 * anyway
-		 */
-		spin_lock(&sctx->stat_lock);
-		++sctx->stat.super_errors;
-		spin_unlock(&sctx->stat_lock);
-		if (fail_cor)
-			btrfs_dev_stat_inc_and_print(sector->dev,
-				BTRFS_DEV_STAT_CORRUPTION_ERRS);
-		else
-			btrfs_dev_stat_inc_and_print(sector->dev,
-				BTRFS_DEV_STAT_GENERATION_ERRS);
-	}
-
 	return fail_cor + fail_gen;
 }
 
-- 
2.35.1

