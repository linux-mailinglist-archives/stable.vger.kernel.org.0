Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325F03EB7BA
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbhHMPIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241190AbhHMPIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AC2461103;
        Fri, 13 Aug 2021 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867304;
        bh=Fra+xviE6GKyepm+SKDA3lXdcyo451/6M8Jg6WcLpuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJm6wohKllJSwGcuLPQ11T60XH5sqKnQ3rjFDd8L+bvJyFyeljzO9FByMmOUqA1s5
         LCEWtsaw1oFQOVG0riRzku1kdEBBwHkpebQ5APDW8nZMIKd4weX3d/ESf5Ls9SaP5q
         1fhMqwDuaQ6Oguq0ki13Q2tpt1lNpEr+CIIXI8Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c31a48e6702ccb3d64c9@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/25] reiserfs: check directory items on read from disk
Date:   Fri, 13 Aug 2021 17:06:43 +0200
Message-Id: <20210813150521.340772188@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 33b78ee9fb9e..13322c39e6cc 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -386,6 +386,24 @@ void pathrelse(struct treepath *search_path)
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
@@ -453,11 +471,14 @@ static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
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



