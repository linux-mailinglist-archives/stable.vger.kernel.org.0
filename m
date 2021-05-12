Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA4937C206
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhELPGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhELPCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4AE86162A;
        Wed, 12 May 2021 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831478;
        bh=rfezmo9Q8iOh0jLOaNAhDGmOVE0AItSpOMx38FAbjCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaS6/hIuVy2jj3gIMTcGaG6RJDVlMpjWlMdIofNgew+KSZ5OH3FBMw4gRHnGNr6zz
         42ofe+hpy9Xcp6ZkbA/2m7zLkS+YO7rYwEBKbCMPHpXOS5OEBj9r/lXl2L/Txr3PhA
         2Yk2DptDseGPPlYSHI1m+vtm794WwalsJwcr7jfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/244] usb: dwc2: Fix hibernation between host and device modes.
Date:   Wed, 12 May 2021 16:48:27 +0200
Message-Id: <20210512144747.365769344@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>

[ Upstream commit 24d209dba5a3959b2ebde7cf3ad40c8015e814cf ]

When core is in hibernation in host mode and a device cable
was connected then driver exited from device hibernation.
However, registers saved for host mode and when exited from
device hibernation register restore would be done for device
register which was wrong because there was no device registers
stored to restore.

- Added dwc_handle_gpwrdn_disc_det() function which handles
  gpwrdn disconnect detect flow and exits hibernation
  without restoring the registers.
- Updated exiting from hibernation in GPWRDN_STS_CHGINT with
  calling dwc_handle_gpwrdn_disc_det() function. Here no register
  is restored which is the solution described above.

Fixes: 65c9c4c6b01f ("usb: dwc2: Add dwc2_handle_gpwrdn_intr() handler")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/20210416124715.75355A005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/core_intr.c | 154 +++++++++++++++++++----------------
 1 file changed, 83 insertions(+), 71 deletions(-)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index f73e78143ad1..9da27ec22d58 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -665,6 +665,71 @@ static u32 dwc2_read_common_intr(struct dwc2_hsotg *hsotg)
 		return 0;
 }
 
