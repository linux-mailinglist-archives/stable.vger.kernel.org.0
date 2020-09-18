Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58326F31D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgIRDEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgIRCEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EDFD23731;
        Fri, 18 Sep 2020 02:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394682;
        bh=a3KtIY3zS5tFGMw/4re3J0MkdSRhsoocIYujeU5Ijgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSYmj3Rd09vzCtk6Y1ljYdeR93aknvKd7cuijxdq0G5zi7cmkn82yGEJG5VQraqmu
         pV9uStMslnO188s7iaulFw/TvtjYndjETYv9FKAMbgdN8BN0wsJnxEfsLa4Xpbi25h
         wyArt+A5YrexKNgxrkCFVvYx28wZW+ekz2LWPhGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 5.4 172/330] xfs: mark dir corrupt when lookup-by-hash fails
Date:   Thu, 17 Sep 2020 21:58:32 -0400
Message-Id: <20200918020110.2063155-172-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 2e107cf869eecc770e3f630060bb4e5f547d0fd8 ]

In xchk_dir_actor, we attempt to validate the directory hash structures
by performing a directory entry lookup by (hashed) name.  If the lookup
returns ENOENT, that means that the hash information is corrupt.  The
_process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e11721eb99..20eca2d8e7c77 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -152,6 +152,9 @@ xchk_dir_actor(
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	/* ENOENT means the hash lookup failed and the dir is corrupt */
+	if (error == -ENOENT)
+		error = -EFSCORRUPTED;
 	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
-- 
2.25.1

