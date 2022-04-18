Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E47504E8F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbiDRJ5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiDRJ5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:57:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BCF64F9
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1561B80E66
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AEBC385A1;
        Mon, 18 Apr 2022 09:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650275688;
        bh=FN2u6bKiZFkPvMMCjtk4ZMJCj8NbWe06zcm2Jro++2E=;
        h=Subject:To:Cc:From:Date:From;
        b=p+y8bwJ//vs6tunfb56TyM82V7WBMezJkViBrpWVf6AOcAsVu/rAbQmL2HGwOqFPe
         UsgJ7KAqpa4aCrTb5Mtpdog/b5ZNz6dbCSOITRC4gnqX80T04cPbQj3lvQGuRQbhmg
         Ecx2DmdW+Y8Jurt6tJ9DIflf2nIbuYWL43WSMg48=
Subject: FAILED: patch "[PATCH] io_uring: use right issue_flags for splice/tee" failed to apply to 5.17-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:54:46 +0200
Message-ID: <1650275686134226@kroah.com>
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

From e941976659f1f6834077a1596bf53e6bdb10e90b Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 13 Apr 2022 16:10:33 +0100
Subject: [PATCH] io_uring: use right issue_flags for splice/tee

Pass right issue_flags into into io_file_get_fixed() instead of
IO_URING_F_UNLOCKED. It's probably not a problem at the moment but let's
do it safer.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7d242daa9df5d776907686977cd29fbceb4a2d8d.1649862516.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b1a98697dcf..3d6cbf77c89d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4358,7 +4358,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
 	else
 		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {
@@ -4400,7 +4400,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
 	else
 		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {

