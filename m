Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E1B64A892
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 21:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiLLUPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 15:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiLLUPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 15:15:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D941838D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:14:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e13so14718926edj.7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LNeKedXD0Kl6AcDMF/d3CoGNVEpAGSVGvZ8MSDW0DiU=;
        b=giTS0tGcE1dz9vIk9sSMU1qvD1UjXbWjbK1JjpLf4V28qjylRFTPrlXj+Fh1QBQJW6
         646OrtTae+Vpgo1nPBgsyh1yrPbJA4GGJLEBjrFvIKaly3JRasLm67+BA7AL7ui63C4q
         fHwm36XQy23gFkYw8WrkQFYB81UHk+Mxu5GC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNeKedXD0Kl6AcDMF/d3CoGNVEpAGSVGvZ8MSDW0DiU=;
        b=QqqQqEzLsJ0EAVRmH7pNOEG024yU+AZexNHRtPz/7hGP6cTH+pEy4kHYBaURi7+UL4
         G8DG2iSBZke3NoOmjI88AnQDcQ4UgNshFFs+fIPhmnHD9t2nW5f+fDqmdnFkVaH0aNiv
         LEI/Yg7htwQseLaQnHGFu7S/w5kacy2wZfS4t21HKIBid53gIKhor0GeiklKU9u0/9CR
         WXrmza/Ake4axEGhPAA6Vy7zrlNM6a6z4eRCQag148CPZcrxmH1WkZWz7WZBcJamlDi2
         Ln5q6Ffij/4uEHGox3ksiDgWWvpL6gB6lQ34kqbkvQrCoWgTBGLwPlPhlscZ3bWQEITL
         GX1A==
X-Gm-Message-State: ANoB5pnDealROhbz95oAK8INsR+Xh7W06m5m2tHUXcBit5t3ohmgdMTT
        9LuvPwNrp/4vmNK041ST137zQwYoJXRJiuyp
X-Google-Smtp-Source: AA0mqf6DqXWQXXTXEwffECnnWLyTvOYJyd6gS5iea1EaL3u4xHmIzWc8GFkBEYWgZBYQs9NWOxfdtA==
X-Received: by 2002:a05:6402:3788:b0:467:481f:df5e with SMTP id et8-20020a056402378800b00467481fdf5emr13491596edb.19.1670876078448;
        Mon, 12 Dec 2022 12:14:38 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id s12-20020a056402164c00b0046bada4b121sm4151700edx.54.2022.12.12.12.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 12:14:38 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 12 Dec 2022 21:14:33 +0100
Subject: [PATCH] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v1-0-c52e1783c31d@chromium.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=3645; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=nam6sSBCZM3trcTWBmQHsG2SGMJaYyZEqH23zO5Yu8A=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjl4usOILXDyyP76kClnGl6+kvNG6EiBW+UDUMubd8
 qwP+Xs+JAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY5eLrAAKCRDRN9E+zzrEiKwrD/
 47voqcNQ2Pn132A4dd8Ad6W1dxQaZLgEQlDGTxBm56m0AtapREvMg0LA5s9BFKEfHDO6a6BARyG/5M
 +h3+Anjc7uursLTurlnKkDpWlb8OoJ/6p0zB9+PPP6WY34KnsupUG8gyHpUteONVMVVMY1oaYE79oa
 I9Td/xbkztN102u3lImOY7J87ZFd1iNNJv84xdqByHLIkcx3xkz3SsKKGQIF7Wv3dq/VvG37mEHY9R
 vfUnplG2i2CKDRGP+jBuuYLCZUnnGtUcGhW7FfIj73oKHe8jKmIILyJYIbpht+eCf51/ak5mGkCoHg
 gRf9jLFC+0SnSfN1qe+tPsEutWFimIZ3cnp7z/OXMuXZGjUtCUor5Du5BizuVkXL6DX/Ok/0qV9SMF
 7+LWYKhG7I0trzNjwGzdxMK+IbHfv4UHDxnuMJSwcJ12cgi2IPzc6Iavzg7ffiDAj66p35bicdFU13
 a2jWZwr9t9wyUjvSkG9zCvYU4aKqyhNWoJ22qvcmfPRlYYHXkMq3fN2YdjY3cmJ7gh5ImWYZllDzZm
 bsbIemMwPPMgbR4cTCtB8ucmJd8X0ZxHGenRCfeeUndXiLEct8jPTAH2XKlDXb+sstdE7fla9Plu4l
 pFsIzYwgjqhwW/TDDjHbirzwfqT9aDFGoZQ98lZga6Tbmq/hLtW8vHpPqzEg==
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
control changes. If the code is executed in the following order:

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
there are no users on the system.

Also add a flag that is clear during stop, that will capture this
situation:

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
					uvc_status_start()
uvc_ctrl_status_event_work() -> FAIL

Hopefully, with the usb layer protection it should be enough to cover
all the cases.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 9 +++++++++
 drivers/media/usb/uvc/uvc_status.c | 1 +
 drivers/media/usb/uvc/uvcvideo.h   | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c95a2229f4fa..0634a4baa2e9 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1442,12 +1442,20 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	mutex_lock(&dev->lock);
+	if (!dev->users || !dev->resubmit_urb) {
+		mutex_unlock(&dev->lock);
+		return;
+	}
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
 	if (ret < 0)
 		dev_err(&dev->udev->dev,
 			"Failed to resubmit status URB (%d).\n", ret);
+	dev->resubmit_urb = false;
+	mutex_unlock(&dev->lock);
 }
 
 bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
@@ -1466,6 +1474,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	w->chain = chain;
 	w->ctrl = ctrl;
 
+	dev->resubmit_urb = true;
 	schedule_work(&w->work);
 
 	return true;
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7518ffce22ed..3cc6e1dfaf01 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -310,4 +310,5 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 void uvc_status_stop(struct uvc_device *dev)
 {
 	usb_kill_urb(dev->int_urb);
+	dev->resubmit_urb = false;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index df93db259312..9e6a52008ce5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -539,6 +539,8 @@ struct uvc_device {
 
 	struct mutex lock;		/* Protects users */
 	unsigned int users;
+	bool resubmit_urb;
+
 	atomic_t nmappings;
 
 	/* Video control interface */

---
base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
