Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB703C50AD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345412AbhGLHeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346256AbhGLHal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99EE060C40;
        Mon, 12 Jul 2021 07:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074873;
        bh=qh0vOdLul9FAfrplMJRzwxuUPBT1buMnmY0f8B/DaRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYcXmgMtcLL3xJ/0C/0naP5a7RwWUBmfOHd/cA/EAXr5bMgYv119R713NA/RLSL61
         Bnt+NFyf0U8vxXYwVuJUq1uJUiORvTbDJdr9QXclleINeB+4EBwfI5n9dohV6I9viU
         r8vntdTCBd1tDPafurs+VNavq5yg6UE4LGFyShhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannu Hartikainen <hannu@hrtk.in>
Subject: [PATCH 5.13 025/800] USB: cdc-acm: blacklist Heimann USB Appset device
Date:   Mon, 12 Jul 2021 08:00:48 +0200
Message-Id: <20210712060916.660383352@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -1959,6 +1959,11 @@ static const struct usb_device_id acm_id
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


