Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122A6565726
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiGDNao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiGDNaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:30:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013A813DFD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 997F2B80EFD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF65CC3411E;
        Mon,  4 Jul 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656941063;
        bh=OuLrUFkc0b33asgITPN79XlEY9YCum7/5J9ZajeKMcM=;
        h=Subject:To:Cc:From:Date:From;
        b=UmkW+QUBevycBb+YcHcthxjGsNVl7e1CNmlw/OPY6bdP3rkkZh0Veet4PkJn8ik+Z
         7ABjnDiwU/dPItObhf31SlQIUy64Jyb/QU6ligsfipb/u0rIZe9SD+9c3DJoXoL8qG
         nAQ+8TcIEvzOAEzWkWGZk0GPPlrCGa6d6M+xY/W0=
Subject: FAILED: patch "[PATCH] io_uring: fix provided buffer import" failed to apply to 5.18-stable tree
To:     dylany@fb.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:24:20 +0200
Message-ID: <1656941060218130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 09007af2b627f0f195c6c53c4829b285cc3990ec Mon Sep 17 00:00:00 2001
From: Dylan Yudaken <dylany@fb.com>
Date: Thu, 30 Jun 2022 06:20:06 -0700
Subject: [PATCH] io_uring: fix provided buffer import

io_import_iovec uses the s pointer, but this was changed immediately
after the iovec was re-imported and so it was imported into the wrong
place.

Change the ordering.

Fixes: 2be2eb02e2f5 ("io_uring: ensure reads re-import for selected buffers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220630132006.2825668-1-dylany@fb.com
[axboe: ensure we don't half-import as well]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aeb042ba5cc5..0d491ad15b66 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4318,18 +4318,19 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
+		rw = req->async_data;
+		s = &rw->s;
+
 		/*
 		 * Safe and required to re-import if we're using provided
 		 * buffers, as we dropped the selected one before retry.
 		 */
-		if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
 			ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
 			if (unlikely(ret < 0))
 				return ret;
 		}
 
-		rw = req->async_data;
-		s = &rw->s;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't

