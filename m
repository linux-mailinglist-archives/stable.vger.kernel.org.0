Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DD0201269
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbgFSPXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393146AbgFSPXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1281D20B80;
        Fri, 19 Jun 2020 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580185;
        bh=vYquxl+ManGyj2gJMnWxQGcOa7hy+NmSwUArZP+m8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXa29vNPEEUYpsOkpaeDWvQw8E//YywHkUIdg2IA5Q2Vr/wBHMRy9ZcPFZ606Y11k
         EPNzn02Oc1gkHhN8S1i2Ajq0HBaTIaZTKRzULZjI0anuwo13s5CMUKBYw/H+twq/eX
         fyBLLLLumw9A4juJt72hJ918tLyydelW6qtK0mjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 155/376] xfs: clean up the error handling in xfs_swap_extents
Date:   Fri, 19 Jun 2020 16:31:13 +0200
Message-Id: <20200619141717.658904179@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 8bc3b5e4b70d28f8edcafc3c9e4de515998eea9e ]

Make sure we release resources properly if we cannot clean out the COW
extents in preparation for an extent swap.

Fixes: 96987eea537d6c ("xfs: cancel COW blocks before swapext")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f800f7fe888..cc23a3e23e2d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1606,7 +1606,7 @@ xfs_swap_extents(
 	if (xfs_inode_has_cow_data(tip)) {
 		error = xfs_reflink_cancel_cow_range(tip, 0, NULLFILEOFF, true);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.25.1



