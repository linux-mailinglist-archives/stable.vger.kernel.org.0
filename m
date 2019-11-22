Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC8106208
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfKVF5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfKVF5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD9BE207FC;
        Fri, 22 Nov 2019 05:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402238;
        bh=uAYZUiGgVZVA8TdMU5/qfdvQ0kgDh1SXmr8vRZKpNZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzKK302VcYvJFFo7kva7NWMVthVCuFws18/JDtkX9oRDhmMQaJGYHWl2ZmSdOhN6p
         MuBcyLQIpRhxSuWvFeMZ1D4bn5VX2F7u08AjJx9VHDnLfd9+nLsCXCSPWzTb6JB8kb
         maqT2lGY/eO+TNQZ8MDpTNn7RcOyBmWIZpTmihv0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 083/127] f2fs: fix to dirty inode synchronously
Date:   Fri, 22 Nov 2019 00:55:01 -0500
Message-Id: <20191122055544.3299-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit b32e019049e959ee10ec359893c9dd5d057dad55 ]

If user change inode's i_flags via ioctl, let's add it into global
dirty list, so that checkpoint can guarantee its persistence before
fsync, it can make checkpoint keeping strong consistency.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1b17921994459..d68b0132718a6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1593,7 +1593,7 @@ static int __f2fs_ioc_setflags(struct inode *inode, unsigned int flags)
 
 	inode->i_ctime = current_time(inode);
 	f2fs_set_inode_flags(inode);
-	f2fs_mark_inode_dirty_sync(inode, false);
+	f2fs_mark_inode_dirty_sync(inode, true);
 	return 0;
 }
 
-- 
2.20.1

