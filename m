Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5786E6732C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfGLQTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 12:19:37 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:38260 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfGLQTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 12:19:37 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2019 12:19:35 EDT
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 7BA3FC0122
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 18:11:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 63vlRMn7bRmd for <stable@vger.kernel.org>;
        Fri, 12 Jul 2019 18:11:18 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 4FFE3C0106
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 18:11:18 +0200 (CEST)
Received: (qmail 17800 invoked from network); 12 Jul 2019 18:42:54 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 12 Jul 2019 18:42:54 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id 0A88A460C4C; Fri, 12 Jul 2019 18:11:18 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] Revert "NFS: readdirplus optimization by cache mechanism" (memleak)
Date:   Fri, 12 Jul 2019 18:10:56 +0200
Message-Id: <20190712161055.14098-1-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit be4c2d4723a4a637f0d1b4f7c66447141a4b3564.

That commit caused a severe memory leak in nfs_readdir_make_qstr().

When listing a directory with more than 100 files (this is how many
struct nfs_cache_array_entry elements fit in one 4kB page), all
allocated file name strings past those 100 leak.

The root of the leakage is that those string pointers are managed in
pages which are never linked into the page cache.

fs/nfs/dir.c puts pages into the page cache by calling
read_cache_page(); the callback function nfs_readdir_filler() will
then fill the given page struct which was passed to it, which is
already linked in the page cache (by do_read_cache_page() calling
add_to_page_cache_lru()).

Commit be4c2d4723a4 added another (local) array of allocated pages, to
be filled with more data, instead of discarding excess items received
from the NFS server.  Those additional pages can be used by the next
nfs_readdir_filler() call (from within the same nfs_readdir() call).

The leak happens when some of those additional pages are never used
(copied to the page cache using copy_highpage()).  The pages will be
freed by nfs_readdir_free_pages(), but their contents will not.  The
commit did not invoke nfs_readdir_clear_array() (and doing so would
have been dangerous, because it did not track which of those pages
were already copied to the page cache, risking double free bugs).

How to reproduce the leak:

- Use a kernel with CONFIG_SLUB_DEBUG_ON.

- Create a directory on a NFS mount with more than 100 files with
  names long enough to use the "kmalloc-32" slab (so we can easily
  look up the allocation counts):

  for i in `seq 110`; do touch ${i}_0123456789abcdef; done

- Drop all caches:

  echo 3 >/proc/sys/vm/drop_caches

- Check the allocation counter:

  grep nfs_readdir /sys/kernel/slab/kmalloc-32/alloc_calls
  30564391 nfs_readdir_add_to_array+0x73/0xd0 age=534558/4791307/6540952 pid=370-1048386 cpus=0-47 nodes=0-1

- Request a directory listing and check the allocation counters again:

  ls
  [...]
  grep nfs_readdir /sys/kernel/slab/kmalloc-32/alloc_calls
  30564511 nfs_readdir_add_to_array+0x73/0xd0 age=207/4792999/6542663 pid=370-1048386 cpus=0-47 nodes=0-1

There are now 120 new allocations.

- Drop all caches and check the counters again:

  echo 3 >/proc/sys/vm/drop_caches
  grep nfs_readdir /sys/kernel/slab/kmalloc-32/alloc_calls
  30564401 nfs_readdir_add_to_array+0x73/0xd0 age=735/4793524/6543176 pid=370-1048386 cpus=0-47 nodes=0-1

110 allocations are gone, but 10 have leaked and will never be freed.

Unhelpfully, those allocations are explicitly excluded from KMEMLEAK,
that's why my initial attempts with KMEMLEAK were not successful:

	/*
	 * Avoid a kmemleak false positive. The pointer to the name is stored
	 * in a page cache page which kmemleak does not scan.
	 */
	kmemleak_not_leak(string->name);

It would be possible to solve this bug without reverting the whole
commit:

- keep track of which pages were not used, and call
  nfs_readdir_clear_array() on them, or
- manually link those pages into the page cache

But for now I have decided to just revert the commit, because the real
fix would require complex considerations, risking more dangerous
(crash) bugs, which may seem unsuitable for the stable branches.

Signed-off-by: Max Kellermann <mk@cm4all.com>
Cc: stable@vger.kernel.org
---
 fs/nfs/dir.c      | 90 ++++-------------------------------------------
 fs/nfs/internal.h |  3 +-
 2 files changed, 7 insertions(+), 86 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 57b6a45576ad..9f44ddc34c7b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -140,19 +140,12 @@ struct nfs_cache_array {
 	struct nfs_cache_array_entry array[0];
 };
 
-struct readdirvec {
-	unsigned long nr;
-	unsigned long index;
-	struct page *pages[NFS_MAX_READDIR_RAPAGES];
-};
-
 typedef int (*decode_dirent_t)(struct xdr_stream *, struct nfs_entry *, bool);
 typedef struct {
 	struct file	*file;
 	struct page	*page;
 	struct dir_context *ctx;
 	unsigned long	page_index;
-	struct readdirvec pvec;
 	u64		*dir_cookie;
 	u64		last_cookie;
 	loff_t		current_index;
@@ -532,10 +525,6 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *en
 	struct nfs_cache_array *array;
 	unsigned int count = 0;
 	int status;
-	int max_rapages = NFS_MAX_READDIR_RAPAGES;
-
-	desc->pvec.index = desc->page_index;
-	desc->pvec.nr = 0;
 
 	scratch = alloc_page(GFP_KERNEL);
 	if (scratch == NULL)
@@ -560,40 +549,20 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *en
 		if (desc->plus)
 			nfs_prime_dcache(file_dentry(desc->file), entry);
 
-		status = nfs_readdir_add_to_array(entry, desc->pvec.pages[desc->pvec.nr]);
-		if (status == -ENOSPC) {
-			desc->pvec.nr++;
-			if (desc->pvec.nr == max_rapages)
-				break;
-			status = nfs_readdir_add_to_array(entry, desc->pvec.pages[desc->pvec.nr]);
-		}
+		status = nfs_readdir_add_to_array(entry, page);
 		if (status != 0)
 			break;
 	} while (!entry->eof);
 
