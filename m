Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4374D66E2C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfGLMhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729827AbfGLMfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:35:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019CE20645;
        Fri, 12 Jul 2019 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934906;
        bh=CjoIrDRx3t7J0e3BRwzPJrFFi25ZN1aEEFAAkabqYsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzi+QTeXPZ9SC3AdkMbq2iDPCDxam0Xx9DtE610kauobgYOyBJPT/xnyKQVtQ4dJa
         EGRK/iBoory2CHDDDgwKHrlDVaAu5MBb4W7B51YwSkWhGyQ+GGpXR9p8POsXp7KMU+
         YHY8aSByxq7966nRZQlvKDANrxNiZXim6XYqh23g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        syzbot+3ae18325f96190606754@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.2 43/61] binder: return errors from buffer copy functions
Date:   Fri, 12 Jul 2019 14:19:56 +0200
Message-Id: <20190712121622.950959406@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit bb4a2e48d5100ed3ff614df158a636bca3c6bf9f upstream.

The buffer copy functions assumed the caller would ensure
correct alignment and that the memory to be copied was
completely within the binder buffer. There have been
a few cases discovered by syzkallar where a malformed
transaction created by a user could violated the
assumptions and resulted in a BUG_ON.

The fix is to remove the BUG_ON and always return the
error to be handled appropriately by the caller.

Acked-by: Martijn Coenen <maco@android.com>
Reported-by: syzbot+3ae18325f96190606754@syzkaller.appspotmail.com
Fixes: bde4a19fc04f ("binder: use userspace pointer as base of buffer space")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c       |  151 ++++++++++++++++++++++++-----------------
 drivers/android/binder_alloc.c |   44 ++++++-----
 drivers/android/binder_alloc.h |   20 ++---
 3 files changed, 124 insertions(+), 91 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2059,10 +2059,9 @@ static size_t binder_get_object(struct b
 
 	read_size = min_t(size_t, sizeof(*object), buffer->data_size - offset);
 	if (offset > buffer->data_size || read_size < sizeof(*hdr) ||
-	    !IS_ALIGNED(offset, sizeof(u32)))
+	    binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
+					  offset, read_size))
 		return 0;
-	binder_alloc_copy_from_buffer(&proc->alloc, object, buffer,
-				      offset, read_size);
 
 	/* Ok, now see if we read a complete object. */
 	hdr = &object->hdr;
@@ -2131,8 +2130,10 @@ static struct binder_buffer_object *bind
 		return NULL;
 
 	buffer_offset = start_offset + sizeof(binder_size_t) * index;
-	binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
-				      b, buffer_offset, sizeof(object_offset));
+	if (binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
+					  b, buffer_offset,
+					  sizeof(object_offset)))
+		return NULL;
 	object_size = binder_get_object(proc, b, object_offset, object);
 	if (!object_size || object->hdr.type != BINDER_TYPE_PTR)
 		return NULL;
@@ -2212,10 +2213,12 @@ static bool binder_validate_fixup(struct
 			return false;
 		last_min_offset = last_bbo->parent_offset + sizeof(uintptr_t);
 		buffer_offset = objects_start_offset +
-			sizeof(binder_size_t) * last_bbo->parent,
-		binder_alloc_copy_from_buffer(&proc->alloc, &last_obj_offset,
-					      b, buffer_offset,
-					      sizeof(last_obj_offset));
+			sizeof(binder_size_t) * last_bbo->parent;
+		if (binder_alloc_copy_from_buffer(&proc->alloc,
+						  &last_obj_offset,
+						  b, buffer_offset,
+						  sizeof(last_obj_offset)))
+			return false;
 	}
 	return (fixup_offset >= last_min_offset);
 }
