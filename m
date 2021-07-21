Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61563D0A11
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhGUHL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235331AbhGUHKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 03:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D35261019;
        Wed, 21 Jul 2021 07:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626853879;
        bh=zj0zDgtBIZd/U9IEb1Seaq2S0Y0LXtDbNo6WzDS9bZU=;
        h=Subject:To:From:Date:From;
        b=zwaPar/rQSZXE/KeVT5SUPH345mchZn3jYKkAJKKkKpgZQEApItA3ZqnloxDv7I5N
         GXE8SJqzHe+g41pipDr1GeutY2rnfKVk3IuBNS6/d8IkapeS0ffELDZg0H23bwVgLM
         51InTIPdOiDJT3bKfVjAhPlU3YFq7oplgUZBZk30=
Subject: patch "usb: dwc2: Skip clock gating on Samsung SoCs" added to usb-linus
To:     m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
        krzysztof.kozlowski@canonical.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:51:08 +0200
Message-ID: <1626853868221208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Skip clock gating on Samsung SoCs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c4a0f7a6ab5417eb6105b0e1d7e6e67f6ef7d4e5 Mon Sep 17 00:00:00 2001
From: Marek Szyprowski <m.szyprowski@samsung.com>
Date: Fri, 16 Jul 2021 07:01:27 +0200
Subject: usb: dwc2: Skip clock gating on Samsung SoCs

Commit 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr
function.") changed the way the driver handles power down modes in a such
way that it uses clock gating when no other power down mode is available.

This however doesn't work well on the DWC2 implementation used on the
Samsung SoCs. When a clock gating is enabled, system hangs. It looks that
the proper clock gating requires some additional glue code in the shared
USB2 PHY and/or Samsung glue code for the DWC2. To restore driver
operation on the Samsung SoCs simply skip enabling clock gating mode
until one finds what is really needed to make it working reliably.

Fixes: 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr function.")
Cc: stable <stable@vger.kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20210716050127.4406-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h      | 4 ++++
 drivers/usb/dwc2/core_intr.c | 3 ++-
 drivers/usb/dwc2/hcd.c       | 6 ++++--
 drivers/usb/dwc2/params.c    | 1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index ab6b815e0089..483de2bbfaab 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -383,6 +383,9 @@ enum dwc2_ep0_state {
  *			0 - No (default)
  *			1 - Partial power down
  *			2 - Hibernation
+ * @no_clock_gating:	Specifies whether to avoid clock gating feature.
+ *			0 - No (use clock gating)
+ *			1 - Yes (avoid it)
  * @lpm:		Enable LPM support.
  *			0 - No
  *			1 - Yes
@@ -480,6 +483,7 @@ struct dwc2_core_params {
 #define DWC2_POWER_DOWN_PARAM_NONE		0
 #define DWC2_POWER_DOWN_PARAM_PARTIAL		1
 #define DWC2_POWER_DOWN_PARAM_HIBERNATION	2
+	bool no_clock_gating;
 
 	bool lpm;
 	bool lpm_clock_gating;
diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index a5ab03808da6..a5c52b237e72 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -556,7 +556,8 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_hsotg *hsotg)
 				 * If neither hibernation nor partial power down are supported,
 				 * clock gating is used to save power.
 				 */
-				dwc2_gadget_enter_clock_gating(hsotg);
+				if (!hsotg->params.no_clock_gating)
+					dwc2_gadget_enter_clock_gating(hsotg);
 			}
 
 			/*
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 035d4911a3c3..2a7828971d05 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -3338,7 +3338,8 @@ int dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
 		 * If not hibernation nor partial power down are supported,
 		 * clock gating is used to save power.
 		 */
-		dwc2_host_enter_clock_gating(hsotg);
+		if (!hsotg->params.no_clock_gating)
+			dwc2_host_enter_clock_gating(hsotg);
 		break;
 	}
 
@@ -4402,7 +4403,8 @@ static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
 		 * If not hibernation nor partial power down are supported,
 		 * clock gating is used to save power.
 		 */
-		dwc2_host_enter_clock_gating(hsotg);
+		if (!hsotg->params.no_clock_gating)
+			dwc2_host_enter_clock_gating(hsotg);
 
 		/* After entering suspend, hardware is not accessible */
 		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
diff --git a/drivers/usb/dwc2/params.c b/drivers/usb/dwc2/params.c
index 67c5eb140232..59e119345994 100644
--- a/drivers/usb/dwc2/params.c
+++ b/drivers/usb/dwc2/params.c
@@ -76,6 +76,7 @@ static void dwc2_set_s3c6400_params(struct dwc2_hsotg *hsotg)
 	struct dwc2_core_params *p = &hsotg->params;
 
 	p->power_down = DWC2_POWER_DOWN_PARAM_NONE;
+	p->no_clock_gating = true;
 	p->phy_utmi_width = 8;
 }
 
-- 
2.32.0


