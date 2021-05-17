Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968D1382FD4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhEQOVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238922AbhEQOTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3CC6135B;
        Mon, 17 May 2021 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260649;
        bh=Gi4mM5mHXrXlvg+hLlpM2WREGyj0O+DQD5JNREvdXpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEigyWbmqCEo3W6aEgDo/uLToWB9yNee7sfw1P8T3XnDe0PuF5IWT3xW4MWWdRWpC
         L+uZ/9iNER+34SzPcpigEw1XBm+hh1+M4VS7PeoutYMbuMF8gDV3puYBndENgllDoa
         r/lcCPQ+uLjC07xsva3n4YMRobKLAgf2hSEidFMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 142/363] fs: 9p: fix v9fs_file_open writeback fid error check
Date:   Mon, 17 May 2021 16:00:08 +0200
Message-Id: <20210517140307.420179018@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f8b139e2f24112f4e21f1eb02c7fc7600fea4b8d ]

IS_ERR() and PTR_ERR() use wrong pointer, it should be
writeback_fid, fix it.

Link: http://lkml.kernel.org/r/20210330130632.1054357-1-yangyingliang@huawei.com
Fixes: 5bfe97d7382b ("9p: Fix writeback fid incorrectly being attached to dentry")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
[Dominique: adjusted commit summary]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 649f04f112dc..59c32c9b799f 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -86,8 +86,8 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 		 * to work.
 		 */
 		writeback_fid = v9fs_writeback_fid(file_dentry(file));
-		if (IS_ERR(fid)) {
-			err = PTR_ERR(fid);
+		if (IS_ERR(writeback_fid)) {
+			err = PTR_ERR(writeback_fid);
 			mutex_unlock(&v9inode->v_mutex);
 			goto out_error;
 		}
-- 
2.30.2



