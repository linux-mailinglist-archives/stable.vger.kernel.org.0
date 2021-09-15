Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497E740C788
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbhIOOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237956AbhIOOgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 10:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DEED60EE9;
        Wed, 15 Sep 2021 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631716491;
        bh=/wP9KosXXU2h8Ko4XdLAb3u4iu81AiNNml8/EbNdFAo=;
        h=Subject:To:Cc:From:Date:From;
        b=XXgNzB2dZUcYO5VKAFy2l85yzSI2d3U/py9qNpyGZcrLfALLC5S+JiTX6u6XbYAed
         eoDanj4BukT9L3/9PgDIFwQ2g3l/lm+bPGaYBIHxJnGOOPq96b3gqNGTvN5JpdCVBq
         +/AzfVwEi0WwdN6duVFwH13YmEK1qJQ9mNR0uzdE=
Subject: FAILED: patch "[PATCH] f2fs: let's keep writing IOs on SBI_NEED_FSCK" failed to apply to 5.13-stable tree
To:     jaegeuk@kernel.org, chao@kernel.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 16:34:42 +0200
Message-ID: <16317164828961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ffc8f5f7751f91fe6af527d426a723231b741a6 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Wed, 14 Jul 2021 16:14:02 -0700
Subject: [PATCH] f2fs: let's keep writing IOs on SBI_NEED_FSCK

SBI_NEED_FSCK is an indicator that fsck.f2fs needs to be triggered, so it
is not fully critical to stop any IO writes. So, let's allow to write data
instead of reporting EIO forever given SBI_NEED_FSCK, but do keep OPU.

Fixes: 955772787667 ("f2fs: drop inplace IO if fs status is abnormal")
Cc: <stable@kernel.org> # v5.13+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d2cf48c5a2e4..ba120d55e9b1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2498,6 +2498,8 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_is_atomic_file(inode))
 		return true;
+	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
+		return true;
 
 	/* swap file is migrating in aligned write mode */
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 15cc89eef28d..f9b7fb785e1d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3563,7 +3563,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 		goto drop_bio;
 	}
 
-	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK) || f2fs_cp_error(sbi)) {
+	if (f2fs_cp_error(sbi)) {
 		err = -EIO;
 		goto drop_bio;
 	}

