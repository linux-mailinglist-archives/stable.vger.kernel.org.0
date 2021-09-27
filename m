Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195F1419AF2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhI0ROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhI0RMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8650F6128C;
        Mon, 27 Sep 2021 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762541;
        bh=rULxsDEW11GuTvf5HgE3jNRIhroxB1TVyIjSsfkzDJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTullnkU2T4a/t7roJQ4ii9KpyOllNG355zi1NbahEgDN3gLkSLGsXEDSQWfBSwqC
         WJge/ZILIl6Ia0rr4ZMWjGZ9bFTu/VVHqopHLc7GAczp9tigcVMQp3kGX2WGzw0XtV
         TBTqISKkhw90pK3EHml1Ymh7JUQJAEKrBFLD6znA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlo Lobrano <c.lobrano@gmail.com>,
        Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 020/103] USB: serial: option: add Telit LN920 compositions
Date:   Mon, 27 Sep 2021 19:01:52 +0200
Message-Id: <20210927170226.416036337@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlo Lobrano <c.lobrano@gmail.com>

commit 7bb057134d609b9c038a00b6876cf0d37d0118ce upstream.

This patch adds the following Telit LN920 compositions:

0x1060: tty, adb, rmnet, tty, tty, tty, tty
0x1061: tty, adb, mbim, tty, tty, tty, tty
0x1062: rndis, tty, adb, tty, tty, tty, tty
0x1063: tty, adb, ecm, tty, tty, tty, tty

Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>
Link: https://lore.kernel.org/r/20210903123913.1086513-1-c.lobrano@gmail.com
Reviewed-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1205,6 +1205,14 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1060, 0xff),	/* Telit LN920 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1061, 0xff),	/* Telit LN920 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1062, 0xff),	/* Telit LN920 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1063, 0xff),	/* Telit LN920 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


