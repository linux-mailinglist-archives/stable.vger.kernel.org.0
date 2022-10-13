Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436965FCFED
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiJMAYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiJMAXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503B9EB774;
        Wed, 12 Oct 2022 17:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25629616EA;
        Thu, 13 Oct 2022 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20DAC43141;
        Thu, 13 Oct 2022 00:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620419;
        bh=4bVzplRUEri578yf4hMSfP54NrhqRnxXXKHhE/E0fPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqWcm8DQFABgzlJ3UZysFOohaJqS8w5EScqUznU9iZ+nwWmFxjKXRMGQPZ3Q8IcnP
         GDcTIXKdlJsXI+0/33J0KYjdr9TJWJzynjuw9b/Nqu0Wjqm3uxYecou8tpv6fj25cp
         2P/Fm4w05yXxxVXHH6uSz6/fpI0KXMWRV8v3Yx9lzDfwOVvv2Q/mj62+Ijz7sr/eqG
         ijKCwVRRtQvOON2cLFlgQMej9vGc3TmyM2OhQ20M8tJWjB82jijlYPbA15baT9XUnp
         X95syviqw7n+bGO0RVbzYPtk0RG57z+A6V5RoHzV8dIIailD1u2ZbJnMnwJzMLTYZ9
         d2g+yDGLQeRzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Piyush Mehta <piyush.mehta@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Thinh.Nguyen@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 40/63] usb: dwc3: core: Enable GUCTL1 bit 10 for fixing termination error after resume bug
Date:   Wed, 12 Oct 2022 20:18:14 -0400
Message-Id: <20221013001842.1893243-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piyush Mehta <piyush.mehta@amd.com>

[ Upstream commit 63d7f9810a38102cdb8cad214fac98682081e1a7 ]

When configured in HOST mode, after issuing U3/L2 exit controller fails
to send proper CRC checksum in CRC5 field. Because of this behavior
Transaction Error is generated, resulting in reset and re-enumeration of
usb device attached. Enabling chicken bit 10 of GUCTL1 will correct this
problem.

When this bit is set to '1', the UTMI/ULPI opmode will be changed to
"normal" along with HS terminations, term, and xcvr signals after EOR.
This option is to support certain legacy UTMI/ULPI PHYs.

Added "snps,resume-hs-terminations" quirk to resolved the above issue.

Signed-off-by: Piyush Mehta <piyush.mehta@amd.com>
Link: https://lore.kernel.org/r/20220920052235.194272-3-piyush.mehta@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 17 +++++++++++++++++
 drivers/usb/dwc3/core.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 019c79322850..7f28742aa453 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1150,6 +1150,21 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		dwc3_writel(dwc->regs, DWC3_GUCTL2, reg);
 	}
 
+	/*
+	 * When configured in HOST mode, after issuing U3/L2 exit controller
+	 * fails to send proper CRC checksum in CRC5 feild. Because of this
+	 * behaviour Transaction Error is generated, resulting in reset and
+	 * re-enumeration of usb device attached. All the termsel, xcvrsel,
+	 * opmode becomes 0 during end of resume. Enabling bit 10 of GUCTL1
+	 * will correct this problem. This option is to support certain
+	 * legacy ULPI PHYs.
+	 */
+	if (dwc->resume_hs_terminations) {
+		reg = dwc3_readl(dwc->regs, DWC3_GUCTL1);
+		reg |= DWC3_GUCTL1_RESUME_OPMODE_HS_HOST;
+		dwc3_writel(dwc->regs, DWC3_GUCTL1, reg);
+	}
+
 	if (!DWC3_VER_IS_PRIOR(DWC3, 250A)) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUCTL1);
 
@@ -1493,6 +1508,8 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 				"snps,dis-del-phy-power-chg-quirk");
 	dwc->dis_tx_ipgap_linecheck_quirk = device_property_read_bool(dev,
 				"snps,dis-tx-ipgap-linecheck-quirk");
+	dwc->resume_hs_terminations = device_property_read_bool(dev,
+				"snps,resume-hs-terminations");
 	dwc->parkmode_disable_ss_quirk = device_property_read_bool(dev,
 				"snps,parkmode-disable-ss-quirk");
 	dwc->gfladj_refclk_lpm_sel = device_property_read_bool(dev,
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 725fb17e4a9e..b9fa0fa5ba7c 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -262,6 +262,7 @@
 #define DWC3_GUCTL1_DEV_FORCE_20_CLK_FOR_30_CLK	BIT(26)
 #define DWC3_GUCTL1_DEV_L1_EXIT_BY_HW		BIT(24)
 #define DWC3_GUCTL1_PARKMODE_DISABLE_SS		BIT(17)
+#define DWC3_GUCTL1_RESUME_OPMODE_HS_HOST	BIT(10)
 
 /* Global Status Register */
 #define DWC3_GSTS_OTG_IP	BIT(10)
@@ -1094,6 +1095,8 @@ struct dwc3_scratchpad_array {
  *			change quirk.
  * @dis_tx_ipgap_linecheck_quirk: set if we disable u2mac linestate
  *			check during HS transmit.
+ * @resume-hs-terminations: Set if we enable quirk for fixing improper crc
+ *			generation after resume from suspend.
  * @parkmode_disable_ss_quirk: set if we need to disable all SuperSpeed
  *			instances in park mode.
  * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
@@ -1309,6 +1312,7 @@ struct dwc3 {
 	unsigned		dis_u2_freeclk_exists_quirk:1;
 	unsigned		dis_del_phy_power_chg_quirk:1;
 	unsigned		dis_tx_ipgap_linecheck_quirk:1;
+	unsigned		resume_hs_terminations:1;
 	unsigned		parkmode_disable_ss_quirk:1;
 	unsigned		gfladj_refclk_lpm_sel:1;
 
-- 
2.35.1

