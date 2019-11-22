Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B81064F8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfKVGUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfKVFwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505282071F;
        Fri, 22 Nov 2019 05:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401962;
        bh=bU8lHFm9OBXC+O3oT+aSOg/7u1TW8GHVR7WkQspLb68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Frk+KZg/YVcmIOjD7VsUhvCFtWFBx0p9zPrE454kmijE5cRDVe73lQRU1NUXxUP05
         XTyx1fb3Y1rsWJzIs1ehLUR/jOxdIhkbIvlUYlAwRdXk56RBL2omhoU6zoEq+FI6di
         kUrnnlXlTfeOE7D+lrEChw9mvpbzVinRz4Uk4FkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 183/219] xfs: end sync buffer I/O properly on shutdown error
Date:   Fri, 22 Nov 2019 00:48:35 -0500
Message-Id: <20191122054911.1750-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 465fa17f4a303d9fdff9eac4d45f91ece92e96ca ]

As of commit e339dd8d8b ("xfs: use sync buffer I/O for sync delwri
queue submission"), the delwri submission code uses sync buffer I/O
for sync delwri I/O. Instead of waiting on async I/O to unlock the
buffer, it uses the underlying sync I/O completion mechanism.

If delwri buffer submission fails due to a shutdown scenario, an
error is set on the buffer and buffer completion never occurs. This
can cause xfs_buf_delwri_submit() to deadlock waiting on a
completion event.

We could check the error state before waiting on such buffers, but
that doesn't serialize against the case of an error set via a racing
I/O completion. Instead, invoke I/O completion in the shutdown case
regardless of buffer I/O type.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e839907e8492f..78173870502ce 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1470,8 +1470,7 @@ __xfs_buf_submit(
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
-		if (bp->b_flags & XBF_ASYNC)
-			xfs_buf_ioend(bp);
+		xfs_buf_ioend(bp);
 		return -EIO;
 	}
 
-- 
2.20.1

