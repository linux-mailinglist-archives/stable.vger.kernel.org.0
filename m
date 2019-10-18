Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480C7DD4CC
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406449AbfJRW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfJRWEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABB122459;
        Fri, 18 Oct 2019 22:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436239;
        bh=g/1jJJEFKW5X1R+aFTvTd5Tfcgjad6O4MnPohfqGe8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf4PalOdWMkc0C5DcfyqDwlrCLPhVgd6yISvUrO8BWibbGKFObIgApSnHgUb/q+Qs
         PXh3fexKLrfvk3CKJCcDIIdO6lAJ5itgeFT25NA2TnsbXqi9TKjsT0aRj/HFVQaFAz
         WNbKZhOpW6CRzjtOlwukiozEeOHx4JrZ0zukiYAg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 24/89] nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request
Date:   Fri, 18 Oct 2019 18:02:19 -0400
Message-Id: <20191018220324.8165-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
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
 fs/nfs/write.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 85ca49549b39b..52cab65f91cf0 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -786,7 +786,6 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_page *head;
 
-	atomic_long_dec(&nfsi->nrequests);
 	if (nfs_page_group_sync_on_bit(req, PG_REMOVE)) {
 		head = req->wb_head;
 
@@ -799,8 +798,10 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 		spin_unlock(&mapping->private_lock);
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

