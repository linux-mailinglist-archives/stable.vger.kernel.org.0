Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D43E7E90
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhHJReP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhHJRdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59564610CC;
        Tue, 10 Aug 2021 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616795;
        bh=hVRjeIKeqGzKqDwszUGsi+lUR5UdWKTKaBB8H9mmTzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuvibdVVIEEtZO7NEv6BYa7yqgHn68jnSs4Vd5u11cY0hS/G3QRiAMuDXOrqJNNWX
         0Szat1paaBSMayovGluhBfc4AoPrAA+vybGw9jtaA2zVkX3Wolt007B9h/uDBACCB/
         IPU3UQ3uEx16tfbM7r2NPA1lW+6325DJmOwWh5ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c31a48e6702ccb3d64c9@syzkaller.appspotmail.com,
        Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/54] reiserfs: check directory items on read from disk
Date:   Tue, 10 Aug 2021 19:30:45 +0200
Message-Id: <20210810172945.892055610@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index 5229038852ca..4ebad6781b0e 100644
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



