Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5AE29DB86
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbgJ2ABu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 20:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389394AbgJ2AAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 20:00:36 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA93C0613D1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 17:00:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g20so649502plj.10
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 17:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=4L3GRWcn1QXFFa7JJprgoYtKbufpSEL9YuPHfYyVTUE=;
        b=fgTak46/XDe/JwHcVO18/NYT0dteStHKYQP9BRq3ZzCJ7ApTBFYoDurQ3JszGjDaKf
         apagSRIzzctjGO28kvNrBig9qnSUBjNtxTVBRl3wsdhVW/pb2ASL2BoXRm95CMSRB8p1
         OQMy7KpkEQ8BDy3prXx9u/kLqqJtW2XSks2RVioPyQkJ9u6ZyvWapQ5YeJKma3mZUyL+
         5xxikOd7Ycqv631fHvtED9/FxxJXI9mZ43KLFD69TGiMUHiI82QTuoSV8zLPf5adx0ag
         1NMj+ilRiD+PYB4EAEOknBRJrOTFB6wRNZGz62kCFvPP6rzXKxUOX/4zpsq98RbFqdot
         tD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=4L3GRWcn1QXFFa7JJprgoYtKbufpSEL9YuPHfYyVTUE=;
        b=ImUEE2ocA5rfZEb8e6gJP8akoTDTv7ilkOM1pC8hXZTC6DoFLBDZbPB9ehkXj3laug
         VKYHEar5hKs/Mbg3RjlW5Bm3B7+laaDohnf76u+yWYZUXXEvBFcVCZBbekfQ7w9pflMx
         /fTTkA6SK656WfusVhqSC3sNnb7dcqBmhdSDq+sPjC6DvEJwbMTxXJiVttSPgUOzxJaz
         XMGANS7z1p2khFZeLfr7iosP2VF5eJ6h5F3im1PeICi9WzgqG4hiFgonkwt5mm75zjOn
         zUUH3iEneB8YsHPk7uFNu4XfLkSuSQfmM6nXoxyoJhI46MH5QmMcs3yrZtxcRdH2pYYC
         tz0Q==
X-Gm-Message-State: AOAM5311zANGx8Ihv88NEFnCv6iYE4MGsvzWR4GKQabPbnhayDL46NNA
        jZ8PJ0ee6/lFfBV2Z9nrtEUTez1Y
X-Google-Smtp-Source: ABdhPJyFk1BhOreo+PWHCKfWnG23jY/CegC6TowPKu2mal35Ml2jpNAEYWtIuRInpVAmMxVT6IWEWwWy
Sender: "lzye via sendgmr" <lzye@chrisye.mtv.corp.google.com>
X-Received: from chrisye.mtv.corp.google.com ([2620:15c:211:2:f693:9fff:fef4:4323])
 (user=lzye job=sendgmr) by 2002:a62:8847:0:b029:15b:51c6:6a10 with SMTP id
 l68-20020a6288470000b029015b51c66a10mr1337309pfd.69.1603929635475; Wed, 28
 Oct 2020 17:00:35 -0700 (PDT)
Date:   Wed, 28 Oct 2020 17:00:32 -0700
Message-Id: <20201029000032.668418-1-lzye@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
From:   Chris Ye <lzye@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, trivial@kernel.org,
        stable@vger.kernel.org, linzhao.ye@gmail.com,
        Chris Ye <lzye@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices
need to be set explicitly with this flag.

Signed-off-by: Chris Ye <lzye@google.com>

diff -uprN -X linux-vanilla/Documentation/dontdiff linux-vanilla/drivers/hid/hid-ids.h linux/drivers/hid/hid-ids.h
--- linux-vanilla/drivers/hid/hid-ids.h	2020-10-26 22:16:49.930361683 -0700
+++ linux/drivers/hid/hid-ids.h	2020-10-26 22:20:02.811994573 -0700
@@ -443,6 +443,10 @@
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
+#define USB_VENDOR_ID_GAMEVICE	0x27F8
+#define USB_DEVICE_ID_GAMEVICE_GV186	0x0BBE
+#define USB_DEVICE_ID_GAMEVICE_KISHI	0x0BBF
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
diff -uprN -X linux-vanilla/Documentation/dontdiff linux-vanilla/drivers/hid/hid-quirks.c linux/drivers/hid/hid-quirks.c
--- linux-vanilla/drivers/hid/hid-quirks.c	2020-10-26 22:16:49.930361683 -0700
+++ linux/drivers/hid/hid-quirks.c	2020-10-28 16:14:14.498337383 -0700
@@ -84,6 +84,10 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_GV186),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_KISHI),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
