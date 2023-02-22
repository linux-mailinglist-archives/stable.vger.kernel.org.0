Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0469F411
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBVMM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBVMM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:12:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4543F13D73
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 04:12:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73386140F
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 12:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C48C4339C;
        Wed, 22 Feb 2023 12:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677067944;
        bh=NAZzcRGXuCZ4Wgvxo5bUG3exRopxVrOolRQRbAvFNIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p98R/FsqFU5sRIbbRzc4bv7DkCh/hFwFaxPyFMJFcvlhJ7shvt2ME+1kD9iqlRoHX
         dgboHNhPhnpdeVdxdvzfZc0qL245G3kk6pkYT2M0rAjniBCVG+X7Yad9iuMkLrIOOr
         2tZGt+qENhUzHNhQKWlWdVv7fxGBAwwpPQGlMiou/5byvAJPFR5dTKkgiwJ/fprmXX
         VUUe+UM+zjKCLz4swsqW8OvjX5dK3GN2IocpRvaXTiSWExz0PsnQXe4KAKeJOrSquL
         65gfQHvlhUA+8gKFjp/D9r13WcAf/sxosdB3m9NekS2RZ9xAIiGCHA+6huQibLg/hP
         1PgujMw+BWjDg==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Todd Kjos <tkjos@google.com>,
        Martijn Coenen <maco@android.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH v5.15.y 1/5] binder: read pre-translated fds from sender buffer
Date:   Wed, 22 Feb 2023 12:12:04 +0000
Message-Id: <20230222121208.898198-2-lee@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
In-Reply-To: <20230222121208.898198-1-lee@kernel.org>
References: <20230222121208.898198-1-lee@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 656e01f3ab54afe71bed066996fc2640881e1220 upstream.

This patch is to prepare for an up coming patch where we read
pre-translated fds from the sender buffer and translate them before
copying them to the target.  It does not change run time.

The patch adds two new parameters to binder_translate_fd_array() to
hold the sender buffer and sender buffer parent.  These parameters let
us call copy_from_user() directly from the sender instead of using
binder_alloc_copy_from_buffer() to copy from the target.  Also the patch
adds some new alignment checks.  Previously the alignment checks would
have been done in a different place, but this lets us print more
useful error messages.

Reviewed-by: Martijn Coenen <maco@android.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20211130185152.437403-4-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/android/binder.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 00c6c03ff8222..67f96d2959280 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2270,15 +2270,17 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset,
 }
 
 static int binder_translate_fd_array(struct binder_fd_array_object *fda,
+				     const void __user *sender_ubuffer,
 				     struct binder_buffer_object *parent,
+				     struct binder_buffer_object *sender_uparent,
 				     struct binder_transaction *t,
 				     struct binder_thread *thread,
 				     struct binder_transaction *in_reply_to)
 {
 	binder_size_t fdi, fd_buf_size;
 	binder_size_t fda_offset;
+	const void __user *sender_ufda_base;
 	struct binder_proc *proc = thread->proc;
-	struct binder_proc *target_proc = t->to_proc;
 
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
@@ -2302,7 +2304,10 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32))) {
+	sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
+
+	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
+	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {
 		binder_user_error("%d:%d parent offset not aligned correctly.\n",
 				  proc->pid, thread->pid);
 		return -EINVAL;
@@ -2311,10 +2316,9 @@ static int binder_translate_fd_array(struct binder_fd_array_object *fda,
 		u32 fd;
 		int ret;
 		binder_size_t offset = fda_offset + fdi * sizeof(fd);
+		binder_size_t sender_uoffset = fdi * sizeof(fd);
 
-		ret = binder_alloc_copy_from_buffer(&target_proc->alloc,
-						    &fd, t->buffer,
-						    offset, sizeof(fd));
+		ret = copy_from_user(&fd, sender_ufda_base + sender_uoffset, sizeof(fd));
 		if (!ret)
 			ret = binder_translate_fd(fd, offset, t, thread,
 						  in_reply_to);
@@ -2987,6 +2991,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_FDA: {
 			struct binder_object ptr_object;
 			binder_size_t parent_offset;
+			struct binder_object user_object;
+			size_t user_parent_size;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
 			size_t num_valid = (buffer_offset - off_start_offset) /
@@ -3018,8 +3024,27 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error_line = __LINE__;
 				goto err_bad_parent;
 			}
-			ret = binder_translate_fd_array(fda, parent, t, thread,
-							in_reply_to);
+			/*
+			 * We need to read the user version of the parent
+			 * object to get the original user offset
+			 */
+			user_parent_size =
+				binder_get_object(proc, user_buffer, t->buffer,
+						  parent_offset, &user_object);
+			if (user_parent_size != sizeof(user_object.bbo)) {
+				binder_user_error("%d:%d invalid ptr object size: %zd vs %zd\n",
+						  proc->pid, thread->pid,
+						  user_parent_size,
+						  sizeof(user_object.bbo));
+				return_error = BR_FAILED_REPLY;
+				return_error_param = -EINVAL;
+				return_error_line = __LINE__;
+				goto err_bad_parent;
+			}
+			ret = binder_translate_fd_array(fda, user_buffer,
+							parent,
+							&user_object.bbo, t,
+							thread, in_reply_to);
 			if (!ret)
 				ret = binder_alloc_copy_to_buffer(&target_proc->alloc,
 								  t->buffer,
-- 
2.39.2.637.g21b0678d19-goog

