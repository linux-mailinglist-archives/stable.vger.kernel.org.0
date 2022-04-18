Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B651350559F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiDRNPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243010AbiDRNJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3B0369E7;
        Mon, 18 Apr 2022 05:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B3B1B80EC3;
        Mon, 18 Apr 2022 12:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F5FC385A8;
        Mon, 18 Apr 2022 12:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286147;
        bh=z+MJ5BwcFYCOls5GqHWIzpBRgYQfepqqFTN/5M0j8+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQb8FyAGGxhP57sRA4LtmvnxKVfR10mKocN0+fr+dXDypo6iASRN6RfKeHXI1jIWu
         mmnQjYunUkaVDW8xHo0eMNE3Px0aG1XWR306cH07PTTl+qjJOTkv/jlLwA2pMSRqMH
         SRGKfnHyRHa9NBV8BHvU1nTFnFs11/DbJpTollXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Zach OKeefe <zokeefe@google.com>
Subject: [PATCH 4.14 009/284] fuse: fix pipe buffer lifetime for direct_io
Date:   Mon, 18 Apr 2022 14:09:50 +0200
Message-Id: <20220418121210.961307913@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c    |   12 +++++++++++-
 fs/fuse/file.c   |    1 +
 fs/fuse/fuse_i.h |    2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -991,7 +991,17 @@ static int fuse_copy_page(struct fuse_co
 
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
-			return fuse_ref_page(cs, page, offset, count);
+			/*
+			 * Can't control lifetime of pipe buffers, so always
+			 * copy user pages.
+			 */
+			if (cs->req->user_pages) {
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
@@ -1325,6 +1325,7 @@ static int fuse_get_user_pages(struct fu
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	req->user_pages = true;
 	if (write)
 		req->in.argpages = 1;
 	else
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -312,6 +312,8 @@ struct fuse_req {
 	/** refcount */
 	refcount_t count;
 
+	bool user_pages;
+
 	/** Unique ID for the interrupt request */
 	u64 intr_unique;
 


