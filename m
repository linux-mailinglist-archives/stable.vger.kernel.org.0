Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD07D676DC2
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjAVOoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjAVOoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:44:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACD91BAF3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67DA960B6C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C735C433EF;
        Sun, 22 Jan 2023 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398657;
        bh=/bOiZL9T/souIlSGbf7aLhWNqvUcK2gznkSFwhE5s1o=;
        h=Subject:To:Cc:From:Date:From;
        b=JAGpK/nzQc90vgxloHJs+s8IC6objSlur0ax/NOmcFBDG9tJUP9lDK0pdOXseuxfK
         EsrgF9eSEwzrKUQOcR1Cd5zAgMzyqxmqBz7Qbi6kAxo4fn0a05kt+1p/Q1srl8Qy+j
         I5j6L8pesU6FZHTrl5EqVHXX2AF4HFYvM3TdF8vg=
Subject: FAILED: patch "[PATCH] io_uring: Clean up a false-positive warning from GCC 9.3.0" failed to apply to 5.15-stable tree
To:     alviro.iskandar@gmail.com, ammarfaizi2@gnuweeb.org,
        asml.silence@gmail.com, axboe@kernel.dk, dan.carpenter@oracle.com,
        lkp@intel.com, rong.a.chen@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 15:44:07 +0100
Message-ID: <167439864718781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0d7c1153d929 ("io_uring: Clean up a false-positive warning from GCC 9.3.0")
d1fd1c201d75 ("io_uring: simplify selected buf handling")
3648e5265cfa ("io_uring: move up io_put_kbuf() and io_put_rw_kbuf()")
04c76b41ca97 ("io_uring: add option to skip CQE posting")
913a571affed ("io_uring: clean cqe filling functions")
7297ce3d5944 ("io_uring: improve send/recv error handling")
54daa9b2d80a ("io_uring: correct fill events helpers types")
867f8fa5aeb7 ("io_uring: inline io_req_needs_clean()")
d17e56eb4907 ("io_uring: remove struct io_completion")
d886e185a128 ("io_uring: control ->async_data with a REQ_F flag")
fff4e40e3094 ("io_uring: delay req queueing into compl-batch list")
51d48dab62ed ("io_uring: add more likely/unlikely() annotations")
7e3709d57651 ("io_uring: optimise kiocb layout")
30d51dd4ad20 ("io_uring: clean up buffer select")
a1cdbb4cb5f7 ("io_uring: comment why inline complete calls io_clean_op()")
ef05d9ebcc92 ("io_uring: kill off ->inflight_entry field")
6962980947e2 ("io_uring: restructure submit sqes to_submit checks")
d9f9d2842c91 ("io_uring: reshuffle queue_sqe completion handling")
f5ed3bcd5b11 ("io_uring: optimise batch completion")
b3fa03fd1b17 ("io_uring: convert iopoll_completed to store_release")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0d7c1153d9291197c1dc473cfaade77acb874b4b Mon Sep 17 00:00:00 2001
From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Date: Mon, 7 Feb 2022 21:05:33 +0700
Subject: [PATCH] io_uring: Clean up a false-positive warning from GCC 9.3.0

In io_recv(), if import_single_range() fails, the @flags variable is
uninitialized, then it will goto out_free.

After the goto, the compiler doesn't know that (ret < min_ret) is
always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
could be taken.

The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
```
  fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags'
```
Fix this by bypassing the @ret and @flags check when
import_single_range() fails.

Reasons:
 1. import_single_range() only returns -EFAULT when it fails.
 2. At that point, @flags is uninitialized and shouldn't be read.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: "Chen, Rong A" <rong.a.chen@intel.com>
Link: https://lore.gnuweeb.org/timl/d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com/
Cc: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Fixes: 7297ce3d59449de49d3c9e1f64ae25488750a1fc ("io_uring: improve send/recv error handling")
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Link: https://lore.kernel.org/r/20220207140533.565411-1-ammarfaizi2@gnuweeb.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..3445c4da0153 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5228,7 +5228,6 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
-out_free:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
@@ -5236,9 +5235,9 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+out_free:
 		req_set_fail(req);
 	}
-
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
 	return 0;
 }

