Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07991B74D5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgDXMYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgDXMYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B942168B;
        Fri, 24 Apr 2020 12:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731041;
        bh=CriRCGClvamC+iFzH8OrWMWdqSTNirz+iZj25GHP8jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVLZLV67ee2Gn6DqPHhYI8cAcHw9+l3IPDVBh0hWVRz31DoLF0Odowsq5g6mFHoCy
         TZM1ue+Dh8I4Z3rClY8NdrACd0T8G4Oa0bLBftfSa0LXT/44059bq85NcjPTwJRZK8
         W9xUEqLF/UqhjxF8T4v9Tw3ZqRKNyCXhISJWsM6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/18] xfs: fix partially uninitialized structure in xfs_reflink_remap_extent
Date:   Fri, 24 Apr 2020 08:23:41 -0400
Message-Id: <20200424122355.10453-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit c142932c29e533ee892f87b44d8abc5719edceec ]

In the reflink extent remap function, it turns out that uirec (the block
mapping corresponding only to the part of the passed-in mapping that got
unmapped) was not fully initialized.  Specifically, br_state was not
being copied from the passed-in struct to the uirec.  This could lead to
unpredictable results such as the reflinked mapping being marked
unwritten in the destination file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f3c393f309e19..6622652a85a80 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1058,6 +1058,7 @@ xfs_reflink_remap_extent(
 		uirec.br_startblock = irec->br_startblock + rlen;
 		uirec.br_startoff = irec->br_startoff + rlen;
 		uirec.br_blockcount = unmap_len - rlen;
+		uirec.br_state = irec->br_state;
 		unmap_len = rlen;
 
 		/* If this isn't a real mapping, we're done. */
-- 
2.20.1

