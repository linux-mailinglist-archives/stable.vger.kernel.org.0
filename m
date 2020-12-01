Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5972C9A65
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbgLAI5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387785AbgLAI5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:57:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFFB12225A;
        Tue,  1 Dec 2020 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812980;
        bh=nMcV0TF/rDiiyT2nMQ2/33+20aLpple7nWMURFyN7HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzwjzw3uKm6khlKK6mTrzk5OqrMlaEOzr23kCJ+7oWFUXxhtB7hUBxyaIWgutQZpR
         ridvNypLf6SsAiGgLsCKWmaWtV6gaxzGoiaiJjx+8vqYZ6cYNUXyJoMi9Dup0WfWwB
         NE5vZW7/1ybP7JWlxSqDBZUHXDg6hGtqX70ewufU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Chalikiopoulos <bugzilla.kernel.org@mrtoasted.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 42/42] USB: core: Fix regression in Hercules audio card
Date:   Tue,  1 Dec 2020 09:53:40 +0100
Message-Id: <20201201084646.170521635@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 184eead057cc7e803558269babc1f2cfb9113ad1 upstream

Commit 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
aimed to make the USB stack more reliable by detecting and skipping
over endpoints that are duplicated between interfaces.  This caused a
regression for a Hercules audio card (reported as Bugzilla #208357),
which contains such non-compliant duplications.  Although the
duplications are harmless, skipping the valid endpoints prevented the
device from working.

This patch fixes the regression by adding ENDPOINT_IGNORE quirks for
the Hercules card, telling the kernel to ignore the invalid duplicate
endpoints and thereby allowing the valid endpoints to be used as
intended.

Fixes: 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
CC: <stable@vger.kernel.org>
Reported-by: Alexander Chalikiopoulos <bugzilla.kernel.org@mrtoasted.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201119170040.GA576844@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: use usb_endpoint_blacklist and USB_QUIRK_ENDPOINT_BLACKLIST]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -195,6 +195,10 @@ static const struct usb_device_id usb_qu
 	/* Guillemot Webcam Hercules Dualpix Exchange*/
 	{ USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Guillemot Hercules DJ Console audio card (BZ 208357) */
+	{ USB_DEVICE(0x06f8, 0xb000), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Midiman M-Audio Keystation 88es */
 	{ USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -351,6 +355,8 @@ static const struct usb_device_id usb_am
  * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x01 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x06f8, 0xb000, 5), .driver_info = 0x81 },
 	{ }
 };
 


