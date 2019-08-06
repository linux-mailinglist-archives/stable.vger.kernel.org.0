Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881B383BD6
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfHFViQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbfHFViM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:38:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 422E621882;
        Tue,  6 Aug 2019 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127491;
        bh=qGsun2nBwGKYUuXuCKiiDlZM9Ty0QpT5hz8syLcrrzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0Nzr7dVCQNlINWHbrKM5jMpZ2eWzG4mGpI5niMA+wqoZk5G86WMxY/F4+GwluuLu
         d7nFS3b2HqsTHKXUN+z9CWBnHPjRqu3zwU9wWV76FpaadxuBiwJW0d12ZB3SckZBQz
         l8IUmgZI0KeSflncIz5eok7ZVXAB67Es/4V8+VYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 12/14] ocfs2: remove set but not used variable 'last_hash'
Date:   Tue,  6 Aug 2019 17:37:46 -0400
Message-Id: <20190806213749.20689-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213749.20689-1-sashal@kernel.org>
References: <20190806213749.20689-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 7bc36e3ce91471b6377c8eadc0a2f220a2280083 ]

Fixes gcc '-Wunused-but-set-variable' warning:

  fs/ocfs2/xattr.c: In function ocfs2_xattr_bucket_find:
  fs/ocfs2/xattr.c:3828:6: warning: variable last_hash set but not used [-Wunused-but-set-variable]

It's never used and can be removed.

Link: http://lkml.kernel.org/r/20190716132110.34836-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4f0788232f2f9..06faa608e5622 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3808,7 +3808,6 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	int low_bucket = 0, bucket, high_bucket;
 	struct ocfs2_xattr_bucket *search;
-	u32 last_hash;
 	u64 blkno, lower_blkno = 0;
 
 	search = ocfs2_xattr_bucket_new(inode);
@@ -3852,8 +3851,6 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 		if (xh->xh_count)
 			xe = &xh->xh_entries[le16_to_cpu(xh->xh_count) - 1];
 
-		last_hash = le32_to_cpu(xe->xe_name_hash);
-
 		/* record lower_blkno which may be the insert place. */
 		lower_blkno = blkno;
 
-- 
2.20.1

