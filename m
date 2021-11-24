Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0745C4E9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbhKXNxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354525AbhKXNvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:51:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2965861155;
        Wed, 24 Nov 2021 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759062;
        bh=gBLkBueN3XR4mRvguawLiob9dAk/rs3Twl2v3FNY7xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKyxhjSRzgb82JUKTXHYfoPCpeYbgyZ7socS9IJDIcOi6n+srcxIMwt0foTO7/5zB
         lAx+RiRHgE0qCmo2Qdoy/ixRjHBMF9sfUIuH2NksuvtBQ8c2fl3+JIOZAwv+oDcboc
         AY7wuFQ5kepxmUPdEwuaremCrhcb/S4uM3ID272c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungjong Seo <sj1557.seo@samsung.com>,
        Hyeong-Jun Kim <hj514.kim@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/279] f2fs: compress: disallow disabling compress on non-empty compressed file
Date:   Wed, 24 Nov 2021 12:56:15 +0100
Message-Id: <20211124115721.751215916@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeong-Jun Kim <hj514.kim@samsung.com>

[ Upstream commit 02d58cd253d7536c412993573fc6b3b4454960eb ]

Compresse file and normal file has differ in i_addr addressing,
specifically addrs per inode/block. So, we will face data loss, if we
disable the compression flag on non-empty files. Therefore we should
disallow not only enabling but disabling the compression flag on
non-empty files.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Hyeong-Jun Kim <hj514.kim@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b339ae89c1ad1..c242274e3479b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4152,8 +4152,7 @@ static inline bool f2fs_disable_compressed_file(struct inode *inode)
 
 	if (!f2fs_compressed_file(inode))
 		return true;
-	if (S_ISREG(inode->i_mode) &&
-		(get_dirty_pages(inode) || atomic_read(&fi->i_compr_blocks)))
+	if (S_ISREG(inode->i_mode) && F2FS_HAS_BLOCKS(inode))
 		return false;
 
 	fi->i_flags &= ~F2FS_COMPR_FL;
-- 
2.33.0



