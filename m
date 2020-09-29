Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C7827C4B8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgI2LQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgI2LQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A75C21D41;
        Tue, 29 Sep 2020 11:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378160;
        bh=G2pROOOvv0dU3i/XznMnDTbgZaexADnv4FKP0yQoJY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV/W3tA7yFidhb268XibEDhwWorqSHfLJYwonn43w3gLaz8Lq9CwcWinfmodUcN/x
         0/qnNg5CxR3/c7Zi1UUblZxnbcsGBMz4tm+mGId+KOMwN9HLf4GFMym/ZkcaYSxUdR
         8I6bhKFzDoKpLBKAeB301LZVDq1Zw3B2RyieoXRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/166] xfs: dont ever return a stale pointer from __xfs_dir3_free_read
Date:   Tue, 29 Sep 2020 12:59:54 +0200
Message-Id: <20200929105939.308636246@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

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
index 682e2bf370c72..ee4ebc2dd7492 100644
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



