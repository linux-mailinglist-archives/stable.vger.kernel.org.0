Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10FD5AB0D8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbiIBM7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiIBM67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:58:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F19520BF;
        Fri,  2 Sep 2022 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE78B82AD7;
        Fri,  2 Sep 2022 12:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57321C433C1;
        Fri,  2 Sep 2022 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122385;
        bh=G2T7Tlf5fBjaTBzZT3U25YetWR9g+p/O4H0DDcDcyqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDPvrazkY4Ok2dMzwogmXskXeKiG/NGH/GrCyqgx7OsJsifLO8kqJqGmEP0LCSe4D
         +oh9TplYp3RzWPYB2FptO0MuOGRk9J6PIFdvZFsnjYnFqe/UUywA9r1F5YuJ3veDgU
         0pYounfvlGKbc9nCRDc8DgO/6+xVpRHZbJMb7l0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 30/37] io_uring: disable polling pollfree files
Date:   Fri,  2 Sep 2022 14:19:52 +0200
Message-Id: <20220902121400.115965399@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
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
 fs/io_uring.c            |    5 +++++
 fs/signalfd.c            |    1 +
 include/linux/fs.h       |    1 +
 4 files changed, 8 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6069,6 +6069,7 @@ const struct file_operations binder_fops
 	.open = binder_open,
 	.flush = binder_flush,
 	.release = binder_release,
+	.may_pollfree = true,
 };
 
 static int __init init_binder_device(const char *name)
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5198,6 +5198,11 @@ static __poll_t __io_arm_poll_handler(st
 	struct io_ring_ctx *ctx = req->ctx;
 	bool cancel = false;
 
+	if (req->file->f_op->may_pollfree) {
+		spin_lock_irq(&ctx->completion_lock);
+		return -EOPNOTSUPP;
+	}
+
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, wake_func);
 	poll->file = req->file;
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


