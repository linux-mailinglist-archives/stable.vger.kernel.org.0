Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37555ECC2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiF1Sk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiF1Sk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253FB22B16;
        Tue, 28 Jun 2022 11:40:25 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id jh14so11869014plb.1;
        Tue, 28 Jun 2022 11:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlu4iuvVEFL0RFP9rItuvOieChz+ZKZcK5FBCkGby/Y=;
        b=C8QyxkT96B+xyguPYPqHJLpMY6WYQw3f6yV7UdkLXC8iCRJ4diuCUw7VKQhriAe+WT
         jRaDNEDR/OpuyloaSDKcKVJzKtGxbiEXSyJATSXPUqJNGAxtfS4AHmOnGOZiusJlr2eO
         CqosqFz3Bq8ZwkZy1plyOMLTXWWTdTRGrAdlk1ysDUYK7TtWwUCN/DoAHYR+n0z5aW1c
         iWB5V11DkEBAGjhs6x5lFE8X/m68Afr/IJZR6y7E5dkdss60wE3Btura5vk6ziTyWOyk
         LuJoDNJjiD9toCulw7jY9BChkrlFu3MP6ABiGyFkV/2aw738MuMWh3NbmIF+DpMr5+Vt
         MUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlu4iuvVEFL0RFP9rItuvOieChz+ZKZcK5FBCkGby/Y=;
        b=qRlBWY4EYszjfd7+je5I8gVVur7bHM2HbLrakFmYja0W7Fs35PMiuF7DXlUl1Oby5x
         1Lue46JEddK+V2kX6MFbx9rpjLoe7d2HJ7D1iLQbRXiBpBvSMGggoIaiaKJFdYCTRMeL
         6LKTRFUM2+9F3YgdGf6mwYQfac0Saup44QvV0BqRupLbWei5hRxSL4DsYjOHTfAwdS0U
         szxQHx+/KBiAoqgU+7veVcxl+Sp0R3r4TEQZXRxdq5SJhUirYl4t33LO0v/k2MwUb8l3
         vrR2Pl9An25hsj0dHS6aINlWoqzdudfLhFLRxOnn0UXPfKT1hrQtqiW/tfskakDVKQ9V
         rCKA==
X-Gm-Message-State: AJIora+7wvWSTS1TT+W9l1f//63ygtw2bqeKlo/d0EnelDM41u7LEfBe
        HYN1kDBXGxJjJUFtKsrryL/B3nStxJBDOw==
X-Google-Smtp-Source: AGRyM1t+1e5ViH1OJONmadv5gVE4Str6PIW9fvfhMapg+NQUpn1B9Lzr9AM3A9RjrdkqXGUlv+3wNg==
X-Received: by 2002:a17:90b:2785:b0:1ef:ff9:4f4c with SMTP id pw5-20020a17090b278500b001ef0ff94f4cmr1136685pjb.132.1656441624395;
        Tue, 28 Jun 2022 11:40:24 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:24 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 4/7] xfs: remove all COW fork extents when remounting readonly
Date:   Tue, 28 Jun 2022 11:39:48 -0700
Message-Id: <20220628183951.3425528-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
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

[ Upstream commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 170fee98c45c..23673703618a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1768,7 +1768,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1776,8 +1779,13 @@ xfs_remount_ro(
 	 */
 	xfs_blockgc_stop(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_blockgc_free_space(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_blockgc_free_space(mp, &icw);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.37.0.rc0.161.g10f37bed90-goog

