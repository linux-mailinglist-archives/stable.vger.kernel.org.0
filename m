Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462F22B60B9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgKQNML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbgKQNMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:12:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD2B24199;
        Tue, 17 Nov 2020 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618728;
        bh=hNBuE05tx2UA5FFxJmgDGikRZUiHpt5WoUd97r9C9ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5ucD5+c//kVrkPIBoYdZ4Gm5iliP5CUPDzlcJWJ9dXooXc9NNa9Gs4R2I21veL+p
         sY9KL+CKowi6ZVBzHeFlBRWChVV9/rCvXNj92DLyGPfqZnxqUXM4SH0qSX5XCtKVYw
         dwcEWMnnG3jM+5nRyKLDN7k9eqnfDudjexM3kcJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/78] xfs: fix flags argument to rmap lookup when converting shared file rmaps
Date:   Tue, 17 Nov 2020 14:05:03 +0100
Message-Id: <20201117122110.917210447@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit ea8439899c0b15a176664df62aff928010fad276 ]

Pass the same oldext argument (which contains the existing rmapping's
unwritten state) to xfs_rmap_lookup_le_range at the start of
xfs_rmap_convert_shared.  At this point in the code, flags is zero,
which means that we perform lookups using the wrong key.

Fixes: 3f165b334e51 ("xfs: convert unwritten status of reverse mappings for shared files")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3a8cc7139912b..89fdcc641715f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1318,7 +1318,7 @@ xfs_rmap_convert_shared(
 	 * record for our insertion point. This will also give us the record for
 	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, flags,
+	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, oldext,
 			&PREV, &i);
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 
-- 
2.27.0



