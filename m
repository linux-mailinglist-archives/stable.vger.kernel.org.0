Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509847392C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbfGXThd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389473AbfGXThc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D3A214AF;
        Wed, 24 Jul 2019 19:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997051;
        bh=lSfct6///+hWwmy0pE9niqiCGbidNZ4fY9l6J+aTGzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7RgNbabyHpIY3nXousYYFqkYUorkZOPNosXPLkNCT8Eu389PBPiSWxzah/PqWy7g
         PBr9WthLyBcpNEV6w2FJE8eDecDiuFcNNdtY8GxHsLQvlvzGubf8fYlwaD+L09b96M
         eGMxOMCKEa3jBAtY6qD5rm0ItvUX6dU+xhluRyxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 305/413] Revert "NFS: readdirplus optimization by cache mechanism" (memleak)
Date:   Wed, 24 Jul 2019 21:19:56 +0200
Message-Id: <20190724191757.641570436@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Kellermann <mk@cm4all.com>

commit db531db951f950b86d274cc8ed7b21b9e2240036 upstream.

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
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dir.c      |   90 +++---------------------------------------------------
 fs/nfs/internal.h |    3 -
 2 files changed, 7 insertions(+), 86 deletions(-)

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
@@ -532,10 +525,6 @@ int nfs_readdir_page_filler(nfs_readdir_
 	struct nfs_cache_array *array;
 	unsigned int count = 0;
 	int status;
-	int max_rapages = NFS_MAX_READDIR_RAPAGES;
-
-	desc->pvec.index = desc->page_index;
-	desc->pvec.nr = 0;
 
 	scratch = alloc_page(GFP_KERNEL);
 	if (scratch == NULL)
@@ -560,40 +549,20 @@ int nfs_readdir_page_filler(nfs_readdir_
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
 
@@ -627,24 +596,6 @@ out_freepages:
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
@@ -655,12 +606,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir
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
@@ -721,24 +666,9 @@ int nfs_readdir_filler(void *data, struc
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
@@ -903,7 +833,6 @@ static int nfs_readdir(struct file *file
 			*desc = &my_desc;
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	int res = 0;
-	int max_rapages = NFS_MAX_READDIR_RAPAGES;
 
 	dfprintk(FILE, "NFS: readdir(%pD2) starting at cookie %llu\n",
 			file, (long long)ctx->pos);
@@ -923,12 +852,6 @@ static int nfs_readdir(struct file *file
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
@@ -964,7 +887,6 @@ static int nfs_readdir(struct file *file
 			break;
 	} while (!desc->eof);
 out:
-	nfs_readdir_free_pages(desc->pvec.pages, max_rapages);
 	if (res > 0)
 		res = 0;
 	dfprintk(FILE, "NFS: readdir(%pD2) returns %d\n", file, res);
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


