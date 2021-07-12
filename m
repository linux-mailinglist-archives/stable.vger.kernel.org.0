Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469AC3C5060
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhGLHcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346213AbhGLHaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A509F60230;
        Mon, 12 Jul 2021 07:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074870;
        bh=nucrAFs0kQP9IRBcjH0nakZVfYgdC/gs8SR+BZz4lzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN5razPSlh2SQCsWVi07zkqj3YkAbqImNV6sxPgTVeMoR3nogdAG9bD3h0S+q6OV3
         M5E8ivok053v+amXFDUmTNPTRcDy6Wav8rk/yLpYWeErs67Z0QtYNbWSzbVrq51AlA
         YzVGWOZlZM4r3en7TmvnLccE05JoBlrbElx4UWow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown ROM state
Date:   Mon, 12 Jul 2021 08:00:47 +0200
Message-Id: <20210712060916.499546891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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


