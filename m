Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9265FCFF4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiJMAYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiJMAXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44FB63CE;
        Wed, 12 Oct 2022 17:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D27CB81CCE;
        Thu, 13 Oct 2022 00:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E956C433D7;
        Thu, 13 Oct 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620414;
        bh=w0dejz/Ww7rK/wpqNrvjmbXb73YnwzDC0upOPthDqLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvlXH0Do63NkIQhQ1RWXsKCFOt7/rlnTHjI5ZnSNS0nMBYyorqZFL2DeaLR7sTZZw
         U2msdP8+tbV7F4G4gN/KXEH7zqvAe3j9fp+GYdZJjifNoGydlECODSSboIcqR5cuis
         r7h6atzitsqgkq9fQ+NVoL7+2B2LqcMD0E5T7Jgg9DR95vUGT0N2kJJNJ2os8l24RP
         t0+egF/nXmyQlY3ak4MTH92xEHsdUQ9vsj+tgk4L+8q8ia0P72hSgIxYkUXHxFr4Hr
         ASoJ55mu9VKC3adDImsOjMTSw4RWN85zYjCaIDxHkC/PWwcGmcNdnQGrW8qcctn2G4
         RK2eX0NkQsdAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Li Jun <jun.li@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Thinh.Nguyen@synopsys.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 38/63] usb: dwc3: core: add gfladj_refclk_lpm_sel quirk
Date:   Wed, 12 Oct 2022 20:18:12 -0400
Message-Id: <20221013001842.1893243-38-sashal@kernel.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit a6fc2f1b092787e9d7dbe472d720cede81680315 ]

This selects the SOF/ITP counter be running on ref_clk. As documented
U2_FREECLK_EXISTS has to be set to 0 as well.

Reviewed-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220915062855.751881-3-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 8 +++++++-
 drivers/usb/dwc3/core.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 08ca65ffe57b..019c79322850 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -408,6 +408,10 @@ static void dwc3_ref_clk_period(struct dwc3 *dwc)
 	reg |= FIELD_PREP(DWC3_GFLADJ_REFCLK_FLADJ_MASK, fladj)
 	    |  FIELD_PREP(DWC3_GFLADJ_240MHZDECR, decr >> 1)
 	    |  FIELD_PREP(DWC3_GFLADJ_240MHZDECR_PLS1, decr & 1);
+
+	if (dwc->gfladj_refclk_lpm_sel)
+		reg |=  DWC3_GFLADJ_REFCLK_LPM_SEL;
+
 	dwc3_writel(dwc->regs, DWC3_GFLADJ, reg);
 }
 
@@ -789,7 +793,7 @@ static int dwc3_phy_setup(struct dwc3 *dwc)
 	else
 		reg |= DWC3_GUSB2PHYCFG_ENBLSLPM;
 
-	if (dwc->dis_u2_freeclk_exists_quirk)
+	if (dwc->dis_u2_freeclk_exists_quirk || dwc->gfladj_refclk_lpm_sel)
 		reg &= ~DWC3_GUSB2PHYCFG_U2_FREECLK_EXISTS;
 
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
@@ -1491,6 +1495,8 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 				"snps,dis-tx-ipgap-linecheck-quirk");
 	dwc->parkmode_disable_ss_quirk = device_property_read_bool(dev,
 				"snps,parkmode-disable-ss-quirk");
+	dwc->gfladj_refclk_lpm_sel = device_property_read_bool(dev,
+				"snps,gfladj-refclk-lpm-sel-quirk");
 
 	dwc->tx_de_emphasis_quirk = device_property_read_bool(dev,
 				"snps,tx_de_emphasis_quirk");
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 81c486b3941c..725fb17e4a9e 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -390,6 +390,7 @@
 #define DWC3_GFLADJ_30MHZ_SDBND_SEL		BIT(7)
 #define DWC3_GFLADJ_30MHZ_MASK			0x3f
 #define DWC3_GFLADJ_REFCLK_FLADJ_MASK		GENMASK(21, 8)
+#define DWC3_GFLADJ_REFCLK_LPM_SEL		BIT(23)
 #define DWC3_GFLADJ_240MHZDECR			GENMASK(30, 24)
 #define DWC3_GFLADJ_240MHZDECR_PLS1		BIT(31)
 
@@ -1309,6 +1310,7 @@ struct dwc3 {
 	unsigned		dis_del_phy_power_chg_quirk:1;
 	unsigned		dis_tx_ipgap_linecheck_quirk:1;
 	unsigned		parkmode_disable_ss_quirk:1;
+	unsigned		gfladj_refclk_lpm_sel:1;
 
 	unsigned		tx_de_emphasis_quirk:1;
 	unsigned		tx_de_emphasis:2;
-- 
2.35.1

