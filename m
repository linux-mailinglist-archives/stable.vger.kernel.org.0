Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B93284EB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhCAQpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhCAQih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A0564F7C;
        Mon,  1 Mar 2021 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616057;
        bh=GoDqIxV13FJPFHeWNzhi+nFxjbaOg6Jv1327hww/aWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nM8aTRAl5yzfq9VBHz49GB/gA3VjOxveHnyVmVHkFKDhM8pufrQYcsmhgf+gcT3m9
         5Q54c4hA0e0cl5kzeMsxelcV98oZoN5Dgv2U45cSOWeU226Jl3qTJA8T+Rlg8pcutD
         bNq5S5rpIXxtmrEivak2pqo3DedEDYBki8ffpvMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Ursella <stefan.ursella@wolfvision.net>
Subject: [PATCH 4.14 002/176] usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable
Date:   Mon,  1 Mar 2021 17:11:15 +0100
Message-Id: <20210301161021.064036688@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
 


