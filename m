Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A51DD28C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390028AbfJRWMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390014AbfJRWKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:10:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBEC02245C;
        Fri, 18 Oct 2019 22:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436621;
        bh=Prfl26erNfYF8RnVidZiEPq31ZLT7YCbGIN3tQcM+3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NDokq4/z3it31zhmKvKqXNNQcqIAS1PQx0KniaqLZe2XXzsYcfbMh1tRRW8grKmE
         ddRD7TqvT7zVoYzD4IOndXbThdUzKoDz847HjilL6BgfYhWXLs+7sQ1aqE+of0GALu
         wwBO8FjAIGEm/CUh1iAqF3pQBCdFEhpf47s979+s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/21] nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request
Date:   Fri, 18 Oct 2019 18:09:55 -0400
Message-Id: <20191018221007.10851-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018221007.10851-1-sashal@kernel.org>
References: <20191018221007.10851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 33ea5aaa87cdae0f9af4d6b7ee4f650a1a36fd1d ]

When xfstests testing, there are some WARNING as below:

WARNING: CPU: 0 PID: 6235 at fs/nfs/inode.c:122 nfs_clear_inode+0x9c/0xd8
Modules linked in:
CPU: 0 PID: 6235 Comm: umount.nfs
Hardware name: linux,dummy-virt (DT)
pstate: 60000005 (nZCv daif -PAN -UAO)
pc : nfs_clear_inode+0x9c/0xd8
lr : nfs_evict_inode+0x60/0x78
sp : fffffc000f68fc00
x29: fffffc000f68fc00 x28: fffffe00c53155c0
x27: fffffe00c5315000 x26: fffffc0009a63748
x25: fffffc000f68fd18 x24: fffffc000bfaaf40
x23: fffffc000936d3c0 x22: fffffe00c4ff5e20
x21: fffffc000bfaaf40 x20: fffffe00c4ff5d10
x19: fffffc000c056000 x18: 000000000000003c
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000040 x14: 0000000000000228
x13: fffffc000c3a2000 x12: 0000000000000045
x11: 0000000000000000 x10: 0000000000000000
x9 : 0000000000000000 x8 : 0000000000000000
x7 : 0000000000000000 x6 : fffffc00084b027c
x5 : fffffc0009a64000 x4 : fffffe00c0e77400
x3 : fffffc000c0563a8 x2 : fffffffffffffffb
x1 : 000000000000764e x0 : 0000000000000001
Call trace:
 nfs_clear_inode+0x9c/0xd8
 nfs_evict_inode+0x60/0x78
 evict+0x108/0x380
 dispose_list+0x70/0xa0
 evict_inodes+0x194/0x210
 generic_shutdown_super+0xb0/0x220
 nfs_kill_super+0x40/0x88
 deactivate_locked_super+0xb4/0x120
 deactivate_super+0x144/0x160
 cleanup_mnt+0x98/0x148
 __cleanup_mnt+0x38/0x50
 task_work_run+0x114/0x160
 do_notify_resume+0x2f8/0x308
 work_pending+0x8/0x14

The nrequest should be increased/decreased only if PG_INODE_REF flag
was setted.

But in the nfs_inode_remove_request function, it maybe decrease when
no PG_INODE_REF flag, this maybe lead nrequests count error.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 6e81a5b5858ec..5df35475eea82 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -725,8 +725,10 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 		spin_unlock(&inode->i_lock);
 	}
 
-	if (test_and_clear_bit(PG_INODE_REF, &req->wb_flags))
+	if (test_and_clear_bit(PG_INODE_REF, &req->wb_flags)) {
 		nfs_release_request(req);
+		atomic_long_dec(&nfsi->nrequests);
+	}
 }
 
 static void
-- 
2.20.1

