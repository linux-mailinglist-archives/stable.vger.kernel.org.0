Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3851A610
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353699AbiEDQwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353754AbiEDQwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D0E4738D;
        Wed,  4 May 2022 09:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 735FCB82552;
        Wed,  4 May 2022 16:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C959C385AA;
        Wed,  4 May 2022 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682913;
        bh=zL7m3jJKBlSnNR74+VWXMFcYh75Cfk2X59tlw/vprHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3IJMgSvL/LLSt8S6IYbmIj5k5JeKMs+h5bGFCZmVpdX0JEefjV+CxGhqT97Ab52/
         fP86/Cb881/puLfpn6gN7rDSWcI4Ga24Ya2KcSbbMfg6SygQpyEA6qMtscWHGF4FVG
         WeoZFS4Y+X55DH76oiBQAl3EWQaj/kBPugcxW1W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.4 19/84] usb: gadget: uvc: Fix crash when encoding data for usb request
Date:   Wed,  4 May 2022 18:44:00 +0200
Message-Id: <20220504152929.126254575@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dan Vacura <w36195@motorola.com>

commit 71d471e3faf90c9674cadc7605ac719e82cb7fac upstream.

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
 drivers/usb/gadget/function/uvc_queue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -242,6 +242,8 @@ void uvcg_queue_cancel(struct uvc_video_
 		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
+	queue->buf_used = 0;
+
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not


