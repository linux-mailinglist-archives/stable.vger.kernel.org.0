Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426A66B3F22
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCJM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjCJM1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:27:49 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4149377E00
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:27:48 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id da10so19798806edb.3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678451266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEnPF3txL82EcXZLXGfSlTcE0aF2c4Vm5zQB5mBotqs=;
        b=VRCkNY+n1U6V2/GmVw9slRwxSvM9Q87Nu4t/Scq7EVlQ/iyiRBajbumKbiPmYkH87m
         6Rg0cxC0T7pQURZWbiywbbaXXsupz+c2ghY/P7k2wokzO14cau6Xle+/5xDpGIokuSd9
         k4iN+lwWz810FOQ41zj7njHEQoFXLnf4T2npI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678451266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEnPF3txL82EcXZLXGfSlTcE0aF2c4Vm5zQB5mBotqs=;
        b=FtWBX2EfXUdA9yqQYqbwFTY1g34hQqtYrvALU7eUbMbUoABLleZa3+J6azHHriOD6k
         yGgafiNcr10PMbuVOoIERAMCH7zR7nTEXm1lNXK4MNBlAUN6p8tBOPQEXSwAsuwKoxaA
         QiiB9Wx50M7m9tg3uCuplH698XWRL4x1gtJAACfu8JPyRrNUSk16iJ5H57W8BcGyvN3x
         D2rTaX6HEd1T9EkcF7m+HYN/uPZIOAqn1x0/kxeIA5rKfgedbpKlb/reH7X5SlqkmIn0
         eI7MgZw8pWxKWdtcNC+rxtuTkW269zN1PFnGiKyDzzkY41E9PtkzlmdNi4EiFX1Tt/Bn
         Ad6Q==
X-Gm-Message-State: AO0yUKUY/fyzfsExFn1JUWGB8+FJ9I4ghs5TUBqkA+MF/OUwYOZC16Qe
        PRkeik7/9aU8FqZD3vURjTnHrpHDczcvpNcAOPniRQ==
X-Google-Smtp-Source: AK7set+EHO1ag7G1+89LZbh8J09F7N2Q+TlmgwKUzGI9RekK+UHzSyjFHc2YtUtywma7SA9es2qiiQ==
X-Received: by 2002:a17:906:4f94:b0:8f7:3488:fd78 with SMTP id o20-20020a1709064f9400b008f73488fd78mr25800094eju.0.1678451266559;
        Fri, 10 Mar 2023 04:27:46 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:e8d1:757a:19c3:a0cf])
        by smtp.gmail.com with ESMTPSA id q10-20020a170906678a00b008d09b900614sm893980ejp.80.2023.03.10.04.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 04:27:46 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4.y 1/2] media: uvcvideo: Provide sync and async uvc_ctrl_status_event
Date:   Fri, 10 Mar 2023 13:27:38 +0100
Message-Id: <20230310122739.566442-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <167845046715250@kroah.com>
References: <167845046715250@kroah.com>
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

Split the functionality of void uvc_ctrl_status_event_work in two, so it
can be called by functions outside interrupt context and not part of an
URB.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
(cherry picked from commit d9c8763e61295be0a21dc04ad9c379d5d17c3d86)
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 25 +++++++++++++++----------
 drivers/media/usb/uvc/uvc_status.c |  3 ++-
 drivers/media/usb/uvc/uvcvideo.h   |  4 +++-
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 36abe47997b0..b6cadae3c187 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1275,17 +1275,12 @@ static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
 	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
 }
 
-static void uvc_ctrl_status_event_work(struct work_struct *work)
+void uvc_ctrl_status_event(struct uvc_video_chain *chain,
+			   struct uvc_control *ctrl, const u8 *data)
 {
-	struct uvc_device *dev = container_of(work, struct uvc_device,
-					      async_ctrl.work);
-	struct uvc_ctrl_work *w = &dev->async_ctrl;
-	struct uvc_video_chain *chain = w->chain;
 	struct uvc_control_mapping *mapping;
-	struct uvc_control *ctrl = w->ctrl;
 	struct uvc_fh *handle;
 	unsigned int i;
-	int ret;
 
 	mutex_lock(&chain->ctrl_mutex);
 
@@ -1293,7 +1288,7 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 	ctrl->handle = NULL;
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
-		s32 value = __uvc_ctrl_get_value(mapping, w->data);
+		s32 value = __uvc_ctrl_get_value(mapping, data);
 
 		/*
 		 * handle may be NULL here if the device sends auto-update
@@ -1312,6 +1307,16 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 	}
 
 	mutex_unlock(&chain->ctrl_mutex);
+}
+
+static void uvc_ctrl_status_event_work(struct work_struct *work)
+{
+	struct uvc_device *dev = container_of(work, struct uvc_device,
+					      async_ctrl.work);
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+	int ret;
+
+	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
@@ -1321,8 +1326,8 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 			   ret);
 }
 
-bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
-			   struct uvc_control *ctrl, const u8 *data)
+bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
+				 struct uvc_control *ctrl, const u8 *data)
 {
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 2bdb0ff203f8..3e26d82a906d 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -179,7 +179,8 @@ static bool uvc_event_control(struct urb *urb,
 
 	switch (status->bAttribute) {
 	case UVC_CTRL_VALUE_CHANGE:
-		return uvc_ctrl_status_event(urb, chain, ctrl, status->bValue);
+		return uvc_ctrl_status_event_async(urb, chain, ctrl,
+						   status->bValue);
 
 	case UVC_CTRL_INFO_CHANGE:
 	case UVC_CTRL_FAILURE_CHANGE:
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 5f137400bebd..fce41609e27a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -832,7 +832,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 int uvc_ctrl_init_device(struct uvc_device *dev);
 void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 int uvc_ctrl_restore_values(struct uvc_device *dev);
-bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
+bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
+				 struct uvc_control *ctrl, const u8 *data);
+void uvc_ctrl_status_event(struct uvc_video_chain *chain,
 			   struct uvc_control *ctrl, const u8 *data);
 
 int uvc_ctrl_begin(struct uvc_video_chain *chain);
-- 
2.40.0.rc1.284.g88254d51c5-goog

