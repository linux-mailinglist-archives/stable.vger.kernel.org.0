Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1E3A8420
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhFOPkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:40:19 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:45584 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhFOPkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 11:40:14 -0400
Received: by mail-pj1-f50.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso2460644pjb.4;
        Tue, 15 Jun 2021 08:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow9MwHDQZoCtOkYmSlGoPU4JHie/Q0V/L+qPA/bMQ6w=;
        b=kc8gYQUatONyY9L74kWNGuLWWzMasFlU1eKuhpPrRYo3+yzx0Ji8P65Qp7w3Mzg19j
         3TlU0fXUfbclxvYAmEBvcjdkljFWL7z6WdoLYl+W9gO3+wCJOnBM6He8eI0/B/3/CDRb
         EolpewBssOPvVvTgHO5JKCmGrO7sm8GTJsv+R0dmsRSZEapEreeSeEqyDxxOBjZi5uE3
         nhyUhTwHQyLpcY7RD2l1LNnN8nuV3J5oh4bWX2/zoPh56e62SONRBgoqv8ZVj0i8FIKn
         l95xSL5WrDpb6lr04WdSP6oLMgdqmOlK3ltqyD1B6qtAZfxUHWjpw4b2DSyqDgZLrUGq
         OT8Q==
X-Gm-Message-State: AOAM532kVgQ1lsSybp7YjfLc+/lpSzZXgY4jVFWfCO8Oo+q0bpvuS+vj
        qrLSSflECEnjIw6AZYmUHLI=
X-Google-Smtp-Source: ABdhPJwOyhUXvKnijqXnXKcuWwbGxnK0gtDWu+9QVWG397Kj0iksDNcl+cmOgoqMp9P/059e26TmDQ==
X-Received: by 2002:a17:90b:1285:: with SMTP id fw5mr5528543pjb.35.1623771488441;
        Tue, 15 Jun 2021 08:38:08 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id m16sm12844491pgb.92.2021.06.15.08.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:38:07 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maz@kernel.org, vkoul@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com,
        Moritz Fischer <mdf@kernel.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>
Subject: [PATCH v2] usb: renesas-xhci: Fix handling of unknown ROM state
Date:   Tue, 15 Jun 2021 08:37:58 -0700
Message-Id: <20210615153758.253572-1-mdf@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ROM load sometimes seems to return an unknown status
(RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.

If the ROM load indeed failed this leads to failures when trying to
communicate with the controller later on.

Attempt to load firmware using RAM load in those cases.

Cc: stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vkoul@kernel.org>
Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Tested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---

Changes from v1:
- Added Vinod's Tested-by and Reviewed-by
- Reworded commit message with more detail
- Fixed up comment formatting

---
 drivers/usb/host/xhci-pci-renesas.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index f97ac9f52bf4..431213cdf9e0 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,7 +207,8 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			return 0;
+			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
+			break;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -224,13 +225,12 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
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
-- 
2.31.1

