Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F06608A20
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJVIrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbiJVIp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:45:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DF832AA9;
        Sat, 22 Oct 2022 01:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 080D5B82E15;
        Sat, 22 Oct 2022 08:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFB8C433D6;
        Sat, 22 Oct 2022 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425875;
        bh=utvZx2zyUFJMYQMIX7YK1QsEzU1Uj+lHms/CgOf1vGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS0XXYfxUe+bf9I5/+0F3+4ijy5C3wdoEMORDnFWpPC1nMlgoxOtoWobJHaKvTmkK
         q68ckC29ASgB1PbVrcj+0TUj2o+YcLt9DLgcbjzcCqP2dgLlMV+c93H1OWXxcC7fTt
         TuCkgUMTzmwcqVlg2h/5chP437yXwNJh/zNj/2rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 644/717] btrfs: scrub: try to fix super block errors
Date:   Sat, 22 Oct 2022 09:28:43 +0200
Message-Id: <20221022072526.931023131@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f62bfa023178..a14f97bf2a40 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4112,6 +4112,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	unsigned int nofs_flag;
+	bool need_commit = false;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EAGAIN;
@@ -4215,6 +4216,12 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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
@@ -4223,6 +4230,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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
@@ -4249,6 +4266,25 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
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



