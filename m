Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE9D3833A4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhEQPAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241868AbhEQO6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0973619A7;
        Mon, 17 May 2021 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261574;
        bh=Gi4mM5mHXrXlvg+hLlpM2WREGyj0O+DQD5JNREvdXpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8+YsmP3tJ/m6546ZOdgwl9i2wLJHo9pOFz3oAv6AWKGkVk9iymAZ8aVF7hrLIWib
         7VGJ6cxLW1qbHN4Pw7787lFuxB53CadFpqiKwIiYZvXSJm7kr0htlGQ7+T4HQKchP7
         ksHRLjjBdMQ0sOjcsKXX+g6BStBiP1BzVFjoIHwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 130/329] fs: 9p: fix v9fs_file_open writeback fid error check
Date:   Mon, 17 May 2021 16:00:41 +0200
Message-Id: <20210517140306.511284377@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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



