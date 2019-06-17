Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C7549306
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfFQV0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbfFQV0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F23320673;
        Mon, 17 Jun 2019 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806801;
        bh=+FYusu5/eFXxLRd5OJh1iqwMUgWT71Qh9VJzk466pU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4ywauAdDOcnvqGdmMRbUirSobbrGcsYJhTES4PjYqrrHX2LrScHLsvCukn/WUQwG
         B8qyO0i+IVbJdesuNwhnvajsD0Pd/+TNYEKY8VHUyv2nXLWdhZ+srgFGJBDywnyCgl
         ZmVrjwD0G+EQax3QguwnRYcde3g9yy9uUfaH0N/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Zatta <marco@zatta.me>
Subject: [PATCH 4.19 61/75] USB: Fix chipmunk-like voice when using Logitech C270 for recording audio.
Date:   Mon, 17 Jun 2019 23:10:12 +0200
Message-Id: <20190617210755.313460703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Zatta <marco@zatta.me>

commit bd21f0222adab64974b7d1b4b8c7ce6b23e9ea4d upstream.

This patch fixes the chipmunk-like voice that manifets randomly when
using the integrated mic of the Logitech Webcam HD C270.

The issue was solved initially for this device by commit 2394d67e446b
("USB: add RESET_RESUME for webcams shown to be quirky") but it was then
reintroduced by e387ef5c47dd ("usb: Add USB_QUIRK_RESET_RESUME for all
Logitech UVC webcams"). This patch is to have the fix back.

Signed-off-by: Marco Zatta <marco@zatta.me>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -215,6 +215,9 @@ static const struct usb_device_id usb_qu
 	/* Cherry Stream G230 2.0 (G85-231) and 3.0 (G85-232) */
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech HD Webcam C270 */
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech HD Pro Webcams C920, C920-C, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0841), .driver_info = USB_QUIRK_DELAY_INIT },


