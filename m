Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13F5378789
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhEJLP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236558AbhEJLIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917AB619AB;
        Mon, 10 May 2021 11:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644531;
        bh=YqB5HsBTL47oTc7G0whds8beb8uDfY6i6H9h2f9KDRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZETPu2Ofkv2seYJ0dwAk8rx431J62dpLLlpa4FgtmQFRaFNGw3ikRhXOWsSBiTZ7o
         +KaUgAR5rwVxKgwpQc87lUYEyFMPVlqJLidSK9m5Z1GPLjVEKIUKqBJRSZ9eQKq1FT
         DtC6WS4SRKvSwfqhM8tQcq9Jfw4sDhbEXdmWQdpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 121/384] usb: dwc3: gadget: Check for disabled LPM quirk
Date:   Mon, 10 May 2021 12:18:30 +0200
Message-Id: <20210510102018.883159203@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 475e8be53d0496f9bc6159f4abb3ff5f9b90e8de ]

If the device doesn't support LPM, make sure to disable the LPM
capability and don't advertise to the host that it supports it.

Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/9e68527ff932b1646f92a7593d4092a903754666.1618366071.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 2 ++
 drivers/usb/dwc3/core.h   | 4 +++-
 drivers/usb/dwc3/gadget.c | 9 ++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f2448d0a9d39..b46985c9595f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1277,6 +1277,8 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 				"snps,usb3_lpm_capable");
 	dwc->usb2_lpm_disable = device_property_read_bool(dev,
 				"snps,usb2-lpm-disable");
+	dwc->usb2_gadget_lpm_disable = device_property_read_bool(dev,
+				"snps,usb2-gadget-lpm-disable");
 	device_property_read_u8(dev, "snps,rx-thr-num-pkt-prd",
 				&rx_thr_num_pkt_prd);
 	device_property_read_u8(dev, "snps,rx-max-burst-prd",
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 052b20d52651..7ae6684a94ae 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1034,7 +1034,8 @@ struct dwc3_scratchpad_array {
  * @dis_start_transfer_quirk: set if start_transfer failure SW workaround is
  *			not needed for DWC_usb31 version 1.70a-ea06 and below
  * @usb3_lpm_capable: set if hadrware supports Link Power Management
- * @usb2_lpm_disable: set to disable usb2 lpm
+ * @usb2_lpm_disable: set to disable usb2 lpm for host
+ * @usb2_gadget_lpm_disable: set to disable usb2 lpm for gadget
  * @disable_scramble_quirk: set if we enable the disable scramble quirk
  * @u2exit_lfps_quirk: set if we enable u2exit lfps quirk
  * @u2ss_inp3_quirk: set if we enable P3 OK for U2/SS Inactive quirk
@@ -1238,6 +1239,7 @@ struct dwc3 {
 	unsigned		dis_start_transfer_quirk:1;
 	unsigned		usb3_lpm_capable:1;
 	unsigned		usb2_lpm_disable:1;
+	unsigned		usb2_gadget_lpm_disable:1;
 
 	unsigned		disable_scramble_quirk:1;
 	unsigned		u2exit_lfps_quirk:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 111ab6f6c055..41bb75a3abe5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3469,6 +3469,7 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 	/* Enable USB2 LPM Capability */
 
 	if (!DWC3_VER_IS_WITHIN(DWC3, ANY, 194A) &&
+	    !dwc->usb2_gadget_lpm_disable &&
 	    (speed != DWC3_DSTS_SUPERSPEED) &&
 	    (speed != DWC3_DSTS_SUPERSPEED_PLUS)) {
 		reg = dwc3_readl(dwc->regs, DWC3_DCFG);
@@ -3495,6 +3496,12 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 
 		dwc3_gadget_dctl_write_safe(dwc, reg);
 	} else {
+		if (dwc->usb2_gadget_lpm_disable) {
+			reg = dwc3_readl(dwc->regs, DWC3_DCFG);
+			reg &= ~DWC3_DCFG_LPM_CAP;
+			dwc3_writel(dwc->regs, DWC3_DCFG, reg);
+		}
+
 		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 		reg &= ~DWC3_DCTL_HIRD_THRES_MASK;
 		dwc3_gadget_dctl_write_safe(dwc, reg);
@@ -3943,7 +3950,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget->ssp_rate		= USB_SSP_GEN_UNKNOWN;
 	dwc->gadget->sg_supported	= true;
 	dwc->gadget->name		= "dwc3-gadget";
-	dwc->gadget->lpm_capable	= true;
+	dwc->gadget->lpm_capable	= !dwc->usb2_gadget_lpm_disable;
 
 	/*
 	 * FIXME We might be setting max_speed to <SUPER, however versions
-- 
2.30.2



