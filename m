Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022EE1BC9A6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgD1Snm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbgD1Snj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCEF206D6;
        Tue, 28 Apr 2020 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099418;
        bh=VSG8TIJVnV3tp/hC2i4sLHIBytwhR5M21zfk4pix4to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eni5S/LPOtDdpKxDQUi5l9SGYKtlfkX6BGdJJKIjrG0rK+p9YVohW1Et9Oge0VOcH
         P0ew5IquXmdakGKVjesxzxwhLbThv+wWxh3fjtqbVv0VvmeBlVsYzdVn1ztK67vsGE
         bQjGvCN0l1kgwkd58LIO11NnI6AWe1f3TI9fyuxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Zeng Tao <prime.zeng@hisilicon.com>,
        William Bader <williambader@hotmail.com>
Subject: [PATCH 5.4 100/168] USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for high speed devices")
Date:   Tue, 28 Apr 2020 20:24:34 +0200
Message-Id: <20200428182245.005132678@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 3155f4f40811c5d7e3c686215051acf504e05565 upstream.

Commit bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for
high speed devices") changed the way the hub driver enumerates
high-speed devices.  Instead of using the "new" enumeration scheme
first and switching to the "old" scheme if that doesn't work, we start
with the "old" scheme.  In theory this is better because the "old"
scheme is slightly faster -- it involves resetting the device only
once instead of twice.

However, for a long time Windows used only the "new" scheme.  Zeng Tao
said that Windows 8 and later use the "old" scheme for high-speed
devices, but apparently there are some devices that don't like it.
William Bader reports that the Ricoh webcam built into his Sony Vaio
laptop not only doesn't enumerate under the "old" scheme, it gets hung
up so badly that it won't then enumerate under the "new" scheme!  Only
a cold reset will fix it.

Therefore we will revert the commit and go back to trying the "new"
scheme first for high-speed devices.

Reported-and-tested-by: William Bader <williambader@hotmail.com>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=207219
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for high speed devices")
CC: Zeng Tao <prime.zeng@hisilicon.com>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2004221611230.11262-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    3 +--
 drivers/usb/core/hub.c                          |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5005,8 +5005,7 @@
 
 	usbcore.old_scheme_first=
 			[USB] Start with the old device initialization
-			scheme,  applies only to low and full-speed devices
-			 (default 0 = off).
+			scheme (default 0 = off).
 
 	usbcore.usbfs_memory_mb=
 			[USB] Memory limit (in MB) for buffers allocated by
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2727,13 +2727,11 @@ static bool use_new_scheme(struct usb_de
 {
 	int old_scheme_first_port =
 		port_dev->quirks & USB_PORT_QUIRK_OLD_SCHEME;
-	int quick_enumeration = (udev->speed == USB_SPEED_HIGH);
 
 	if (udev->speed >= USB_SPEED_SUPER)
 		return false;
 
-	return USE_NEW_SCHEME(retry, old_scheme_first_port || old_scheme_first
-			      || quick_enumeration);
+	return USE_NEW_SCHEME(retry, old_scheme_first_port || old_scheme_first);
 }
 
 /* Is a USB 3.0 port in the Inactive or Compliance Mode state?