-	/*
-	 * page and desc->pvec.pages[0] are valid, don't need to check
-	 * whether or not to be NULL.
-	 */
-	copy_highpage(page, desc->pvec.pages[0]);
-
 out_nopages:
 	if (count == 0 || (status == -EBADCOOKIE && entry->eof != 0)) {
-		array = kmap_atomic(desc->pvec.pages[desc->pvec.nr]);
+		array = kmap(page);
 		array->eof_index = array->size;
 		status = 0;
-		kunmap_atomic(array);
+		kunmap(page);
 	}
 
 	put_page(scratch);
-
-	/*
-	 * desc->pvec.nr > 0 means at least one page was completely filled,
-	 * we should return -ENOSPC. Otherwise function
-	 * nfs_readdir_xdr_to_array will enter infinite loop.
-	 */
-	if (desc->pvec.nr > 0)
-		return -ENOSPC;
 	return status;
 }
 
@@ -627,24 +596,6 @@ int nfs_readdir_alloc_pages(struct page **pages, unsigned int npages)
 	return -ENOMEM;
 }
 
-/*
- * nfs_readdir_rapages_init initialize rapages by nfs_cache_array structure.
- */
-static
-void nfs_readdir_rapages_init(nfs_readdir_descriptor_t *desc)
-{
-	struct nfs_cache_array *array;
-	int max_rapages = NFS_MAX_READDIR_RAPAGES;
-	int index;
-
-	for (index = 0; index < max_rapages; index++) {
-		array = kmap_atomic(desc->pvec.pages[index]);
-		memset(array, 0, sizeof(struct nfs_cache_array));
-		array->eof_index = -1;
-		kunmap_atomic(array);
-	}
-}
-
 static
 int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page, struct inode *inode)
 {
@@ -655,12 +606,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	int status = -ENOMEM;
 	unsigned int array_size = ARRAY_SIZE(pages);
 
-	/*
-	 * This means we hit readdir rdpages miss, the preallocated rdpages
-	 * are useless, the preallocate rdpages should be reinitialized.
-	 */
-	nfs_readdir_rapages_init(desc);
-
 	entry.prev_cookie = 0;
 	entry.cookie = desc->last_cookie;
 	entry.eof = 0;
@@ -721,24 +666,9 @@ int nfs_readdir_filler(void *data, struct page* page)
 	struct inode	*inode = file_inode(desc->file);
 	int ret;
 
-	/*
-	 * If desc->page_index in range desc->pvec.index and
-	 * desc->pvec.index + desc->pvec.nr, we get readdir cache hit.
-	 */
-	if (desc->page_index >= desc->pvec.index &&
-		desc->page_index < (desc->pvec.index + desc->pvec.nr)) {
-		/*
-		 * page and desc->pvec.pages[x] are valid, don't need to check
-		 * whether or not to be NULL.
-		 */
-		copy_highpage(page, desc->pvec.pages[desc->page_index - desc->pvec.index]);
-		ret = 0;
-	} else {
-		ret = nfs_readdir_xdr_to_array(desc, page, inode);
-		if (ret < 0)
-			goto error;
-	}
-
+	ret = nfs_readdir_xdr_to_array(desc, page, inode);
+	if (ret < 0)
+		goto error;
 	SetPageUptodate(page);
 
 	if (invalidate_inode_pages2_range(inode->i_mapping, page->index + 1, -1) < 0) {
@@ -903,7 +833,6 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 			*desc = &my_desc;
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	int res = 0;
-	int max_rapages = NFS_MAX_READDIR_RAPAGES;
 
 	dfprintk(FILE, "NFS: readdir(%pD2) starting at cookie %llu\n",
 			file, (long long)ctx->pos);
@@ -923,12 +852,6 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	desc->decode = NFS_PROTO(inode)->decode_dirent;
 	desc->plus = nfs_use_readdirplus(inode, ctx);
 
-	res = nfs_readdir_alloc_pages(desc->pvec.pages, max_rapages);
-	if (res < 0)
-		return -ENOMEM;
-
-	nfs_readdir_rapages_init(desc);
-
 	if (ctx->pos == 0 || nfs_attribute_cache_expired(inode))
 		res = nfs_revalidate_mapping(inode, file->f_mapping);
 	if (res < 0)
@@ -964,7 +887,6 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 			break;
 	} while (!desc->eof);
 out:
-	nfs_readdir_free_pages(desc->pvec.pages, max_rapages);
 	if (res > 0)
 		res = 0;
 	dfprintk(FILE, "NFS: readdir(%pD2) returns %d\n", file, res);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 498fab72f70b..81e2fdff227e 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -69,8 +69,7 @@ struct nfs_clone_mount {
  * Maximum number of pages that readdir can use for creating
  * a vmapped array of pages.
  */
-#define NFS_MAX_READDIR_PAGES 64
-#define NFS_MAX_READDIR_RAPAGES 8
+#define NFS_MAX_READDIR_PAGES 8
 
 struct nfs_client_initdata {
 	unsigned long init_flags;
-- 
2.20.1

