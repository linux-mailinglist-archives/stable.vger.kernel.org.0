Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4523C3FDC4F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345868AbhIAMsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343640AbhIAMqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B0E60E98;
        Wed,  1 Sep 2021 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499996;
        bh=OYeaMIIOBNuPwhpnFGcyy0uOKPLSDi3ejwPR1ER5Ma4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG3VIl6T7E8WPFEarYGioAiDfCEYr3r+ksvtUdR3RVIE44ojCG3xftGrzJBpoSvLn
         p8Sfs3DsOXbMdc+1Yxq7EOWFCDDgAqBQS1mWq9ydb5sqBMCExSn4uW35v3cWvdRcYT
         8KRGWIY5suW5ceiSzin8Xu+JicKPf7snk+LVo97w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 030/113] usb: renesas-xhci: Prefer firmware loading on unknown ROM state
Date:   Wed,  1 Sep 2021 14:27:45 +0200
Message-Id: <20210901122302.995956828@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c82cacd2f1e622a461a77d275a75d7e19e7635a3 upstream.

The recent attempt to handle an unknown ROM state in the commit
d143825baf15 ("usb: renesas-xhci: Fix handling of unknown ROM state")
resulted in a regression and reverted later by the commit 44cf53602f5a
("Revert "usb: renesas-xhci: Fix handling of unknown ROM state"").
The problem of the former fix was that it treated the failure of
firmware loading as a fatal error.  Since the firmware files aren't
included in the standard linux-firmware tree, most users don't have
them, hence they got the non-working system after that.  The revert
fixed the regression, but also it didn't make the firmware loading
triggered even on the devices that do need it.  So we need still a fix
for them.

This is another attempt to handle the unknown ROM state.  Like the
previous fix, this also tries to load the firmware when ROM shows
unknown state.  In this patch, however, the failure of a firmware
loading (such as a missing firmware file) isn't handled as a fatal
error any longer when ROM has been already detected, but it falls back
to the ROM mode like before.  The error is returned only when no ROM
is detected and the firmware loading failed.

Along with it, for simplifying the code flow, the detection and the
check of ROM is factored out from renesas_fw_check_running() and done
in the caller side, renesas_xhci_check_request_fw().  It avoids the
redundant ROM checks.

The patch was tested on Lenovo Thinkpad T14 gen (BIOS 1.34).  Also it
was confirmed that no regression is seen on another Thinkpad T14
machine that has worked without the patch, too.

Fixes: 44cf53602f5a ("Revert "usb: renesas-xhci: Fix handling of unknown ROM state"")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1189207
Link: https://lore.kernel.org/r/20210826124127.14789-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci-renesas.c | 35 +++++++++++++++++++----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index 5923844ed821..ef5e91a5542d 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,7 +207,8 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			return 0;
+			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
+			return -ENOENT;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -224,14 +225,6 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
 	u8 fw_state;
 	int err;
 
-	/* Check if device has ROM and loaded, if so skip everything */
-	err = renesas_check_rom(pdev);
-	if (err) { /* we have rom */
-		err = renesas_check_rom_state(pdev);
-		if (!err)
-			return err;
-	}
-
 	/*
 	 * Test if the device is actually needing the firmware. As most
 	 * BIOSes will initialize the device for us. If the device is
@@ -591,21 +584,39 @@ int renesas_xhci_check_request_fw(struct pci_dev *pdev,
 			(struct xhci_driver_data *)id->driver_data;
 	const char *fw_name = driver_data->firmware;
 	const struct firmware *fw;
+	bool has_rom;
 	int err;
 
+	/* Check if device has ROM and loaded, if so skip everything */
+	has_rom = renesas_check_rom(pdev);
+	if (has_rom) {
+		err = renesas_check_rom_state(pdev);
+		if (!err)
+			return 0;
+		else if (err != -ENOENT)
+			has_rom = false;
+	}
+
 	err = renesas_fw_check_running(pdev);
 	/* Continue ahead, if the firmware is already running. */
 	if (err == 0)
 		return 0;
 
+	/* no firmware interface available */
 	if (err != 1)
-		return err;
+		return has_rom ? 0 : err;
 
 	pci_dev_get(pdev);
-	err = request_firmware(&fw, fw_name, &pdev->dev);
+	err = firmware_request_nowarn(&fw, fw_name, &pdev->dev);
 	pci_dev_put(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "request_firmware failed: %d\n", err);
+		if (has_rom) {
+			dev_info(&pdev->dev, "failed to load firmware %s, fallback to ROM\n",
+				 fw_name);
+			return 0;
+		}
+		dev_err(&pdev->dev, "failed to load firmware %s: %d\n",
+			fw_name, err);
 		return err;
 	}
 
-- 
2.32.0



