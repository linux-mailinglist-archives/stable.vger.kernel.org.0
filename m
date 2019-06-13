Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0571944038
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfFMQEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbfFMIrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123CB2147A;
        Thu, 13 Jun 2019 08:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415626;
        bh=D5FGKFwjFUH71ekrSHCtoUBX2CjewGvGL6JB0mWPcYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/by3k3niQenfmhYmMIFQDLMfzeoTGPrhtikox1Hi2SX5UDg/M5Q+JlTqH7mT1PEN
         069/OL+S1A48OGDaYCbtRvIujHX5G3yxhGscrGowlXz9QlT3iBecmy3MgTPftDnsEC
         p4D8cQAWp4XqMylWTfxhZCRTn/zkjiaordbBBoik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 044/155] f2fs: fix error path of recovery
Date:   Thu, 13 Jun 2019 10:32:36 +0200
Message-Id: <20190613075655.585197106@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 73338c432e7e..b14c718139a9 100644
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
@@ -370,6 +375,7 @@ next:
 				"%s: detect looped node chain, "
 				"blkaddr:%u, next:%u",
 				__func__, blkaddr, next_blkaddr_of_node(page));
+			f2fs_put_page(page, 1);
 			err = -EINVAL;
 			break;
 		}
@@ -380,7 +386,6 @@ next:
 
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



