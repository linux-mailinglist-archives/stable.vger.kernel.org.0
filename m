Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D855FB716
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiJKP2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJKP1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:27:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D60CDF09;
        Tue, 11 Oct 2022 08:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79C4611D7;
        Tue, 11 Oct 2022 14:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AC8C433D7;
        Tue, 11 Oct 2022 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500034;
        bh=rCB0Xv+xi/SjS1Z1j3Vilkp/16M2refyx39jmGCCBTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEgK2W8ZNUJCgoJPYilyNzKlFxJud5xmJvr9dUm2EXnx71WRellrXvcIxt9IJnTB/
         Fyie5fwmrVIGmX//ADnNTq8cnj50Nnplb/3cJmmxJZGjvGRuLXxwXzY8y9FbtMR57s
         /TYdEwsbiLdfm7k0/Bxj16/W/C6WSzknjVB+FGMj+rES/o1008xAjtMIcb1XBAgQPz
         v3v5E1BHBjx8B4wzXBqW8Nm++OCbsSn+gapb2UZ731hy54Vl0hC4p6ScCGEbu5kHC3
         siqxEW1wyeKoLz1Pk6YxseuialHkyL8y6JRztv38ukcKZI0tfqhxmT1aviv1g71Z6+
         BF9iRaRKuTZtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/13] btrfs: scrub: try to fix super block errors
Date:   Tue, 11 Oct 2022 10:53:36 -0400
Message-Id: <20221011145338.1624591-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145338.1624591-1-sashal@kernel.org>
References: <20221011145338.1624591-1-sashal@kernel.org>
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
index e5db948daa12..45809f75692e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3849,6 +3849,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	unsigned int nofs_flag;
+	bool need_commit = false;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EAGAIN;
@@ -3961,6 +3962,12 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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
@@ -3969,6 +3976,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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
@@ -3995,6 +4012,25 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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

