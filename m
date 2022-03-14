Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E87D4D81F6
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiCNL6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240184AbiCNL6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:58:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33AC9FCB;
        Mon, 14 Mar 2022 04:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A147EB80DE2;
        Mon, 14 Mar 2022 11:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCF7C340E9;
        Mon, 14 Mar 2022 11:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259030;
        bh=53SuvHqLsdQdV5lGsvyqBuQ/n38DdwjVCycIDj9374k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4E0A99EwixVGe7p+WkN6t7Oti65q3BtCT0KTFUi9whMW5gMRgZQe2THs6N/f5lvW
         yAeUA9RwrzOi/50BiWc+BfVD9tjA9W8TpOMp3Fvg0GLPd6rSpRT8O4LKr9bZE+SZ3J
         b6sDS8s9g1f3YEBzD6HmO4RpZXTIANhvUNX60Bns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 30/43] fuse: fix pipe buffer lifetime for direct_io
Date:   Mon, 14 Mar 2022 12:53:41 +0100
Message-Id: <20220314112735.266119159@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 0c4bcfdecb1ac0967619ee7ff44871d93c08c909 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c    |   12 +++++++++++-
 fs/fuse/file.c   |    1 +
 fs/fuse/fuse_i.h |    1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -933,7 +933,17 @@ static int fuse_copy_page(struct fuse_co
 
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
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1433,6 +1433,7 @@ static int fuse_get_user_pages(struct fu
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	ap->args.user_pages = true;
 	if (write)
 		ap->args.in_pages = 1;
 	else
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -248,6 +248,7 @@ struct fuse_args {
 	bool nocreds:1;
 	bool in_pages:1;
 	bool out_pages:1;
+	bool user_pages:1;
 	bool out_argvar:1;
 	bool page_zeroing:1;
 	bool page_replace:1;