+/**
+ * dwc_handle_gpwrdn_disc_det() - Handles the gpwrdn disconnect detect.
+ * Exits hibernation without restoring registers.
+ *
+ * @hsotg: Programming view of DWC_otg controller
+ * @gpwrdn: GPWRDN register
+ */
+static inline void dwc_handle_gpwrdn_disc_det(struct dwc2_hsotg *hsotg,
+					      u32 gpwrdn)
+{
+	u32 gpwrdn_tmp;
+
+	/* Switch-on voltage to the core */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp &= ~GPWRDN_PWRDNSWTCH;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+	udelay(5);
+
+	/* Reset core */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp &= ~GPWRDN_PWRDNRSTN;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+	udelay(5);
+
+	/* Disable Power Down Clamp */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp &= ~GPWRDN_PWRDNCLMP;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+	udelay(5);
+
+	/* Deassert reset core */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp |= GPWRDN_PWRDNRSTN;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+	udelay(5);
+
+	/* Disable PMU interrupt */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp &= ~GPWRDN_PMUINTSEL;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+
+	/* De-assert Wakeup Logic */
+	gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
+	gpwrdn_tmp &= ~GPWRDN_PMUACTV;
+	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
+
+	hsotg->hibernated = 0;
+	hsotg->bus_suspended = 0;
+
+	if (gpwrdn & GPWRDN_IDSTS) {
+		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
+		dwc2_core_init(hsotg, false);
+		dwc2_enable_global_interrupts(hsotg);
+		dwc2_hsotg_core_init_disconnected(hsotg, false);
+		dwc2_hsotg_core_connect(hsotg);
+	} else {
+		hsotg->op_state = OTG_STATE_A_HOST;
+
+		/* Initialize the Core for Host mode */
+		dwc2_core_init(hsotg, false);
+		dwc2_enable_global_interrupts(hsotg);
+		dwc2_hcd_start(hsotg);
+	}
+}
+
 /*
  * GPWRDN interrupt handler.
  *
@@ -686,64 +751,14 @@ static void dwc2_handle_gpwrdn_intr(struct dwc2_hsotg *hsotg)
 
 	if ((gpwrdn & GPWRDN_DISCONN_DET) &&
 	    (gpwrdn & GPWRDN_DISCONN_DET_MSK) && !linestate) {
-		u32 gpwrdn_tmp;
-
 		dev_dbg(hsotg->dev, "%s: GPWRDN_DISCONN_DET\n", __func__);
-
-		/* Switch-on voltage to the core */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp &= ~GPWRDN_PWRDNSWTCH;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-		udelay(10);
-
-		/* Reset core */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp &= ~GPWRDN_PWRDNRSTN;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-		udelay(10);
-
-		/* Disable Power Down Clamp */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp &= ~GPWRDN_PWRDNCLMP;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-		udelay(10);
-
-		/* Deassert reset core */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp |= GPWRDN_PWRDNRSTN;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-		udelay(10);
-
-		/* Disable PMU interrupt */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp &= ~GPWRDN_PMUINTSEL;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-
-		/* De-assert Wakeup Logic */
-		gpwrdn_tmp = dwc2_readl(hsotg, GPWRDN);
-		gpwrdn_tmp &= ~GPWRDN_PMUACTV;
-		dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
-
-		hsotg->hibernated = 0;
-
-		if (gpwrdn & GPWRDN_IDSTS) {
-			hsotg->op_state = OTG_STATE_B_PERIPHERAL;
-			dwc2_core_init(hsotg, false);
-			dwc2_enable_global_interrupts(hsotg);
-			dwc2_hsotg_core_init_disconnected(hsotg, false);
-			dwc2_hsotg_core_connect(hsotg);
-		} else {
-			hsotg->op_state = OTG_STATE_A_HOST;
-
-			/* Initialize the Core for Host mode */
-			dwc2_core_init(hsotg, false);
-			dwc2_enable_global_interrupts(hsotg);
-			dwc2_hcd_start(hsotg);
-		}
-	}
-
-	if ((gpwrdn & GPWRDN_LNSTSCHG) &&
-	    (gpwrdn & GPWRDN_LNSTSCHG_MSK) && linestate) {
+		/*
+		 * Call disconnect detect function to exit from
+		 * hibernation
+		 */
+		dwc_handle_gpwrdn_disc_det(hsotg, gpwrdn);
+	} else if ((gpwrdn & GPWRDN_LNSTSCHG) &&
+		   (gpwrdn & GPWRDN_LNSTSCHG_MSK) && linestate) {
 		dev_dbg(hsotg->dev, "%s: GPWRDN_LNSTSCHG\n", __func__);
 		if (hsotg->hw_params.hibernation &&
 		    hsotg->hibernated) {
@@ -754,24 +769,21 @@ static void dwc2_handle_gpwrdn_intr(struct dwc2_hsotg *hsotg)
 				dwc2_exit_hibernation(hsotg, 1, 0, 1);
 			}
 		}
-	}
-	if ((gpwrdn & GPWRDN_RST_DET) && (gpwrdn & GPWRDN_RST_DET_MSK)) {
+	} else if ((gpwrdn & GPWRDN_RST_DET) &&
+		   (gpwrdn & GPWRDN_RST_DET_MSK)) {
 		dev_dbg(hsotg->dev, "%s: GPWRDN_RST_DET\n", __func__);
 		if (!linestate && (gpwrdn & GPWRDN_BSESSVLD))
 			dwc2_exit_hibernation(hsotg, 0, 1, 0);
-	}
-	if ((gpwrdn & GPWRDN_STS_CHGINT) &&
-	    (gpwrdn & GPWRDN_STS_CHGINT_MSK) && linestate) {
+	} else if ((gpwrdn & GPWRDN_STS_CHGINT) &&
+		   (gpwrdn & GPWRDN_STS_CHGINT_MSK)) {
 		dev_dbg(hsotg->dev, "%s: GPWRDN_STS_CHGINT\n", __func__);
-		if (hsotg->hw_params.hibernation &&
-		    hsotg->hibernated) {
-			if (gpwrdn & GPWRDN_IDSTS) {
-				dwc2_exit_hibernation(hsotg, 0, 0, 0);
-				call_gadget(hsotg, resume);
-			} else {
-				dwc2_exit_hibernation(hsotg, 1, 0, 1);
-			}
-		}
+		/*
+		 * As GPWRDN_STS_CHGINT exit from hibernation flow is
+		 * the same as in GPWRDN_DISCONN_DET flow. Call
+		 * disconnect detect helper function to exit from
+		 * hibernation.
+		 */
+		dwc_handle_gpwrdn_disc_det(hsotg, gpwrdn);
 	}
 }
 
-- 
2.30.2



