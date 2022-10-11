Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EEF5FB61B
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiJKPAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiJKO65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E52D9F768;
        Tue, 11 Oct 2022 07:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4086D611C3;
        Tue, 11 Oct 2022 14:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15B8C433D6;
        Tue, 11 Oct 2022 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500011;
        bh=DldUW7Lm57Tuv67v64bf+Aur5Zpyj3o2v/3TEU1dk1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvlQCMTkRGU/ECK0Mo/FL/XBOZECPuD1/Caeaphm25V4s9uaWhIVXqskasCvMP9ro
         w4rRjUhK+DpLB8JnwlhDHil58hy9HB7bNXBL0fTw8N/dj+3pYdklTSae/EgALX2qjD
         M7kx3IdlV5ibq1JaggtfFBo+qSZqZbskriYesyr4qQMDKE1Jf2x7h3YcLbiZ320IBq
         4x1GFGxeHLwCUS7Z5Qequk9M8jZeB1pDb52NeCjidv1fYjS0djDMC/c/hgkg11Q3vu
         5vVFSD25Mp0vgQl3ankzXIzgIr5ZEngOSIJlGZSgA3uIx8L4IdsMKrhcoWteB/0g7p
         NUA7+P3PSdrKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/17] btrfs: scrub: try to fix super block errors
Date:   Tue, 11 Oct 2022 10:53:08 -0400
Message-Id: <20221011145312.1624341-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145312.1624341-1-sashal@kernel.org>
References: <20221011145312.1624341-1-sashal@kernel.org>
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

[ Upstream commit f9eab5f0bba76742af654f33d517bf62a0db8f12 ]

[BUG]
The following script shows that, although scrub can detect super block
errors, it never tries to fix it:

	mkfs.btrfs -f -d raid1 -m raid1 $dev1 $dev2
	xfs_io -c "pwrite 67108864 4k" $dev2

	mount $dev1 $mnt
	btrfs scrub start -B $dev2
	btrfs scrub start -Br $dev2
	umount $mnt

The first scrub reports the super error correctly:

  scrub done for f3289218-abd3-41ac-a630-202f766c0859
  Scrub started:    Tue Aug  2 14:44:11 2022
  Status:           finished
  Duration:         0:00:00
  Total to scrub:   1.26GiB
  Rate:             0.00B/s
  Error summary:    super=1
    Corrected:      0
    Uncorrectable:  0
    Unverified:     0

But the second read-only scrub still reports the same super error:

  Scrub started:    Tue Aug  2 14:44:11 2022
  Status:           finished
  Duration:         0:00:00
  Total to scrub:   1.26GiB
  Rate:             0.00B/s
  Error summary:    super=1
    Corrected:      0
    Uncorrectable:  0
    Unverified:     0

[CAUSE]
The comments already shows that super block can be easily fixed by
committing a transaction:

	/*
	 * If we find an error in a super block, we just report it.
	 * They will get written with the next transaction commit
	 * anyway
	 */

But the truth is, such assumption is not always true, and since scrub
should try to repair every error it found (except for read-only scrub),
we should really actively commit a transaction to fix this.

[FIX]
Just commit a transaction if we found any super block errors, after
everything else is done.

We cannot do this just after scrub_supers(), as
btrfs_commit_transaction() will try to pause and wait for the running
scrub, thus we can not call it with scrub_lock hold.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0392c556af60..88b9a5394561 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3811,6 +3811,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	unsigned int nofs_flag;
+	bool need_commit = false;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EAGAIN;
@@ -3924,6 +3925,12 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 */
 	nofs_flag = memalloc_nofs_save();
 	if (!is_dev_replace) {
+		u64 old_super_errors;
+
+		spin_lock(&sctx->stat_lock);
+		old_super_errors = sctx->stat.super_errors;
+		spin_unlock(&sctx->stat_lock);
+
 		btrfs_info(fs_info, "scrub: started on devid %llu", devid);
 		/*
 		 * by holding device list mutex, we can
@@ -3932,6 +3939,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		mutex_lock(&fs_info->fs_devices->device_list_mutex);
 		ret = scrub_supers(sctx, dev);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+		spin_lock(&sctx->stat_lock);
+		/*
+		 * Super block errors found, but we can not commit transaction
+		 * at current context, since btrfs_commit_transaction() needs
+		 * to pause the current running scrub (hold by ourselves).
+		 */
+		if (sctx->stat.super_errors > old_super_errors && !sctx->readonly)
+			need_commit = true;
+		spin_unlock(&sctx->stat_lock);
 	}
 
 	if (!ret)
@@ -3958,6 +3975,25 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);
 
+	/*
+	 * We found some super block errors before, now try to force a
+	 * transaction commit, as scrub has finished.
+	 */
+	if (need_commit) {
+		struct btrfs_trans_handle *trans;
+
+		trans = btrfs_start_transaction(fs_info->tree_root, 0);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			btrfs_err(fs_info,
+	"scrub: failed to start transaction to fix super block errors: %d", ret);
+			return ret;
+		}
+		ret = btrfs_commit_transaction(trans);
+		if (ret < 0)
+			btrfs_err(fs_info,
+	"scrub: failed to commit transaction to fix super block errors: %d", ret);
+	}
 	return ret;
 out:
 	scrub_workers_put(fs_info);
-- 
2.35.1

