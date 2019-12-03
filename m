Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA5111D92
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfLCWyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbfLCWyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2908320803;
        Tue,  3 Dec 2019 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413693;
        bh=UXrKNNPHHCXadJX4lrOLkoDwl7hPsSWGkSDvnZUS1dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KyfOvS65pMmKKmY165GS37il9CtZJLFamUI9b0X/GlkdvgbOYhuGR7CnkXMGX+RR
         mMBitbPLzqwaVxrCyCCOhLVfdvndbrcINdurb2rDq5swVS15mt8F3sxRh7ltM5Ijmw
         6LYp7XlrOvLY0ILkUB5fQLEfBIp6fkuFVqpR+DgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 227/321] xfs: end sync buffer I/O properly on shutdown error
Date:   Tue,  3 Dec 2019 23:34:53 +0100
Message-Id: <20191203223438.926046943@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e36124546d0db..c1f7c0d5d608a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1506,8 +1506,7 @@ __xfs_buf_submit(
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



