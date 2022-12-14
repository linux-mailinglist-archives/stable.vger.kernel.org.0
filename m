Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC4D64C7CA
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 12:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbiLNLTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 06:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLNLTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 06:19:35 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A71DEAC
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 03:19:34 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r26so21997389edc.10
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 03:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lqYgjYCLtE2L72f2b146yyEU5fSX4l3ikwaqnULXRG0=;
        b=f0EYB+ywMq2SM6zO7j7oZ3uOvWkhNO4jlumBwyFoHjwuVUSsiJiXoa2TpbC17+nkYK
         uxzBotuSY+bHUWkswz6FAWFxsSXjyX8sh+taY7Uml8nFUQ55m9mDmgVVIYz1WMiIKxJL
         jPbtAId/bcj7ajzqmOGP3vyenyn7bwLudb84A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lqYgjYCLtE2L72f2b146yyEU5fSX4l3ikwaqnULXRG0=;
        b=3wm451AVAikGCdZGMGni/475DjP/73GKYuRBeBHSkbAP/P3OazaWoBRCAI2qKMwznD
         gM/MqvNKhqIIavSZen+Hl/RHn0uDAY7bwkmyBYr2C+A/xmrNlF9CZ+RbHdWCH7pxJJLR
         XDvPSyy7HeOm75zla0s0RzOkFr8bok6ujlMD3F5sEmTx0mIz/D/Fx5AaHxG6PdYlGjDR
         FwvpRq7lmu1k8+FUgh//XM/kbebtCL/cVTTrBbZUL13s771Pg7cpIzIetYKZfZ+w8kU2
         i1XEXfrp7lOtdLmVHvZlO2PasMQvlHcBJGXgXfX03FoI31TMcoXWmu26mb0EcNUtyvgm
         CcCQ==
X-Gm-Message-State: ANoB5pnBko6PSWbJ6ojMizFBhzc9sw6gzU8Vg33VbCCgEblMnOGQGMB+
        6kPya7aDPD0Wnvq9TLCY+D69bA==
X-Google-Smtp-Source: AA0mqf5ZsE4ye8IFy5V1nxAjAHZzcR5UfBV/Jg6PsG+u4ZnFKrdEodZe44omLfRObw6S9EdXIk/IlQ==
X-Received: by 2002:a05:6402:294f:b0:46c:e226:7717 with SMTP id ed15-20020a056402294f00b0046ce2267717mr22592544edb.31.1671016772906;
        Wed, 14 Dec 2022 03:19:32 -0800 (PST)
Received: from alco.roam.corp.google.com ([100.104.168.209])
        by smtp.gmail.com with ESMTPSA id s9-20020a508d09000000b00462e1d8e914sm6147842eds.68.2022.12.14.03.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 03:19:32 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 14 Dec 2022 12:18:52 +0100
Subject: [PATCH v3] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v3-0-954efc752c9a@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Max Staudt <mstaudt@google.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunke Cao <yunkec@chromium.org>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=4125; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=fAcZ3Rb/oLvmz2WVeJpX5Jp809XzJo8lwMwPsv9AhLw=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjmbE38/EjSW7pYSQWBBTtxFS+gGqtW8i6Pd+83n94
 5dsMscmJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY5mxNwAKCRDRN9E+zzrEiBzgD/
 91H1p8xDaegLuUzI3YejSZMVxB9xUPubBopI2ndm40hTN4UF3Z6F5uHCW0BokHZO59L6TcM8yOzGP9
 xnPSd6ufmc48vZ78quyJuyKsSwMHOKaALfD8N88pJ16zP+Tcy/AD8Vo82zUxsjGiDzL6aVbNflfhG0
 uGRd9k3w9qizGwKIvwcCtk6DgoO1oygIJGsRs4Mfg6QxeJ65kfsCA9mgpSl+2+sr3wnuUL1QnPbrNn
 BMSi81wxFc2sNoPX8xgbzpHbMR87R5/ydLqet+mFYEccvPIB67ubOHFrZPDnOUGngw4NCHKI+fVr9Y
 MNSjDt3ZHtuiWo8JWpSrYj4uBz5j+Jf5ChjJGdietXSTjGgXmI1G5Pi82C3EM4Y1U0QafnNvQsKi+Z
 L7iqDZmk2IfVwibvNEk7Lb8z8BDZoyiAzxBOaie1xpZ2+S3lUREoXL4DJMz+foGYrqk8R5H9rPOUZx
 py0u/3SEJOYdfxj/+fK6rvQPqtOgJMiApiOPDtODmi39hpokdJJdoDrS+DYQdF1du7HEl6bpbddPOs
 981YY8r3d9TIxjqhs97sLeyt9xw3J9HmiufcFhP6AnWVeEy5c7NhAIP0eduO41p2EtP26fjKp2KxzY
 QyzkJkEru0PaSHQAZ8/dYdp24ijeEyzngqVzyaewnzRjOymGgsi7Ru3JLDPA==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index c95a2229f4fa..5160facc8e20 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	if (dev->flush_status)
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7518ffce22ed..09a5802dc974 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 	if (dev->int_urb == NULL)
 		return 0;
 
+	dev->flush_status = false;
 	return usb_submit_urb(dev->int_urb, flags);
 }
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	dev->flush_status = true;
 	usb_kill_urb(dev->int_urb);
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index df93db259312..6a9b72d6789e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -560,6 +560,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	u8 *status;
+	bool flush_status;
 	struct input_dev *input;
 	char input_phys[64];
 

---
base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
