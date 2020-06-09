Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84C71F4353
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgFIRwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731666AbgFIRwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95ED420734;
        Tue,  9 Jun 2020 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725134;
        bh=Faj6ySPN4NhaH1lHmRfYbHVD4GDrDtfBMnqzZGepr5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi5DYHYFPu6n3Ot0K3cYp1nx/tgt60Dv/LOpMfrxWp37EDVaWXdF++HHCEq/Or6Va
         O88go99Us3tGHd4YmkA/f4WNOfTY89zge0vBjmNtXuw/YBMGqfv7z9khnYvJEVG6UJ
         4HeYL+4wtmaUl48gpYiZVV9MDjAzqO2tKQE2DslY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 14/34] USB: serial: option: add Telit LE910C1-EUX compositions
Date:   Tue,  9 Jun 2020 19:45:10 +0200
Message-Id: <20200609174054.419238416@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 399ad9477c523f721f8e51d4f824bdf7267f120c upstream.

Add Telit LE910C1-EUX compositions:

	0x1031: tty, tty, tty, rmnet
	0x1033: tty, tty, tty, ecm

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20200525211106.27338-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1157,6 +1157,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UE910_V2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1031, 0xff),	/* Telit LE910C1-EUX */
+	 .driver_info = NCTRL(0) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1033, 0xff),	/* Telit LE910C1-EUX (ECM) */
+	 .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE922_USBCFG0),
 	  .driver_info = RSVD(0) | RSVD(1) | NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE922_USBCFG1),


