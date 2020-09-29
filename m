Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DB27C3E5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgI2LJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgI2LJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 108C521D46;
        Tue, 29 Sep 2020 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377743;
        bh=Q3qlLeijSOxaR4t888kSr+We1cYAMIVWVmTCZIAu9lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3V+vT5bfcWZ4Nyt2daMOwWuRX+DQj7O6aYuBZ6os7qdkh4BOIzLNazEXbOBNEw60
         jOXFVE8DvSNbLVnn6iXaE4YpxQdMuo6+04GcliqHPiYwp8TOr6gtQIEdpLpTnVEWbP
         MP+KidN/j+Uea/d31BDu78gd9WMCIXLwHNxjsirM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/121] xfs: fix attr leaf header freemap.size underflow
Date:   Tue, 29 Sep 2020 12:59:30 +0200
Message-Id: <20200929105931.488431418@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7b9dd76403bfd..537acde2c497b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1332,7 +1332,9 @@ xfs_attr3_leaf_add_work(
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



