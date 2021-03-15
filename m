Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18AD33B9FB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhCOOHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhCOOCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF3164F35;
        Mon, 15 Mar 2021 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816935;
        bh=+JcAoFLgLXKXXxLZloBbxdahgWcsoABDP2DuTfg0MSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C49nuNHO3W4xIRfc4OhkeTE0VKloIGxFbmEfi1spQESJg39RgMdcyH+3DTu9iJvIH
         bDi5a/qHO+c2rwOFQ3g4Zr7lB0wqbBSJ6reBYpHlk3hqqqHIAt6ZEqOg4pW5MQEE32
         Fr4S20v/Trq2yJzVQOx1AP+JxUZzUB7Ez1HwrVn0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yorick de Wid <ydewid@gmail.com>
Subject: [PATCH 5.10 197/290] Goodix Fingerprint device is not a modem
Date:   Mon, 15 Mar 2021 14:54:50 +0100
Message-Id: <20210315135548.569097771@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Yorick de Wid <ydewid@gmail.com>

commit 4d8654e81db7346f915eca9f1aff18f385cab621 upstream.

The CDC ACM driver is false matching the Goodix Fingerprint device
against the USB_CDC_ACM_PROTO_AT_V25TER.

The Goodix Fingerprint device is a biometrics sensor that should be
handled in user-space. libfprint has some support for Goodix
fingerprint sensors, although not for this particular one. It is
possible that the vendor allocates a PID per OEM (Lenovo, Dell etc).
If this happens to be the case then more devices from the same vendor
could potentially match the ACM modem module table.

Signed-off-by: Yorick de Wid <ydewid@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210213144901.53199-1-ydewid@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1929,6 +1929,11 @@ static const struct usb_device_id acm_id
 	.driver_info = SEND_ZERO_PACKET,
 	},
 
+	/* Exclude Goodix Fingerprint Reader */
+	{ USB_DEVICE(0x27c6, 0x5395),
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },


