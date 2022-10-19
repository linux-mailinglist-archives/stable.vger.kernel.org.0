Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7442604804
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiJSNse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiJSNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:47:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85C172503;
        Wed, 19 Oct 2022 06:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE8DB82435;
        Wed, 19 Oct 2022 08:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1897CC433C1;
        Wed, 19 Oct 2022 08:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169901;
        bh=436goTtGP7cjA/vtXH88LMq5NRFPoKFfaJ/IZ4MBkUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be11nvRYUcNMJPsB9UbrpBGdmgfmxhCb441+vyBSU9vxoM2gIK8TYuZpa9uQoEYO2
         wSxG0oeukW9iFp8X1TILnYRLDJoUpX/JgJySYZ24cHj+SOmLhxVnvd8pSsM22xlyvT
         ZQ2Nh0jStRNB4tmeimFdkI1XCGolbFFs4dLddFW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 418/862] locks: fix TOCTOU race when granting write lease
Date:   Wed, 19 Oct 2022 10:28:25 +0200
Message-Id: <20221019083308.434615073@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit d6da19c9cace63290ccfccb1fc35151ffefc0bec ]

Thread A trying to acquire a write lease checks the value of i_readcount
and i_writecount in check_conflicting_open() to verify that its own fd
is the only fd referencing the file.

Thread B trying to open the file for read will call break_lease() in
do_dentry_open() before incrementing i_readcount, which leaves a small
window where thread A can acquire the write lease and then thread B
completes the open of the file for read without breaking the write lease
that was acquired by thread A.

Fix this race by incrementing i_readcount before checking for existing
leases, same as the case with i_writecount.

Use a helper put_file_access() to decrement i_readcount or i_writecount
in do_dentry_open() and __fput().

Fixes: 387e3746d01c ("locks: eliminate false positive conflicts for write lease")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c |  7 +------
 fs/internal.h   | 10 ++++++++++
 fs/open.c       | 11 ++++-------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 99c6796c9f28..dd88701e54a9 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -324,12 +324,7 @@ static void __fput(struct file *file)
 	}
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
-	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		i_readcount_dec(inode);
-	if (mode & FMODE_WRITER) {
-		put_write_access(inode);
-		__mnt_drop_write(mnt);
-	}
+	put_file_access(file);
 	dput(dentry);
 	if (unlikely(mode & FMODE_NEED_UNMOUNT))
 		dissolve_on_fput(mnt);
diff --git a/fs/internal.h b/fs/internal.h
index 3e206d3e317c..4372d67a3753 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -102,6 +102,16 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
 extern struct file *alloc_empty_file(int, const struct cred *);
 extern struct file *alloc_empty_file_noaccount(int, const struct cred *);
 
+static inline void put_file_access(struct file *file)
+{
+	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
+		i_readcount_dec(file->f_inode);
+	} else if (file->f_mode & FMODE_WRITER) {
+		put_write_access(file->f_inode);
+		__mnt_drop_write(file->f_path.mnt);
+	}
+}
+
 /*
  * super.c
  */
diff --git a/fs/open.c b/fs/open.c
index cf7e5c350a54..a81319b6177f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -842,7 +842,9 @@ static int do_dentry_open(struct file *f,
 		return 0;
 	}
 
-	if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode)) {
+	if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
+		i_readcount_inc(inode);
+	} else if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode)) {
 		error = get_write_access(inode);
 		if (unlikely(error))
 			goto cleanup_file;
@@ -882,8 +884,6 @@ static int do_dentry_open(struct file *f,
 			goto cleanup_all;
 	}
 	f->f_mode |= FMODE_OPENED;
-	if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
-		i_readcount_inc(inode);
 	if ((f->f_mode & FMODE_READ) &&
 	     likely(f->f_op->read || f->f_op->read_iter))
 		f->f_mode |= FMODE_CAN_READ;
@@ -937,10 +937,7 @@ static int do_dentry_open(struct file *f,
 	if (WARN_ON_ONCE(error > 0))
 		error = -EINVAL;
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITER) {
-		put_write_access(inode);
-		__mnt_drop_write(f->f_path.mnt);
-	}
+	put_file_access(f);
 cleanup_file:
 	path_put(&f->f_path);
 	f->f_path.mnt = NULL;
-- 
2.35.1



