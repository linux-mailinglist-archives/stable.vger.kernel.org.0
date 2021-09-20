Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB93F4110AD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhITIK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235338AbhITIK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00508610A3;
        Mon, 20 Sep 2021 08:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632125329;
        bh=LZr6Ps3fmHED/4PreAWOkmtWLjebbxdqi21P1uKw9DE=;
        h=Subject:To:Cc:From:Date:From;
        b=ygeyaZSFAwK39z1R0gQUUGG8M7/3/I2em76PZxgkIF6SnXRxV1gwpkIRPs4Wjct6I
         HAFcxNTSs2DWWhkJjC/ML3AskliqR4P2U3oD1ZUjeGetcoelk4K81+OYUQciOLGHGX
         Aaamf5/kakPJTPaFM769LO7AkraRYYpMIT2JF4qA=
Subject: FAILED: patch "[PATCH] io_uring: fix missing sigmask restore in io_cqring_wait()" failed to apply to 5.14-stable tree
To:     xiaoguang.wang@linux.alibaba.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:08:47 +0200
Message-ID: <1632125327122192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 44df58d441a94de40d52fca67dc60790daee4266 Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date: Tue, 14 Sep 2021 22:38:52 +0800
Subject: [PATCH] io_uring: fix missing sigmask restore in io_cqring_wait()

Move get_timespec() section in io_cqring_wait() before the sigmask
saving, otherwise we'll fail to restore sigmask once get_timespec()
returns error.

Fixes: c73ebb685fb6 ("io_uring: add timeout support for io_uring_enter()")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210914143852.9663-1-xiaoguang.wang@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a864a94364c6..94afd087e97b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7518,6 +7518,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			break;
 	} while (1);
 
+	if (uts) {
+		struct timespec64 ts;
+
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = timespec64_to_jiffies(&ts);
+	}
+
 	if (sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
@@ -7531,14 +7539,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			return ret;
 	}
 
-	if (uts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		timeout = timespec64_to_jiffies(&ts);
-	}
-
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);

