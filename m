Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636592A569A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733077AbgKCU7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733072AbgKCU7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E202822226;
        Tue,  3 Nov 2020 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437149;
        bh=jXUjiPtxynW4AdqW9KM6Th1BPteywzmQp9HJnobJPbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLLqaWatPtt+XEbRZS2RwVU32lPOftzbHBHTvMyovafNrOBkr/bNd4EYvwN2x6H3G
         41PeRiaz0yuffTYNkk36cWBIAe2HF7QkylwLhXWOn4AsWg5xD2cE6vD21p/zrCl4oE
         v90/MdhX/Fk3Bqd2Mcrddo+i67cB2xZPTgNE8/xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 168/214] ubifs: xattr: Fix some potential memory leaks while iterating entries
Date:   Tue,  3 Nov 2020 21:36:56 +0100
Message-Id: <20201103203306.515423776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit f2aae745b82c842221f4f233051f9ac641790959 upstream.

Fix some potential memory leaks in error handling branches while
iterating xattr entries. For example, function ubifs_tnc_remove_ino()
forgets to free pxent if it exists. Similar problems also exist in
ubifs_purge_xattrs(), ubifs_add_orphan() and ubifs_jnl_write_inode().

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/journal.c |    2 ++
 fs/ubifs/orphan.c  |    2 ++
 fs/ubifs/tnc.c     |    3 +++
 fs/ubifs/xattr.c   |    2 ++
 4 files changed, 9 insertions(+)

--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -894,6 +894,7 @@ int ubifs_jnl_write_inode(struct ubifs_i
 				if (err == -ENOENT)
 					break;
 
+				kfree(pxent);
 				goto out_release;
 			}
 
@@ -906,6 +907,7 @@ int ubifs_jnl_write_inode(struct ubifs_i
 				ubifs_err(c, "dead directory entry '%s', error %d",
 					  xent->name, err);
 				ubifs_ro_mode(c, err);
+				kfree(pxent);
 				kfree(xent);
 				goto out_release;
 			}
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -173,6 +173,7 @@ int ubifs_add_orphan(struct ubifs_info *
 			err = PTR_ERR(xent);
 			if (err == -ENOENT)
 				break;
+			kfree(pxent);
 			return err;
 		}
 
@@ -182,6 +183,7 @@ int ubifs_add_orphan(struct ubifs_info *
 
 		xattr_orphan = orphan_add(c, xattr_inum, orphan);
 		if (IS_ERR(xattr_orphan)) {
+			kfree(pxent);
 			kfree(xent);
 			return PTR_ERR(xattr_orphan);
 		}
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -2885,6 +2885,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 			err = PTR_ERR(xent);
 			if (err == -ENOENT)
 				break;
+			kfree(pxent);
 			return err;
 		}
 
@@ -2898,6 +2899,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 		fname_len(&nm) = le16_to_cpu(xent->nlen);
 		err = ubifs_tnc_remove_nm(c, &key1, &nm);
 		if (err) {
+			kfree(pxent);
 			kfree(xent);
 			return err;
 		}
@@ -2906,6 +2908,7 @@ int ubifs_tnc_remove_ino(struct ubifs_in
 		highest_ino_key(c, &key2, xattr_inum);
 		err = ubifs_tnc_remove_range(c, &key1, &key2);
 		if (err) {
+			kfree(pxent);
 			kfree(xent);
 			return err;
 		}
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -522,6 +522,7 @@ int ubifs_purge_xattrs(struct inode *hos
 				  xent->name, err);
 			ubifs_ro_mode(c, err);
 			kfree(pxent);
+			kfree(xent);
 			return err;
 		}
 
@@ -531,6 +532,7 @@ int ubifs_purge_xattrs(struct inode *hos
 		err = remove_xattr(c, host, xino, &nm);
 		if (err) {
 			kfree(pxent);
+			kfree(xent);
 			iput(xino);
 			ubifs_err(c, "cannot remove xattr, error %d", err);
 			return err;


