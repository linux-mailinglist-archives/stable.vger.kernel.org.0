Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8023C47AD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhGLGeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236963AbhGLGcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D591660FD8;
        Mon, 12 Jul 2021 06:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071366;
        bh=nucrAFs0kQP9IRBcjH0nakZVfYgdC/gs8SR+BZz4lzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gomcs/lGkMB5VuazJO5s0Sf8wMWIC9sUBbHI7Mgby8OAKrA8K1bbtzFHsv8EWWnc+
         M0vKEaBVgxyy3nwsQS7ROvOuXdN/5Vjy86pasPKqIbFn3Pr0s2SBxCjiCPtw3L+I2x
         brbT2IAbVOK9L1EKKjhGqjvdkfKKbwVTR+kgzf/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.10 022/593] usb: renesas-xhci: Fix handling of unknown ROM state
Date:   Mon, 12 Jul 2021 08:03:02 +0200
Message-Id: <20210712060845.644006882@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>

commit d143825baf15f204dac60acdf95e428182aa3374 upstream.

The ROM load sometimes seems to return an unknown status
(RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.

If the ROM load indeed failed this leads to failures when trying to
communicate with the controller later on.

Attempt to load firmware using RAM load in those cases.

Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Cc: stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vkoul@kernel.org>
Tested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci-renesas.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,7 +207,8 @@ static int renesas_check_rom_state(struc
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			return 0;
+			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
+			break;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -224,13 +225,12 @@ static int renesas_fw_check_running(stru
 	u8 fw_state;
 	int err;
 
-	/* Check if device has ROM and loaded, if so skip everything */
-	err = renesas_check_rom(pdev);
-	if (err) { /* we have rom */
-		err = renesas_check_rom_state(pdev);
-		if (!err)
-			return err;
-	}
+	/*
+	 * Only if device has ROM and loaded FW we can skip loading and
+	 * return success. Otherwise (even unknown state), attempt to load FW.
+	 */
+	if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
+		return 0;
 
 	/*
 	 * Test if the device is actually needing the firmware. As most


