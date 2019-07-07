Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296FC61675
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfGGTiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57972 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727666AbfGGTiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:16 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006jJ-2K; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005gR-Is; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.304290448@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 124/129] binder: Replace "%p" with "%pK" for stable
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

This was done as part of upstream commits fdfb4a99b6ab "8inder:
separate binder allocator structure from binder proc", 19c987241ca1
"binder: separate out binder_alloc functions", and 7a4408c6bd3e
"binder: make sure accesses to proc/thread are safe".  However, those
commits made lots of other changes that are not suitable for stable.

Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/android/binder.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -473,7 +473,7 @@ static void binder_insert_free_buffer(st
 	new_buffer_size = binder_buffer_size(proc, new_buffer);
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %p\n",
+		     "%d: add free buffer, size %zd, at %pK\n",
 		      proc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -552,7 +552,7 @@ static int binder_update_page_range(stru
 	struct mm_struct *mm;
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: %s pages %p-%p\n", proc->pid,
+		     "%d: %s pages %pK-%pK\n", proc->pid,
 		     allocate ? "allocate" : "free", start, end);
 
 	if (end <= start)
@@ -593,7 +593,7 @@ static int binder_update_page_range(stru
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page == NULL) {
-			pr_err("%d: binder_alloc_buf failed for page at %p\n",
+			pr_err("%d: binder_alloc_buf failed for page at %pK\n",
 				proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -602,7 +602,7 @@ static int binder_update_page_range(stru
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %pK in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -706,7 +706,7 @@ static struct binder_buffer *binder_allo
 	}
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
 		      proc->pid, size, buffer, buffer_size);
 
 	has_page_addr =
@@ -736,7 +736,7 @@ static struct binder_buffer *binder_allo
 		binder_insert_free_buffer(proc, new_buffer);
 	}
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got %p\n",
+		     "%d: binder_alloc_buf size %zd got %pK\n",
 		      proc->pid, size, buffer);
 	buffer->data_size = data_size;
 	buffer->offsets_size = offsets_size;
@@ -776,7 +776,7 @@ static void binder_delete_free_buffer(st
 		if (buffer_end_page(prev) == buffer_end_page(buffer))
 			free_page_end = 0;
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "%d: merge free, buffer %p share page with %p\n",
+			     "%d: merge free, buffer %pK share page with %pK\n",
 			      proc->pid, buffer, prev);
 	}
 
@@ -789,14 +789,14 @@ static void binder_delete_free_buffer(st
 			    buffer_start_page(buffer))
 				free_page_start = 0;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%d: merge free, buffer %p share page with %p\n",
+				     "%d: merge free, buffer %pK share page with %pK\n",
 				      proc->pid, buffer, prev);
 		}
 	}
 	list_del(&buffer->entry);
 	if (free_page_start || free_page_end) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "%d: merge free, buffer %p do not share page%s%s with %p or %p\n",
+			     "%d: merge free, buffer %pK do not share page%s%s with %pK or %pK\n",
 			     proc->pid, buffer, free_page_start ? "" : " end",
 			     free_page_end ? "" : " start", prev, next);
 		binder_update_page_range(proc, 0, free_page_start ?
@@ -817,7 +817,7 @@ static void binder_free_buf(struct binde
 		ALIGN(buffer->offsets_size, sizeof(void *));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
 		      proc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
@@ -2825,7 +2825,7 @@ static int binder_mmap(struct file *filp
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %pK bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
@@ -3083,7 +3083,7 @@ static void binder_deferred_release(stru
 
 			page_addr = proc->buffer + i * PAGE_SIZE;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%s: %d: page %d at %p not freed\n",
+				     "%s: %d: page %d at %pK not freed\n",
 				     __func__, proc->pid, i, page_addr);
 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
 			__free_page(proc->pages[i]);
@@ -3184,7 +3184,7 @@ static void print_binder_transaction(str
 static void print_binder_buffer(struct seq_file *m, const char *prefix,
 				struct binder_buffer *buffer)
 {
-	seq_printf(m, "%s %d: %p size %zd:%zd %s\n",
+	seq_printf(m, "%s %d: %pK size %zd:%zd %s\n",
 		   prefix, buffer->debug_id, buffer->data,
 		   buffer->data_size, buffer->offsets_size,
 		   buffer->transaction ? "active" : "delivered");
@@ -3287,7 +3287,7 @@ static void print_binder_node(struct seq
 
 static void print_binder_ref(struct seq_file *m, struct binder_ref *ref)
 {
-	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
+	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %pK\n",
 		   ref->debug_id, ref->desc, ref->node->proc ? "" : "dead ",
 		   ref->node->debug_id, ref->strong, ref->weak, ref->death);
 }

