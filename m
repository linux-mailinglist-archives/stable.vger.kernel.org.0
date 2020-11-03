Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC32A5813
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgKCVsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbgKCUuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C0F1223FD;
        Tue,  3 Nov 2020 20:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436623;
        bh=jXUjiPtxynW4AdqW9KM6Th1BPteywzmQp9HJnobJPbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPbvsN+J2n3AxdBczI+0asn27ZIama9WEKPtYrNgmdAuZWylEenUEg+gMNWOxeZun
         AjXNpAPjZVZBRAtjCWBNt9sOMvDt7MV0CtTqZz8/uT3kX9VDi9gAIkITxxScDuNXKB
         q5q8dOxxcZb/yhH38zDP1TeK6Umhbf4AE9F9JtS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.9 304/391] ubifs: xattr: Fix some potential memory leaks while iterating entries
Date:   Tue,  3 Nov 2020 21:35:55 +0100
Message-Id: <20201103203407.615441010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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


