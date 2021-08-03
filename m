Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069F13DECAE
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhHCLo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236249AbhHCLog (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B776360F11;
        Tue,  3 Aug 2021 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991065;
        bh=dTVsgaI0Ijz/iBriwJNSMb7CCOp1qtmBVnOwQDSdRcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgevFu2Tcs5uvmr9I8Kz4wkBcb35EEmMgg8A9WIyo5KJH5y8fqAFYUPSQSgRvHpic
         AZw7qGnodOO29KREHLty5gTheqn9p1KtwArk0IzX7TOyAVNL6W50/sidfA+b+y/zv2
         sJlp0VpD6rcUD6PYiIq7iRO2tICru+i2zxUgVy0bSRKMW7EOOJ2EjFRk8RLY6MxpDp
         9j2+jCE5KtnEWWkw2+BUlUonvUOK1QjFX1VTHsl+Ll3QW835EemrQAVjYSq8UpitgT
         zYrPPGB03i4fcvCVMhKFLi9OvqYYlFyRT0Tgis6AKWD0LitXEdGGO9WPhw+e0OE1p5
         XOzLL6k8O9h0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        syzbot+c31a48e6702ccb3d64c9@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/6] reiserfs: check directory items on read from disk
Date:   Tue,  3 Aug 2021 07:44:18 -0400
Message-Id: <20210803114421.2252840-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114421.2252840-1-sashal@kernel.org>
References: <20210803114421.2252840-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

[ Upstream commit 13d257503c0930010ef9eed78b689cec417ab741 ]

While verifying the leaf item that we read from the disk, reiserfs
doesn't check the directory items, this could cause a crash when we
read a directory item from the disk that has an invalid deh_location.

This patch adds a check to the directory items read from the disk that
does a bounds check on deh_location for the directory entries. Any
directory entry header with a directory entry offset greater than the
item length is considered invalid.

Link: https://lore.kernel.org/r/20210709152929.766363-1-chouhan.shreyansh630@gmail.com
Reported-by: syzbot+c31a48e6702ccb3d64c9@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 9e64e23014e8..07d787145cc3 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -387,6 +387,24 @@ void pathrelse(struct treepath *search_path)
 	search_path->path_length = ILLEGAL_PATH_ELEMENT_OFFSET;
 }
 
+static int has_valid_deh_location(struct buffer_head *bh, struct item_head *ih)
+{
+	struct reiserfs_de_head *deh;
+	int i;
+
+	deh = B_I_DEH(bh, ih);
+	for (i = 0; i < ih_entry_count(ih); i++) {
+		if (deh_location(&deh[i]) > ih_item_len(ih)) {
+			reiserfs_warning(NULL, "reiserfs-5094",
+					 "directory entry location seems wrong %h",
+					 &deh[i]);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
 static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
 {
 	struct block_head *blkh;
@@ -454,11 +472,14 @@ static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
 					 "(second one): %h", ih);
 			return 0;
 		}
-		if (is_direntry_le_ih(ih) && (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE))) {
-			reiserfs_warning(NULL, "reiserfs-5093",
-					 "item entry count seems wrong %h",
-					 ih);
-			return 0;
+		if (is_direntry_le_ih(ih)) {
+			if (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE)) {
+				reiserfs_warning(NULL, "reiserfs-5093",
+						 "item entry count seems wrong %h",
+						 ih);
+				return 0;
+			}
+			return has_valid_deh_location(bh, ih);
 		}
 		prev_location = ih_location(ih);
 	}
-- 
2.30.2

