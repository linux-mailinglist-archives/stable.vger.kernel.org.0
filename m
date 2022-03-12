Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4864D6E48
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 12:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiCLLCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 06:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiCLLCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 06:02:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A31190B60
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 03:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA55FB82E28
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 11:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2343EC340EB;
        Sat, 12 Mar 2022 11:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647082887;
        bh=KypU78jLUk/906KJ/URlukVQUxJh+SHYJAi5aFdZNj4=;
        h=Subject:To:Cc:From:Date:From;
        b=noEBCriJOrofpZxVSvk3lfsiTAaouHL0nGA/Q8haz4UJzyQFidWjjHyNZDOktBU4j
         E9Val+51kVRaRHz9rTiVoHdWdRqJLxMbJTZhJb0RC4hiowjyhnR2Sr13RaUeZZDFNK
         6J4Kz0mQJM5CQqDqr1rh+LLglsd1/W3NPecPJUOA=
Subject: FAILED: patch "[PATCH] fuse: fix pipe buffer lifetime for direct_io" failed to apply to 4.14-stable tree
To:     mszeredi@redhat.com, jannh@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Mar 2022 12:01:11 +0100
Message-ID: <164708287149190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0c4bcfdecb1ac0967619ee7ff44871d93c08c909 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 7 Mar 2022 16:30:44 +0100
Subject: [PATCH] fuse: fix pipe buffer lifetime for direct_io

In FOPEN_DIRECT_IO mode, fuse_file_write_iter() calls
fuse_direct_write_iter(), which normally calls fuse_direct_io(), which then
imports the write buffer with fuse_get_user_pages(), which uses
iov_iter_get_pages() to grab references to userspace pages instead of
actually copying memory.

On the filesystem device side, these pages can then either be read to
userspace (via fuse_dev_read()), or splice()d over into a pipe using
fuse_dev_splice_read() as pipe buffers with &nosteal_pipe_buf_ops.

This is wrong because after fuse_dev_do_read() unlocks the FUSE request,
the userspace filesystem can mark the request as completed, causing write()
to return. At that point, the userspace filesystem should no longer have
access to the pipe buffer.

Fix by copying pages coming from the user address space to new pipe
buffers.

Reported-by: Jann Horn <jannh@google.com>
Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index cd54a529460d..592730fd6e42 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -941,7 +941,17 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
-			return fuse_ref_page(cs, page, offset, count);
+			/*
+			 * Can't control lifetime of pipe buffers, so always
+			 * copy user pages.
+			 */
+			if (cs->req->args->user_pages) {
+				err = fuse_copy_fill(cs);
+				if (err)
+					return err;
+			} else {
+				return fuse_ref_page(cs, page, offset, count);
+			}
 		} else if (!cs->len) {
 			if (cs->move_pages && page &&
 			    offset == 0 && count == PAGE_SIZE) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 829094451774..0fc150c1c50b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1413,6 +1413,7 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	ap->args.user_pages = true;
 	if (write)
 		ap->args.in_pages = true;
 	else
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e8e59fbdefeb..eac4984cc753 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -256,6 +256,7 @@ struct fuse_args {
 	bool nocreds:1;
 	bool in_pages:1;
 	bool out_pages:1;
+	bool user_pages:1;
 	bool out_argvar:1;
 	bool page_zeroing:1;
 	bool page_replace:1;

