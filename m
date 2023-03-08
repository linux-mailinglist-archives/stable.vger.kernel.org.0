Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32CD6B09CE
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCHNuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjCHNtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:49:53 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EEE82341
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:49:47 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id ec29so35127624edb.6
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 05:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678283386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfeXX0tgJ9DbOF8tcF0b8sec4B30vgT0UFdIWcdNoOE=;
        b=oSeAk0Yly3J1IrIFV1FU/oXNsscRPFrC/exFK2b0MewkicGhSzz8GzG6X9/TPbSkXt
         6pO8b88oC0eSIAKRNM5FpAhQvrgymPX7OWLQ/YWxxsDnf/fH1YD8qCzv5dxQEqOxocwB
         369FHOC8M47stgGvQuoxLDb6xvjlONi1xi8RY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678283386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfeXX0tgJ9DbOF8tcF0b8sec4B30vgT0UFdIWcdNoOE=;
        b=h/0LYBn+Cc7bJVZgOype05HoIQs2pJmaU99oGSG3DfVUX9X0cDIOCEbmyuAYThNXIB
         wlUb8u7kis1aGwrL2yyKlojV+oPh4C29xPF/APaMfe1MN5f+IltXXFwpvy743kUE/d2l
         auCWVHviIWo/DM1HFyVFCMNCeiAWi87sZpoLUOGNcB3xFdzjLS2HStxBti4DNa0IPSi2
         1BM7y885MScFIUVgqYH/aABeeHIf/iHt1+vCv17Sc4/NQsQ59p6eGGS/b+rlrJpdCYoy
         fLubXRu5eriSwB1OZfd+KdrA1X+64WCr0FAsWx0XAJCzBPYiCXcN13fnTH4PLuWJoi2Q
         DaTg==
X-Gm-Message-State: AO0yUKX3tHHc0vm5UHeBE+HbuN5JfpotjBkKhPz6ojZbMZCItA+mmh2p
        l901x4hKk6E0769w/pAgQLVcNbgNZB+vdGpHx1U=
X-Google-Smtp-Source: AK7set+QOwBop4kdD4pfp9rY1+cKrtaIq6YocJSJwb2d5z/ctCCA+izOPql/Sr8x9PrRFwnnlDOwKw==
X-Received: by 2002:aa7:cfcf:0:b0:4ab:1d33:69ba with SMTP id r15-20020aa7cfcf000000b004ab1d3369bamr16181742edy.16.1678283386257;
        Wed, 08 Mar 2023 05:49:46 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:2926:70d3:ee98:eb12])
        by smtp.gmail.com with ESMTPSA id u7-20020a50d507000000b004acc6cbc451sm8223119edi.36.2023.03.08.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 05:49:46 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.10.y 2/2] media: uvcvideo: Fix race condition with usb_kill_urb
Date:   Wed,  8 Mar 2023 14:49:41 +0100
Message-Id: <20230308134941.247570-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230308134941.247570-1-ribalda@chromium.org>
References: <1678100215149200@kroah.com>
 <20230308134941.247570-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usb_kill_urb warranties that all the handlers are finished when it
returns, but does not protect against threads that might be handling
asynchronously the urb.

For UVC, the function uvc_ctrl_status_event_async() takes care of
control changes asynchronously.

If the code is executed in the following order:

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
uvc_ctrl_status_event_work()
					uvc_status_start() -> FAIL

Then uvc_status_start will keep failing and this error will be shown:

<4>[    5.540139] URB 0000000000000000 submitted while active
drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528

Let's improve the current situation, by not re-submiting the urb if
we are stopping the status event. Also process the queued work
(if any) during stop.

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
					uvc_status_start()
uvc_ctrl_status_event_work() -> FAIL

Hopefully, with the usb layer protection this should be enough to cover
all the cases.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Reviewed-by: Yunke Cao <yunkec@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
(cherry picked from commit 619d9b710cf06f7a00a17120ca92333684ac45a8)
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   |  5 ++++
 drivers/media/usb/uvc/uvc_status.c | 37 ++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 43 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 327ffc232993..5e0acabed37a 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -1318,6 +1319,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 3e26d82a906d..73725051cc16 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -310,5 +311,41 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/*
+	 * Prevent the asynchronous control handler from requeing the URB. The
+	 * barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
+	 */
+	smp_store_release(&dev->flush_status, true);
+
+	/*
+	 * Cancel any pending asynchronous work. If any status event was queued,
+	 * process it synchronously.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* Kill the urb. */
 	usb_kill_urb(dev->int_urb);
+
+	/*
+	 * The URB completion handler may have queued asynchronous work. This
+	 * won't resubmit the URB as flush_status is set, but it needs to be
+	 * cancelled before returning or it could then race with a future
+	 * uvc_status_start() call.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status URB
+	 * is dead. No events will be queued until uvc_status_start() is called.
+	 * The barrier is needed to make sure that flush_status is visible to
+	 * uvc_ctrl_status_event_work() when uvc_status_start() will be called
+	 * again.
+	 */
+	smp_store_release(&dev->flush_status, false);
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e487879b1c73..370811dafe2a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -670,6 +670,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	u8 *status;
+	bool flush_status;
 	struct input_dev *input;
 	char input_phys[64];
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

