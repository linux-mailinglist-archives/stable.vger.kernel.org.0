Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31C53CDA8B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbhGSOgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343626AbhGSOfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1FD861205;
        Mon, 19 Jul 2021 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707737;
        bh=DVPq4OqNADmDlH82yvOmY4bkIglJRdlwoSv7wwKiruE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWeT9mMKf0VMlzRYGnGrc66vldX9almUwVJ9Iqack+pAtz7rU77BsH25LYUpdMq2K
         mWDImhexrMQznrVO8qG+Oq6gHFTs/ZqYDfuxS5rn89jm0ZclQ2yT020/lkG5LlZkVf
         42hkwYsFq6sHsEKDAT34yKJebca3o5NH4oMDBSo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannu Hartikainen <hannu@hrtk.in>
Subject: [PATCH 4.14 006/315] USB: cdc-acm: blacklist Heimann USB Appset device
Date:   Mon, 19 Jul 2021 16:48:15 +0200
Message-Id: <20210719144943.079369881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
@@ -2014,6 +2014,11 @@ static const struct usb_device_id acm_id
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


