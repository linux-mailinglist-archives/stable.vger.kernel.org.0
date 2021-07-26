Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBBA3D6104
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbhGZP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237845AbhGZPYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2DA60F5A;
        Mon, 26 Jul 2021 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315485;
        bh=L/CAnG7f3XEnt95H3+76U4BERVOkxSaQKBqDXEoJLes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3IC7434296y5ylZTnhcRbawJQ/MZyQ0nyv0cYeNfW6fL5s9DoqQRPi64w7q3/lIE
         Ci5QwdcfrDwaQe/OHoyFCVqhfc2PafQAbj36Bi7e3s9QW2aOHigkoCDwFis6Rw06Ba
         IUT1GkOLixxa/h2L2TaNdob7ryMfXMGnp3jOg3TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.10 116/167] Revert "usb: renesas-xhci: Fix handling of unknown ROM state"
Date:   Mon, 26 Jul 2021 17:39:09 +0200
Message-Id: <20210726153843.293595596@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>

commit 44cf53602f5a0db80d53c8fff6cdbcae59650a42 upstream.

This reverts commit d143825baf15f204dac60acdf95e428182aa3374.

Justin reports some of his systems now fail as result of this commit:

 xhci_hcd 0000:04:00.0: Direct firmware load for renesas_usb_fw.mem failed with error -2
 xhci_hcd 0000:04:00.0: request_firmware failed: -2
 xhci_hcd: probe of 0000:04:00.0 failed with error -2

The revert brings back the original issue the commit tried to solve but
at least unbreaks existing systems relying on previous behavior.

Cc: stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>
Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Fixes: d143825baf15 ("usb: renesas-xhci: Fix handling of unknown ROM state")
Link: https://lore.kernel.org/r/20210719070519.41114-1-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci-renesas.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,8 +207,7 @@ static int renesas_check_rom_state(struc
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
-			break;
+			return 0;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -225,12 +224,13 @@ static int renesas_fw_check_running(stru
 	u8 fw_state;
 	int err;
 
-	/*
-	 * Only if device has ROM and loaded FW we can skip loading and
-	 * return success. Otherwise (even unknown state), attempt to load FW.
-	 */
-	if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
-		return 0;
+	/* Check if device has ROM and loaded, if so skip everything */
+	err = renesas_check_rom(pdev);
+	if (err) { /* we have rom */
+		err = renesas_check_rom_state(pdev);
+		if (!err)
+			return err;
+	}
 
 	/*
 	 * Test if the device is actually needing the firmware. As most


