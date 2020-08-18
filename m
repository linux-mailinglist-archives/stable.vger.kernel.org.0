Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CCE248254
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgHRJzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHRJzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:55:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1473020738;
        Tue, 18 Aug 2020 09:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744522;
        bh=yok0fyRRjrLxCqtJWJzpL5fhr1JG4TgTRvu5FmIStN4=;
        h=Subject:To:From:Date:From;
        b=oezWbLYhDw9O1vnNpEE7YkAuQICAn2QkDbvSIJWSLSbJOvIIDU3TNol155duXPkPt
         bIGhZNQxNlOuf1nvch0c2QkdmbDE0Do5NzPDp6nJM5xJBxxrwN86KdRY+Lct1KcN9o
         lEDVTfrPTd+9oWFFhYOgINE3INNxXjOzOyIun7is=
Subject: patch "usb: renesas-xhci: remove version check" added to usb-linus
To:     vkoul@kernel.org, gregkh@linuxfoundation.org, journeay@gmail.com,
        stable@vger.kernel.org, vacharakis@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 11:55:43 +0200
Message-ID: <159774454323012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas-xhci: remove version check

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d66a57be2f9a315fc10d0f524f670fec903e0fb4 Mon Sep 17 00:00:00 2001
From: Vinod Koul <vkoul@kernel.org>
Date: Tue, 18 Aug 2020 12:47:39 +0530
Subject: usb: renesas-xhci: remove version check

Some devices in wild are reporting bunch of firmware versions, so remove
the check for versions in driver

Reported by: Anastasios Vacharakis <vacharakis@gmail.com>
Reported by: Glen Journeay <journeay@gmail.com>
Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208911
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200818071739.789720-1-vkoul@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci-renesas.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index 59b1965ad0a3..f97ac9f52bf4 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -50,20 +50,6 @@
 #define RENESAS_RETRY	10000
 #define RENESAS_DELAY	10
 
-#define ROM_VALID_01 0x2013
-#define ROM_VALID_02 0x2026
-
-static int renesas_verify_fw_version(struct pci_dev *pdev, u32 version)
-{
-	switch (version) {
-	case ROM_VALID_01:
-	case ROM_VALID_02:
-		return 0;
-	}
-	dev_err(&pdev->dev, "FW has invalid version :%d\n", version);
-	return -EINVAL;
-}
-
 static int renesas_fw_download_image(struct pci_dev *dev,
 				     const u32 *fw, size_t step, bool rom)
 {
@@ -202,10 +188,7 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
 
 	version &= RENESAS_FW_VERSION_FIELD;
 	version = version >> RENESAS_FW_VERSION_OFFSET;
-
-	err = renesas_verify_fw_version(pdev, version);
-	if (err)
-		return err;
+	dev_dbg(&pdev->dev, "Found ROM version: %x\n", version);
 
 	/*
 	 * Test if ROM is present and loaded, if so we can skip everything
-- 
2.28.0


