Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE44429B248
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460381AbgJ0Oid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460372AbgJ0Oic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793DE21D7B;
        Tue, 27 Oct 2020 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809510;
        bh=iEifK2TNLciMuc47Cp2eL+oGGisLPiNQ8cdgUt9LfoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBW9Hvbbuf2GZDyM8CA3Zx8qrL1OCBk3QUib2krK59YdV7R0zuIBVQyn86QzmXGFl
         /lFgbmkBlGRmt7EzyLzHAjSZZD6SxeDkU/c8qqVn9FVEX+IRgBiAeNGiS+8z/bu6Tv
         YLSWxrdwDjqGyxAxRGEtVoP9+gg4cuQzJMoBQDI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/408] xfs: fix deadlock and streamline xfs_getfsmap performance
Date:   Tue, 27 Oct 2020 14:52:32 +0100
Message-Id: <20201027135505.019817480@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 8ffa90e1145c70c7ac47f14b59583b2296d89e72 ]

Refactor xfs_getfsmap to improve its performance: instead of indirectly
calling a function that copies one record to userspace at a time, create
a shadow buffer in the kernel and copy the whole array once at the end.
On the author's computer, this reduces the runtime on his /home by ~20%.

This also eliminates a deadlock when running GETFSMAP against the
realtime device.  The current code locks the rtbitmap to create
fsmappings and copies them into userspace, having not released the
rtbitmap lock.  If the userspace buffer is an mmap of a sparse file that
itself resides on the realtime device, the write page fault will recurse
into the fs for allocation, which will deadlock on the rtbitmap lock.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  45 +++++++-------
 fs/xfs/xfs_fsmap.h |   6 +-
 fs/xfs/xfs_ioctl.c | 144 ++++++++++++++++++++++++++++++---------------
 3 files changed, 124 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5b864985bc648..01c0933a4d10d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -26,7 +26,7 @@
 #include "xfs_rtalloc.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
-void
+static void
 xfs_fsmap_from_internal(
 	struct fsmap		*dest,
 	struct xfs_fsmap	*src)
