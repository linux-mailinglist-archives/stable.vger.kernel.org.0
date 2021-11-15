Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FE94511B9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbhKOTNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244152AbhKOTLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:11:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D8261101;
        Mon, 15 Nov 2021 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000349;
        bh=rrH7UNQZuVL/rSxp4XtzUsJ35UNuCKUETxXcj2WXres=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHQsqWQjMDN5s39uPbNOFriuTIIXPzqOYWUjOvO/N9315twxz7VpZL4wv/hyVusZc
         hdEOSKIu9G4R8TES9sYkmmo+cOXrz11/cBI7wr+nbDDk4/iUeAlvVl5rio5sykcg5h
         ZwTLjGUfJ9zoJmuaT8zKbpBHGdfkF5Yz1kt9nuYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 628/849] usb: dwc2: drd: fix dwc2_drd_role_sw_set when clock could be disabled
Date:   Mon, 15 Nov 2021 18:01:51 +0100
Message-Id: <20211115165441.506657838@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 8d387f61b0240854e81450c261beb775065bad5d ]

In case of USB_DR_MODE_PERIPHERAL, the OTG clock is disabled at the end of
the probe (it is not the case if USB_DR_MODE_HOST or USB_DR_MODE_OTG).
The clock is then enabled on udc_start.
If dwc2_drd_role_sw_set is called before udc_start (it is the case if the
usb cable is plugged at boot), GOTGCTL and GUSBCFG registers cannot be
read/written, so session cannot be overridden.
To avoid this case, check the ll_hw_enabled value and enable the clock if
it is available, and disable it after the override.

Fixes: 17f934024e84 ("usb: dwc2: override PHY input signals with usb role switch support")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211005095305.66397-3-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/drd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index 80eae88d76dda..99672360f34b0 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -7,6 +7,7 @@
  * Author(s): Amelie Delaunay <amelie.delaunay@st.com>
  */
 
+#include <linux/clk.h>
 #include <linux/iopoll.h>
 #include <linux/platform_device.h>
 #include <linux/usb/role.h>
@@ -86,6 +87,20 @@ static int dwc2_drd_role_sw_set(struct usb_role_switch *sw, enum usb_role role)
 	}
 #endif
 
+	/*
+	 * In case of USB_DR_MODE_PERIPHERAL, clock is disabled at the end of
+	 * the probe and enabled on udc_start.
+	 * If role-switch set is called before the udc_start, we need to enable
+	 * the clock to read/write GOTGCTL and GUSBCFG registers to override
+	 * mode and sessions. It is the case if cable is plugged at boot.
+	 */
+	if (!hsotg->ll_hw_enabled && hsotg->clk) {
+		int ret = clk_prepare_enable(hsotg->clk);
+
+		if (ret)
+			return ret;
+	}
+
 	spin_lock_irqsave(&hsotg->lock, flags);
 
 	if (role == USB_ROLE_HOST) {
@@ -110,6 +125,9 @@ static int dwc2_drd_role_sw_set(struct usb_role_switch *sw, enum usb_role role)
 		/* This will raise a Connector ID Status Change Interrupt */
 		dwc2_force_mode(hsotg, role == USB_ROLE_HOST);
 
+	if (!hsotg->ll_hw_enabled && hsotg->clk)
+		clk_disable_unprepare(hsotg->clk);
+
 	dev_dbg(hsotg->dev, "%s-session valid\n",
 		role == USB_ROLE_NONE ? "No" :
 		role == USB_ROLE_HOST ? "A" : "B");
-- 
2.33.0



