Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E445AAF7A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiIBMjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiIBMiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD444566;
        Fri,  2 Sep 2022 05:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41326215A;
        Fri,  2 Sep 2022 12:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB809C433D6;
        Fri,  2 Sep 2022 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121820;
        bh=jg21/zAcWtXDnw6C4rfwOyVUqIjJj4LhRlaz0D8/GT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/w6eqSiR1xA9GRJ2pYbx0/Ukp0CYoOEvDXUKtBjoBI13knHP5B+l1l/6CZHWcr/I
         QBNel3q/nIDlZVhUBZueyyQnEglhaM8cDbAXAP1EeFVOwPbtn90WOoWH6XtUycPp7M
         lUQZnhEtyLJfoaw8d3zeywTK/9L6qBeSyOGzeQ+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.4 75/77] io_uring: disable polling pollfree files
Date:   Fri,  2 Sep 2022 14:19:24 +0200
Message-Id: <20220902121406.177903979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Older kernels lack io_uring POLLFREE handling. As only affected files
are signalfd and android binder the safest option would be to disable
polling those files via io_uring and hope there are no users.

Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    1 +
 fs/io_uring.c            |    3 +++
 fs/signalfd.c            |    1 +
 include/linux/fs.h       |    1 +
 4 files changed, 6 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6083,6 +6083,7 @@ const struct file_operations binder_fops
 	.open = binder_open,
 	.flush = binder_flush,
 	.release = binder_release,
+	.may_pollfree = true,
 };
 
 static int __init init_binder_device(const char *name)
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1908,6 +1908,9 @@ static int io_poll_add(struct io_kiocb *
 	__poll_t mask;
 	u16 events;
 
+	if (req->file->f_op->may_pollfree)
+		return -EOPNOTSUPP;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -248,6 +248,7 @@ static const struct file_operations sign
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
 	.llseek		= noop_llseek,
+	.may_pollfree	= true,
 };
 
 static int do_signalfd4(int ufd, sigset_t *mask, int flags)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1859,6 +1859,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	bool may_pollfree;
 } __randomize_layout;
 
 struct inode_operations {


