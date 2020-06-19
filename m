Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E631200EB1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392004AbgFSPKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392001AbgFSPKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2ACD20776;
        Fri, 19 Jun 2020 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579414;
        bh=QAMWE1/DBYx5+V1FZnPPGk7MNCHZVe3zjX7evAGd5dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4HNLJ/nq4xk/DJdvHJdYvl6ENE69Mka3Ibx0BZaufl3xJluhQYnJkorjdAzwxfpf
         Y3u4Xm+IdHKSDZGIUnADHyktn8F5LolyFrObbTtZJn8gTy2iFzVNi95Y6CQeOM/B08
         6e2iBG2LuzKnwW+upisWMwAZyAuz0iFoFV2LRKqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/261] xfs: reset buffer write failure state on successful completion
Date:   Fri, 19 Jun 2020 16:31:48 +0200
Message-Id: <20200619141654.521884857@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0abba171aa89..1264ac63e4e5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1162,8 +1162,10 @@ xfs_buf_ioend(
 		bp->b_ops->verify_read(bp);
 	}
 
-	if (!bp->b_error)
+	if (!bp->b_error) {
+		bp->b_flags &= ~XBF_WRITE_FAIL;
 		bp->b_flags |= XBF_DONE;
+	}
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
@@ -1223,7 +1225,7 @@ xfs_bwrite(
 
 	bp->b_flags |= XBF_WRITE;
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
-			 XBF_WRITE_FAIL | XBF_DONE);
+			 XBF_DONE);
 
 	error = xfs_buf_submit(bp);
 	if (error)
@@ -1929,7 +1931,7 @@ xfs_buf_delwri_submit_buffers(
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



