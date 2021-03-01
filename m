Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77050328378
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbhCAQTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237736AbhCAQSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB0E64E56;
        Mon,  1 Mar 2021 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615411;
        bh=GoDqIxV13FJPFHeWNzhi+nFxjbaOg6Jv1327hww/aWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZNa+0lPRMpll3NnkoIu5R3to6lqJs4+pp3mC4FRu/yG1DlgNOLwHziyD/1B4NmrQ
         3ZkHHSEkXdVNp8k43K+d1+deZrXB1MFiI9+VRej2Z1yvSS6v9KbhtcXhkqQbZEAX5J
         3YbmcYPLrglrpGbtynas7IIpm+G62CvDh1LF3UiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Ursella <stefan.ursella@wolfvision.net>
Subject: [PATCH 4.4 02/93] usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable
Date:   Mon,  1 Mar 2021 17:12:14 +0100
Message-Id: <20210301161007.000886007@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Ursella <stefan.ursella@wolfvision.net>

commit 1ebe718bb48278105816ba03a0408ecc2d6cf47f upstream.

Without this quirk starting a video capture from the device often fails with

kernel: uvcvideo: Failed to set UVC probe control : -110 (exp. 34).

Signed-off-by: Stefan Ursella <stefan.ursella@wolfvision.net>
Link: https://lore.kernel.org/r/20210210140713.18711-1-stefan.ursella@wolfvision.net
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -230,6 +230,9 @@ static const struct usb_device_id usb_qu
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
+	/* ELMO L-12F document camera */
+	{ USB_DEVICE(0x09a1, 0x0028), .driver_info = USB_QUIRK_DELAY_CTRL_MSG },
+
 	/* Broadcom BCM92035DGROM BT dongle */
 	{ USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },
 


