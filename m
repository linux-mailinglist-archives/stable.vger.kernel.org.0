Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78861AED53
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgDRNvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDRNtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDFF22277;
        Sat, 18 Apr 2020 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217752;
        bh=j7Txo4qpJyCfapw98FBpfH7Li3HU/q6Jwro+XlysnqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OISjhS0B7vUyOAGGbSOAmB3ddgm2Hj8IQqUqx3BU7YDwzMSrTGS8Ft5ynXXvDy5YO
         TEOhWvkNNB5M6HhzYdO36vUDc471Pf8ADIe8BkHthZ0W/jIMfUNV1iw0NGxupB3ed7
         BhLz+bLAQzQ0+GuLEQdvoTC1jEDFye61a8lWfycs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 45/73] ceph: re-org copy_file_range and fix some error paths
Date:   Sat, 18 Apr 2020 09:47:47 -0400
Message-Id: <20200418134815.6519-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

[ Upstream commit 1b0c3b9f91f0df03088d293fc9e62743fd789ad2 ]

This patch re-organizes copy_file_range, trying to fix a few issues in the
error handling.  Here's the summary:

- Abort copy if initial do_splice_direct() returns fewer bytes than
  requested.

- Move the 'size' initialization (with i_size_read()) further down in the
  code, after the initial call to do_splice_direct().  This avoids issues
  with a possibly stale value if a manual copy is done.

- Move the object copy loop into a separate function.  This makes it
  easier to handle errors (e.g, dirtying caps and updating the MDS
  metadata if only some objects have been copied before an error has
  occurred).

- Added calls to ceph_oloc_destroy() to avoid leaking memory with src_oloc
  and dst_oloc

- After the object copy loop, the new file size to be reported to the MDS
  (if there's file size change) is now the actual file size, and not the
  size after an eventual extra manual copy.

- Added a few dout() to show the number of bytes copied in the two manual
  copies and in the object copy loop.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 173 ++++++++++++++++++++++++++++---------------------
 1 file changed, 100 insertions(+), 73 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5a478cd06e113..7f8c4e3083018 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1944,6 +1944,71 @@ static int is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
 	return 0;
 }
 
+static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off,
+				    struct ceph_inode_info *dst_ci, u64 *dst_off,
+				    struct ceph_fs_client *fsc,
+				    size_t len, unsigned int flags)
+{
+	struct ceph_object_locator src_oloc, dst_oloc;
+	struct ceph_object_id src_oid, dst_oid;
+	size_t bytes = 0;
+	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
+	u32 src_objlen, dst_objlen;
+	u32 object_size = src_ci->i_layout.object_size;
+	int ret;
+
+	src_oloc.pool = src_ci->i_layout.pool_id;
+	src_oloc.pool_ns = ceph_try_get_string(src_ci->i_layout.pool_ns);
+	dst_oloc.pool = dst_ci->i_layout.pool_id;
+	dst_oloc.pool_ns = ceph_try_get_string(dst_ci->i_layout.pool_ns);
+
+	while (len >= object_size) {
+		ceph_calc_file_object_mapping(&src_ci->i_layout, *src_off,
+					      object_size, &src_objnum,
+					      &src_objoff, &src_objlen);
+		ceph_calc_file_object_mapping(&dst_ci->i_layout, *dst_off,
+					      object_size, &dst_objnum,
+					      &dst_objoff, &dst_objlen);
+		ceph_oid_init(&src_oid);
+		ceph_oid_printf(&src_oid, "%llx.%08llx",
+				src_ci->i_vino.ino, src_objnum);
+		ceph_oid_init(&dst_oid);
+		ceph_oid_printf(&dst_oid, "%llx.%08llx",
+				dst_ci->i_vino.ino, dst_objnum);
+		/* Do an object remote copy */
+		ret = ceph_osdc_copy_from(&fsc->client->osdc,
+					  src_ci->i_vino.snap, 0,
+					  &src_oid, &src_oloc,
+					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
+					  CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
+					  &dst_oid, &dst_oloc,
+					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
+					  CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
+					  dst_ci->i_truncate_seq,
+					  dst_ci->i_truncate_size,
+					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
+		if (ret) {
+			if (ret == -EOPNOTSUPP) {
+				fsc->have_copy_from2 = false;
+				pr_notice("OSDs don't support copy-from2; disabling copy offload\n");
+			}
+			dout("ceph_osdc_copy_from returned %d\n", ret);
+			if (!bytes)
+				bytes = ret;
+			goto out;
+		}
+		len -= object_size;
+		bytes += object_size;
+		*src_off += object_size;
+		*dst_off += object_size;
+	}
+
+out:
+	ceph_oloc_destroy(&src_oloc);
+	ceph_oloc_destroy(&dst_oloc);
+	return bytes;
+}
+
 static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 				      struct file *dst_file, loff_t dst_off,
 				      size_t len, unsigned int flags)
@@ -1954,14 +2019,11 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
 	struct ceph_cap_flush *prealloc_cf;
 	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
-	struct ceph_object_locator src_oloc, dst_oloc;
-	struct ceph_object_id src_oid, dst_oid;
-	loff_t endoff = 0, size;
-	ssize_t ret = -EIO;
+	loff_t size;
+	ssize_t ret = -EIO, bytes;
 	u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
-	u32 src_objlen, dst_objlen, object_size;
+	u32 src_objlen, dst_objlen;
 	int src_got = 0, dst_got = 0, err, dirty;
