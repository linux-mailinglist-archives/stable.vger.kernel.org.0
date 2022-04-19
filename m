Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5968E507029
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 16:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353226AbiDSOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 10:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350197AbiDSOZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 10:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C512A70F
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 07:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 970C960B38
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 14:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC3CC385A7;
        Tue, 19 Apr 2022 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650378152;
        bh=rz5zaFCfxiDSsdS2VQpoUx6bd3GHKWHALu5DGfU/WHM=;
        h=Subject:To:From:Date:From;
        b=b23WzAsymineyqTvj7XY52lxWCeyZqNmsBQNOseI6KldCGQu/AN6ZSD8eGk3fIzr2
         qyrJIRjiWrjGsVI2zROGg8iTU/MH1yFd2SI0inPsfPD3PSrIoXKis7YGpLRckbLcZB
         Wo6gd8OCJVVFK+r2F+9UKMcyA37CRQ/wCGD9+GG4=
Subject: patch "usb: gadget: uvc: Fix crash when encoding data for usb request" added to usb-linus
To:     w36195@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 19 Apr 2022 16:22:28 +0200
Message-ID: <1650378148174190@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    usb: gadget: uvc: Fix crash when encoding data for usb request

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 71d471e3faf90c9674cadc7605ac719e82cb7fac Mon Sep 17 00:00:00 2001
From: Dan Vacura <w36195@motorola.com>
Date: Thu, 31 Mar 2022 13:40:23 -0500
Subject: usb: gadget: uvc: Fix crash when encoding data for usb request

During the uvcg_video_pump() process, if an error occurs and
uvcg_queue_cancel() is called, the buffer queue will be cleared out, but
the current marker (queue->buf_used) of the active buffer (no longer
active) is not reset. On the next iteration of uvcg_video_pump() the
stale buf_used count will be used and the logic of min((unsigned
int)len, buf->bytesused - queue->buf_used) may incorrectly calculate a
nbytes size, causing an invalid memory access.

[80802.185460][  T315] configfs-gadget gadget: uvc: VS request completed
with status -18.
[80802.185519][  T315] configfs-gadget gadget: uvc: VS request completed
with status -18.
...
uvcg_queue_cancel() is called and the queue is cleared out, but the
marker queue->buf_used is not reset.
...
[80802.262328][ T8682] Unable to handle kernel paging request at virtual
address ffffffc03af9f000
...
...
[80802.263138][ T8682] Call trace:
[80802.263146][ T8682]  __memcpy+0x12c/0x180
[80802.263155][ T8682]  uvcg_video_pump+0xcc/0x1e0
[80802.263165][ T8682]  process_one_work+0x2cc/0x568
[80802.263173][ T8682]  worker_thread+0x28c/0x518
[80802.263181][ T8682]  kthread+0x160/0x170
[80802.263188][ T8682]  ret_from_fork+0x10/0x18
[80802.263198][ T8682] Code: a8c12829 a88130cb a8c130

Fixes: d692522577c0 ("usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20220331184024.23918-1-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index d852ac9e47e7..2cda982f3765 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -264,6 +264,8 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
+	queue->buf_used = 0;
+
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
-- 
2.35.3


