Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463663CD77D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhGSOQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241687AbhGSOQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7095610F7;
        Mon, 19 Jul 2021 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706653;
        bh=RSsGb2qoBkZxvqofQNfypBfSr76e1GbuQ8P1AmvpwRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp1QxqtFG/AioSfd9l5Uek8RWmAN+qIRD4CkvS4yK38T67Q7uC0gdcTyQyxFz7F9P
         6V3GxmaNFJAIFBzQ+WKBbqcb5ZFE7kchr94UpFuzuIXWlOl30n4KDClwtgM0s4rFSX
         ngsfKDPPWzzgS4T9HN8+AiGesGquON8PDktx1QNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannu Hartikainen <hannu@hrtk.in>
Subject: [PATCH 4.4 006/188] USB: cdc-acm: blacklist Heimann USB Appset device
Date:   Mon, 19 Jul 2021 16:49:50 +0200
Message-Id: <20210719144914.546568254@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannu Hartikainen <hannu@hrtk.in>

commit 4897807753e078655a78de39ed76044d784f3e63 upstream.

The device (32a7:0000 Heimann Sensor GmbH USB appset demo) claims to be
a CDC-ACM device in its descriptors but in fact is not. If it is run
with echo disabled it returns garbled data, probably due to something
that happens in the TTY layer. And when run with echo enabled (the
default), it will mess up the calibration data of the sensor the first
time any data is sent to the device.

In short, I had a bad time after connecting the sensor and trying to get
it to work. I hope blacklisting it in the cdc-acm driver will save
someone else a bit of trouble.

Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210622141454.337948-1-hannu@hrtk.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1939,6 +1939,11 @@ static const struct usb_device_id acm_id
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* Exclude Heimann Sensor GmbH USB appset demo */
+	{ USB_DEVICE(0x32a7, 0x0000),
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },


