Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947152ABC85
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgKINiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgKINB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53BA206C0;
        Mon,  9 Nov 2020 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926917;
        bh=gB8obUv6WNp1jhhZllmd3FJBO+me5pu0XTCl/9bAw3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIeu2QLgUmXYYauJTcWjJGshX0CMLa89zCMfZgwABGI+/RWLoftg4PXwyhdsTHscO
         CK1F5L8CykLr+KWovQ7rCf0taJxO3EVEk5vwmKcmPEmaiCqrYl2hM+3JfAToSsjyWh
         z38InwOLABTchUMNrtApzdRhPqyrikiKigPWoTzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/117] f2fs: add trace exit in exception path
Date:   Mon,  9 Nov 2020 13:54:04 +0100
Message-Id: <20201109125026.512041324@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 9b66482282888d02832b7d90239e1cdb18e4b431 ]

Missing the trace exit in f2fs_sync_dirty_inodes

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0b061bbf1639a..c1b24d7aa6ef1 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -904,8 +904,12 @@ int sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
 				get_pages(sbi, is_dir ?
 				F2FS_DIRTY_DENTS : F2FS_DIRTY_DATA));
 retry:
-	if (unlikely(f2fs_cp_error(sbi)))
+	if (unlikely(f2fs_cp_error(sbi))) {
+		trace_f2fs_sync_dirty_inodes_exit(sbi->sb, is_dir,
+				get_pages(sbi, is_dir ?
+				F2FS_DIRTY_DENTS : F2FS_DIRTY_DATA));
 		return -EIO;
+	}
 
 	spin_lock(&sbi->inode_lock[type]);
 
-- 
2.27.0



