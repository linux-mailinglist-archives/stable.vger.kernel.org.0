Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A17370BFE
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEBOFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232454AbhEBOEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEEEC613B0;
        Sun,  2 May 2021 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964240;
        bh=jJhsYv8EYiSDb/i1+WUcS9e0SCstEdckTV24t98NXkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKAHU2G7VPbaKdQCfCWnHo2sF/VhA2Zer+ZGKmprOCaXlmK5YAfwORVFl7DhPCDZG
         GWJ7vYtE0vBRJgSbH+FsZ9Y3SqA6zhotHedb5kpNZLNsRh1VvYMMJ5q09LaH2/qETk
         ulTldIdXZ+ZiSkzVCBV1OrISTTnMhSwqx7Gzo7OwmFofryXc/OyxKCW/LZS290Gqg9
         MD1+f73M+xxlZEDSrxrnjDKvE67mDEIqHjHEVaa95bw+LzjjmWIIo0KfCcubcblH7Y
         qHX/rC594nNJ8DqkbwhWI3rGGnXrvlC+ho6XiLHXZF3e//EdC297nybv4NAfPYSGRs
         jYSRgm6s5YBgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pawel Laszczak <pawell@cadence.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Chen <peter.chen@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 10/70] usb: webcam: Invalid size of Processing Unit Descriptor
Date:   Sun,  2 May 2021 10:02:44 -0400
Message-Id: <20210502140344.2719040-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140344.2719040-1-sashal@kernel.org>
References: <20210502140344.2719040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 6a154ec9ef6762c774cd2b50215c7a8f0f08a862 ]

According with USB Device Class Definition for Video Device the
Processing Unit Descriptor bLength should be 12 (10 + bmControlSize),
but it has 11.

Invalid length caused that Processing Unit Descriptor Test Video form
CV tool failed. To fix this issue patch adds bmVideoStandards into
uvc_processing_unit_descriptor structure.

The bmVideoStandards field was added in UVC 1.1 and it wasn't part of
UVC 1.0a.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20210315071748.29706-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uvc.c | 1 +
 drivers/usb/gadget/legacy/webcam.c  | 1 +
 include/uapi/linux/usb/video.h      | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index ed77a126a74f..f48a00e49794 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -822,6 +822,7 @@ static struct usb_function_instance *uvc_alloc_inst(void)
 	pd->bmControls[0]		= 1;
 	pd->bmControls[1]		= 0;
 	pd->iProcessing			= 0;
+	pd->bmVideoStandards		= 0;
 
 	od = &opts->uvc_output_terminal;
 	od->bLength			= UVC_DT_OUTPUT_TERMINAL_SIZE;
diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
index a9f8eb8e1c76..2c9eab2b863d 100644
--- a/drivers/usb/gadget/legacy/webcam.c
+++ b/drivers/usb/gadget/legacy/webcam.c
@@ -125,6 +125,7 @@ static const struct uvc_processing_unit_descriptor uvc_processing = {
 	.bmControls[0]		= 1,
 	.bmControls[1]		= 0,
 	.iProcessing		= 0,
+	.bmVideoStandards	= 0,
 };
 
 static const struct uvc_output_terminal_descriptor uvc_output_terminal = {
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index d854cb19c42c..bfdae12cdacf 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -302,9 +302,10 @@ struct uvc_processing_unit_descriptor {
 	__u8   bControlSize;
 	__u8   bmControls[2];
 	__u8   iProcessing;
+	__u8   bmVideoStandards;
 } __attribute__((__packed__));
 
-#define UVC_DT_PROCESSING_UNIT_SIZE(n)			(9+(n))
+#define UVC_DT_PROCESSING_UNIT_SIZE(n)			(10+(n))
 
 /* 3.7.2.6. Extension Unit Descriptor */
 struct uvc_extension_unit_descriptor {
-- 
2.30.2

