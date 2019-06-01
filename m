Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4D031EC8
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfFANVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfFANVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18B9D272F6;
        Sat,  1 Jun 2019 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395278;
        bh=KyJQPpQA3t/kHSchWa3aIy96jwgQX46ZurVe8ZfdpHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow1fWcHKgSB2mq5ntdSS8dz4MwkZiJuEH3VlN812O60LQtG4Uy81wDZ/fAf+bDfvO
         D8oFJYD+K5RByUh11HuOolOVLkUtnyxlcB5e3Ot0odCV29QJlaV2lRvuMF8poJCGHi
         ApYo6DTzuksxJObf9yijAOh8k4yl4HVHBO8Vnxro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.0 042/173] f2fs: fix error path of recovery
Date:   Sat,  1 Jun 2019 09:17:14 -0400
Message-Id: <20190601131934.25053-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 988385795c7f46b231982d54750587f204bd558b ]

There are some places in where we missed to unlock page or unlock page
incorrectly, fix them.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 73338c432e7e4..b14c718139a96 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -325,8 +325,10 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
 			break;
 		}
 
-		if (!is_recoverable_dnode(page))
+		if (!is_recoverable_dnode(page)) {
+			f2fs_put_page(page, 1);
 			break;
+		}
 
 		if (!is_fsync_dnode(page))
 			goto next;
@@ -338,8 +340,10 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
 			if (!check_only &&
 					IS_INODE(page) && is_dent_dnode(page)) {
 				err = f2fs_recover_inode_page(sbi, page);
-				if (err)
+				if (err) {
+					f2fs_put_page(page, 1);
 					break;
+				}
 				quota_inode = true;
 			}
 
@@ -355,6 +359,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
 					err = 0;
 					goto next;
 				}
+				f2fs_put_page(page, 1);
 				break;
 			}
 		}
@@ -370,6 +375,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
 				"%s: detect looped node chain, "
 				"blkaddr:%u, next:%u",
 				__func__, blkaddr, next_blkaddr_of_node(page));
+			f2fs_put_page(page, 1);
 			err = -EINVAL;
 			break;
 		}
@@ -380,7 +386,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head,
 
 		f2fs_ra_meta_pages_cond(sbi, blkaddr);
 	}
-	f2fs_put_page(page, 1);
 	return err;
 }
 
@@ -674,8 +679,10 @@ static int recover_data(struct f2fs_sb_info *sbi, struct list_head *inode_list,
 		 */
 		if (IS_INODE(page)) {
 			err = recover_inode(entry->inode, page);
-			if (err)
+			if (err) {
+				f2fs_put_page(page, 1);
 				break;
+			}
 		}
 		if (entry->last_dentry == blkaddr) {
 			err = recover_dentry(entry->inode, page, dir_list);
-- 
2.20.1

