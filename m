Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F404C6B09E9
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCHNxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjCHNwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:52:53 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C389885358
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:52:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id i34so65993634eda.7
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 05:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678283570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bo/kKG9OXVdpa1sfTspshCJ+yOb3wQw+kpsskIelO0U=;
        b=EL19SmOVc53BTGrgdG5pcX6m15xMNyDJ5uH8RjTqkguNvLB6oBdn3ZAMKaSWG+lp/R
         /8w+5f9WPLw869yHnudRlCk1fZnn/D5K51L8HTqYj7NGGjtXtRCg0ExhEr9+khafla9v
         a9GxfIRrFBUjjXJH350qdqnMWEgub8vSxeQS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678283570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bo/kKG9OXVdpa1sfTspshCJ+yOb3wQw+kpsskIelO0U=;
        b=adE/qsw7lc8gsRjvqAGrz0zj0ymz2GbAakGeHXmg8BwVtXbYnO0o0FiVQumtx6F3JR
         xylVKxpoPRjvT3ua4rfU6DJTcGSAI0xkgSnK3TkN3Ge7ZzxB9LrxFXNvTiVWS7kvrt9Q
         +pQ1yhUssh1LwNwCBMm6MYfMNG7pAO0Tc051LPmKPfpCyksQahtLOO5nJluLkCK+D9RR
         IT/Xo+em9WATCYm/lRiK8Wua9Oq3iGArTeJhIy7kkXbJQec1yN9gqSCvotB508UjAut5
         kczrsOBl2EQzhDO0vP2g8D/VO9mx34al098VatJ7tmFUncUmDkHgNKtRmo9mrGgrQ7LB
         08ig==
X-Gm-Message-State: AO0yUKVnQ8mH0WArn7MiOpnZlgDkkiYgD+Ke1RP14FVhDTU3uEbvYwaF
        jnNlKAeU03BFlzG1Gki/ZJp0rzxNK3KQC2oKvi0=
X-Google-Smtp-Source: AK7set9QIaTyWrL3yaLiEtXr+sAp8CR2NIyLJMkekdbBnYtNVtN65MckNqyMRBeH7iuFwFbeSo3QRA==
X-Received: by 2002:a17:907:cf48:b0:8b1:bab0:aa3d with SMTP id uv8-20020a170907cf4800b008b1bab0aa3dmr18063770ejc.8.1678283569902;
        Wed, 08 Mar 2023 05:52:49 -0800 (PST)
Received: from alco.corp.google.com ([2620:0:1059:10:2926:70d3:ee98:eb12])
        by smtp.gmail.com with ESMTPSA id qw15-20020a170906fcaf00b008d57e796dcbsm7476927ejb.25.2023.03.08.05.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 05:52:49 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4.y 1/2] media: uvcvideo: Provide sync and async uvc_ctrl_status_event
Date:   Wed,  8 Mar 2023 14:52:46 +0100
Message-Id: <20230308135247.262826-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <167810021615514@kroah.com>
References: <167810021615514@kroah.com>
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
2.40.0.rc0.216.gc4246ad0f0-goog

