Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AF23AA15
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732459AbfFIQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732454AbfFIQxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A4A206BB;
        Sun,  9 Jun 2019 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099222;
        bh=mV8qG6VrvM3FTzlOwCZ2PTV/GzEmJZLwhAuQ7MD2cE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hchw8NyR6gjUlagWTKdi5gIJoOkRpSs9TwR0ufst6kilf6dnDZkyPxlJBYN0NwHiy
         rJMxV0XBKYjx9LdLRtHEqLPsSG49QnWv5AHjOzvuId3tQ+aSQ2No+COrIjM2YOcd4X
         Y/pZtPySxaRo6+OZK7rwsvsmhc2VE0AqbzLneWrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 52/83] binder: Replace "%p" with "%pK" for stable
Date:   Sun,  9 Jun 2019 18:42:22 +0200
Message-Id: <20190609164132.381317323@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

This was done as part of upstream commits fdfb4a99b6ab "8inder:
separate binder allocator structure from binder proc", 19c987241ca1
"binder: separate out binder_alloc functions", and 7a4408c6bd3e
"binder: make sure accesses to proc/thread are safe".  However, those
commits made lots of other changes that are not suitable for stable.

Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -488,7 +488,7 @@ static void binder_insert_free_buffer(st
 	new_buffer_size = binder_buffer_size(proc, new_buffer);
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %p\n",
+		     "%d: add free buffer, size %zd, at %pK\n",
 		      proc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -566,7 +566,7 @@ static int binder_update_page_range(stru
 	struct mm_struct *mm;
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: %s pages %p-%p\n", proc->pid,
+		     "%d: %s pages %pK-%pK\n", proc->pid,
 		     allocate ? "allocate" : "free", start, end);
 
 	if (end <= start)
@@ -606,7 +606,7 @@ static int binder_update_page_range(stru
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page == NULL) {
-			pr_err("%d: binder_alloc_buf failed for page at %p\n",
+			pr_err("%d: binder_alloc_buf failed for page at %pK\n",
 				proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -615,7 +615,7 @@ static int binder_update_page_range(stru
 		flush_cache_vmap((unsigned long)page_addr,
 				(unsigned long)page_addr + PAGE_SIZE);
 		if (ret != 1) {
-			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %pK in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -719,7 +719,7 @@ static struct binder_buffer *binder_allo
 	}
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
 		      proc->pid, size, buffer, buffer_size);
 
 	has_page_addr =
@@ -749,7 +749,7 @@ static struct binder_buffer *binder_allo
 		binder_insert_free_buffer(proc, new_buffer);
 	}
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got %p\n",
+		     "%d: binder_alloc_buf size %zd got %pK\n",
 		      proc->pid, size, buffer);
 	buffer->data_size = data_size;
 	buffer->offsets_size = offsets_size;
@@ -789,7 +789,7 @@ static void binder_delete_free_buffer(st
 		if (buffer_end_page(prev) == buffer_end_page(buffer))
 			free_page_end = 0;
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "%d: merge free, buffer %p share page with %p\n",
+			     "%d: merge free, buffer %pK share page with %pK\n",
 			      proc->pid, buffer, prev);
 	}
 
@@ -802,14 +802,14 @@ static void binder_delete_free_buffer(st
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
@@ -830,7 +830,7 @@ static void binder_free_buf(struct binde
 		ALIGN(buffer->offsets_size, sizeof(void *));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
 		      proc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
@@ -2930,7 +2930,7 @@ static int binder_mmap(struct file *filp
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %pK bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
@@ -3191,7 +3191,7 @@ static void binder_deferred_release(stru
 
 			page_addr = proc->buffer + i * PAGE_SIZE;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%s: %d: page %d at %p not freed\n",
+				     "%s: %d: page %d at %pK not freed\n",
 				     __func__, proc->pid, i, page_addr);
 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
 			__free_page(proc->pages[i]);
@@ -3294,7 +3294,7 @@ static void print_binder_transaction(str
 static void print_binder_buffer(struct seq_file *m, const char *prefix,
 				struct binder_buffer *buffer)
 {
-	seq_printf(m, "%s %d: %p size %zd:%zd %s\n",
+	seq_printf(m, "%s %d: %pK size %zd:%zd %s\n",
 		   prefix, buffer->debug_id, buffer->data,
 		   buffer->data_size, buffer->offsets_size,
 		   buffer->transaction ? "active" : "delivered");
@@ -3397,7 +3397,7 @@ static void print_binder_node(struct seq
 
 static void print_binder_ref(struct seq_file *m, struct binder_ref *ref)
 {
-	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
+	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %pK\n",
 		   ref->debug_id, ref->desc, ref->node->proc ? "" : "dead ",
 		   ref->node->debug_id, ref->strong, ref->weak, ref->death);
 }


