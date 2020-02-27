Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C5D171E68
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbgB0O1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387557AbgB0OIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:08:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4316021D7E;
        Thu, 27 Feb 2020 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812523;
        bh=IAbXsdKThfWp5kflFnf+H5CpkjsYJ220+iv2NJURT2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/466QPAey9PRYYFGeB/APO/njvw9wMjGM8ylAmhvcJlkFaDxVJa6gOtPF6AjRDKL
         rFPDNgjTnuFPBQ1x1JH4BZg+V1pADmeD+Zkhc7p0bp+7bkrMJpFk5ImessUJLNsrhI
         RCv1+J97QLKcqqyOoHWf2LMDyctvXyYl3lNc9reY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rene D Obermueller <cmdrrdo@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 023/135] xhci: Force Maximum Packet size for Full-speed bulk devices to valid range.
Date:   Thu, 27 Feb 2020 14:36:03 +0100
Message-Id: <20200227132232.702723589@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f148b9f402ef002b57bcff3964d45abc8ffb6c3f upstream.

A Full-speed bulk USB audio device (DJ-Tech CTRL) with a invalid Maximum
Packet Size of 4 causes a xHC "Parameter Error" at enumeration.

This is because valid Maximum packet sizes for Full-speed bulk endpoints
are 8, 16, 32 and 64 bytes. Hosts are not required to support other values
than these. See usb 2 specs section 5.8.3 for details.

The device starts working after forcing the maximum packet size to 8.
This is most likely the case with other devices as well, so force the
maximum packet size to a valid range.

Cc: stable@vger.kernel.org
Reported-by: Rene D Obermueller <cmdrrdo@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200210134553.9144-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1475,9 +1475,15 @@ int xhci_endpoint_init(struct xhci_hcd *
 	/* Allow 3 retries for everything but isoc, set CErr = 3 */
 	if (!usb_endpoint_xfer_isoc(&ep->desc))
 		err_count = 3;
-	/* Some devices get this wrong */
-	if (usb_endpoint_xfer_bulk(&ep->desc) && udev->speed == USB_SPEED_HIGH)
-		max_packet = 512;
+	/* HS bulk max packet should be 512, FS bulk supports 8, 16, 32 or 64 */
+	if (usb_endpoint_xfer_bulk(&ep->desc)) {
+		if (udev->speed == USB_SPEED_HIGH)
+			max_packet = 512;
+		if (udev->speed == USB_SPEED_FULL) {
+			max_packet = rounddown_pow_of_two(max_packet);
+			max_packet = clamp_val(max_packet, 8, 64);
+		}
+	}
 	/* xHCI 1.0 and 1.1 indicates that ctrl ep avg TRB Length should be 8 */
 	if (usb_endpoint_xfer_control(&ep->desc) && xhci->hci_version >= 0x100)
 		avg_trb_len = 8;


