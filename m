Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D9C2E3BBD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407395AbgL1NyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407389AbgL1NyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD13520782;
        Mon, 28 Dec 2020 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163628;
        bh=BLhgA+3v/QK6Owk8XZsvvW9oksCl6btWtbJOugOYS0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPlvF6fDAjNF15Nj8DJ+lmgtfJ+OuCzK68+UV/DxncCZC96SENgIVFBiG4vo+hgLJ
         Uh4cHzQuaq0o5YitJRLXO+LS45gr4Ei8gqO7dK3o6pc/xFRAYmtQKsUzIa1H4CmmRb
         3Uka02S4ugnEMq/SxjfZtJIDQWifhmAXxqXxkeIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 353/453] binder: add flag to clear buffer on txn complete
Date:   Mon, 28 Dec 2020 13:49:49 +0100
Message-Id: <20201228124954.192014069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 0f966cba95c78029f491b433ea95ff38f414a761 upstream.

Add a per-transaction flag to indicate that the buffer
must be cleared when the transaction is complete to
prevent copies of sensitive data from being preserved
in memory.

Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20201120233743.3617529-1-tkjos@google.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c            |    1 
 drivers/android/binder_alloc.c      |   48 ++++++++++++++++++++++++++++++++++++
 drivers/android/binder_alloc.h      |    4 ++-
 include/uapi/linux/android/binder.h |    1 
 4 files changed, 53 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3150,6 +3150,7 @@ static void binder_transaction(struct bi
 	t->buffer->debug_id = t->debug_id;
 	t->buffer->transaction = t;
 	t->buffer->target_node = target_node;
+	t->buffer->clear_on_free = !!(t->flags & TF_CLEAR_BUF);
 	trace_binder_transaction_alloc_buf(t->buffer);
 
 	if (binder_alloc_copy_user_to_buffer(
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -647,6 +647,8 @@ static void binder_free_buf_locked(struc
 	binder_insert_free_buffer(alloc, buffer);
 }
 
+static void binder_alloc_clear_buf(struct binder_alloc *alloc,
+				   struct binder_buffer *buffer);
 /**
  * binder_alloc_free_buf() - free a binder buffer
  * @alloc:	binder_alloc for this proc
@@ -657,6 +659,18 @@ static void binder_free_buf_locked(struc
 void binder_alloc_free_buf(struct binder_alloc *alloc,
 			    struct binder_buffer *buffer)
 {
+	/*
+	 * We could eliminate the call to binder_alloc_clear_buf()
+	 * from binder_alloc_deferred_release() by moving this to
+	 * binder_alloc_free_buf_locked(). However, that could
+	 * increase contention for the alloc mutex if clear_on_free
+	 * is used frequently for large buffers. The mutex is not
+	 * needed for correctness here.
+	 */
+	if (buffer->clear_on_free) {
+		binder_alloc_clear_buf(alloc, buffer);
+		buffer->clear_on_free = false;
+	}
 	mutex_lock(&alloc->mutex);
 	binder_free_buf_locked(alloc, buffer);
 	mutex_unlock(&alloc->mutex);
@@ -753,6 +767,10 @@ void binder_alloc_deferred_release(struc
 		/* Transaction should already have been freed */
 		BUG_ON(buffer->transaction);
 
+		if (buffer->clear_on_free) {
+			binder_alloc_clear_buf(alloc, buffer);
+			buffer->clear_on_free = false;
+		}
 		binder_free_buf_locked(alloc, buffer);
 		buffers++;
 	}
@@ -1087,6 +1105,36 @@ static struct page *binder_alloc_get_pag
 }
 
 /**
+ * binder_alloc_clear_buf() - zero out buffer
+ * @alloc: binder_alloc for this proc
+ * @buffer: binder buffer to be cleared
+ *
+ * memset the given buffer to 0
+ */
+static void binder_alloc_clear_buf(struct binder_alloc *alloc,
+				   struct binder_buffer *buffer)
+{
+	size_t bytes = binder_alloc_buffer_size(alloc, buffer);
+	binder_size_t buffer_offset = 0;
+
+	while (bytes) {
+		unsigned long size;
+		struct page *page;
+		pgoff_t pgoff;
+		void *kptr;
+
+		page = binder_alloc_get_page(alloc, buffer,
+					     buffer_offset, &pgoff);
+		size = min_t(size_t, bytes, PAGE_SIZE - pgoff);
+		kptr = kmap(page) + pgoff;
+		memset(kptr, 0, size);
+		kunmap(page);
+		bytes -= size;
+		buffer_offset += size;
+	}
+}
+
+/**
  * binder_alloc_copy_user_to_buffer() - copy src user to tgt user
  * @alloc: binder_alloc for this proc
  * @buffer: binder buffer to be accessed
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -23,6 +23,7 @@ struct binder_transaction;
  * @entry:              entry alloc->buffers
  * @rb_node:            node for allocated_buffers/free_buffers rb trees
  * @free:               %true if buffer is free
+ * @clear_on_free:      %true if buffer must be zeroed after use
  * @allow_user_free:    %true if user is allowed to free buffer
  * @async_transaction:  %true if buffer is in use for an async txn
  * @debug_id:           unique ID for debugging
@@ -40,9 +41,10 @@ struct binder_buffer {
 	struct rb_node rb_node; /* free entry by size or allocated entry */
 				/* by address */
 	unsigned free:1;
+	unsigned clear_on_free:1;
 	unsigned allow_user_free:1;
 	unsigned async_transaction:1;
-	unsigned debug_id:29;
+	unsigned debug_id:28;
 
 	struct binder_transaction *transaction;
 
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -248,6 +248,7 @@ enum transaction_flags {
 	TF_ROOT_OBJECT	= 0x04,	/* contents are the component's root object */
 	TF_STATUS_CODE	= 0x08,	/* contents are a 32-bit status code */
 	TF_ACCEPT_FDS	= 0x10,	/* allow replies with file descriptors */
+	TF_CLEAR_BUF	= 0x20,	/* clear buffer on txn complete */
 };
 
 struct binder_transaction_data {


