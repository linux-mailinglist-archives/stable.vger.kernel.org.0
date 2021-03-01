Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF454328041
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhCAOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:06:40 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:51830
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S236207AbhCAOGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:06:12 -0500
Received: from pekshcsitd06010.hihonor.com (unknown [198.19.131.2])
        by front-2 (Coremail) with SMTP id DAGowAAH1IB19Dxgc9pDAA--.11211S2;
        Mon, 01 Mar 2021 22:04:37 +0800 (CST)
From:   Yunlei He <heyunlei@hihonor.com>
To:     heyunlei@hihonor.com
Cc:     stable@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] f2fs: fsverity: Truncate cache pages if set verity failed
Date:   Mon,  1 Mar 2021 22:04:36 +0800
Message-Id: <20210301140436.5562-1-heyunlei@hihonor.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DAGowAAH1IB19Dxgc9pDAA--.11211S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFW8AFW7KrWxuw1xXFWfAFb_yoW8tr4Dpr
        9xAFWakw48XrW7WwnakF1UZr15Ka48K3yj9as3uwn3uF1kZw1FqFyIyrW0vFW3tFWDXw42
        qr4jkay7Gw1DGw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
        twAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF
        04k20xvE74AGY7Cv6cx26ryfJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUr7
        KsUUUUU
X-CM-SenderInfo: pkh130hohlqxxlkr003uof0z/1tbiAQIJEV3ki2mkXAAAs4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If file enable verity failed, should truncate anything wrote
past i_size, including cache pages.

Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Yunlei He <heyunlei@hihonor.com>
---
 fs/f2fs/verity.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 054ec852b5ea..3aa851affc46 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -158,33 +158,36 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
 		.size = cpu_to_le32(desc_size),
 		.pos = cpu_to_le64(desc_pos),
 	};
-	int err = 0;
+	int err;
 
-	if (desc != NULL) {
-		/* Succeeded; write the verity descriptor. */
-		err = pagecache_write(inode, desc, desc_size, desc_pos);
+	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	if (!desc)
+		return 0;
 
-		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
-		if (!err)
-			err = filemap_write_and_wait(inode->i_mapping);
-	}
+	/* Succeeded; write the verity descriptor. */
+	err = pagecache_write(inode, desc, desc_size, desc_pos);
+	if (err)
+		goto out;
 
-	/* If we failed, truncate anything we wrote past i_size. */
-	if (desc == NULL || err)
-		f2fs_truncate(inode);
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto out;
 
-	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
+	err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
+			    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
+			    NULL, XATTR_CREATE);
+	if (err)
+		goto out;
 
-	if (desc != NULL && !err) {
-		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
-				    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
-				    NULL, XATTR_CREATE);
-		if (!err) {
-			file_set_verity(inode);
-			f2fs_set_inode_flags(inode);
-			f2fs_mark_inode_dirty_sync(inode, true);
-		}
-	}
+	file_set_verity(inode);
+	f2fs_set_inode_flags(inode);
+	f2fs_mark_inode_dirty_sync(inode, true);
+
+	return 0;
+out:
+	/* If we failed, truncate anything we wrote past i_size. */
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	f2fs_truncate(inode);
 	return err;
 }
 
-- 
2.17.1