-	bool do_final_copy = false;
 
 	if (src_inode->i_sb != dst_inode->i_sb) {
 		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
@@ -2039,22 +2101,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	if (ret < 0)
 		goto out_caps;
 
-	size = i_size_read(dst_inode);
-	endoff = dst_off + len;
-
 	/* Drop dst file cached pages */
 	ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
 					    dst_off >> PAGE_SHIFT,
-					    endoff >> PAGE_SHIFT);
+					    (dst_off + len) >> PAGE_SHIFT);
 	if (ret < 0) {
 		dout("Failed to invalidate inode pages (%zd)\n", ret);
 		ret = 0; /* XXX */
 	}
-	src_oloc.pool = src_ci->i_layout.pool_id;
-	src_oloc.pool_ns = ceph_try_get_string(src_ci->i_layout.pool_ns);
-	dst_oloc.pool = dst_ci->i_layout.pool_id;
-	dst_oloc.pool_ns = ceph_try_get_string(dst_ci->i_layout.pool_ns);
-
 	ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
 				      src_ci->i_layout.object_size,
 				      &src_objnum, &src_objoff, &src_objlen);
@@ -2073,6 +2127,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	 * starting at the src_off
 	 */
 	if (src_objoff) {
+		dout("Initial partial copy of %u bytes\n", src_objlen);
+
 		/*
 		 * we need to temporarily drop all caps as we'll be calling
 		 * {read,write}_iter, which will get caps again.
@@ -2080,8 +2136,9 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		put_rd_wr_caps(src_ci, src_got, dst_ci, dst_got);
 		ret = do_splice_direct(src_file, &src_off, dst_file,
 				       &dst_off, src_objlen, flags);
-		if (ret < 0) {
-			dout("do_splice_direct returned %d\n", err);
+		/* Abort on short copies or on error */
+		if (ret < src_objlen) {
+			dout("Failed partial copy (%zd)\n", ret);
 			goto out;
 		}
 		len -= ret;
@@ -2094,62 +2151,29 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		if (err < 0)
 			goto out_caps;
 	}
-	object_size = src_ci->i_layout.object_size;
-	while (len >= object_size) {
-		ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
-					      object_size, &src_objnum,
-					      &src_objoff, &src_objlen);
-		ceph_calc_file_object_mapping(&dst_ci->i_layout, dst_off,
-					      object_size, &dst_objnum,
-					      &dst_objoff, &dst_objlen);
-		ceph_oid_init(&src_oid);
-		ceph_oid_printf(&src_oid, "%llx.%08llx",
-				src_ci->i_vino.ino, src_objnum);
-		ceph_oid_init(&dst_oid);
-		ceph_oid_printf(&dst_oid, "%llx.%08llx",
-				dst_ci->i_vino.ino, dst_objnum);
-		/* Do an object remote copy */
-		err = ceph_osdc_copy_from(
-			&src_fsc->client->osdc,
-			src_ci->i_vino.snap, 0,
-			&src_oid, &src_oloc,
-			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
-			&dst_oid, &dst_oloc,
-			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
-			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
-			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
-		if (err) {
-			if (err == -EOPNOTSUPP) {
-				src_fsc->have_copy_from2 = false;
-				pr_notice("OSDs don't support copy-from2; disabling copy offload\n");
-			}
-			dout("ceph_osdc_copy_from returned %d\n", err);
-			if (!ret)
-				ret = err;
-			goto out_caps;
-		}
-		len -= object_size;
-		src_off += object_size;
-		dst_off += object_size;
-		ret += object_size;
-	}
 
-	if (len)
-		/* We still need one final local copy */
-		do_final_copy = true;
+	size = i_size_read(dst_inode);
+	bytes = ceph_do_objects_copy(src_ci, &src_off, dst_ci, &dst_off,
+				     src_fsc, len, flags);
+	if (bytes <= 0) {
+		if (!ret)
+			ret = bytes;
+		goto out_caps;
+	}
+	dout("Copied %zu bytes out of %zu\n", bytes, len);
+	len -= bytes;
+	ret += bytes;
 
 	file_update_time(dst_file);
 	inode_inc_iversion_raw(dst_inode);
 
-	if (endoff > size) {
+	if (dst_off > size) {
 		int caps_flags = 0;
 
 		/* Let the MDS know about dst file size change */
-		if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
+		if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
 			caps_flags |= CHECK_CAPS_NODELAY;
-		if (ceph_inode_set_size(dst_inode, endoff))
+		if (ceph_inode_set_size(dst_inode, dst_off))
 			caps_flags |= CHECK_CAPS_AUTHONLY;
 		if (caps_flags)
 			ceph_check_caps(dst_ci, caps_flags, NULL);
@@ -2165,15 +2189,18 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 out_caps:
 	put_rd_wr_caps(src_ci, src_got, dst_ci, dst_got);
 
-	if (do_final_copy) {
-		err = do_splice_direct(src_file, &src_off, dst_file,
-				       &dst_off, len, flags);
-		if (err < 0) {
-			dout("do_splice_direct returned %d\n", err);
-			goto out;
-		}
-		len -= err;
-		ret += err;
+	/*
+	 * Do the final manual copy if we still have some bytes left, unless
+	 * there were errors in remote object copies (len >= object_size).
+	 */
+	if (len && (len < src_ci->i_layout.object_size)) {
+		dout("Final partial copy of %zu bytes\n", len);
+		bytes = do_splice_direct(src_file, &src_off, dst_file,
+					 &dst_off, len, flags);
+		if (bytes > 0)
+			ret += bytes;
+		else
+			dout("Failed partial copy (%zd)\n", bytes);
 	}
 
 out:
-- 
2.20.1