@@ -154,8 +154,7 @@ xfs_fsmap_owner_from_rmap(
 /* getfsmap query state */
 struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
-	xfs_fsmap_format_t	formatter;	/* formatting fn */
-	void			*format_arg;	/* format buffer */
+	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
@@ -223,6 +222,20 @@ xfs_getfsmap_is_shared(
 	return 0;
 }
 
+static inline void
+xfs_getfsmap_format(
+	struct xfs_mount		*mp,
+	struct xfs_fsmap		*xfm,
+	struct xfs_getfsmap_info	*info)
+{
+	struct fsmap			*rec;
+
+	trace_xfs_getfsmap_mapping(mp, xfm);
+
+	rec = &info->fsmap_recs[info->head->fmh_entries++];
+	xfs_fsmap_from_internal(rec, xfm);
+}
+
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
  * into the appropriate daddr units.
@@ -287,10 +300,7 @@ xfs_getfsmap_helper(
 		fmr.fmr_offset = 0;
 		fmr.fmr_length = rec_daddr - info->next_daddr;
 		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
-		error = info->formatter(&fmr, info->format_arg);
-		if (error)
-			return error;
-		info->head->fmh_entries++;
+		xfs_getfsmap_format(mp, &fmr, info);
 	}
 
 	if (info->last)
@@ -322,11 +332,8 @@ xfs_getfsmap_helper(
 		if (shared)
 			fmr.fmr_flags |= FMR_OF_SHARED;
 	}
-	error = info->formatter(&fmr, info->format_arg);
-	if (error)
-		return error;
-	info->head->fmh_entries++;
 
+	xfs_getfsmap_format(mp, &fmr, info);
 out:
 	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 	if (info->next_daddr < rec_daddr)
@@ -794,11 +801,11 @@ xfs_getfsmap_check_keys(
 #endif /* CONFIG_XFS_RT */
 
 /*
- * Get filesystem's extents as described in head, and format for
- * output.  Calls formatter to fill the user's buffer until all
- * extents are mapped, until the passed-in head->fmh_count slots have
- * been filled, or until the formatter short-circuits the loop, if it
- * is tracking filled-in extents on its own.
+ * Get filesystem's extents as described in head, and format for output. Fills
+ * in the supplied records array until there are no more reverse mappings to
+ * return or head.fmh_entries == head.fmh_count.  In the second case, this
+ * function returns -ECANCELED to indicate that more records would have been
+ * returned.
  *
  * Key to Confusion
  * ----------------
@@ -818,8 +825,7 @@ int
 xfs_getfsmap(
 	struct xfs_mount		*mp,
 	struct xfs_fsmap_head		*head,
-	xfs_fsmap_format_t		formatter,
-	void				*arg)
+	struct fsmap			*fsmap_recs)
 {
 	struct xfs_trans		*tp = NULL;
 	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
@@ -894,8 +900,7 @@ xfs_getfsmap(
 
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
-	info.formatter = formatter;
-	info.format_arg = arg;
+	info.fsmap_recs = fsmap_recs;
 	info.head = head;
 
 	/*
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
index c6c57739b8626..a0775788e7b13 100644
--- a/fs/xfs/xfs_fsmap.h
+++ b/fs/xfs/xfs_fsmap.h
@@ -27,13 +27,9 @@ struct xfs_fsmap_head {
 	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
 };
 
-void xfs_fsmap_from_internal(struct fsmap *dest, struct xfs_fsmap *src);
 void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
 
-/* fsmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_fsmap_format_t)(struct xfs_fsmap *, void *);
-
 int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
-		xfs_fsmap_format_t formatter, void *arg);
+		struct fsmap *out_recs);
 
 #endif /* __XFS_FSMAP_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 60c4526312771..bf0435dbec436 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1832,39 +1832,17 @@ xfs_ioc_getbmap(
 	return error;
 }
 
-struct getfsmap_info {
-	struct xfs_mount	*mp;
-	struct fsmap_head __user *data;
-	unsigned int		idx;
-	__u32			last_flags;
-};
-
-STATIC int
-xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
-{
-	struct getfsmap_info	*info = priv;
-	struct fsmap		fm;
-
-	trace_xfs_getfsmap_mapping(info->mp, xfm);
-
-	info->last_flags = xfm->fmr_flags;
-	xfs_fsmap_from_internal(&fm, xfm);
-	if (copy_to_user(&info->data->fmh_recs[info->idx++], &fm,
-			sizeof(struct fsmap)))
-		return -EFAULT;
-
-	return 0;
-}
-
 STATIC int
 xfs_ioc_getfsmap(
 	struct xfs_inode	*ip,
 	struct fsmap_head	__user *arg)
 {
-	struct getfsmap_info	info = { NULL };
 	struct xfs_fsmap_head	xhead = {0};
 	struct fsmap_head	head;
-	bool			aborted = false;
+	struct fsmap		*recs;
+	unsigned int		count;
+	__u32			last_flags = 0;
+	bool			done = false;
 	int			error;
 
 	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
@@ -1876,38 +1854,112 @@ xfs_ioc_getfsmap(
 		       sizeof(head.fmh_keys[1].fmr_reserved)))
 		return -EINVAL;
 
+	/*
+	 * Use an internal memory buffer so that we don't have to copy fsmap
+	 * data to userspace while holding locks.  Start by trying to allocate
+	 * up to 128k for the buffer, but fall back to a single page if needed.
+	 */
+	count = min_t(unsigned int, head.fmh_count,
+			131072 / sizeof(struct fsmap));
+	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+	if (!recs) {
+		count = min_t(unsigned int, head.fmh_count,
+				PAGE_SIZE / sizeof(struct fsmap));
+		recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+		if (!recs)
+			return -ENOMEM;
+	}
+
 	xhead.fmh_iflags = head.fmh_iflags;
-	xhead.fmh_count = head.fmh_count;
 	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
 	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
 
 	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
 	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
 
-	info.mp = ip->i_mount;
-	info.data = arg;
-	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
-	if (error == -ECANCELED) {
-		error = 0;
-		aborted = true;
-	} else if (error)
-		return error;
+	head.fmh_entries = 0;
+	do {
+		struct fsmap __user	*user_recs;
+		struct fsmap		*last_rec;
+
+		user_recs = &arg->fmh_recs[head.fmh_entries];
+		xhead.fmh_entries = 0;
+		xhead.fmh_count = min_t(unsigned int, count,
+					head.fmh_count - head.fmh_entries);
+
+		/* Run query, record how many entries we got. */
+		error = xfs_getfsmap(ip->i_mount, &xhead, recs);
+		switch (error) {
+		case 0:
+			/*
+			 * There are no more records in the result set.  Copy
+			 * whatever we got to userspace and break out.
+			 */
+			done = true;
+			break;
+		case -ECANCELED:
+			/*
+			 * The internal memory buffer is full.  Copy whatever
+			 * records we got to userspace and go again if we have
+			 * not yet filled the userspace buffer.
+			 */
+			error = 0;
+			break;
+		default:
+			goto out_free;
+		}
+		head.fmh_entries += xhead.fmh_entries;
+		head.fmh_oflags = xhead.fmh_oflags;
 
-	/* If we didn't abort, set the "last" flag in the last fmx */
-	if (!aborted && info.idx) {
-		info.last_flags |= FMR_OF_LAST;
-		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
-				&info.last_flags, sizeof(info.last_flags)))
-			return -EFAULT;
+		/*
+		 * If the caller wanted a record count or there aren't any
+		 * new records to return, we're done.
+		 */
+		if (head.fmh_count == 0 || xhead.fmh_entries == 0)
+			break;
+
+		/* Copy all the records we got out to userspace. */
+		if (copy_to_user(user_recs, recs,
+				 xhead.fmh_entries * sizeof(struct fsmap))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+
+		/* Remember the last record flags we copied to userspace. */
+		last_rec = &recs[xhead.fmh_entries - 1];
+		last_flags = last_rec->fmr_flags;
+
+		/* Set up the low key for the next iteration. */
+		xfs_fsmap_to_internal(&xhead.fmh_keys[0], last_rec);
+		trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
+	} while (!done && head.fmh_entries < head.fmh_count);
+
+	/*
+	 * If there are no more records in the query result set and we're not
+	 * in counting mode, mark the last record returned with the LAST flag.
+	 */
+	if (done && head.fmh_count > 0 && head.fmh_entries > 0) {
+		struct fsmap __user	*user_rec;
+
+		last_flags |= FMR_OF_LAST;
+		user_rec = &arg->fmh_recs[head.fmh_entries - 1];
+
+		if (copy_to_user(&user_rec->fmr_flags, &last_flags,
+					sizeof(last_flags))) {
+			error = -EFAULT;
+			goto out_free;
+		}
 	}
 
 	/* copy back header */
-	head.fmh_entries = xhead.fmh_entries;
-	head.fmh_oflags = xhead.fmh_oflags;
-	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
-		return -EFAULT;
+	if (copy_to_user(arg, &head, sizeof(struct fsmap_head))) {
+		error = -EFAULT;
+		goto out_free;
+	}
 
-	return 0;
+out_free:
+	kmem_free(recs);
+	return error;
 }
 
 STATIC int
-- 
2.25.1



