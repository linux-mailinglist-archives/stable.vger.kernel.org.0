Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325F0102C34
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKSS7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 13:59:23 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45106 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfKSS7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 13:59:23 -0500
Received: by mail-qk1-f194.google.com with SMTP id q70so18808009qke.12
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 10:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7CufLKA54CvFLnN5jiioKOMQ3lkfBKVmYkvR0Nk3Rw=;
        b=0ulC5rDlurEGb4/G1SZEMhC/5ASVEOCYZnmXF9ECqjGGgROD6cJ7DQs2ZlxfKTqCam
         T/TV2I/lAF9cqw/WB5JDakYRRHQVG1MsMD0V/d/5wodO3Cp72FeRNUq2j/JlvMHFSxjV
         /srexWmB3Xme8SUhqePsBjqo75Gt0+fEq8CoTFJTMtgPHvHxWoI5zhxsAsfx/GIdVRyt
         Bcoy3z0LS2c/QAEjMGHG+qEBeRsQ8vCPI5OzSRRSJdoialIwgpDKUzcVBjTjIDZ31eXD
         Bfm7Y2SG31PkkKMt/Fjx9hjv0p+RrG1LJ7s87xRd1oujro37iSM9aWARbc8cmU+3DTBi
         Vfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7CufLKA54CvFLnN5jiioKOMQ3lkfBKVmYkvR0Nk3Rw=;
        b=B/J8ozKKEQE+5FZvSim4ge64pV5u7s0Twg1BPuJfb1FbhoWI7LektawIjKZLGJcgvP
         X0bEVTsnLnk6iSeI7WPHaHv2IhVEKwgmA6lJFDtaBSPwWi0rK9tZXDKLASjXo+/Qi3rA
         NSc9hgtfF4t5FsSbGM3LAD0NrN3inNzhhfX6vaNhL1cKeSsbOR5G0E/HwguTscdItw7/
         MK4VRITl9buQt+VTeSdx5NUatWMSyCFB4d8jPyR8NaqUEfr1pNc04WlUwFbdvvo7W90B
         q4AUHSKfkvSJjdvIY3eMJYOGdv2ak+I1xfeiYrXpiVDwTYL/TUYe7gdFnYmZZFeParXp
         tJUQ==
X-Gm-Message-State: APjAAAXZcP52KRL+lyk5n6aCq0YC6OSRiG/5fxqpppxwyYw3zyUEqZ5Z
        fRNgvYquXOZxxvB3Ff1pZj5gaQ==
X-Google-Smtp-Source: APXvYqymaoGpRFmKz6gyFc2+GuVriOPIi6FYfNxUWQqxZDHclr1BlMoGQi8F0RVStT+9eOaRRjY7Kg==
X-Received: by 2002:ae9:e404:: with SMTP id q4mr18825507qkc.365.1574189962071;
        Tue, 19 Nov 2019 10:59:22 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id h12sm9399614qtj.37.2019.11.19.10.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 10:59:21 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: don't double lock the subvol_sem
Date:   Tue, 19 Nov 2019 13:59:20 -0500
Message-Id: <20191119185920.3031-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we're rename exchanging two subvols we'll try to lock this lock
twice, which is bad.  Just lock once if either of the ino's are subvols.

cc: stable@vger.kernel.org
Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b13c212b1bed..8db7455fee38 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9563,9 +9563,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	btrfs_init_log_ctx(&ctx_dest, new_inode);
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 
 	/*
@@ -9799,9 +9798,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = ret ? ret : ret2;
 	}
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
 	ASSERT(list_empty(&ctx_root.list));
-- 
2.23.0

