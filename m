Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034062595BD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgIAPzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731889AbgIAPpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA38206EB;
        Tue,  1 Sep 2020 15:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975138;
        bh=oohKm4wA5PeEduUAWRlKUhWqsHa0F45uQylFxb/AJN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtTISVl5Oht43lCjANU/S+7YES5etmBVk80OFfthHqvCuGk6q9yqNKXrJjhI5QMN9
         urXkZMNPkV7Rhf+WitAaWuuitncLTB6YITrKip8YRJmR575wGOntLJBy6xzvCvoApk
         LfRN7cxWtIZzlxCVKvp4ewajAy7sXKguTPbjWMMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jean-Christophe Barnoud <jcbarnoud@gmail.com>
Subject: [PATCH 5.8 225/255] USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D
Date:   Tue,  1 Sep 2020 17:11:21 +0200
Message-Id: <20200901151011.538574094@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 068834a2773b6a12805105cfadbb3d4229fc6e0a upstream.

The Sound Devices MixPre-D audio card suffers from the same defect
as the Sound Devices USBPre2: an endpoint shared between a normal
audio interface and a vendor-specific interface, in violation of the
USB spec.  Since the USB core now treats duplicated endpoints as bugs
and ignores them, the audio endpoint isn't available and the card
can't be used for audio capture.

Along the same lines as commit bdd1b147b802 ("USB: quirks: blacklist
duplicate ep on Sound Devices USBPre2"), this patch adds a quirks
entry saying to ignore ep5in for interface 1, leaving it available for
use with standard audio interface 2.

Reported-and-tested-by: Jean-Christophe Barnoud <jcbarnoud@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Fixes: 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
Link: https://lore.kernel.org/r/20200826194624.GA412633@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -370,6 +370,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
 			USB_QUIRK_ENDPOINT_BLACKLIST },
 
+	/* Sound Devices MixPre-D */
+	{ USB_DEVICE(0x0926, 0x0208), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Keytouch QWERTY Panel keyboard */
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
@@ -511,6 +515,7 @@ static const struct usb_device_id usb_am
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0208, 1), .driver_info = 0x85 },
 	{ }
 };
 


