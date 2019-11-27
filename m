Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B272D10B7DE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfK0Uhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfK0Uhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A18215B2;
        Wed, 27 Nov 2019 20:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887061;
        bh=4s8e4vFMSbvxkOqzZBgfRHrA0gBMSbB8WI/S0IuJjVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6UB94fcmPySBDsFzujMo6319Cc4x4xTt4FxgzrCyttsbGE/Vi+3wzWG2frKiuXHW
         AYJCmHu/GhAzcejqzdKa2xRsgGJRVIw05pWAS4hHDVDU1D9Wh7GAZgAqfHunhxnM3W
         F+3XyS/fqoD+m3/LJM6AHrL9it4BM2q75SHik5eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" 
        <ernesto.mnd.fernandez@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/132] hfs: fix return value of hfs_get_block()
Date:   Wed, 27 Nov 2019 21:31:02 +0100
Message-Id: <20191127203006.746354737@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit 1267a07be5ebbff2d2739290f3d043ae137c15b4 ]

Direct writes to empty inodes fail with EIO.  The generic direct-io code
is in part to blame (a patch has been submitted as "direct-io: allow
direct writes to empty inodes"), but hfs is worse affected than the other
filesystems because the fallback to buffered I/O doesn't happen.

The problem is the return value of hfs_get_block() when called with
!create.  Change it to be more consistent with the other modules.

Link: http://lkml.kernel.org/r/4538ab8c35ea37338490525f0f24cbc37227528c.1539195310.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/extent.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 1bd1afefe2538..16819d2a978b4 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -345,7 +345,9 @@ int hfs_get_block(struct inode *inode, sector_t block,
 	ablock = (u32)block / HFS_SB(sb)->fs_div;
 
 	if (block >= HFS_I(inode)->fs_blocks) {
-		if (block > HFS_I(inode)->fs_blocks || !create)
+		if (!create)
+			return 0;
+		if (block > HFS_I(inode)->fs_blocks)
 			return -EIO;
 		if (ablock >= HFS_I(inode)->alloc_blocks) {
 			res = hfs_extend_file(inode);
-- 
2.20.1



