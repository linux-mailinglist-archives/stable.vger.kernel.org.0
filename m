Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA13F2C0999
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbgKWNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732833AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CEDA21741;
        Mon, 23 Nov 2020 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135694;
        bh=q0QIVCw7tDMrcy/bO5wyJr/RaP70CkiRD/Zl1SwA028=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6CmjQdlKzT8IP/EuBQO/C10br1WadZOaK562Bxu9dVCkkqYSmJzQ2+cdAg2uXxjy
         oXGbrDhCTI7atJZANJ7sLsGQulmNIXQnSFy9xfSTg1OD9vcrN/aa56XN0hASwojFza
         vgNIy/540MAMFp6guk0k5TdqQRraenYC5V+wPss8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 162/252] xfs: directory scrub should check the null bestfree entries too
Date:   Mon, 23 Nov 2020 13:21:52 +0100
Message-Id: <20201123121843.409030494@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 6b48e5b8a20f653b7d64ccf99a498f2523bff752 ]

Teach the directory scrubber to check all the bestfree entries,
including the null ones.  We want to be able to detect the case where
the entry is null but there actually /is/ a directory data block.

Found by fuzzing lbests[0] = ones in xfs/391.

Fixes: df481968f33b ("xfs: scrub directory freespace")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 7c432997edade..b045e95c2ea73 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -558,14 +558,27 @@ xchk_directory_leaf1_bestfree(
 	/* Check all the bestfree entries. */
 	for (i = 0; i < bestcount; i++, bestp++) {
 		best = be16_to_cpu(*bestp);
-		if (best == NULLDATAOFF)
-			continue;
 		error = xfs_dir3_data_read(sc->tp, sc->ip,
-				i * args->geo->fsbcount, 0, &dbp);
+				xfs_dir2_db_to_da(args->geo, i),
+				XFS_DABUF_MAP_HOLE_OK,
+				&dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
-		xchk_directory_check_freesp(sc, lblk, dbp, best);
+
+		if (!dbp) {
+			if (best != NULLDATAOFF) {
+				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+						lblk);
+				break;
+			}
+			continue;
+		}
+
+		if (best == NULLDATAOFF)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+		else
+			xchk_directory_check_freesp(sc, lblk, dbp, best);
 		xfs_trans_brelse(sc->tp, dbp);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			break;
-- 
2.27.0



