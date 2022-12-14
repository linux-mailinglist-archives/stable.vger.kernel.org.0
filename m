Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2469A64CE20
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 17:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbiLNQeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 11:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbiLNQdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 11:33:41 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836052A438
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:32:22 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s5so23262465edc.12
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MVrlltRx17nfXTGhP7yPJwRU3y4M8/9HTbuxEEs49iU=;
        b=aXv6T3ty9OZD4OYRcWL5+4mKME8v/e1WDdI9AA+KQJzPhv03AdE8drDDUqdiblA3yP
         s3/zhNBDtfTEYSkUNDB0AoiAz16cuPGibNxtKMzRSH9ilTXaJbDoVQ2FCuMzaGR2CKlx
         ERlbbfHgFDDGKgxdZXQ7Jy8oTG0/idZ4EWhqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MVrlltRx17nfXTGhP7yPJwRU3y4M8/9HTbuxEEs49iU=;
        b=ZgGnW5MSr98zS7seI8MKRRAItgSz6zE3sC9IKnQTvwWsMQnMrsgs5+wGCXW36W/fgf
         49Egxh7qPHHQncADTj5TqU2DLiqigZqyRWFN22nWNXT77ppxRrNfxB1O89BsVCS9bC/u
         3TH/oVvErt2ukMCd5Kt4l4ZzljsHk4pHk/G5jVV7WTfEDiiuPBF8EojZZpJkcYyP8VZ2
         TI9MiOP9yQb/ScZESxYlw2j3AVC0bys9+Kg9qptraUUTgBqRJB7MZbJWWN9BFzYL4ZYn
         QnG0rvKGf5njWSXOk/OWp7ia5EJXFtAlou7z0df9J2DSI9tqhnrIzREd29Ia6T8kCuxf
         2MUw==
X-Gm-Message-State: ANoB5pmuGdbMiXJFUpsmUopPULtZSy8V4HiAzobMke63zT32WsUJeQxr
        6pn6sYpYs+oFDPtwGW1UNS40Gde5bA+AHrsns8c=
X-Google-Smtp-Source: AA0mqf41+3D5Js+uQP1l7WfEZEbOf6NiTJkGvwte5sA62Fzt/SILgjAyev/3jho0mOvjeKhWFRtVfA==
X-Received: by 2002:aa7:cd46:0:b0:46d:e3f8:4ed4 with SMTP id v6-20020aa7cd46000000b0046de3f84ed4mr17653967edw.21.1671035541045;
        Wed, 14 Dec 2022 08:32:21 -0800 (PST)
Received: from alco.roam.corp.google.com ([100.104.168.209])
        by smtp.gmail.com with ESMTPSA id ee48-20020a056402293000b004615f7495e0sm6395908edb.8.2022.12.14.08.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:32:20 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 14 Dec 2022 17:31:55 +0100
Subject: [PATCH v4] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v4-0-38d7075b03f5@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        Yunke Cao <yunkec@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=4414; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=ogVdjybS9LEoywx0YwN/okaYfuH/y03AYQsWkydp3kQ=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjmfqNKqeDuIPruv3HRUGHzLrKhw0xXerfWXVR/oWJ
 Mh7m06eJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY5n6jQAKCRDRN9E+zzrEiGEBD/
 9paXuRWZxtIqzclORW4HCZGYi73FtH4rtSGo1FNlEq1R7vGpC1gQ796/GNRy0vTNoPO+QxaG6poI5J
 8vAFLwLc3YCxAUXzcN/QuRqSznplWWU+TiGxWm/I2x+dlNbE0tk30rBktBkJ0rYvQev/gODgWCgghN
 JKnkI1XV3lxO9nCa/7WllWLHsNpjcGE0reWbaPRdpmwgQxUZyQsn0v1UjsGkI2EPfhhCBA9pLym2ie
 qJguxwajBM0LmK/ds6p5rVXdEmdz1BoOTa91s5QN89Qfu2n9gPljroekcxObhSEAR7A+TH4JCenRYJ
 zfstu4W4xhtU5LdCrdBumpkkOmxjw4mDZR4yYtH/asavDzAMEM98ceXIkSRT4ipCkbcQCeDfcD3339
 e7BLYFB+fh7dO0R2dEZdw/i0vmr0gxk79TPbMbp/21RZutJPl/Ht2JMQfGOLfv/tojT7MT35xsEjqi
 ZTlGsBuRhEjLFLnjSEmAKs+AITV2Js6CV0xeCPwkwVkyyS/D4qhsv3NNxGuKjqvutOAcTKVaKNx7OD
 M75UhkjEUu9w2EF9WyCuIrjRO3YLkRQUrDrN9vqCGLuElX71HVPqqCTn9zxpYlYwQ2RnzYpt+fQe7k
 4LxOvbbN2nLIE8NqmuMp9hiq5+moqyLr+SNq2O3Nlg0YoGQiXc424GQnJdlA==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
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
---
uvc: Fix race condition on uvc

Make sure that all the async work is finished when we stop the status urb.

To: Yunke Cao <yunkec@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Max Staudt <mstaudt@google.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes in v4:
- Replace bool with atomic_t to avoid compiler reordering
- First complete the async work and then kill the urb to avoid race (Thanks Laurent!)
- Link to v3: https://lore.kernel.org/r/20221212-uvc-race-v3-0-954efc752c9a@chromium.org

Changes in v3:
- Remove the patch for dev->status, makes more sense in another series, and makes
  the zero day less nervous.
- Update reviewed-by (thanks Yunke!).
- Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org

Changes in v2:
- Add a patch for not kalloc dev->status
- Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
- Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
 drivers/media/usb/uvc/uvc_status.c | 6 ++++++
 drivers/media/usb/uvc/uvcvideo.h   | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c95a2229f4fa..1be6897a7d6d 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	if (atomic_read(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7518ffce22ed..4a95850cdc1b 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 	if (dev->int_urb == NULL)
 		return 0;
 
+	atomic_set(&dev->flush_status, 0);
 	return usb_submit_urb(dev->int_urb, flags);
 }
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	atomic_set(&dev->flush_status, 1);
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 	usb_kill_urb(dev->int_urb);
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index df93db259312..1274691f157f 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -560,6 +560,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	u8 *status;
+	atomic_t flush_status;
 	struct input_dev *input;
 	char input_phys[64];
 

---
base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
