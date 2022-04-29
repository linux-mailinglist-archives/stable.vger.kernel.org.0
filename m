Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389FC514772
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357920AbiD2Ksp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358047AbiD2KsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63119C7EA9;
        Fri, 29 Apr 2022 03:43:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBCC60A66;
        Fri, 29 Apr 2022 10:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF931C385A4;
        Fri, 29 Apr 2022 10:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651229011;
        bh=aVPwi7AnfwBcAWU4BNQi0eXEFm9MJhPgf2ZG4eGq6Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KplqpOE/5s3jryFEUSnFnzSVVmvQ2hXmFTlxCAS81161zB/pAip0nNRR+1/dOvA8a
         pSs7xer1YRnIZOnYO+LTpbeMQdNv1zgwmxtAhA8zm8ztd5BkzHCoSPznuv7244eDT0
         y0wiU7LUURZ/clFljY/gqXN12oERl39tM8kM1kCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 29/33] gfs2: Fix mmap + page fault deadlocks for direct I/O
Date:   Fri, 29 Apr 2022 12:42:16 +0200
Message-Id: <20220429104053.182142923@linuxfoundation.org>
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

commit b01b2d72da25c000aeb124bc78daf3fb998be2b6 upstream

Also disable page faults during direct I/O requests and implement a
similar kind of retry logic as in the buffered I/O case.

The retry logic in the direct I/O case differs from the buffered I/O
case in the following way: direct I/O doesn't provide the kinds of
consistency guarantees between concurrent reads and writes that buffered
I/O provides, so once we lose the inode glock while faulting in user
pages, we always resume the operation.  We never need to return a
partial read or write.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 88 insertions(+), 13 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -812,22 +812,64 @@ static ssize_t gfs2_file_direct_read(str
 {
 	struct file *file = iocb->ki_filp;
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	size_t count = iov_iter_count(to);
+	size_t prev_count = 0, window_size = 0;
+	size_t written = 0;
 	ssize_t ret;
 
-	if (!count)
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * Unlike generic_file_read_iter, for reads, iomap_dio_rw can trigger
+	 * physical as well as manual page faults, and we need to disable both
+	 * kinds.
+	 *
+	 * For direct I/O, gfs2 takes the inode glock in deferred mode.  This
+	 * locking mode is compatible with other deferred holders, so multiple
+	 * processes and nodes can do direct I/O to a file at the same time.
+	 * There's no guarantee that reads or writes will be atomic.  Any
+	 * coordination among readers and writers needs to happen externally.
+	 */
+
+	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
-	gfs2_glock_dq(gh);
+retry_under_glock:
+	pagefault_disable();
+	to->nofault = true;
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, written);
+	to->nofault = false;
+	pagefault_enable();
+	if (ret > 0)
+		written = ret;
+
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return written;
 }
 
 static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
@@ -836,11 +878,21 @@ static ssize_t gfs2_file_direct_write(st
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	size_t len = iov_iter_count(from);
-	loff_t offset = iocb->ki_pos;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
 	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * For writes, iomap_dio_rw only triggers manual page faults, so we
+	 * don't need to disable physical ones.
+	 */
+
+	/*
 	 * Deferred lock, even if its a write, since we do no allocation on
 	 * this path. All we need to change is the atime, and this lock mode
 	 * ensures that other nodes have flushed their buffered read caches
@@ -849,22 +901,45 @@ static ssize_t gfs2_file_direct_write(st
 	 * VFS does.
 	 */
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	/* Silently fall back to buffered I/O when writing beyond EOF */
-	if (offset + len > i_size_read(&ip->i_inode))
+	if (iocb->ki_pos + iov_iter_count(from) > i_size_read(&ip->i_inode))
 		goto out;
 
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
+	from->nofault = true;
+	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, read);
+	from->nofault = false;
+
 	if (ret == -ENOTBLK)
 		ret = 0;
+	if (ret > 0)
+		read = ret;
+
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
 out:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return read;
 }
 
 static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)


