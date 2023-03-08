Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235686B0A24
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCHN4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjCHN4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:56:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257C97C94B
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:55:04 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ec29so35196258edb.6
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 05:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678283699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKYWzKXafiQG8he4OAJrxmaJR9hVnm3yMCcj6gd4Znw=;
        b=QP4aKoY78z4nuvSeJSM1Ista/KT7bvMzg2hI12iCFwC+PdKGKrvHglQnPKEmrPFEKL
         aMo7lK6JJtzoMYey2XrHfX55NgYaL8MSEpQyzkiCia+UVEPUXz5tpmMY/YAwtg4nRLbl
         iV6nvLvgv4xZ2uDThibbboV63KgK4hsyKIFNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678283699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKYWzKXafiQG8he4OAJrxmaJR9hVnm3yMCcj6gd4Znw=;
        b=JiYePkwjkPFXrrxgwjtOv587IZpLU6KRoSueEYfBb9BSHal5tVNG79gfmtsKdnjBnL
         uBAQvjqLTk/f9Om7HfsuCpHG7AsAioi1A8jlQ7/drbFRs3T16QMuG6AZlQgku/cQl/NO
         9OCg64g0/4AGK8cQJ7T+mI6IRM/nS1ZpfrPJcFa1Y7VQBefcH/y1mKusUqF48L21QHrP
         T7XefC3DwOUgLi/3R2sD9arWxBCqgxQssfNqjo9F3zyRnydHxGZB//9syw4y8e/KItBq
         Pactc3nsU3c2I3/oAzyv8iOAXnoTELHOJTrJdib+gHqhEVAWV699riObMbYb05/5oveo
         VTxw==
X-Gm-Message-State: AO0yUKVo1sF5R/JBkU7xFgYlOSNFemQjfj6m+nMzB+x6H3g1k08RCGHv
        vy6tZKY8h2vYWaTq3uS2xLXDyutV604eAijTLj8=
X-Google-Smtp-Source: AK7set+OWda3ZI5Y6XA8XGu8zR2ukGPTHYSYBL/OwoBW5pDBAt7FPkqsrY/VMAeTMjHBYRLXi0mU4w==
X-Received: by 2002:a17:907:3f10:b0:906:3799:cc7f with SMTP id hq16-20020a1709073f1000b009063799cc7fmr20569370ejc.39.1678283699453;
        Wed, 08 Mar 2023 05:54:59 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:2926:70d3:ee98:eb12])
        by smtp.gmail.com with ESMTPSA id x22-20020a170906b09600b008d9ddd2da88sm7503701ejy.6.2023.03.08.05.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 05:54:59 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19.y 1/2] media: uvcvideo: Provide sync and async uvc_ctrl_status_event
Date:   Wed,  8 Mar 2023 14:54:55 +0100
Message-Id: <20230308135456.269294-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <167810021760137@kroah.com>
References: <167810021760137@kroah.com>
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
2.40.0.rc0.216.gc4246ad0f0-goog

