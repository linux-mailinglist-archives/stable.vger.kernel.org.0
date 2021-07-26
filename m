Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC323D6240
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhGZPfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234779AbhGZPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D24D560F6E;
        Mon, 26 Jul 2021 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316054;
        bh=2b3PArOjnZazMsR2ZUq+OGH7tjb2qq3jyjIc7tFW/w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxSSoLmhm1sB3Gv6cqalxw0dwcddbOAxNxlaMYF44v+9TQ9+PY+dxzmclxuEl85IC
         pjt3zB+3wJhTrBmYX+a2Jb8A2JbIk+MS71rkI1+DIhhStgkkvM2AV1d7QTpgIgH2A+
         VI2/b1+WTMg6JEEVTTi86QVW88hQfM8T6mp/Y/pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.13 170/223] usb: dwc2: Skip clock gating on Samsung SoCs
Date:   Mon, 26 Jul 2021 17:39:22 +0200
Message-Id: <20210726153851.763379342@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c4a0f7a6ab5417eb6105b0e1d7e6e67f6ef7d4e5 upstream.

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
 drivers/usb/dwc2/core.h      |    4 ++++
 drivers/usb/dwc2/core_intr.c |    3 ++-
 drivers/usb/dwc2/hcd.c       |    6 ++++--
 drivers/usb/dwc2/params.c    |    1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

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
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -556,7 +556,8 @@ static void dwc2_handle_usb_suspend_intr
 				 * If neither hibernation nor partial power down are supported,
 				 * clock gating is used to save power.
 				 */
-				dwc2_gadget_enter_clock_gating(hsotg);
+				if (!hsotg->params.no_clock_gating)
+					dwc2_gadget_enter_clock_gating(hsotg);
 			}
 
 			/*
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -3338,7 +3338,8 @@ int dwc2_port_suspend(struct dwc2_hsotg
 		 * If not hibernation nor partial power down are supported,
 		 * clock gating is used to save power.
 		 */
-		dwc2_host_enter_clock_gating(hsotg);
+		if (!hsotg->params.no_clock_gating)
+			dwc2_host_enter_clock_gating(hsotg);
 		break;
 	}
 
@@ -4402,7 +4403,8 @@ static int _dwc2_hcd_suspend(struct usb_
 		 * If not hibernation nor partial power down are supported,
 		 * clock gating is used to save power.
 		 */
-		dwc2_host_enter_clock_gating(hsotg);
+		if (!hsotg->params.no_clock_gating)
+			dwc2_host_enter_clock_gating(hsotg);
 
 		/* After entering suspend, hardware is not accessible */
 		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
--- a/drivers/usb/dwc2/params.c
+++ b/drivers/usb/dwc2/params.c
@@ -76,6 +76,7 @@ static void dwc2_set_s3c6400_params(stru
 	struct dwc2_core_params *p = &hsotg->params;
 
 	p->power_down = DWC2_POWER_DOWN_PARAM_NONE;
+	p->no_clock_gating = true;
 	p->phy_utmi_width = 8;
 }
 


