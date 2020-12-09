Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87EB2D4487
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733019AbgLIOkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731477AbgLIOkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 09:40:52 -0500
Subject: patch "binder: add flag to clear buffer on txn complete" added to char-misc-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607524811;
        bh=oYZgylYM5HMFOSmmAcZYYC7m2Wev64im088axmnRK2s=;
        h=To:From:Date:From;
        b=13jyMZbkjaFCVlwz0zHoXGfFMMu5uFJUKYZ+mpsPl1c4KNH9cM+EWehLM7RdmzErS
         VmWXJO2n7ygvI10Mm8rVFGGZESs45DKqUYnmDL3N4AwAK+OakcJR4a0/mxYBN0De+p
         hfqTCf3Btexz0MGvTmBI5NrrY4ZGIsBEMIjLQ6+o=
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 15:41:28 +0100
Message-ID: <1607524888187110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: add flag to clear buffer on txn complete

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 0f966cba95c78029f491b433ea95ff38f414a761 Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Fri, 20 Nov 2020 15:37:43 -0800
Subject: binder: add flag to clear buffer on txn complete

Add a per-transaction flag to indicate that the buffer
must be cleared when the transaction is complete to
prevent copies of sensitive data from being preserved
in memory.

Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20201120233743.3617529-1-tkjos@google.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c            |  1 +
 drivers/android/binder_alloc.c      | 48 +++++++++++++++++++++++++++++
 drivers/android/binder_alloc.h      |  4 ++-
 include/uapi/linux/android/binder.h |  1 +
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 20b08f52e788..1338209f9f86 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2756,6 +2756,7 @@ static void binder_transaction(struct binder_proc *proc,
 	t->buffer->debug_id = t->debug_id;
 	t->buffer->transaction = t;
 	t->buffer->target_node = target_node;
+	t->buffer->clear_on_free = !!(t->flags & TF_CLEAR_BUF);
 	trace_binder_transaction_alloc_buf(t->buffer);
 
 	if (binder_alloc_copy_user_to_buffer(
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 2f846b7ae8b8..7caf74ad2405 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -696,6 +696,8 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
 	binder_insert_free_buffer(alloc, buffer);
 }
 
+static void binder_alloc_clear_buf(struct binder_alloc *alloc,
+				   struct binder_buffer *buffer);
 /**
  * binder_alloc_free_buf() - free a binder buffer
  * @alloc:	binder_alloc for this proc
@@ -706,6 +708,18 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
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
@@ -802,6 +816,10 @@ void binder_alloc_deferred_release(struct binder_alloc *alloc)
 		/* Transaction should already have been freed */
 		BUG_ON(buffer->transaction);
 
+		if (buffer->clear_on_free) {
+			binder_alloc_clear_buf(alloc, buffer);
+			buffer->clear_on_free = false;
+		}
 		binder_free_buf_locked(alloc, buffer);
 		buffers++;
 	}
@@ -1135,6 +1153,36 @@ static struct page *binder_alloc_get_page(struct binder_alloc *alloc,
 	return lru_page->page_ptr;
 }
 
+/**
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
 /**
  * binder_alloc_copy_user_to_buffer() - copy src user to tgt user
  * @alloc: binder_alloc for this proc
diff --git a/drivers/android/binder_alloc.h b/drivers/android/binder_alloc.h
index 55d8b4106766..6e8e001381af 100644
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
@@ -41,9 +42,10 @@ struct binder_buffer {
 	struct rb_node rb_node; /* free entry by size or allocated entry */
 				/* by address */
 	unsigned free:1;
+	unsigned clear_on_free:1;
 	unsigned allow_user_free:1;
 	unsigned async_transaction:1;
-	unsigned debug_id:29;
+	unsigned debug_id:28;
 
 	struct binder_transaction *transaction;
 
diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/android/binder.h
index f1ce2c4c077e..ec84ad106568 100644
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -248,6 +248,7 @@ enum transaction_flags {
 	TF_ROOT_OBJECT	= 0x04,	/* contents are the component's root object */
 	TF_STATUS_CODE	= 0x08,	/* contents are a 32-bit status code */
 	TF_ACCEPT_FDS	= 0x10,	/* allow replies with file descriptors */
+	TF_CLEAR_BUF	= 0x20,	/* clear buffer on txn complete */
 };
 
 struct binder_transaction_data {
-- 
2.29.2


