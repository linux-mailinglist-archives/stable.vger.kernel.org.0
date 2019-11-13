Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063C9FA443
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfKMCPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbfKMB4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE87D2053B;
        Wed, 13 Nov 2019 01:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610208;
        bh=bzUwpoltK0ZWSt3VPP8TQ0CyedzDEhkfvqHOKjCwNfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONjVrH1o06QD72ZAwKBnSTCTd5J7W+GZxZb3tFlxjUuhxlbE6O+XUSl9x3w9SOdwA
         vtw5SYIllaZoOtxMwgIqCjrdqScW6I9WvMshy5l8x7nItzR7yRls1PaXtBuf31eswe
         uJIzLr1bkJl4YyXzrvlQ8FSPDcI1lGKCbITyUyzk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 018/115] usb: dwc3: gadget: Check ENBLSLPM before sending ep command
Date:   Tue, 12 Nov 2019 20:54:45 -0500
Message-Id: <20191113015622.11592-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 87dd96111b0bb8e616fcbd74dbf4bb4182f2c596 ]

When operating in USB 2.0 speeds (HS/FS), if GUSB2PHYCFG.ENBLSLPM or
GUSB2PHYCFG.SUSPHY is set, it must be cleared before issuing an endpoint
command.

Current implementation only save and restore GUSB2PHYCFG.SUSPHY
configuration. We must save and clear both GUSB2PHYCFG.ENBLSLPM and
GUSB2PHYCFG.SUSPHY settings. Restore them after the command is
completed.

DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2

Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1b99d44e52b9a..2cc6b2aceedb8 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -277,27 +277,36 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned cmd,
 	const struct usb_endpoint_descriptor *desc = dep->endpoint.desc;
 	struct dwc3		*dwc = dep->dwc;
 	u32			timeout = 1000;
+	u32			saved_config = 0;
 	u32			reg;
 
 	int			cmd_status = 0;
-	int			susphy = false;
 	int			ret = -EINVAL;
 
 	/*
-	 * Synopsys Databook 2.60a states, on section 6.3.2.5.[1-8], that if
-	 * we're issuing an endpoint command, we must check if
-	 * GUSB2PHYCFG.SUSPHY bit is set. If it is, then we need to clear it.
+	 * When operating in USB 2.0 speeds (HS/FS), if GUSB2PHYCFG.ENBLSLPM or
+	 * GUSB2PHYCFG.SUSPHY is set, it must be cleared before issuing an
+	 * endpoint command.
 	 *
-	 * We will also set SUSPHY bit to what it was before returning as stated
-	 * by the same section on Synopsys databook.
+	 * Save and clear both GUSB2PHYCFG.ENBLSLPM and GUSB2PHYCFG.SUSPHY
+	 * settings. Restore them after the command is completed.
+	 *
+	 * DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2
 	 */
 	if (dwc->gadget.speed <= USB_SPEED_HIGH) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		if (unlikely(reg & DWC3_GUSB2PHYCFG_SUSPHY)) {
-			susphy = true;
+			saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
 			reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
-			dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 		}
+
+		if (reg & DWC3_GUSB2PHYCFG_ENBLSLPM) {
+			saved_config |= DWC3_GUSB2PHYCFG_ENBLSLPM;
+			reg &= ~DWC3_GUSB2PHYCFG_ENBLSLPM;
+		}
+
+		if (saved_config)
+			dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 	}
 
 	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
@@ -395,9 +404,9 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned cmd,
 		}
 	}
 
-	if (unlikely(susphy)) {
+	if (saved_config) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-		reg |= DWC3_GUSB2PHYCFG_SUSPHY;
+		reg |= saved_config;
 		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 	}
 
-- 
2.20.1

