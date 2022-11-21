Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901C7631C96
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiKUJOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKUJOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:14:50 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA27EC94;
        Mon, 21 Nov 2022 01:14:48 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NG1p56V9qzqSZZ;
        Mon, 21 Nov 2022 17:10:53 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 17:14:47 +0800
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 17:14:46 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <chenzhongjin@huawei.com>, <konishi.ryusuke@gmail.com>,
        <akpm@linux-foundation.org>
Subject: [PATCH v3] nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date:   Mon, 21 Nov 2022 17:11:41 +0800
Message-ID: <20221121091141.214703-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When extending segments, nilfs_sufile_alloc() is called to get an
unassigned segment, then mark it as dirty to avoid accidentally
allocating the same segment in the future.

But for some special cases such as a corrupted image it can be
unreliable.
If such corruption of the dirty state of the segment occurs, nilfs2 may
reallocate a segment that is in use and pick the same segment for
writing twice at the same time.

This will cause the problem reported by syzkaller:
https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
It supposed segment 4 has already been allocated and marked as dirty.

However the dirty state was corrupted and segment 4 usage was not dirty.
For the first time nilfs_segctor_extend_segments() segment 4 was
allocated again, which made segbuf2 and next segbuf3 had same segment 4.

sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is
added to both buffer lists of two segbuf. It makes the lists broken
which causes NULL pointer dereference.

Fix the problem by setting usage as dirty every time in
nilfs_sufile_mark_dirty(), which is called during constructing current
segment to be written out and before allocating next segment.

Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Cc: stable@vger.kernel.org
Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
Reported-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
v1 -> v2:
1) Add lock protection as Ryusuke suggested and slightly fix commit
message.
2) Fix and add tags.

v2 -> v3:
Fix commit message to make it clear.
---
 fs/nilfs2/sufile.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 77ff8e95421f..dc359b56fdfa 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -495,14 +495,22 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+		nilfs_segment_usage_set_dirty(su);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
+	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
 
-- 
2.17.1

