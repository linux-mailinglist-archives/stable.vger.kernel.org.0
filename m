Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48157614864
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKALRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKALRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:17:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D44186C9
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 04:17:44 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1nYC674TzHvQ5;
        Tue,  1 Nov 2022 19:17:19 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:17:37 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <leo.lilong@huawei.com>
CC:     Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        <syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH openEuler-22.03-LTS] nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
Date:   Tue, 1 Nov 2022 19:39:18 +0800
Message-ID: <20221101113918.715622-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

mainline inclusion
from mainline-v6.0-rc3
commit 21a87d88c2253350e115029f14fe2a10a7e6c856
category: bugfix
bugzilla: https://gitee.com/src-openeuler/kernel/issues/I5X1Z4
CVE: CVE-2022-3621

Reference: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=21a87d88c2253350e115029f14fe2a10a7e6c856

--------------------------------

If the i_mode field in inode of metadata files is corrupted on disk, it
can cause the initialization of bmap structure, which should have been
called from nilfs_read_inode_common(), not to be called.  This causes a
lockdep warning followed by a NULL pointer dereference at
nilfs_bmap_lookup_at_level().

This patch fixes these issues by adding a missing sanitiy check for the
i_mode field of metadata file's inode.

Link: https://lkml.kernel.org/r/20221002030804.29978-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/nilfs2/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ca380c6d7825..bfe3c7ccdf50 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -462,6 +462,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
-- 
2.31.1

