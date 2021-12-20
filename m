Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC56647ABFA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhLTOkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:40:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53158 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbhLTOjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E18BCE0B06;
        Mon, 20 Dec 2021 14:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51497C36AE8;
        Mon, 20 Dec 2021 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011170;
        bh=TVyHfNgLXoTH9rt7SuNYYBZWaRYghzUNUOE6/kOu4E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jS7WX5/esTfcLXPc8fYq2QjGDwNjF6YFw+3qLlWszGObbzUQXakaV9d7Uqpwjdc3v
         mc4MH+XPS15hm8sAuplOBCzLiR6hjzPq1rRtkcGwH4zAYDDSRJ2cGJYUxiUM9x5shM
         ZfLU+SlbNecTeBWGiaSLZ5tsz5vK8cbkT1YnqpRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 28/45] USB: serial: option: add Telit FN990 compositions
Date:   Mon, 20 Dec 2021 15:34:23 +0100
Message-Id: <20211220143023.215124062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 2b503c8598d1b232e7fc7526bce9326d92331541 upstream.

Add the following Telit FN990 compositions:

0x1070: tty, adb, rmnet, tty, tty, tty, tty
0x1071: tty, adb, mbim, tty, tty, tty, tty
0x1072: rndis, tty, adb, tty, tty, tty, tty
0x1073: tty, adb, ecm, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20211210100714.22587-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1222,6 +1222,14 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1063, 0xff),	/* Telit LN920 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1070, 0xff),	/* Telit FN990 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1071, 0xff),	/* Telit FN990 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1072, 0xff),	/* Telit FN990 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1073, 0xff),	/* Telit FN990 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


