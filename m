Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C02C0AEE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgKWMcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgKWMcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9C02076E;
        Mon, 23 Nov 2020 12:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134735;
        bh=zTqSVl6e/CwJ8uAp5qgjjh0A/0uAZHROmGN2twz+niA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsxnOwBQ+rJp5YILwKcn5jYwd7hTXeYUbXVdMfLHOtXvvpRs65coaxPk8CHYr6ybp
         PYLEm5oUJ4I41BhLge8IuuRhO+5uSBUY/d1YIerSwCsuv/vSQgqhDamRQ98zZQH1MV
         mH50UoK7Q8leG1hQHSbXmOYWxIplfyOwu3RWizPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 63/91] xfs: revert "xfs: fix rmap key and record comparison functions"
Date:   Mon, 23 Nov 2020 13:22:23 +0100
Message-Id: <20201123121812.382866887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit eb8409071a1d47e3593cfe077107ac46853182ab ]

This reverts commit 6ff646b2ceb0eec916101877f38da0b73e3a5b7f.

Your maintainer committed a major braino in the rmap code by adding the
attr fork, bmbt, and unwritten extent usage bits into rmap record key
comparisons.  While XFS uses the usage bits *in the rmap records* for
cross-referencing metadata in xfs_scrub and xfs_repair, it only needs
the owner and offset information to distinguish between reverse mappings
of the same physical extent into the data fork of a file at multiple
offsets.  The other bits are not important for key comparisons for index
lookups, and never have been.

Eric Sandeen reports that this causes regressions in generic/299, so
undo this patch before it does more damage.

Reported-by: Eric Sandeen <sandeen@sandeen.net>
Fixes: 6ff646b2ceb0 ("xfs: fix rmap key and record comparison functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 77528f413286b..f79cf040d7450 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -247,8 +247,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = be64_to_cpu(kp->rm_offset);
-	y = xfs_rmap_irec_offset_pack(rec);
+	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
+	y = rec->rm_offset;
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -279,8 +279,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = be64_to_cpu(kp1->rm_offset);
-	y = be64_to_cpu(kp2->rm_offset);
+	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
+	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -393,8 +393,8 @@ xfs_rmapbt_keys_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = be64_to_cpu(k1->rmap.rm_offset);
-	b = be64_to_cpu(k2->rmap.rm_offset);
+	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;
@@ -423,8 +423,8 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = be64_to_cpu(r1->rmap.rm_offset);
-	b = be64_to_cpu(r2->rmap.rm_offset);
+	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
+	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;
-- 
2.27.0



