Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644AA26EE2D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgIRC0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgIRCQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A07A23977;
        Fri, 18 Sep 2020 02:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395355;
        bh=HoEJHSuSC3WoC4fJuv/cSWXVqx51YbdqwK1THED12wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9/RXmJ3l6pRsxoJqPH4kf9kUjjurUqLizLCnYUAC3MfrwvSg64TPq9JH2rO8hs2+
         sG0jenHGv4PTA8JBvcZg/qz6vVD2i1ATvpNo+cRt6wAaFGx7WDqRPNWUe07GetQtme
         2AwBeCeRzjXehh6zSasAAXoNrBR14RhhNUdG0VpQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 4.9 50/90] xfs: don't ever return a stale pointer from __xfs_dir3_free_read
Date:   Thu, 17 Sep 2020 22:14:15 -0400
Message-Id: <20200918021455.2067301-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 1cb5deb5bc095c070c09a4540c45f9c9ba24be43 ]

If we decide that a directory free block is corrupt, we must take care
not to leak a buffer pointer to the caller.  After xfs_trans_brelse
returns, the buffer can be freed or reused, which means that we have to
set *bpp back to NULL.

Callers are supposed to notice the nonzero return value and not use the
buffer pointer, but we should code more defensively, even if all current
callers handle this situation correctly.

Fixes: de14c5f541e7 ("xfs: verify free block header fields")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index bbd1238852b3c..df7f33e60a4f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -212,6 +212,7 @@ __xfs_dir3_free_read(
 		xfs_buf_ioerror(*bpp, -EFSCORRUPTED);
 		xfs_verifier_error(*bpp);
 		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
 		return -EFSCORRUPTED;
 	}
 
-- 
2.25.1

