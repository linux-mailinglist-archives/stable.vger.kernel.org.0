Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B72514746
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357882AbiD2KsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358024AbiD2Krz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378ACC8483;
        Fri, 29 Apr 2022 03:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD2A62350;
        Fri, 29 Apr 2022 10:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBB6C385A4;
        Fri, 29 Apr 2022 10:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228994;
        bh=z7Zg0NsX2uworn010Vn/YscquzuuocbxNmT/Eqc+q/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxyUD6xE6g7HC3XA9cSyHuL8WdyS7+csyO9NZ8REtVlnflZuwkuvTO6pw6ptCskIJ
         oc4NwJFaNuxSx5zeTk4HhIEBPFYlC7Ru9r2Coe2XuZnnuTLPBW24yqpxWc8H0v+VpV
         J40tO6l+42gTWD/wMl+dp+FGkJy9+tXMiTa9CU1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 23/33] gfs2: Fix mmap + page fault deadlocks for buffered I/O
Date:   Fri, 29 Apr 2022 12:42:10 +0200
Message-Id: <20220429104053.010361868@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 00bfe02f479688a67a29019d1228f1470e26f014 upstream

In the .read_iter and .write_iter file operations, we're accessing
user-space memory while holding the inode glock.  There is a possibility
that the memory is mapped to the same file, in which case we'd recurse
on the same glock.

We could detect and work around this simple case of recursive locking,
but more complex scenarios exist that involve multiple glocks,
processes, and cluster nodes, and working around all of those cases
isn't practical or even possible.

Avoid these kinds of problems by disabling page faults while holding the
inode glock.  If a page fault would occur, we either end up with a
partial read or write or with -EFAULT if nothing could be read or
written.  In either case, we know that we're not done with the
operation, so we indicate that we're willing to give up the inode glock
and then we fault in the missing pages.  If that made us lose the inode
glock, we return a partial read or write.  Otherwise, we resume the
operation.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 5 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -777,6 +777,36 @@ static int gfs2_fsync(struct file *file,
 	return ret ? ret : ret1;
 }
 
+static inline bool should_fault_in_pages(ssize_t ret, struct iov_iter *i,
+					 size_t *prev_count,
+					 size_t *window_size)
+{
+	char __user *p = i->iov[0].iov_base + i->iov_offset;
+	size_t count = iov_iter_count(i);
+	int pages = 1;
+
+	if (likely(!count))
+		return false;
+	if (ret <= 0 && ret != -EFAULT)
+		return false;
+	if (!iter_is_iovec(i))
+		return false;
+
+	if (*prev_count != count || !*window_size) {
+		int pages, nr_dirtied;
+
+		pages = min_t(int, BIO_MAX_VECS,
+			      DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE));
+		nr_dirtied = max(current->nr_dirtied_pause -
+				 current->nr_dirtied, 1);
+		pages = min(pages, nr_dirtied);
+	}
+
+	*prev_count = count;
+	*window_size = (size_t)PAGE_SIZE * pages - offset_in_page(p);
+	return true;
+}
+
 static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 				     struct gfs2_holder *gh)
 {
@@ -841,9 +871,17 @@ static ssize_t gfs2_file_read_iter(struc
 {
 	struct gfs2_inode *ip;
 	struct gfs2_holder gh;
+	size_t prev_count = 0, window_size = 0;
 	size_t written = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = gfs2_file_direct_read(iocb, to, &gh);
 		if (likely(ret != -ENOTBLK))
@@ -865,13 +903,34 @@ static ssize_t gfs2_file_read_iter(struc
 	}
 	ip = GFS2_I(iocb->ki_filp->f_mapping->host);
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+retry:
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
 		goto out_uninit;
+retry_under_glock:
+	pagefault_disable();
 	ret = generic_file_read_iter(iocb, to);
+	pagefault_enable();
 	if (ret > 0)
 		written += ret;
-	gfs2_glock_dq(&gh);
+
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(&gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(&gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(&gh)) {
+				if (written)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(&gh))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	return written ? written : ret;
@@ -886,8 +945,17 @@ static ssize_t gfs2_file_buffered_write(
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder *statfs_gh = NULL;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (inode == sdp->sd_rindex) {
 		statfs_gh = kmalloc(sizeof(*statfs_gh), GFP_NOFS);
 		if (!statfs_gh)
@@ -895,10 +963,11 @@ static ssize_t gfs2_file_buffered_write(
 	}
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	if (inode == sdp->sd_rindex) {
 		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 
@@ -909,21 +978,41 @@ static ssize_t gfs2_file_buffered_write(
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);
+	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	pagefault_enable();
 	current->backing_dev_info = NULL;
-	if (ret > 0)
+	if (ret > 0) {
 		iocb->ki_pos += ret;
+		read += ret;
+	}
 
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
 
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh)) {
+				if (read)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
 out_unlock:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
-	return ret;
+	return read ? read : ret;
 }
 
 /**


