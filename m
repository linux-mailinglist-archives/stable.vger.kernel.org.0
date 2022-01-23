Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156E549721B
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiAWO1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWO1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:27:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34ABC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8485B60CA3
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BCEC340E2;
        Sun, 23 Jan 2022 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948067;
        bh=7nctGTSUaa4Iv85in7WsXLOK6oTpZRLlIsm/j1HNkgQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Vo1RrNQN57OuN+4mAjeSm6Wl16m4J6J+fyFPIvm+U5+huvm3GdtvjdyJo8V3Ct15A
         FnDqQlw9RVapTFNZdJYVmCp/2ctmPP3iDEslIFZAYlhyEOKrd/cp8I9qp/QTlyw8ld
         RnzWmjkgCmLByceOcLd+Wf+CU7A/mhHbDHLMhzus=
Subject: FAILED: patch "[PATCH] io_uring: fix no lock protection for ctx->cq_extra" failed to apply to 5.15-stable tree
To:     haoxu@linux.alibaba.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:27:44 +0100
Message-ID: <1642948064248114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e302f1046f4c209291b07ff7bc4d15ca26891f16 Mon Sep 17 00:00:00 2001
From: Hao Xu <haoxu@linux.alibaba.com>
Date: Thu, 25 Nov 2021 17:21:02 +0800
Subject: [PATCH] io_uring: fix no lock protection for ctx->cq_extra

ctx->cq_extra should be protected by completion lock so that the
req_need_defer() does the right check.

Cc: stable@vger.kernel.org
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211125092103.224502-2-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f666a0e7f5e8..ae9534382b26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6537,12 +6537,15 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
+		spin_unlock(&ctx->completion_lock);
 queue:
 		ctx->drain_active = false;
 		io_req_task_queue(req);
 		return;
 	}
+	spin_unlock(&ctx->completion_lock);
 
 	ret = io_req_prep_async(req);
 	if (ret) {

