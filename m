Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E162353D9F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhDEJAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhDEJAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C3F60238;
        Mon,  5 Apr 2021 09:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613246;
        bh=AV/wOrxnF/5vbmy5v8Z0zvI9q7wb9WqlssRbGwDsn84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mL7+Vl4DJIgt5kTlBpfjKwYYPRifn3YeMBp5YRz4WOSKEW0cPWUYkIdBkAoIidNcv
         9TRxOuDLujHv6DhFxy10Ir8ohfbDCHYOCfUKoRZhPREF4GMNVb2GIVVVrwfOpvfnkM
         c0yincLYKRsygM5Fnnv2sHqBc7+IIPnayA2Lfzkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/56] ext4: do not iput inode under running transaction in ext4_rename()
Date:   Mon,  5 Apr 2021 10:53:53 +0200
Message-Id: <20210405085023.246560383@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit 5dccdc5a1916d4266edd251f20bbbb113a5c495f ]

In ext4_rename(), when RENAME_WHITEOUT failed to add new entry into
directory, it ends up dropping new created whiteout inode under the
running transaction. After commit <9b88f9fb0d2> ("ext4: Do not iput inode
under running transaction"), we follow the assumptions that evict() does
not get called from a transaction context but in ext4_rename() it breaks
this suggestion. Although it's not a real problem, better to obey it, so
this patch add inode to orphan list and stop transaction before final
iput().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210303131703.330415-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5f701d8dce47..358f6378882f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3624,14 +3624,14 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	retval = -ENOENT;
 	if (!old.bh || le32_to_cpu(old.de->inode) != old.inode->i_ino)
-		goto end_rename;
+		goto release_bh;
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
 		new.bh = NULL;
-		goto end_rename;
+		goto release_bh;
 	}
 	if (new.bh) {
 		if (!new.inode) {
@@ -3648,15 +3648,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
 		if (IS_ERR(handle)) {
 			retval = PTR_ERR(handle);
-			handle = NULL;
-			goto end_rename;
+			goto release_bh;
 		}
 	} else {
 		whiteout = ext4_whiteout_for_rename(&old, credits, &handle);
 		if (IS_ERR(whiteout)) {
 			retval = PTR_ERR(whiteout);
-			whiteout = NULL;
-			goto end_rename;
+			goto release_bh;
 		}
 	}
 
@@ -3764,16 +3762,18 @@ end_rename:
 			ext4_resetent(handle, &old,
 				      old.inode->i_ino, old_file_type);
 			drop_nlink(whiteout);
+			ext4_orphan_add(handle, whiteout);
 		}
 		unlock_new_inode(whiteout);
+		ext4_journal_stop(handle);
 		iput(whiteout);
-
+	} else {
+		ext4_journal_stop(handle);
 	}
+release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
-	if (handle)
-		ext4_journal_stop(handle);
 	return retval;
 }
 
-- 
2.30.1



