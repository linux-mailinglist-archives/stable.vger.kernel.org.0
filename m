Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF5F3CCE36
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 09:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhGSHIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 03:08:35 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:43000 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbhGSHIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 03:08:35 -0400
Received: by mail-pl1-f172.google.com with SMTP id v14so9089486plg.9;
        Mon, 19 Jul 2021 00:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3YrzJmFnmqMIqu+mKxLmp9ctb0s/ds5KBkIaLiUqcG0=;
        b=JCKQl4k8izcy+U0tip3Hha4XCqbDaldy+gynZlrzjMnQ6LjdNUEnO7anlAlQ5yOURO
         w+5xdi6ytBIqqX4ltb1E+iJAinGEhJJy0uUd38Qu63IevjhtGvYeMDyYsUSojYZaPbtr
         R5FtB0gVIE469GT9gtZZW9zal79yFHQx9BzZFNHnAGTCRVGcBBwsNzck0gFgrUlLhf2P
         sFZT4OiWN1HYmaIcCFiByiIqDQF7WOxF8tfac6SyxAuhLmnOLT0OLUrqqDEuxkwjIMAi
         fI9/xqPGdBoISI4U4jz541gWdQN0VjhiwKmBB11b4puC6L0FSbiyZQvVTu9kkmSe2CeW
         7PVw==
X-Gm-Message-State: AOAM530CHuSkyAWb0gU5iC+iFvDa4/ekVvQGR1W/bM/szksDfuxvfwBm
        HhssvaiqYpQFE3hRrNJfHOF21sqHvvc=
X-Google-Smtp-Source: ABdhPJx5zvFmqBHUV1EJ2SRgn6Z9ESmfyQnpCldRIsIXEbXPjcK7Ho8IC3ubwVwJiXY1x5RpDo8gQg==
X-Received: by 2002:a17:90a:9ab:: with SMTP id 40mr29074822pjo.9.1626678335096;
        Mon, 19 Jul 2021 00:05:35 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id k189sm20671984pgk.14.2021.07.19.00.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 00:05:34 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gabriel.kh.huang@fii-na.com,
        moritzf@google.com, Moritz Fischer <mdf@kernel.org>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>
Subject: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM state"
Date:   Mon, 19 Jul 2021 00:05:19 -0700
Message-Id: <20210719070519.41114-1-mdf@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d143825baf15f204dac60acdf95e428182aa3374.

Justin reports some of his systems now fail as result of this commit:

 xhci_hcd 0000:04:00.0: Direct firmware load for renesas_usb_fw.mem failed with error -2
 xhci_hcd 0000:04:00.0: request_firmware failed: -2
 xhci_hcd: probe of 0000:04:00.0 failed with error -2

The revert brings back the original issue the commit tried to solve but
at least unbreaks existing systems relying on previous behavior.

Cc: stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>
Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---

Justin,

would you be able to help out testing follow up patches to this?

I don't have a machine to test your use-case and mine definitly requires
a firmware load on RENESAS_ROM_STATUS_NO_RESULT.

Thanks
- Moritz

---
 drivers/usb/host/xhci-pci-renesas.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index 1da647961c25..5923844ed821 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,8 +207,7 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
-			break;
+			return 0;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -225,12 +224,13 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
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
-- 
2.32.0

