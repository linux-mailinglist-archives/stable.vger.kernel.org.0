Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92A29BC39
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801790AbgJ0PoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801041AbgJ0PhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D6F204EF;
        Tue, 27 Oct 2020 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813043;
        bh=OxJs6otOzaSwI6uvGmQVX7oyaBZuQCa4KxT1dSYTM3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewhaYgLgTJlA/2abAh7l4o79u/ZRVVOn/yh4Z9B07lBEtf874jo324KeV5Qku88Ye
         UPnxwEJX5WnDSVT3KyU3TC8Nk7ufa+0YeGOrPZoHF/dSprAqv7qaUpn469BrUZvh7a
         YFqTuENI468Cr8RvjKXvaAjETShH5nVQDGVgdzWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Scott <nathans@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 419/757] xfs: fix finobt btree block recovery ordering
Date:   Tue, 27 Oct 2020 14:51:09 +0100
Message-Id: <20201027135510.233835466@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 671459676ab0e1d371c8d6b184ad1faa05b6941e ]

Nathan popped up on #xfs and pointed out that we fail to handle
finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
always fall through the entire magic number matching code to "recover
immediately". Whilst most of the time this is the correct behaviour,
occasionally it will be incorrect and could potentially overwrite
more recent metadata because we don't check the LSN in the on disk
metadata at all.

This bug has been present since the finobt was first introduced, and
is a potential cause of the occasional xfs_iget_check_free_state()
failures we see that indicate that the inode btree state does not
match the on disk inode state.

Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
Reported-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8f0457d67d779..de2772394de21 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -719,6 +719,8 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
 	case XFS_REFC_CRC_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+	case XFS_FIBT_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
-- 
2.25.1



