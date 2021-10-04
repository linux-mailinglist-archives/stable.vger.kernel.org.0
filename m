Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E868420CC1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhJDNJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235014AbhJDNHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B1F6136F;
        Mon,  4 Oct 2021 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352504;
        bh=rULxsDEW11GuTvf5HgE3jNRIhroxB1TVyIjSsfkzDJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuyIoms+0QqcKFDJ5mtoTQNLJ9tgiBMUEiDMLrE5e8btlfATSb3AX3sf4jKA8qD/O
         KJjQbe9IXWI9O/6wBFNM0l82EyM4c4TFvwzYRewR9qMzqsKyfzgw9No0lEBvT9tEVy
         TvN3cG1zHAgWwHWoGpm0u2GSFBSJAoC38r0x0B68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlo Lobrano <c.lobrano@gmail.com>,
        Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 13/95] USB: serial: option: add Telit LN920 compositions
Date:   Mon,  4 Oct 2021 14:51:43 +0200
Message-Id: <20211004125033.996792623@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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


