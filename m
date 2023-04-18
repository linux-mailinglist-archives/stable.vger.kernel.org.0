Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA61D6E6466
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjDRMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjDRMsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542D11544A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E63633DF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043FDC433D2;
        Tue, 18 Apr 2023 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822119;
        bh=+vb7HAUkb/Xzx7lFNrVSZ/ywGCQmc2XUFbEmGy+8HAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbROTEeGbEuOKPlGkm8908d6PZewwoqO24IabGYSY2P6KeYIUsLOq/DkJyB42VTHK
         R9yjTjwIrU45aP4hpnBBo+Yo2z8KqBqk1ivNaZQ5r3ZwfNMvklidZKapHAsZjHdQTZ
         Kmbhu8NoFMFzUPhZH7Ss4TptFTPgOimTEMuffWG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6.2 029/139] io_uring: complete request via task work in case of DEFER_TASKRUN
Date:   Tue, 18 Apr 2023 14:21:34 +0200
Message-Id: <20230418120314.732112377@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 860e1c7f8b0b43fbf91b4d689adfaa13adb89452 upstream.

So far io_req_complete_post() only covers DEFER_TASKRUN by completing
request via task work when the request is completed from IOWQ.

However, uring command could be completed from any context, and if io
uring is setup with DEFER_TASKRUN, the command is required to be
completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
can't be wakeup, and may hang forever.

The issue can be observed on removing ublk device, but turns out it is
one generic issue for uring command & DEFER_TASKRUN, so solve it in
io_uring core code.

Fixes: e6aeb2721d3b ("io_uring: complete all requests in task context")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-block/b3fc9991-4c53-9218-a8cc-5b4dd3952108@kernel.dk/
Reported-by: Jens Axboe <axboe@kernel.dk>
Cc: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -962,7 +962,7 @@ static void __io_req_complete_post(struc
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (req->ctx->task_complete && (issue_flags & IO_URING_F_IOWQ)) {
+	if (req->ctx->task_complete && req->ctx->submitter_task != current) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||


