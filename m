Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356AD1F2FB0
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgFIAwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbgFHXJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A352B20B80;
        Mon,  8 Jun 2020 23:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657794;
        bh=iJmO4xHRje2jpVeG+/TAXg5Tl4+PC6G/lsyYhTcVaoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scF3xgVf19nDtR1M/xV7AS0fPaUdcvgkuPotxMjwwIyBy5faxGwepJojSyYsQQnTF
         EXaXT/Wan4Tc5zx6X8RJiEMSdkRKUrsihD9Ftgn6n7EJJjTA04dvmoq1bSvroLeyfj
         kBl5QoK5FGisrL1Kmfxr6VFqjRUGsL3iDi0mw3M0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 173/274] xfs: reset buffer write failure state on successful completion
Date:   Mon,  8 Jun 2020 19:04:26 -0400
Message-Id: <20200608230607.3361041-173-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit b6983e80b03bd4fd42de71993b3ac7403edac758 ]

The buffer write failure flag is intended to control the internal
write retry that XFS has historically implemented to help mitigate
the severity of transient I/O errors. The flag is set when a buffer
is resubmitted from the I/O completion path due to a previous
failure. It is checked on subsequent I/O completions to skip the
internal retry and fall through to the higher level configurable
error handling mechanism. The flag is cleared in the synchronous and
delwri submission paths and also checked in various places to log
write failure messages.

There are a couple minor problems with the current usage of this
flag. One is that we issue an internal retry after every submission
from xfsaild due to how delwri submission clears the flag. This
results in double the expected or configured number of write
attempts when under sustained failures. Another more subtle issue is
that the flag is never cleared on successful I/O completion. This
can cause xfs_wait_buftarg() to suggest that dirty buffers are being
thrown away due to the existence of the flag, when the reality is
that the flag might still be set because the write succeeded on the
retry.

Clear the write failure flag on successful I/O completion to address
both of these problems. This means that the internal retry attempt
occurs once since the last time a buffer write failed and that
various other contexts only see the flag set when the immediately
previous write attempt has failed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ec3eaf1c618..afa73a19caa1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1197,8 +1197,10 @@ xfs_buf_ioend(
 		bp->b_ops->verify_read(bp);
 	}
 
-	if (!bp->b_error)
+	if (!bp->b_error) {
+		bp->b_flags &= ~XBF_WRITE_FAIL;
 		bp->b_flags |= XBF_DONE;
+	}
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
@@ -1258,7 +1260,7 @@ xfs_bwrite(
 
 	bp->b_flags |= XBF_WRITE;
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
-			 XBF_WRITE_FAIL | XBF_DONE);
+			 XBF_DONE);
 
 	error = xfs_buf_submit(bp);
 	if (error)
@@ -1983,7 +1985,7 @@ xfs_buf_delwri_submit_buffers(
 		 * synchronously. Otherwise, drop the buffer from the delwri
 		 * queue and submit async.
 		 */
-		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
+		bp->b_flags &= ~_XBF_DELWRI_Q;
 		bp->b_flags |= XBF_WRITE;
 		if (wait_list) {
 			bp->b_flags &= ~XBF_ASYNC;
-- 
2.25.1

