Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA724BB85
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgHTJvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbgHTJvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B3F2067C;
        Thu, 20 Aug 2020 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917068;
        bh=EqK1nmioHLRXP/FPoASKUhIIOzl5voHdIypZ8eFMvrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbcolSkwpipLw2o0k6w/qTEMtslLWpTCdDAWcg8ZmXRyswTo8sPEnofQg+Gqi2hnx
         7Ghj724wdI/c150vSnW4e3IISCrw7VtkPpHDmsoCI0MYyp4c7RwQPRzV+5pvfXGgFC
         81SoebcTeZIW+wGj1csTmeMjR8SYipl1SMcQtLlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/152] ubifs: Fix wrong orphan node deletion in ubifs_jnl_update|rename
Date:   Thu, 20 Aug 2020 11:21:23 +0200
Message-Id: <20200820091559.703357874@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 094b6d1295474f338201b846a1f15e72eb0b12cf ]

There a wrong orphan node deleting in error handling path in
ubifs_jnl_update() and ubifs_jnl_rename(), which may cause
following error msg:

  UBIFS error (ubi0:0 pid 1522): ubifs_delete_orphan [ubifs]:
  missing orphan ino 65

Fix this by checking whether the node has been operated for
adding to orphan list before being deleted,

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Fixes: 823838a486888cf484e ("ubifs: Add hashes to the tree node cache")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/journal.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 826dad0243dcc..a6ae2428e4c96 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -539,7 +539,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 		     const struct fscrypt_name *nm, const struct inode *inode,
 		     int deletion, int xent)
 {
-	int err, dlen, ilen, len, lnum, ino_offs, dent_offs;
+	int err, dlen, ilen, len, lnum, ino_offs, dent_offs, orphan_added = 0;
 	int aligned_dlen, aligned_ilen, sync = IS_DIRSYNC(dir);
 	int last_reference = !!(deletion && inode->i_nlink == 0);
 	struct ubifs_inode *ui = ubifs_inode(inode);
@@ -630,6 +630,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 			goto out_finish;
 		}
 		ui->del_cmtno = c->cmt_no;
+		orphan_added = 1;
 	}
 
 	err = write_head(c, BASEHD, dent, len, &lnum, &dent_offs, sync);
@@ -702,7 +703,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
-	if (last_reference)
+	if (orphan_added)
 		ubifs_delete_orphan(c, inode->i_ino);
 	finish_reservation(c);
 	return err;
@@ -1217,7 +1218,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 	void *p;
 	union ubifs_key key;
 	struct ubifs_dent_node *dent, *dent2;
-	int err, dlen1, dlen2, ilen, lnum, offs, len;
+	int err, dlen1, dlen2, ilen, lnum, offs, len, orphan_added = 0;
 	int aligned_dlen1, aligned_dlen2, plen = UBIFS_INO_NODE_SZ;
 	int last_reference = !!(new_inode && new_inode->i_nlink == 0);
 	int move = (old_dir != new_dir);
@@ -1333,6 +1334,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 			goto out_finish;
 		}
 		new_ui->del_cmtno = c->cmt_no;
+		orphan_added = 1;
 	}
 
 	err = write_head(c, BASEHD, dent, len, &lnum, &offs, sync);
@@ -1414,7 +1416,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 	release_head(c, BASEHD);
 out_ro:
 	ubifs_ro_mode(c, err);
-	if (last_reference)
+	if (orphan_added)
 		ubifs_delete_orphan(c, new_inode->i_ino);
 out_finish:
 	finish_reservation(c);
-- 
2.25.1



