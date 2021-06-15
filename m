Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232893A73E0
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhFOC1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:27:31 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:36455 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhFOC12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 22:27:28 -0400
Received: by mail-pf1-f169.google.com with SMTP id c12so12104919pfl.3;
        Mon, 14 Jun 2021 19:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pngq3yYUhQah5dibNE1vG0pyf1KGFWwzUYTCAfaDmB8=;
        b=FpfHSIMXsqG0z+zrNwcQNJi4UfgzEA1UGcicGfMFYz1gCxdD25M/vazeQkbpltW7vr
         Dzw+yKk1SqihS0C5Gvb21mqJ/z3SsdJnouODysH0iIr/h1l5gVngHQJgcjSdfU794hWo
         NLt3z25mXa3/iA5GYgR1TqWcIHlHVWTJXR77ULlJyZywOWmhRRFYwwaqoKd0l3UmeueF
         gQVp7ODIChhzcP7/PiS2oeavgiFHmSKygC1eZV8pzyuAxNYUd0sWadpIVVWcFt/yblfd
         Y5/+wTg5vPRZoEUJBj9OzIfrZlJg+8Hxx0BxCLwV67BPheKqsZkD6otzhMa3L3CHZ7xh
         ZS5w==
X-Gm-Message-State: AOAM532e8jxfMv/MJWAopjmaB1D14lhkZTHpuxX9dJIhIfU6FuReAJcj
        nwjI40ppqhZU0H5LdhtIZ5JENczllPKMfA==
X-Google-Smtp-Source: ABdhPJwIz1w8mWf8/YzTrTj2RoOQqAbDLccFD6VK0ymuBLlR4zNR4V8DteUu5lWSc1jeevfccXkVgA==
X-Received: by 2002:aa7:8641:0:b029:2f4:7263:5524 with SMTP id a1-20020aa786410000b02902f472635524mr2253289pfo.70.1623723923424;
        Mon, 14 Jun 2021 19:25:23 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id i8sm14031482pgt.58.2021.06.14.19.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:25:22 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maz@kernel.org, vkoul@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moritz Fischer <mdf@kernel.org>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>
Subject: [PATCH] usb: renesas-xhci: Fix handling of unknown ROM state
Date:   Mon, 14 Jun 2021 19:25:14 -0700
Message-Id: <20210615022514.245274-1-mdf@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the ROM status returned is unknown (RENESAS_ROM_STATUS_NO_RESULT)
we need to attempt loading the firmware rather than just skipping
it all together.

Cc: stable@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vkoul@kernel.org>
Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
 drivers/usb/host/xhci-pci-renesas.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index f97ac9f52bf4..dfe54f0afc4b 100644
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
@@ -224,13 +225,11 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
 	u8 fw_state;
 	int err;
 
-	/* Check if device has ROM and loaded, if so skip everything */
-	err = renesas_check_rom(pdev);
-	if (err) { /* we have rom */
-		err = renesas_check_rom_state(pdev);
-		if (!err)
-			return err;
-	}
+	/* Only if device has ROM and loaded FW we can skip loading and
+	 * return success. Otherwise (even unknown state), attempt to load FW.
+	 */
+	if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
+		return 0;
 
 	/*
 	 * Test if the device is actually needing the firmware. As most
-- 
2.31.1

