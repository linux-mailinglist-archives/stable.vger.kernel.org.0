Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1785F60473D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiJSNf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiJSNef (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13B9CE17;
        Wed, 19 Oct 2022 06:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9EF3B824EA;
        Wed, 19 Oct 2022 09:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167FBC433D7;
        Wed, 19 Oct 2022 09:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170977;
        bh=s0Kxs9AhsSFwrBSiuSntUsIH+Tfr6lrXjjCETDydd48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2Xf2CBctxSrRy0+fI+Xz1joiaZ5kMMo3FAvcPmnbQV+liGdnHTfXVnseFMUslCVK
         Fx1TgoB6ntlTmwS0X5KiWZcE/NEbL8AcbwuVGRmgh+D4kWPten5i0IcjupjDxK/bAs
         uQjVxhMZ1oXjIROtRCmymOru1AoJHwM6RUTKvTzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 859/862] io_uring/rw: ensure kiocb_end_write() is always called
Date:   Wed, 19 Oct 2022 10:35:46 +0200
Message-Id: <20221019083327.847251927@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2ec33a6c3cca9fe2465e82050c81f5ffdc508b36 upstream.

A previous commit moved the notifications and end-write handling, but
it is now missing a few spots where we also want to call both of those.
Without that, we can potentially be missing file notifications, and
more importantly, have an imbalance in the super_block writers sem
accounting.

Fixes: b000145e9907 ("io_uring/rw: defer fsnotify calls to task context")
Reported-by: Dave Chinner <david@fromorbit.com>
Link: https://lore.kernel.org/all/20221010050319.GC2703033@dread.disaster.area/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -184,11 +184,34 @@ static void kiocb_end_write(struct io_ki
 	}
 }
 
+/*
+ * Trigger the notifications after having done some IO, and finish the write
+ * accounting, if any.
+ */
+static void io_req_io_end(struct io_kiocb *req)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	WARN_ON(!in_task());
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+}
+
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
+			/*
+			 * Reissue will start accounting again, finish the
+			 * current cycle.
+			 */
+			io_req_io_end(req);
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
@@ -214,15 +237,7 @@ static inline int io_fixup_rw_res(struct
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
-
+	io_req_io_end(req);
 	io_req_task_complete(req, locked);
 }
 
@@ -267,6 +282,11 @@ static int kiocb_done(struct io_kiocb *r
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
+			/*
+			 * Safe to call io_end from here as we're inline
+			 * from the submission path.
+			 */
+			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;


