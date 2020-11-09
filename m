Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B4D2ABAF0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgKINPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732881AbgKINPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C957520867;
        Mon,  9 Nov 2020 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927717;
        bh=+deqDxKjfvTQp8pmCPDjJx3fKKQ/QVecxikk+yKbHsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gInv/FOcLKre+1fnFegpmcq/4OpW5zOKDH9DnlOIMa23a0lNH1uyY01TqqWEvo95Z
         5siFs4jJRW1sONni4dRsA3v/Eoxf0xK4HQNhgI2oYANFs/ohSnFWyc8TNSye52qhJM
         mzBIiyPH+NmuSRuRPtT6yN3qZM3I67yoWP90vhps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Strohman <astroh@amazon.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.4 83/85] xfs: flush for older, xfs specific ioctls
Date:   Mon,  9 Nov 2020 13:56:20 +0100
Message-Id: <20201109125026.570966436@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Strohman <astroh@amazon.com>

837a6e7f5cdb ("fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers") changed
ioctls XFS_IOC_UNRESVSP XFS_IOC_UNRESVSP64 and XFS_IOC_ZERO_RANGE to be generic
instead of xfs specific.

Because of this change, 36f11775da75 ("xfs: properly serialise fallocate against
AIO+DIO") needed adaptation, as 5.4 still uses the xfs specific ioctls.

Without this, xfstests xfs/242 and xfs/290 fail. Both of these tests test
XFS_IOC_ZERO_RANGE.

Fixes: 36f11775da75 ("xfs: properly serialise fallocate against AIO+DIO")
Tested-by: Andy Strohman <astroh@amazon.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -622,7 +622,6 @@ xfs_ioc_space(
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
-	inode_dio_wait(inode);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -668,6 +667,31 @@ xfs_ioc_space(
 		goto out_unlock;
 	}
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now that AIO and DIO has drained we can flush and (if necessary)
+	 * invalidate the cached range over the first operation we are about to
+	 * run. We include zero range here because it starts with a hole punch
+	 * over the target range.
+	 */
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		error = xfs_flush_unmap_range(ip, bf->l_start, bf->l_len);
+		if (error)
+			goto out_unlock;
+		break;
+	}
+
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		flags |= XFS_PREALLOC_SET;


