Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0611864B77E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiLMOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiLMOgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:36:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CB720354
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:36:05 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so36973826ejc.4
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LoBGLUjEyhQfXWIWPOu9C92qTSNRy93bFCVJA1Gy7YQ=;
        b=A9+F+Qfs1V94/OeuF0azEIfhIkJi+LCS+d3Cs11+Nwe+721/Z9kPMq2qwYD6CWLhp7
         xjy4l9MDJSxb5AwXA6oXMgl0/A8whNjolgrz2x9VQtDgLXTsT8oDiDcUz6Ca9mq1MNb4
         P12dtwtMiMZQBdZz0Ow2u4D0VNu0bWqYtRQcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LoBGLUjEyhQfXWIWPOu9C92qTSNRy93bFCVJA1Gy7YQ=;
        b=HnGnnLxaCthJxSo0oYg8SKIB4gwltVFf6mgVeOlSCZj5wBbX7LM42/zYwwkbVCZHET
         YuFiBt8KM5v6RZjfwXU3IYY5BYPsHsXkndSq6gvhZ3fBbB5fr5ov/zdvIoOiyEJiEvf2
         mMS3TLt6fNEH3tQvOIffqBmw1Ylfz4APET2n0Csit+oEkkG9EW+7+LcS+txIr2y+6fek
         IJlcA3Q2YlsXCRLn1AK+4hSraAqmyKXttsTb6jugsnOrr5YMTgggaFNuJYW5duEd4lZ3
         STvoZv875YoN21NwJ+b+kEMFWrs/4mqrokcUmD7lLTKz4WJSztdmBrqrLkWNXgTqgaDX
         2o3w==
X-Gm-Message-State: ANoB5pkk+0zHOTcLk5XfW2tOB8fJnTKGH/jRGZGQywb8kNzxro7wmQTk
        qIF4a9ns2MGAEJgOklwyOQW1WA==
X-Google-Smtp-Source: AA0mqf6RdH1mZDqyzcy4filvbzKOY19S4yxBwVauYac4/dNFu+WtMWhDlHsBJg4Rb277UyI22owjEA==
X-Received: by 2002:a17:906:a410:b0:7c0:e5ca:411c with SMTP id l16-20020a170906a41000b007c0e5ca411cmr15851856ejz.17.1670942163897;
        Tue, 13 Dec 2022 06:36:03 -0800 (PST)
Received: from alco.roam.corp.google.com ([100.104.168.209])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b00781dbdb292asm4613960ejc.155.2022.12.13.06.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 06:36:03 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Tue, 13 Dec 2022 15:35:31 +0100
Subject: [PATCH v2 2/2] media: uvcvideo: Do not alloc dev->status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v2-2-54496cc3b8ab@chromium.org>
References: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org>
In-Reply-To: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org>
To:     Max Staudt <mstaudt@google.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=1689; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=jEDQuOW3z7ZGcsKin4RTBJvSelqdlHZ1geiYjpdBLTo=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjmI3O4ptcgGHWc6J12tWDekLKnqXOo3j3z7Rmykia
 fM6ORvGJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY5iNzgAKCRDRN9E+zzrEiFvcEA
 CRu/tDiApvFvJAFb1Ou/ogsX4eEXmPAA4FtTn3zf36wW/CYBD3IefrmVoFpPkS1vS50bXAbNZO4gEG
 YBw2ZUKrDBFcwgKx01rQD9CDjIZBWR+yyP7SnKw8TMMcIsvK6nkgUdwotVDWvJC/gBWr3qCdrwo38l
 LtHT+kfE1PBU027stWfi3t0SzBk620H27apN5mmbcrXN5SKx/g61r/9dwZGRWGJqAAFtJi5ETOmwfD
 xKePSptFpzgeVQxpGskAZYlD+KyoYzzlcOQMQ+CiCVRckf1GD+iZdpo2wuWSE3E0W/nTsq3Sl0Sj5t
 c7Ny3sOMd1vkTfGhxl7ftL5y85B14Ilp17tqbpD5s9SqCRcNCyu6Al5Zn2+AKpuXtiZFu5KkLjBCVJ
 e95B6qrk35kQyrEb73wS9iChL/KNYgrdoVyITF+j5OHxruVFeYa2Wi4H2evV245EDo07y/qL7O3++1
 OpC3WHZ0mYJk/rFS8eWfUTMqiBzfha7iTCx3u7r5AZXr/DZ8ngyDkBehsMNY4w51rZ7e05kVp87cKJ
 EJvUimG4v+ZCaFVF2RrNCsDZtoFbDPD8Q+OnK4TYyDtmipeGdtF0hmUXi6a5xDLxvXaCRDG0/fN/8Q
 mwxYI/uW9XzF1H5HGCc4EhYdkQf6FgPzX6vtW5Jc7cUCY/QH98gAAektEAFA==
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

UVC_MAX_STATUS_SIZE is 16, simplify the code by inlining dev->status.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/usb/uvc/uvc_status.c | 9 +--------
 drivers/media/usb/uvc/uvcvideo.h   | 2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 09a5802dc974..52999b3b7c48 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -259,15 +259,9 @@ int uvc_status_init(struct uvc_device *dev)
 
 	uvc_input_init(dev);
 
-	dev->status = kzalloc(UVC_MAX_STATUS_SIZE, GFP_KERNEL);
-	if (dev->status == NULL)
-		return -ENOMEM;
-
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (dev->int_urb == NULL) {
-		kfree(dev->status);
+	if (!dev->int_urb)
 		return -ENOMEM;
-	}
 
 	pipe = usb_rcvintpipe(dev->udev, ep->desc.bEndpointAddress);
 
@@ -296,7 +290,6 @@ void uvc_status_unregister(struct uvc_device *dev)
 void uvc_status_cleanup(struct uvc_device *dev)
 {
 	usb_free_urb(dev->int_urb);
-	kfree(dev->status);
 }
 
 int uvc_status_start(struct uvc_device *dev, gfp_t flags)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 6a9b72d6789e..ccc7e3b60bf1 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -559,7 +559,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
-	u8 *status;
+	u8 status[UVC_MAX_STATUS_SIZE];
 	bool flush_status;
 	struct input_dev *input;
 	char input_phys[64];

-- 
2.39.0.rc1.256.g54fd8350bd-goog-b4-0.11.0-dev-696ae
