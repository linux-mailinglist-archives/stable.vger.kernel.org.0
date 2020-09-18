Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA00426EFA6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgIRChU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgIRCMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3423123899;
        Fri, 18 Sep 2020 02:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395159;
        bh=yi+/pdPy4RirCx/0FCAt/gOicqPPenTfDRwNaYVViCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMH4uQd25c4YM7VcpCpdoNDGtXv3ZwMBRFEhXAaX9RUnKglC/xqBtdcgCTKQF4pQU
         0APbNT23MeRslj5wEdlg/sJP1377L7Z41eUGRptmRAP0nIFuFBQ97gLx9kdi3x/I9A
         lNVC+ymaIy6XxyDzjVQihkBCiWl3Z/u6G6rUUfYQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 4.14 017/127] xfs: fix attr leaf header freemap.size underflow
Date:   Thu, 17 Sep 2020 22:10:30 -0400
Message-Id: <20200918021220.2066485-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 2a2b5932db67586bacc560cc065d62faece5b996 ]

The leaf format xattr addition helper xfs_attr3_leaf_add_work()
adjusts the block freemap in a couple places. The first update drops
the size of the freemap that the caller had already selected to
place the xattr name/value data. Before the function returns, it
also checks whether the entries array has encroached on a freemap
range by virtue of the new entry addition. This is necessary because
the entries array grows from the start of the block (but end of the
block header) towards the end of the block while the name/value data
grows from the end of the block in the opposite direction. If the
associated freemap is already empty, however, size is zero and the
subtraction underflows the field and causes corruption.

This is reproduced rarely by generic/070. The observed behavior is
that a smaller sized freemap is aligned to the end of the entries
list, several subsequent xattr additions land in larger freemaps and
the entries list expands into the smaller freemap until it is fully
consumed and then underflows. Note that it is not otherwise a
corruption for the entries array to consume an empty freemap because
the nameval list (i.e. the firstused pointer in the xattr header)
starts beyond the end of the corrupted freemap.

Update the freemap size modification to account for the fact that
the freemap entry can be empty and thus stale.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 73a541755d5b7..4a27e2ab5b067 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1335,7 +1335,9 @@ xfs_attr3_leaf_add_work(
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (ichdr->freemap[i].base == tmp) {
 			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
-			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);
+			ichdr->freemap[i].size -=
+				min_t(uint16_t, ichdr->freemap[i].size,
+						sizeof(xfs_attr_leaf_entry_t));
 		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
-- 
2.25.1

