Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA9504E92
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiDRJ5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiDRJ5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88778BC34
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4313CB80E5D
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8886CC385A1;
        Mon, 18 Apr 2022 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650275704;
        bh=3J2r9YMnwbNY+mVPNV9TF+ME7aK67SPGYAY90fKlsqc=;
        h=Subject:To:Cc:From:Date:From;
        b=UR78MuoIF1zWiKbSJc+nqhOrFEA8z8JZzzKumAH5LvAxG/enqj3guE8d62R004UuI
         myPZFVO7IVORDXwCd27wMC+ynoazuAHF16qRB9Hn6LupCmBWT+dplZX3V3z3jc2Tw6
         pgr/iS528cmWxZNc69O8mm+PnBe9K9HvcMgdeao8=
Subject: FAILED: patch "[PATCH] io_uring: fix poll error reporting" failed to apply to 5.17-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:55:01 +0200
Message-ID: <1650275701176229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7179c3ce3dbff646c55f7cd664a895f462f049e5 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 13 Apr 2022 16:10:35 +0100
Subject: [PATCH] io_uring: fix poll error reporting

We should not return an error code in req->result in
io_poll_check_events(), because it may get mangled and returned as
success. Just return the error code directly, the callers will fail the
request or proceed accordingly.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5f03514ee33324dc811fb93df84aee0f695fb044.1649862516.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d06f1952fdfa..ab674a0d269b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5861,9 +5861,8 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
 
 			if (unlikely(!io_assign_file(req, flags)))
-				req->result = -EBADF;
-			else
-				req->result = vfs_poll(req->file, &pt) & req->apoll_events;
+				return -EBADF;
+			req->result = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
 		/* multishot, just fill an CQE and proceed */

