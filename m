Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D40F22F6CD
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgG0RiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgG0RiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 13:38:14 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81430C061794;
        Mon, 27 Jul 2020 10:38:14 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id z17so12742229edr.9;
        Mon, 27 Jul 2020 10:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/sKKwVMF8e4uHhkt8F3tJZDTVJK3HD/IRNcRCGfQ0iI=;
        b=Ai5egpzaMg+snqXKaqxknnOqLimP/zj6IXv/zg0JBwwuK2BwrBIY0TLJ4HUwd86yOj
         RCLN69SG4FyZirYcRCk7C74kaP0ZojtIhFxs4zZEB+TYfzr48Lk8HudamqQshhc0D/wC
         gpXUFpQsiOSLG1rdFgb+Tz4Y9nO0Q1tfTio11oUlFfkkqHMdbN/Xf6f/9CeaCq6XXQZH
         KIu2zNkMU9nLtBYFfqks/doGXNHXkrcKdXtXcs5bslKRbh3qRWP8eHyhhKr0T7c3+677
         1udexORQ0Qi8oYFeVw4NjT6bh2qLFnFLVrCSShBsy1UvMhSqDV1LNoHsPKbuOPGx1jNn
         Y2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/sKKwVMF8e4uHhkt8F3tJZDTVJK3HD/IRNcRCGfQ0iI=;
        b=RWY0MnM5qeE9CSQi+R46OWs75N+5iJWi9s5c4/hBUZo485kJ31vzS+asyF5fMG4X5t
         1ZLC4bu0KQtqOntwakZd87E/t4hcn2N+y+JNMRRSfYGKp/emZjptWAdK5uQEH14fARJO
         9HnNSjRsKAWCnSNPZCGuC7sm6NGSEyJgdMWOlS3aO28XmQMah8pZC012WC4hvbnz40nV
         b616xE6nk/MpPr93cqJA4mfXOi3Us87bdLyZvTlvUpZxdIedJLBb/8aZk3rannQRnL/A
         o59JWuMSicNQK5DvK0JcltBi15kkvXOc4+f4FLKmrm+Y2rReMCtVqbq7poCzkgPwgfA1
         GCTQ==
X-Gm-Message-State: AOAM532EBKg/dJ/csfgLoVkLhggGkvlj9FKeVt0yWKa8CwEwaD79uVhW
        IzINypjKQqO36orXRpYJSdQrRV4GnQE=
X-Google-Smtp-Source: ABdhPJxBfOMURSmESYSYBVelY4lBWbo7lOCvYRLpUDv8nxmeawmAsgobF3dOIFn/CqLO8ohJbJKl8g==
X-Received: by 2002:a05:6402:22f0:: with SMTP id dn16mr22471016edb.83.1595871493204;
        Mon, 27 Jul 2020 10:38:13 -0700 (PDT)
Received: from localhost.localdomain (p200300f13716be00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3716:be00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id cc9sm8115756edb.14.2020.07.27.10.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 10:38:12 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hminas@synopsys.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marex@denx.de,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3] usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails
Date:   Mon, 27 Jul 2020 19:38:01 +0200
Message-Id: <20200727173801.792626-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Call dwc2_debugfs_exit() and dwc2_hcd_remove() (if the HCD was enabled
earlier) when usb_add_gadget_udc() has failed. This ensures that the
debugfs entries created by dwc2_debugfs_init() as well as the HCD are
cleaned up in the error path.

Fixes: 207324a321a866 ("usb: dwc2: Postponed gadget registration to the udc class driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v2 at [1]:
- add #if around the new label and it's code to prevent the following
  warning found by the Kernel test robot:
    unused label 'error_debugfs' [-Wunused-label]

Changes since v1 at [0]
- also cleanup the HCD as suggested by Minas (thank you!)
- updated the subject accordingly


[0] https://patchwork.kernel.org/patch/11631381/
[1] https://patchwork.kernel.org/patch/11642957/


 drivers/usb/dwc2/platform.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index cb8ddbd53718..b74099764b2d 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -583,12 +583,19 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
 		if (retval) {
 			dwc2_hsotg_remove(hsotg);
-			goto error_init;
+			goto error_debugfs;
 		}
 	}
 #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+error_debugfs:
+	dwc2_debugfs_exit(hsotg);
+	if (hsotg->hcd_enabled)
+		dwc2_hcd_remove(hsotg);
+#endif
 error_init:
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
-- 
2.27.0

