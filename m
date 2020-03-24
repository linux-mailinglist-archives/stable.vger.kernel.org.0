Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356B1191009
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgCXNYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbgCXNYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E44D20775;
        Tue, 24 Mar 2020 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056289;
        bh=KDrRnao5wbbT0YX6rAPzXBEoGSRh0mPpQB+PYRr3Fio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLj8BC3ZKj87DbqH4IJm7YTAeZKm/fejeF3JmmJ/D03Oz3gxIBWPDYZR5SKeEsuFJ
         10roiVM2RDswbfILLf6gCSjshpw3/i+bLzVUcJqZ3QF5JRzon8msZF8BxigwduSlVv
         D9Bi5pW3T/9RIl/L8dVxV2qZvOud8PGBwt+zGqTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, russianneuromancer@ya.ru,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.5 043/119] usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters
Date:   Tue, 24 Mar 2020 14:10:28 +0100
Message-Id: <20200324130812.646665788@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 75d7676ead19b1fbb5e0ee934c9ccddcb666b68c upstream.

We have been receiving bug reports that ethernet connections over
RTL8153 based ethernet adapters stops working after a while with
errors like these showing up in dmesg when the ethernet stops working:

[12696.189484] r8152 6-1:1.0 enp10s0u1: Tx timeout
[12702.333456] r8152 6-1:1.0 enp10s0u1: Tx timeout
[12707.965422] r8152 6-1:1.0 enp10s0u1: Tx timeout

This has been reported on Dell WD15 docks, Belkin USB-C Express Dock 3.1
docks and with generic USB to ethernet dongles using the RTL8153
chipsets. Some users have tried adding usbcore.quirks=0bda:8153:k to
the kernel commandline and all users who have tried this report that
this fixes this.

Also note that we already have an existing NO_LPM quirk for the RTL8153
used in the Microsoft Surface Dock (where it uses a different usb-id).

This commit adds a NO_LPM quirk for the generic Realtek RTL8153
0bda:8153 usb-id, fixing the Tx timeout errors on these devices.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=198931
Cc: stable@vger.kernel.org
Cc: russianneuromancer@ya.ru
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200313120708.100339-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -381,6 +381,9 @@ static const struct usb_device_id usb_qu
 	/* Realtek hub in Dell WD19 (Type-C) */
 	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Generic RTL8153 based ethernet adapters */
+	{ USB_DEVICE(0x0bda, 0x8153), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


