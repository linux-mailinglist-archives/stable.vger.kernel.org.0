Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D60926EDBA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIRCXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgIRCQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31852396E;
        Fri, 18 Sep 2020 02:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395416;
        bh=hCxE8SWHgewYZ9DYUNh1Anq92mUImfrpYig4ZjGy+Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUwtROeDlZTTv+YtvQkJn2kxfiFT32VYa44mCPnAyIQcwPvriWfyts5/TIFGYYt7j
         hV2EWUPDLLxybKtF3h7fVlcz9/qIVJKi/Uak+1PKi7Q3uZobZlo09e3iI3YI6VarPb
         6ma8PTl3pxDB/GSDJX/vVbXxRgJQ/sx2IL/Fd9l8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 4.4 11/64] xfs: fix attr leaf header freemap.size underflow
Date:   Thu, 17 Sep 2020 22:15:50 -0400
Message-Id: <20200918021643.2067895-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
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
index 445a3f2f871fb..d50f8183dda46 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1326,7 +1326,9 @@ xfs_attr3_leaf_add_work(
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

