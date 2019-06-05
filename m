Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66E359EE
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfFEJxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbfFEJxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 05:53:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAFD0206B8;
        Wed,  5 Jun 2019 09:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559728429;
        bh=TJlSNgmfD89h3xa59ij5PQMEczQQEoQHFTDvX5TZjQ8=;
        h=Subject:To:From:Date:From;
        b=aRYHFoXVAhlTM0FhUyuqS5h4ko/hv0Kj2WUgHRsP8ziz56IZZYKQkFZHHCoB45BOS
         VACuRkx/SJxInAadx5h0J1UZHUqoIMTo/CgvG5/L1N1U9OdJiQ8vOBuE6Wo0beABNS
         caCvsgl1MzDZQoQeB264dpjCJvBc5lt+QPfCf2bw=
Subject: patch "USB: Fix chipmunk-like voice when using Logitech C270 for recording" added to usb-linus
To:     marco@zatta.me, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 05 Jun 2019 11:53:38 +0200
Message-ID: <155972841881147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix chipmunk-like voice when using Logitech C270 for recording

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bd21f0222adab64974b7d1b4b8c7ce6b23e9ea4d Mon Sep 17 00:00:00 2001
From: Marco Zatta <marco@zatta.me>
Date: Sat, 1 Jun 2019 09:52:57 +0200
Subject: USB: Fix chipmunk-like voice when using Logitech C270 for recording
 audio.

This patch fixes the chipmunk-like voice that manifets randomly when
using the integrated mic of the Logitech Webcam HD C270.

The issue was solved initially for this device by commit 2394d67e446b
("USB: add RESET_RESUME for webcams shown to be quirky") but it was then
reintroduced by e387ef5c47dd ("usb: Add USB_QUIRK_RESET_RESUME for all
Logitech UVC webcams"). This patch is to have the fix back.

Signed-off-by: Marco Zatta <marco@zatta.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 6082b008969b..6b6413073584 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -215,6 +215,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Cherry Stream G230 2.0 (G85-231) and 3.0 (G85-232) */
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Webcam C270 */
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech HD Pro Webcams C920, C920-C, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0841), .driver_info = USB_QUIRK_DELAY_INIT },
-- 
2.21.0


