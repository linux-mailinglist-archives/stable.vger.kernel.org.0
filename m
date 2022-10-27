Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD20060FEF1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiJ0RKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbiJ0RJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C82558A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63E2362369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FA5C433D6;
        Thu, 27 Oct 2022 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890597;
        bh=U4bQekDzr4c/i5Vfq8r6FXiN1hzNvH5ZP4ERNh6YAvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llp4+8K2B370ZcuJB0HKBOiH3LR2q8QIckShEmUomYvZVjXQZCYoJpktvaIMvueFq
         twgIA/F55WQec2tYCHYVdkXH8d/Lntzb/7x8cBoX/Wo2fBETNFFyFPZGMaHdQELqRg
         CFqT/sKvHbOsLnEsc7/FlChHBhNkFhnMvKu2Mics=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 21/53] xfs: dont write a corrupt unmount record to force summary counter recalc
Date:   Thu, 27 Oct 2022 18:56:09 +0200
Message-Id: <20221027165050.634402562@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 5cc3c006eb45524860c4d1dd4dd7ad4a506bf3f5 upstream.

[ Modify fs/xfs/xfs_log.c to include the changes at locations suitable for
  5.4-lts kernel ]

In commit f467cad95f5e3, I added the ability to force a recalculation of
the filesystem summary counters if they seemed incorrect.  This was done
(not entirely correctly) by tweaking the log code to write an unmount
record without the UMOUNT_TRANS flag set.  At next mount, the log
recovery code will fail to find the unmount record and go into recovery,
which triggers the recalculation.

What actually gets written to the log is what ought to be an unmount
record, but without any flags set to indicate what kind of record it
actually is.  This worked to trigger the recalculation, but we shouldn't
write bogus log records when we could simply write nothing.

Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -837,19 +837,6 @@ xfs_log_write_unmount_record(
 	if (error)
 		goto out_err;
 
-	/*
-	 * If we think the summary counters are bad, clear the unmount header
-	 * flag in the unmount record so that the summary counters will be
-	 * recalculated during log recovery at next mount.  Refer to
-	 * xlog_check_unmount_rec for more details.
-	 */
-	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
-			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
-		xfs_alert(mp, "%s: will fix summary counters at next mount",
-				__func__);
-		flags &= ~XLOG_UNMOUNT_TRANS;
-	}
-
 	/* remove inited flag, and account for space used */
 	tic->t_flags = 0;
 	tic->t_curr_res -= sizeof(magic);
@@ -932,6 +919,19 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
+		/*
+		 * If we think the summary counters are bad, avoid writing the
+		 * unmount record to force log recovery at next mount, after
+		 * which the summary counters will be recalculated.  Refer to
+		 * xlog_check_unmount_rec for more details.
+		 */
+		if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS),
+				mp, XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
+			xfs_alert(mp,
+				"%s: will fix summary counters at next mount",
+				__func__);
+			return 0;
+		}
 		xfs_log_write_unmount_record(mp);
 	} else {
 		/*


