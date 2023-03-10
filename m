Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E6A6B3F27
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCJMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJMal (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:30:41 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99E410A295
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:30:39 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x3so19689134edb.10
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678451438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHGmi8GmdmV483OF0eXxM9rBGscXHhWoG+o+Ge6Savc=;
        b=Ud0I6gsxa7WPEHeVijxI2EgmZ9WF33iFrkAgnnk/pFPDtTP+ezM4Fgzq3e2LHqtRRc
         FHDJrR2ZwQAvWZYzVg2lV3juZf1DkldjvjGDIKYuufn8pIMbj55EjOWDlWPrPyTMv85X
         YZhgoI5qSz9z+NizOgKEVQQR5e4cMguoJ/RnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678451438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UHGmi8GmdmV483OF0eXxM9rBGscXHhWoG+o+Ge6Savc=;
        b=jqRgTiGwoTjcjIXBZotDesc6qUmHhMyNOOBZ70yS2gTChV3xhLwtx2KykGJhMm/nTb
         Ce2CYKNlnYIP8UThLNIrt6uPpyf6J01dxcrproH6Y8bd2GcUC++AqssMxFlQv0pKOXZu
         qhQNr2qUmrrAgD7jfRcSKaYylTPiRrRwEu1Pnr/9WNll/xDUj7Hrw1n7SeEblFB8PlCK
         Fxji/iDVbjRyXlE/mNmJXFr4W2beg9IC4N5dBjGiMtCX/eub7wTuL8b4O8IkcaDd9lKN
         V9AWRymrgXhEViPh2BGnn1MopJ/4JSqBM8w+s9hHE7FlG6v0KyYMIxCiw/MnusH/su9T
         W8eA==
X-Gm-Message-State: AO0yUKWMEqFCrT8mpeaHTwhEqLJ8mdCR4IaRO03tskzwoi3uJcLBbQ+/
        HhxVZQECOP64e6oxWrWhrC3wzdTXxknff/HDvjvEMQ==
X-Google-Smtp-Source: AK7set/M7nufQORTHYisR2joQ0hsdXpkTUGjRjsFCP1O96Ai6SgZY8WFDtUnvZMszhC3MiztKD1C1Q==
X-Received: by 2002:aa7:d747:0:b0:4c0:1f45:c194 with SMTP id a7-20020aa7d747000000b004c01f45c194mr21089849eds.12.1678451438144;
        Fri, 10 Mar 2023 04:30:38 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:e8d1:757a:19c3:a0cf])
        by smtp.gmail.com with ESMTPSA id v18-20020a50d092000000b004aef147add6sm778608edd.47.2023.03.10.04.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 04:30:37 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19.y 1/2] media: uvcvideo: Provide sync and async uvc_ctrl_status_event
Date:   Fri, 10 Mar 2023 13:30:34 +0100
Message-Id: <20230310123035.575074-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <167845046617959@kroah.com>
References: <167845046617959@kroah.com>
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
index cb6046481aed..c0650c49c9ab 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1280,17 +1280,12 @@ static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
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
 
@@ -1298,7 +1293,7 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 	ctrl->handle = NULL;
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
-		s32 value = __uvc_ctrl_get_value(mapping, w->data);
+		s32 value = __uvc_ctrl_get_value(mapping, data);
 
 		/*
 		 * handle may be NULL here if the device sends auto-update
@@ -1317,6 +1312,16 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
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
@@ -1326,8 +1331,8 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
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
index 883e4cab45e7..fd2a9b5a62e9 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -184,7 +184,8 @@ static bool uvc_event_control(struct urb *urb,
 
 	switch (status->bAttribute) {
 	case UVC_CTRL_VALUE_CHANGE:
-		return uvc_ctrl_status_event(urb, chain, ctrl, status->bValue);
+		return uvc_ctrl_status_event_async(urb, chain, ctrl,
+						   status->bValue);
 
 	case UVC_CTRL_INFO_CHANGE:
 	case UVC_CTRL_FAILURE_CHANGE:
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 839ba3cc5311..38951d7b646a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -768,7 +768,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
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

