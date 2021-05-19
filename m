Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31B389874
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 23:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhESVRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 17:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhESVRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 17:17:15 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C0C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 14:15:55 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o27so14188285qkj.9
        for <stable@vger.kernel.org>; Wed, 19 May 2021 14:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EXyAewZBXhTZKNuX+oOdp9iVQSY4JlKPlNtgWr9nzWE=;
        b=NQFZ4BWgF8yiFdXLpD+87fOMTnHTMtFjQ9K4O8MbNivYjQhQASb7CtoTF4HY5wURJy
         YPH/wvbKUrVLuCiZOhTznUCspWZr7UP8EOH3fsqkCnLjcd6U1MmFxIaFg8b/oqdBnfL/
         fjsz7Z0gy66jZMAKHFjxOQOrXKlKJwHG6YC4BaT2phdYz0syFfEDxMCEIXlTS9wBEKhT
         QKSyM3jOv22LH9qgf1kkJt5HI3JVPM6ZeZjh+ZVqYhjJXpiWCIRw+XnkkcUVgmpCV2Tk
         KBbRO4n1j+G6WJWwynB1xGVdIjKl4q8TiiyK0MvyBGNvmfVOsYHTABZ6NFW+bcEsMhNX
         acaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EXyAewZBXhTZKNuX+oOdp9iVQSY4JlKPlNtgWr9nzWE=;
        b=M76bC8YCueN4n7aXUESv3Qqhu8TepM6zT9jJafab8sLIT1jDtOaxZBKdoNFiISnO4I
         48e3Y682py9IewijYd9qKeM5geDKi6A2Pebkb04YNLccIBI/Uaog4JMitj+iyrtGAEFA
         r28kWILvGlkrsOXA663RRec+w402ibgiT4TTmK58l9sN5grGS8C9rHK3jLNgIn0G2T9X
         P/HtGOVcR/2ZLlPcpVDRZNpvM7lgediB/a5B0SJ4zsGFQlRqhZ8XXZHqjOCZDvT24i0q
         sTXBDpymxhHXpOmuc92TZfUzieq6ZY9GGUMEUbzfjoLNE8jY6T7FSCKxciwOXTKPBbT6
         q6aw==
X-Gm-Message-State: AOAM533ASaJOGpL9JmtqTjgTACXE+E8uS3DWIBoQmnJPAH+7dvBZ+otO
        MALMry5JydoWoyQdzU6n62W/nvATXSxMFw==
X-Google-Smtp-Source: ABdhPJx49Zjth22VGpTpH6p0MHyGxY0EuGbMW/gONE1g1enJkJYzUyqLsjdtskW8hnUz2wK4dBbqkg==
X-Received: by 2002:a37:418d:: with SMTP id o135mr1480510qka.418.1621458954681;
        Wed, 19 May 2021 14:15:54 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id h3sm660659qkk.82.2021.05.19.14.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 14:15:54 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: do not write supers if we have an fs error
Date:   Wed, 19 May 2021 17:15:53 -0400
Message-Id: <58fd56f2942d80bee34108035bd5708a19ac56ed.1621458943.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Error injection testing uncovered a pretty severe problem where we could
end up committing a super that pointed to the wrong tree roots,
resulting in transid mismatch errors.

The way we commit the transaction is we update the super copy with the
current generations and bytenrs of the important roots, and then copy
that into our super_for_commit.  Then we allow transactions to continue
again, we write out the dirty pages for the transaction, and then we
write the super.  If the write out fails we'll bail and skip writing the
supers.

However since we've allowed a new transaction to start, we can have a
log attempting to sync at this point, which would be blocked on
fs_info->tree_log_mutex.  Once the commit fails we're allowed to do the
log tree commit, which uses super_for_commit, which now points at fs
tree's that were not written out.

Fix this by checking BTRFS_FS_STATE_ERROR once we acquire the
tree_log_mutex.  This way if the transaction commit fails we're sure to
see this bit set and we can skip writing the super out.  This patch
fixes this specific transid mismatch error I was seeing with this
particular error path.

cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/tree-log.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0278f489e7d9..83e8f105869b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3302,6 +3302,22 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 *    begins and releases it only after writing its superblock.
 	 */
 	mutex_lock(&fs_info->tree_log_mutex);
+
+	/*
+	 * The transaction writeout phase could have failed, and thus marked the
+	 * fs in an error state.  We must not commit here, as we could have
+	 * updated our generation in the super_for_commit and writing the super
+	 * here would result in transid mismatches.  If there is an error here
+	 * just bail.
+	 */
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
+		ret = -EIO;
+		btrfs_set_log_full_commit(trans);
+		btrfs_abort_transaction(trans, ret);
+		mutex_unlock(&fs_info->tree_log_mutex);
+		goto out_wake_log_root;
+	}
+
 	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
 	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
 	ret = write_all_supers(fs_info, 1);
-- 
2.26.3

