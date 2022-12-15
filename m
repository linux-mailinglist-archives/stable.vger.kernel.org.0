Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC564E058
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLOSML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOSMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:12:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6392E9D8
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CE86B81C12
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F8CC433EF;
        Thu, 15 Dec 2022 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127926;
        bh=Y7s89FXm5+hPhERRA0JeN8mk51u/vp5RzSspf60rj9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWj7w8HnfirqzUGWiDuw/8SO1aXkxnG20t9fGA5TUMyxXfKM3I6fyvw9LAu1ovcA8
         o+nKsWuktrjtcOfCsNBcG+uby12uRZqwh+42b4fg0it/LeT+OntoYazIUTz4weH96e
         bc24OQrvDnqiKCEGMfZtUjqUyQORyzxV35iRZoCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Amir Goldstein <amir73il@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 02/14] vfs: fix copy_file_range() averts filesystem freeze protection
Date:   Thu, 15 Dec 2022 19:10:38 +0100
Message-Id: <20221215172906.447775178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 10bc8e4af65946b727728d7479c028742321b60a upstream.

Commit 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs
copies") removed fallback to generic_copy_file_range() for cross-fs
cases inside vfs_copy_file_range().

To preserve behavior of nfsd and ksmbd server-side-copy, the fallback to
generic_copy_file_range() was added in nfsd and ksmbd code, but that
call is missing sb_start_write(), fsnotify hooks and more.

Ideally, nfsd and ksmbd would pass a flag to vfs_copy_file_range() that
will take care of the fallback, but that code would be subtle and we got
vfs_copy_file_range() logic wrong too many times already.

Instead, add a flag to explicitly request vfs_copy_file_range() to
perform only generic_copy_file_range() and let nfsd and ksmbd use this
flag only in the fallback path.

This choise keeps the logic changes to minimum in the non-nfsd/ksmbd code
paths to reduce the risk of further regressions.

Fixes: 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs copies")
Tested-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[backport comments for v5.15: - sb_write_started() is missing - assert was dropped ]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c     |    6 +++---
 fs/nfsd/vfs.c      |    4 ++--
 fs/read_write.c    |   17 +++++++++++++----
 include/linux/fs.h |    8 ++++++++
 4 files changed, 26 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1788,9 +1788,9 @@ int ksmbd_vfs_copy_file_ranges(struct ks
 		ret = vfs_copy_file_range(src_fp->filp, src_off,
 					  dst_fp->filp, dst_off, len, 0);
 		if (ret == -EOPNOTSUPP || ret == -EXDEV)
-			ret = generic_copy_file_range(src_fp->filp, src_off,
-						      dst_fp->filp, dst_off,
-						      len, 0);
+			ret = vfs_copy_file_range(src_fp->filp, src_off,
+						  dst_fp->filp, dst_off, len,
+						  COPY_FILE_SPLICE);
 		if (ret < 0)
 			return ret;
 
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -574,8 +574,8 @@ ssize_t nfsd_copy_file_range(struct file
 	ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
 
 	if (ret == -EOPNOTSUPP || ret == -EXDEV)
-		ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
-					      count, 0);
+		ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count,
+					  COPY_FILE_SPLICE);
 	return ret;
 }
 
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1418,7 +1418,9 @@ static int generic_copy_file_checks(stru
 	 * and several different sets of file_operations, but they all end up
 	 * using the same ->copy_file_range() function pointer.
 	 */
-	if (file_out->f_op->copy_file_range) {
+	if (flags & COPY_FILE_SPLICE) {
+		/* cross sb splice is allowed */
+	} else if (file_out->f_op->copy_file_range) {
 		if (file_in->f_op->copy_file_range !=
 		    file_out->f_op->copy_file_range)
 			return -EXDEV;
@@ -1468,8 +1470,9 @@ ssize_t vfs_copy_file_range(struct file
 			    size_t len, unsigned int flags)
 {
 	ssize_t ret;
+	bool splice = flags & COPY_FILE_SPLICE;
 
-	if (flags != 0)
+	if (flags & ~COPY_FILE_SPLICE)
 		return -EINVAL;
 
 	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
@@ -1495,14 +1498,14 @@ ssize_t vfs_copy_file_range(struct file
 	 * same sb using clone, but for filesystems where both clone and copy
 	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
-	if (file_out->f_op->copy_file_range) {
+	if (!splice && file_out->f_op->copy_file_range) {
 		ret = file_out->f_op->copy_file_range(file_in, pos_in,
 						      file_out, pos_out,
 						      len, flags);
 		goto done;
 	}
 
-	if (file_in->f_op->remap_file_range &&
+	if (!splice && file_in->f_op->remap_file_range &&
 	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
 		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
@@ -1522,6 +1525,8 @@ ssize_t vfs_copy_file_range(struct file
 	 * consistent story about which filesystems support copy_file_range()
 	 * and which filesystems do not, that will allow userspace tools to
 	 * make consistent desicions w.r.t using copy_file_range().
+	 *
+	 * We also get here if caller (e.g. nfsd) requested COPY_FILE_SPLICE.
 	 */
 	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
 				      flags);
@@ -1576,6 +1581,10 @@ SYSCALL_DEFINE6(copy_file_range, int, fd
 		pos_out = f_out.file->f_pos;
 	}
 
+	ret = -EINVAL;
+	if (flags != 0)
+		goto out;
+
 	ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
 				  flags);
 	if (ret > 0) {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1990,6 +1990,14 @@ struct dir_context {
  */
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
+/*
+ * These flags control the behavior of vfs_copy_file_range().
+ * They are not available to the user via syscall.
+ *
+ * COPY_FILE_SPLICE: call splice direct instead of fs clone/copy ops
+ */
+#define COPY_FILE_SPLICE		(1 << 0)
+
 struct iov_iter;
 
 struct file_operations {


