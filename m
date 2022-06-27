Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DAC55E1EF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiF0GrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiF0GrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:17 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF0C55A2;
        Sun, 26 Jun 2022 23:47:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id i25so6029827wrc.13;
        Sun, 26 Jun 2022 23:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=T9o9Z5rSpPSTtjQ/ZIQhIRfccVy8I+V1LpRTCQ9zjzfZ2vsqqu0c8EXbFGNPubOAxM
         Wj+IJsazTJ26D8yS++8JUu8xR6guMtvyXO0J57oyO4BBfdPnxk6LqnSACQoAxNXQteE+
         Sz4vTVCfcfHoqWTy8YSfLjrsnFVBsloPb6IP4mDFMoCD2PMOrlZmlcXy7TGQTfLv6UpZ
         oevVsqCf/CCuS+Yvh8gk88grOdjkLAfV+zxouiDZALL3I7txT7KUaBKU67JdGlXxFBsf
         bFEdmzL2Om48ObQpmPoCs0vjmYUp1tmR/03CPE7s03vHfbwnV4aRKmsh3Cz+PaAVvAXA
         YlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=Xw9WkxPNuukl7ffx/u+w5oMH8EOMaVdChCUL+rAVWX/4BhpTZlJMilCZ6oF3VDT3Ac
         cCD14woj0JHMk0ucN4uELNA0NOPLd9zIcIwi3awuhxYGBKcb7XUG+VfpYuZYJ0wOpxCu
         9bcYfH1voDGT/RGsLzgQXmN3drRJoq/6WygU3X8gUKcEDomxt7Mv5zUtdZ/wqnoPGZoR
         rMTriC5ZbPXmN8T/X4TIjOB9s87ddBuWM03IUpYF804k9XxNRLWkbr2VsCkXE2tZ924R
         jiBBJi8PwFNjp081Ax1l5/YSPUWzTOvvLEGcVhIUs4WfyxfcBy5aTyICOqCwHiWP2fhm
         grAQ==
X-Gm-Message-State: AJIora+zq1ffFP0YNfcfSoATB5n98j5M2lhiW9mWH6sGxWdspJthMSMN
        yQ3TUJz3PLC/9BvwIk/hhACbq0sORl7j/A==
X-Google-Smtp-Source: AGRyM1tO6c2e9Y3js/FwDApQmstpdSbATXVb9EKwoUMCQLjdbgUHA+Z0rv9A9t42HhA81N6CN10Ljw==
X-Received: by 2002:a5d:5145:0:b0:21b:940d:45d1 with SMTP id u5-20020a5d5145000000b0021b940d45d1mr10569147wrt.308.1656312434875;
        Sun, 26 Jun 2022 23:47:14 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3 4/5] xfs: remove all COW fork extents when remounting readonly
Date:   Mon, 27 Jun 2022 09:47:02 +0300
Message-Id: <20220627064703.2798133-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627064703.2798133-1-amir73il@gmail.com>
References: <20220627064703.2798133-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 upstream.

[backport xfs_icwalk -> xfs_eofblocks for 5.10.y]

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
synchronously, which causes xfs_icwalk to return to inodes that were
skipped because the blockgc code couldn't take the IOLOCK.  This is safe
to do here because the VFS has already prohibited new writer threads.

Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5ebd6cdc44a7..05cea7788d49 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1695,7 +1695,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_EOF_FLAGS_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1703,8 +1706,13 @@ xfs_remount_ro(
 	 */
 	xfs_stop_block_reaping(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_icache_free_cowblocks(mp, &eofb);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.25.1