@@ -2301,15 +2304,15 @@ static void binder_transaction_buffer_re
 	for (buffer_offset = off_start_offset; buffer_offset < off_end_offset;
 	     buffer_offset += sizeof(binder_size_t)) {
 		struct binder_object_header *hdr;
-		size_t object_size;
+		size_t object_size = 0;
 		struct binder_object object;
 		binder_size_t object_offset;
 
-		binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
-					      buffer, buffer_offset,
-					      sizeof(object_offset));
-		object_size = binder_get_object(proc, buffer,
-						object_offset, &object);
+		if (!binder_alloc_copy_from_buffer(&proc->alloc, &object_offset,
+						   buffer, buffer_offset,
+						   sizeof(object_offset)))
+			object_size = binder_get_object(proc, buffer,
+							object_offset, &object);
 		if (object_size == 0) {
 			pr_err("transaction release %d bad object at offset %lld, size %zd\n",
 			       debug_id, (u64)object_offset, buffer->data_size);
@@ -2432,15 +2435,16 @@ static void binder_transaction_buffer_re
 			for (fd_index = 0; fd_index < fda->num_fds;
 			     fd_index++) {
 				u32 fd;
+				int err;
 				binder_size_t offset = fda_offset +
 					fd_index * sizeof(fd);
 
-				binder_alloc_copy_from_buffer(&proc->alloc,
-							      &fd,
-							      buffer,
-							      offset,
-							      sizeof(fd));
-				binder_deferred_fd_close(fd);
+				err = binder_alloc_copy_from_buffer(
+						&proc->alloc, &fd, buffer,
+						offset, sizeof(fd));
+				WARN_ON(err);
+				if (!err)
+					binder_deferred_fd_close(fd);
 			}
 		} break;
 		default:
@@ -2683,11 +2687,12 @@ static int binder_translate_fd_array(str
 		int ret;
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
 
-		binder_alloc_copy_from_buffer(&target_proc->alloc,
-					      &fd, t->buffer,
-					      offset, sizeof(fd));
-		ret = binder_translate_fd(fd, offset, t, thread,
-					  in_reply_to);
+		ret = binder_alloc_copy_from_buffer(&target_proc->alloc,
+						    &fd, t->buffer,
+						    offset, sizeof(fd));
+		if (!ret)
+			ret = binder_translate_fd(fd, offset, t, thread,
+						  in_reply_to);
 		if (ret < 0)
 			return ret;
 	}
@@ -2740,8 +2745,12 @@ static int binder_fixup_parent(struct bi
 	}
 	buffer_offset = bp->parent_offset +
 			(uintptr_t)parent->buffer - (uintptr_t)b->user_data;
