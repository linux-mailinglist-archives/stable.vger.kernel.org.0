Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2B26F43B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgIRCBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgIRCBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575472137B;
        Fri, 18 Sep 2020 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394492;
        bh=FZTJJD/HWiv6zrvi1fp7uYiFa26SoDlsL9tRf7isqjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dux6IX4FXQutscx4+0g3XPzVbhm41klniz3JWnRYx0agaxBBJrWsLe57G7EV8gdX+
         qT4VdoxzRH7TxcMzQJB565stSWAmwkXkiStd3kpfnHiO60ycJWFxncaLKb7ViSoR1f
         gm6ULgvLU3FbCfWom+PwBRrPExDTEeMoN3yL5X5Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 5.4 017/330] xfs: fix inode fork extent count overflow
Date:   Thu, 17 Sep 2020 21:55:57 -0400
Message-Id: <20200918020110.2063155-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08 ]

[commit message is verbose for discussion purposes - will trim it
down later. Some questions about implementation details at the end.]

Zorro Lang recently ran a new test to stress single inode extent
counts now that they are no longer limited by memory allocation.
The test was simply:

# xfs_io -f -c "falloc 0 40t" /mnt/scratch/big-file
# ~/src/xfstests-dev/punch-alternating /mnt/scratch/big-file

This test uncovered a problem where the hole punching operation
appeared to finish with no error, but apparently only created 268M
extents instead of the 10 billion it was supposed to.

Further, trying to punch out extents that should have been present
resulted in success, but no change in the extent count. It looked
like a silent failure.

While running the test and observing the behaviour in real time,
I observed the extent coutn growing at ~2M extents/minute, and saw
this after about an hour:

# xfs_io -f -c "stat" /mnt/scratch/big-file |grep next ; \
> sleep 60 ; \
> xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
fsxattr.nextents = 127657993
fsxattr.nextents = 129683339
#

And a few minutes later this:

# xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
fsxattr.nextents = 4177861124
#

Ah, what? Where did that 4 billion extra extents suddenly come from?

Stop the workload, unmount, mount:

# xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
fsxattr.nextents = 166044375
#

And it's back at the expected number. i.e. the extent count is
correct on disk, but it's screwed up in memory. I loaded up the
extent list, and immediately:

# xfs_io -f -c "stat" /mnt/scratch/big-file |grep next
fsxattr.nextents = 4192576215
#

It's bad again. So, where does that number come from?
xfs_fill_fsxattr():

                if (ip->i_df.if_flags & XFS_IFEXTENTS)
                        fa->fsx_nextents = xfs_iext_count(&ip->i_df);
                else
                        fa->fsx_nextents = ip->i_d.di_nextents;

And that's the behaviour I just saw in a nutshell. The on disk count
is correct, but once the tree is loaded into memory, it goes whacky.
Clearly there's something wrong with xfs_iext_count():

inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
{
        return ifp->if_bytes / sizeof(struct xfs_iext_rec);
}

Simple enough, but 134M extents is 2**27, and that's right about
where things went wrong. A struct xfs_iext_rec is 16 bytes in size,
which means 2**27 * 2**4 = 2**31 and we're right on target for an
integer overflow. And, sure enough:

struct xfs_ifork {
        int                     if_bytes;       /* bytes in if_u1 */
....

Once we get 2**27 extents in a file, we overflow if_bytes and the
in-core extent count goes wrong. And when we reach 2**28 extents,
if_bytes wraps back to zero and things really start to go wrong
there. This is where the silent failure comes from - only the first
2**28 extents can be looked up directly due to the overflow, all the
extents above this index wrap back to somewhere in the first 2**28
extents. Hence with a regular pattern, trying to punch a hole in the
range that didn't have holes mapped to a hole in the first 2**28
extents and so "succeeded" without changing anything. Hence "silent
failure"...

Fix this by converting if_bytes to a int64_t and converting all the
index variables and size calculations to use int64_t types to avoid
overflows in future. Signed integers are still used to enable easy
detection of extent count underflows. This enables scalability of
extent counts to the limits of the on-disk format - MAXEXTNUM
(2**31) extents.

Current testing is at over 500M extents and still going:

fsxattr.nextents = 517310478

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 18 ++++++++++--------
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++------
 5 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fe277ee5ec7c4..b133209f3aa6a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -453,13 +453,15 @@ xfs_attr_copy_value(
  * special case for dev/uuid inodes, they have fixed size data forks.
  */
 int
-xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
+xfs_attr_shortform_bytesfit(
+	struct xfs_inode	*dp,
+	int			bytes)
 {
-	int offset;
-	int minforkoff;	/* lower limit on valid forkoff locations */
-	int maxforkoff;	/* upper limit on valid forkoff locations */
-	int dsize;
-	xfs_mount_t *mp = dp->i_mount;
+	struct xfs_mount	*mp = dp->i_mount;
+	int64_t			dsize;
+	int			minforkoff;
+	int			maxforkoff;
+	int			offset;
 
 	/* rounded down */
 	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
@@ -525,7 +527,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	 * A data fork btree root must have space for at least
 	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
 	 */
-	minforkoff = max(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
+	minforkoff = max_t(int64_t, dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
@@ -924,7 +926,7 @@ xfs_attr_shortform_verify(
 	char				*endp;
 	struct xfs_ifork		*ifp;
 	int				i;
-	int				size;
+	int64_t				size;
 
 	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
 	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc2a8da9..ae16ca7c422a9 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -628,7 +628,7 @@ xfs_dir2_sf_verify(
 	int				i;
 	int				i8count;
 	int				offset;
-	int				size;
+	int64_t				size;
 	int				error;
 	uint8_t				filetype;
 
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 7bc87408f1a0a..52451809c4786 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -596,7 +596,7 @@ xfs_iext_realloc_root(
 	struct xfs_ifork	*ifp,
 	struct xfs_iext_cursor	*cur)
 {
-	size_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
+	int64_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
 	void *new;
 
 	/* account for the prev/next pointers */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c643beeb5a248..8fdd0424070e0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -129,7 +129,7 @@ xfs_init_local_fork(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	const void		*data,
-	int			size)
+	int64_t			size)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			mem_size = size, real_size = 0;
@@ -467,11 +467,11 @@ xfs_iroot_realloc(
 void
 xfs_idata_realloc(
 	struct xfs_inode	*ip,
-	int			byte_diff,
+	int64_t			byte_diff,
 	int			whichfork)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			new_size = (int)ifp->if_bytes + byte_diff;
+	int64_t			new_size = ifp->if_bytes + byte_diff;
 
 	ASSERT(new_size >= 0);
 	ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));
@@ -552,7 +552,7 @@ xfs_iextents_copy(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	rec;
-	int			copied = 0;
+	int64_t			copied = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 00c62ce170d0e..7b845c052fb45 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -13,16 +13,16 @@ struct xfs_dinode;
  * File incore extent information, present for each of data & attr forks.
  */
 struct xfs_ifork {
-	int			if_bytes;	/* bytes in if_u1 */
-	unsigned int		if_seq;		/* fork mod counter */
+	int64_t			if_bytes;	/* bytes in if_u1 */
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
-	short			if_broot_bytes;	/* bytes allocated for root */
-	unsigned char		if_flags;	/* per-fork flags */
+	unsigned int		if_seq;		/* fork mod counter */
 	int			if_height;	/* height of the extent tree */
 	union {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	short			if_broot_bytes;	/* bytes allocated for root */
+	unsigned char		if_flags;	/* per-fork flags */
 };
 
 /*
@@ -93,12 +93,14 @@ int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
-void		xfs_idata_realloc(struct xfs_inode *, int, int);
+void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
+				int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
-void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
+void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
+				const void *data, int64_t size);
 
 xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
-- 
2.25.1

