Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054ABEEE92
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389767AbfKDWFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389760AbfKDWFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A7B218BA;
        Mon,  4 Nov 2019 22:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905099;
        bh=g/1jJJEFKW5X1R+aFTvTd5Tfcgjad6O4MnPohfqGe8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZY1wf1s2aRBAcZEDwHCbcxLnig/B3kdr7k1DLeZm+ascZoUZiOF1Kd4mR2ymKlMoD
         f0wfl1HJT+OgJ2u0FFIGoB5CrfuDvR3G4PNvcmn/AP983vh9sK9e64VI4AYeO5jv4u
         FXlo/caaAd4OvCXfwDJfYiwSLHk58bF9ygTMdoMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 028/163] nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request
Date:   Mon,  4 Nov 2019 22:43:38 +0100
Message-Id: <20191104212142.362069895@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