-	binder_alloc_copy_to_buffer(&target_proc->alloc, b, buffer_offset,
-				    &bp->buffer, sizeof(bp->buffer));
+	if (binder_alloc_copy_to_buffer(&target_proc->alloc, b, buffer_offset,
+					&bp->buffer, sizeof(bp->buffer))) {
+		binder_user_error("%d:%d got transaction with invalid parent offset\n",
+				  proc->pid, thread->pid);
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -3160,15 +3169,20 @@ static void binder_transaction(struct bi
 		goto err_binder_alloc_buf_failed;
 	}
 	if (secctx) {
+		int err;
 		size_t buf_offset = ALIGN(tr->data_size, sizeof(void *)) +
 				    ALIGN(tr->offsets_size, sizeof(void *)) +
 				    ALIGN(extra_buffers_size, sizeof(void *)) -
 				    ALIGN(secctx_sz, sizeof(u64));
 
 		t->security_ctx = (uintptr_t)t->buffer->user_data + buf_offset;
-		binder_alloc_copy_to_buffer(&target_proc->alloc,
-					    t->buffer, buf_offset,
-					    secctx, secctx_sz);
+		err = binder_alloc_copy_to_buffer(&target_proc->alloc,
+						  t->buffer, buf_offset,
+						  secctx, secctx_sz);
+		if (err) {
+			t->security_ctx = 0;
+			WARN_ON(1);
+		}
 		security_release_secctx(secctx, secctx_sz);
 		secctx = NULL;
 	}
@@ -3234,11 +3248,16 @@ static void binder_transaction(struct bi
 		struct binder_object object;
 		binder_size_t object_offset;
 
-		binder_alloc_copy_from_buffer(&target_proc->alloc,
-					      &object_offset,
-					      t->buffer,
-					      buffer_offset,
-					      sizeof(object_offset));
+		if (binder_alloc_copy_from_buffer(&target_proc->alloc,
+						  &object_offset,
+						  t->buffer,
+						  buffer_offset,
+						  sizeof(object_offset))) {
+			return_error = BR_FAILED_REPLY;
+			return_error_param = -EINVAL;
+			return_error_line = __LINE__;
+			goto err_bad_offset;
+		}
 		object_size = binder_get_object(target_proc, t->buffer,
 						object_offset, &object);
 		if (object_size == 0 || object_offset < off_min) {
@@ -3262,15 +3281,17 @@ static void binder_transaction(struct bi
 
 			fp = to_flat_binder_object(hdr);
 			ret = binder_translate_binder(fp, t, thread);
-			if (ret < 0) {
+
+			if (ret < 0 ||
+			    binder_alloc_copy_to_buffer(&target_proc->alloc,
+							t->buffer,
+							object_offset,
+							fp, sizeof(*fp))) {
 				return_error = BR_FAILED_REPLY;
 				return_error_param = ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
-			binder_alloc_copy_to_buffer(&target_proc->alloc,
-						    t->buffer, object_offset,
-						    fp, sizeof(*fp));
 		} break;
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
@@ -3278,15 +3299,16 @@ static void binder_transaction(struct bi
 
 			fp = to_flat_binder_object(hdr);
 			ret = binder_translate_handle(fp, t, thread);
-			if (ret < 0) {
+			if (ret < 0 ||
+			    binder_alloc_copy_to_buffer(&target_proc->alloc,
+							t->buffer,
+							object_offset,
+							fp, sizeof(*fp))) {
 				return_error = BR_FAILED_REPLY;
 				return_error_param = ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
-			binder_alloc_copy_to_buffer(&target_proc->alloc,
-						    t->buffer, object_offset,
-						    fp, sizeof(*fp));
 		} break;
 
 		case BINDER_TYPE_FD: {
@@ -3296,16 +3318,17 @@ static void binder_transaction(struct bi
 			int ret = binder_translate_fd(fp->fd, fd_offset, t,
 						      thread, in_reply_to);
 
-			if (ret < 0) {
+			fp->pad_binder = 0;
+			if (ret < 0 ||
+			    binder_alloc_copy_to_buffer(&target_proc->alloc,
+							t->buffer,
+							object_offset,
+							fp, sizeof(*fp))) {
 				return_error = BR_FAILED_REPLY;
 				return_error_param = ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
-			fp->pad_binder = 0;
-			binder_alloc_copy_to_buffer(&target_proc->alloc,
-						    t->buffer, object_offset,
-						    fp, sizeof(*fp));
 		} break;
 		case BINDER_TYPE_FDA: {
 			struct binder_object ptr_object;
@@ -3393,15 +3416,16 @@ static void binder_transaction(struct bi
 						  num_valid,
 						  last_fixup_obj_off,
 						  last_fixup_min_off);
-			if (ret < 0) {
+			if (ret < 0 ||
+			    binder_alloc_copy_to_buffer(&target_proc->alloc,
+							t->buffer,
+							object_offset,
+							bp, sizeof(*bp))) {
 				return_error = BR_FAILED_REPLY;
 				return_error_param = ret;
 				return_error_line = __LINE__;
 				goto err_translate_failed;
 			}
-			binder_alloc_copy_to_buffer(&target_proc->alloc,
-						    t->buffer, object_offset,
-						    bp, sizeof(*bp));
 			last_fixup_obj_off = object_offset;
 			last_fixup_min_off = 0;
 		} break;
@@ -4140,20 +4164,27 @@ static int binder_apply_fd_fixups(struct
 		trace_binder_transaction_fd_recv(t, fd, fixup->offset);
 		fd_install(fd, fixup->file);
 		fixup->file = NULL;
-		binder_alloc_copy_to_buffer(&proc->alloc, t->buffer,
-					    fixup->offset, &fd,
-					    sizeof(u32));
+		if (binder_alloc_copy_to_buffer(&proc->alloc, t->buffer,
+						fixup->offset, &fd,
+						sizeof(u32))) {
+			ret = -EINVAL;
+			break;
+		}
 	}
 	list_for_each_entry_safe(fixup, tmp, &t->fd_fixups, fixup_entry) {
 		if (fixup->file) {
 			fput(fixup->file);
 		} else if (ret) {
 			u32 fd;
+			int err;
 
-			binder_alloc_copy_from_buffer(&proc->alloc, &fd,
-						      t->buffer, fixup->offset,
-						      sizeof(fd));
-			binder_deferred_fd_close(fd);
+			err = binder_alloc_copy_from_buffer(&proc->alloc, &fd,
+							    t->buffer,
+							    fixup->offset,
+							    sizeof(fd));
+			WARN_ON(err);
+			if (!err)
+				binder_deferred_fd_close(fd);
 		}
 		list_del(&fixup->fixup_entry);
 		kfree(fixup);
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1119,15 +1119,16 @@ binder_alloc_copy_user_to_buffer(struct
 	return 0;
 }
 
-static void binder_alloc_do_buffer_copy(struct binder_alloc *alloc,
-					bool to_buffer,
-					struct binder_buffer *buffer,
-					binder_size_t buffer_offset,
-					void *ptr,
-					size_t bytes)
+static int binder_alloc_do_buffer_copy(struct binder_alloc *alloc,
+				       bool to_buffer,
+				       struct binder_buffer *buffer,
+				       binder_size_t buffer_offset,
+				       void *ptr,
+				       size_t bytes)
 {
 	/* All copies must be 32-bit aligned and 32-bit size */
-	BUG_ON(!check_buffer(alloc, buffer, buffer_offset, bytes));
+	if (!check_buffer(alloc, buffer, buffer_offset, bytes))
+		return -EINVAL;
 
 	while (bytes) {
 		unsigned long size;
@@ -1155,25 +1156,26 @@ static void binder_alloc_do_buffer_copy(
 		ptr = ptr + size;
 		buffer_offset += size;
 	}
+	return 0;
 }
 
-void binder_alloc_copy_to_buffer(struct binder_alloc *alloc,
-				 struct binder_buffer *buffer,
-				 binder_size_t buffer_offset,
-				 void *src,
-				 size_t bytes)
+int binder_alloc_copy_to_buffer(struct binder_alloc *alloc,
+				struct binder_buffer *buffer,
+				binder_size_t buffer_offset,
+				void *src,
+				size_t bytes)
 {
-	binder_alloc_do_buffer_copy(alloc, true, buffer, buffer_offset,
-				    src, bytes);
+	return binder_alloc_do_buffer_copy(alloc, true, buffer, buffer_offset,
+					   src, bytes);
 }
 
-void binder_alloc_copy_from_buffer(struct binder_alloc *alloc,
-				   void *dest,
-				   struct binder_buffer *buffer,
-				   binder_size_t buffer_offset,
-				   size_t bytes)
+int binder_alloc_copy_from_buffer(struct binder_alloc *alloc,
+				  void *dest,
+				  struct binder_buffer *buffer,
+				  binder_size_t buffer_offset,
+				  size_t bytes)
 {
-	binder_alloc_do_buffer_copy(alloc, false, buffer, buffer_offset,
-				    dest, bytes);
+	return binder_alloc_do_buffer_copy(alloc, false, buffer, buffer_offset,
+					   dest, bytes);
 }
 
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -159,17 +159,17 @@ binder_alloc_copy_user_to_buffer(struct
 				 const void __user *from,
 				 size_t bytes);
 
-void binder_alloc_copy_to_buffer(struct binder_alloc *alloc,
-				 struct binder_buffer *buffer,
-				 binder_size_t buffer_offset,
-				 void *src,
-				 size_t bytes);
+int binder_alloc_copy_to_buffer(struct binder_alloc *alloc,
+				struct binder_buffer *buffer,
+				binder_size_t buffer_offset,
+				void *src,
+				size_t bytes);
 
-void binder_alloc_copy_from_buffer(struct binder_alloc *alloc,
-				   void *dest,
-				   struct binder_buffer *buffer,
-				   binder_size_t buffer_offset,
-				   size_t bytes);
+int binder_alloc_copy_from_buffer(struct binder_alloc *alloc,
+				  void *dest,
+				  struct binder_buffer *buffer,
+				  binder_size_t buffer_offset,
+				  size_t bytes);
 
 #endif /* _LINUX_BINDER_ALLOC_H */
 


