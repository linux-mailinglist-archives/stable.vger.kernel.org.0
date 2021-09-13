Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C9F408858
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbhIMJhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238444AbhIMJhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECABC60D42;
        Mon, 13 Sep 2021 09:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631525790;
        bh=K7Nx5NFDff+sPDcv/21DFg3b1DhfgA2JnKjj/8xTDT4=;
        h=Subject:To:Cc:From:Date:From;
        b=m+DCqqmGQyiYtgztrbxVpeYJ0HsPWjTKl5PcI0PCgd8JEbpAVTMt6YS0kGGUV735p
         fAsdUk2t9QMMQysjA0Pxg7KKo/t8P5m44fA4jlhyR8vUGFLRQfAp/UTrXkFBxZyrYm
         OZVvr9W1inQhyuXgkXfhav1CPQt0JFi+uM27UOsI=
Subject: FAILED: patch "[PATCH] io_uring: limit fixed table size by RLIMIT_NOFILE" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 11:36:23 +0200
Message-ID: <163152578328117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a1b8a4e843f96b636431450d8d79061605cf74b Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 20 Aug 2021 10:36:35 +0100
Subject: [PATCH] io_uring: limit fixed table size by RLIMIT_NOFILE

Limit the number of files in io_uring fixed tables by RLIMIT_NOFILE,
that's the first and the simpliest restriction that we should impose.

Cc: stable@vger.kernel.org
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b2756c340aed7d6c0b302c26dab50c6c5907f4ce.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 706ac8c03b95..9a021fe6c461 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7733,6 +7733,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;

