Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8383355D79F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiF0GwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiF0GwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:52:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1883926C0;
        Sun, 26 Jun 2022 23:52:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v14so11562427wra.5;
        Sun, 26 Jun 2022 23:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=V49ZB44pbSFux/V3mahSf7H2FHvqBYCrmeMfS2XRZ51SEcR/Rngt/NsscTEx9O4WCW
         E3JMEESRGbbs6vqoI0zyw1+EOiBVppAEN+70BsPaYWAmXjCgqFBeQfsnOrllCxNQl+zZ
         E9Z/u/q7invUrC73fzwHMo068MbZTyqqRqDPD/yGAmdV/wu3eri+vZPOjIXQhtHDqwS0
         /l61Ec60O+bQQ77HjEEMWhNbKP0cXhNhOerSA8PrLyti3toRQE8A9HUsCcdfK9sgay0l
         UDu7P0dRCgGMuz0qsRbcdnWg/rUCQ7Gz7mUfP2aTv+GhHD8spVUsXg7JaV/9O9w6Jkje
         Antw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=qaq/MzldsoT8N4XclCCQj7ZLF0NZx/kEK/nnZi1xCsrVc69JrzUQu+lSpQayncpXul
         VAxHasBs2XacDDVwDGEp6PiUrZLlcynYXYPkpQVvA2PmKM87N4yBuOSyxC5utrknfKtD
         DpvzAK3M5qcSIVjr5hI0QS8FxJQYvNwACEjR0iuXhHIuaQlgTFdyHEz1h9wy5fw4Z76i
         VmO1eAN23sKovgkpeXsICYwhQEiP/ynGwlMtozFAskpjmvUZyABDc+nfLcL5iU59ywkX
         UlH/Vv0HiKgonO+UXsl9LxFeEL++RAYuwqUzTT0rklvBoQQDqMYTrRKG3ErjJYnritu8
         7O/g==
X-Gm-Message-State: AJIora81Xb8L1jSbA5G5BVaTrk8Vod7jtrIMLdMZsFH1z3lNHUOKNAaj
        h3O4J/+t18Rui/Vczv3qC0Q=
X-Google-Smtp-Source: AGRyM1ukdaj5bqDaGITC15WW6nsCOUcK5p0kkAjecA2Prvpj2yrB3UXTlxAxq6WsEWxr+cGtZhtPFw==
X-Received: by 2002:a05:6000:71e:b0:21b:adf2:c9ab with SMTP id bs30-20020a056000071e00b0021badf2c9abmr10969114wrb.153.1656312723666;
        Sun, 26 Jun 2022 23:52:03 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id e10-20020adffd0a000000b0021a3dd1c5d5sm9415076wrr.96.2022.06.26.23.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:52:03 -0700 (PDT)
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
Subject: [PATCH 5.10 v4 4/5] xfs: remove all COW fork extents when remounting readonly
Date:   Mon, 27 Jun 2022 09:51:39 +0300
Message-Id: <20220627065140.2798412-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627065140.2798412-1-amir73il@gmail.com>
References: <20220627065140.2798412-1-amir73il@gmail.com>
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

