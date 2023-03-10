Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7B6B3F28
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCJMao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJMan (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:30:43 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C0D10A29A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:30:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ec29so19754383edb.6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678451440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ejo43FTvripXyxYAm4kyNirB2dacYjqpyE5TgkZGpcQ=;
        b=gdVN5yitzAo7s+pyBy1f75cMDIPKGULhH0NZn1vrB2K6z8HkU3fR/uTk4C/FzQpI+Z
         7ZjCFnEzmo8w3mF9y2gLorNBo2hi8uxg8DpjghBSvR711Tl5SNMukqFZDBFoW5/04Vzw
         MaRPYU5HgIWEkKLQNVv21U6RHhBirE+rHQDYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678451440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ejo43FTvripXyxYAm4kyNirB2dacYjqpyE5TgkZGpcQ=;
        b=JMxq3zKEFotPfYGwHdWmu53m+OWsjugETe0hztbSmDEfMlLKUDUfISc7w3kUr71Aj0
         XlIPaq1aTjMwjHIu2OTn6sVIZk9OuPy0xwXbx6rdnDYR2KUc9fFu1syRuwdS8FRQhwCh
         3iLOOENAOT+KoLpqWH3j6vRrfV/HfuAgSMf98DSgRQ1aItHA9lT8EjvLU74Op8IYNHX0
         s3x4s3GVKk+tpkSFUbG79l0b6RE3wdF1lANU4kG/tvR3no2pixZrC6g4ADsmenQusOfJ
         W+NTKrRdYJ3dR9Vg2uoYalnf4oxdbRehg03cXYUXjTDBRK0CAe4gk6lJME0QodVGHglS
         p5DA==
X-Gm-Message-State: AO0yUKWtR4Io9U2KDzeMHXdGs1X4vvR3cZ6UQ82ZqOI96AHxQa8kcI3D
        YB9QVwtkTBtnINJX6FRKdrreSQmwVzacK3+rdYE6og==
X-Google-Smtp-Source: AK7set/DCafBWZM3aNqrCkJoyQihuCHiOoColyDU8gCxFtfjVyGpHNDv6w0klmcuCTEZE44wnNSgPA==
X-Received: by 2002:aa7:c1c4:0:b0:4ac:bdf3:36ca with SMTP id d4-20020aa7c1c4000000b004acbdf336camr24029697edp.10.1678451440117;
        Fri, 10 Mar 2023 04:30:40 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:e8d1:757a:19c3:a0cf])
        by smtp.gmail.com with ESMTPSA id v18-20020a50d092000000b004aef147add6sm778608edd.47.2023.03.10.04.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 04:30:39 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 4.19.y 2/2] media: uvcvideo: Fix race condition with usb_kill_urb
Date:   Fri, 10 Mar 2023 13:30:35 +0100
Message-Id: <20230310123035.575074-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230310123035.575074-1-ribalda@chromium.org>
References: <167845046617959@kroah.com>
 <20230310123035.575074-1-ribalda@chromium.org>
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
index c0650c49c9ab..84b1339c2c6e 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -1323,6 +1324,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index fd2a9b5a62e9..141ac1ffb42e 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -315,5 +316,41 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
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
index 38951d7b646a..e8976fed80ca 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -604,6 +604,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	u8 *status;
+	bool flush_status;
 	struct input_dev *input;
 	char input_phys[64];
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

