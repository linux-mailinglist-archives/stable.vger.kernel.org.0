Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9138377E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhEQPoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343737AbhEQPmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9731A613AF;
        Mon, 17 May 2021 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262545;
        bh=1zpwEKforechk7vQAYEtjGDCktV27noGHzkPoFiniyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+EfnpLUVk8Xp9XyfXyAELfaJLqaXJ09F+XvEV/vR5Hlqys6GfHBwHlLWczBIRbhT
         vkZVRmuyWVvpJJ3cWFcEovwXw2tkZH9udKES7t2S/FSdmypbfonuB/Ic1iTcrmEcLA
         dlIel7ECcYTszxvYHNWHZ1aKIomqRDvApcqV8g1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.11 317/329] soc: mediatek: pm-domains: Add a meaningful power domain name
Date:   Mon, 17 May 2021 16:03:48 +0200
Message-Id: <20210517140312.813750966@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

commit 022b02b4505ecea5eda02b18683531e49f7d8eb7 upstream.

Add the power domains names to the power domain struct so we
have meaningful name for every power domain. This also removes the
following debugfs error message.

  [    2.242068] debugfs: Directory 'power-domain' with parent 'pm_genpd' already present!
  [    2.249949] debugfs: Directory 'power-domain' with parent 'pm_genpd' already present!
  [    2.257784] debugfs: Directory 'power-domain' with parent 'pm_genpd' already present!
  ...

Fixes: 59b644b01cf4 ("soc: mediatek: Add MediaTek SCPSYS power domains")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210225175000.824661-1-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mt8173-pm-domains.h |   10 ++++++++++
 drivers/soc/mediatek/mtk-pm-domains.c    |    6 +++++-
 drivers/soc/mediatek/mtk-pm-domains.h    |    2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/soc/mediatek/mt8173-pm-domains.h
+++ b/drivers/soc/mediatek/mt8173-pm-domains.h
@@ -12,24 +12,28 @@
 
 static const struct scpsys_domain_data scpsys_domain_data_mt8173[] = {
 	[MT8173_POWER_DOMAIN_VDEC] = {
+		.name = "vdec",
 		.sta_mask = PWR_STATUS_VDEC,
 		.ctl_offs = SPM_VDE_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8173_POWER_DOMAIN_VENC] = {
+		.name = "venc",
 		.sta_mask = PWR_STATUS_VENC,
 		.ctl_offs = SPM_VEN_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(15, 12),
 	},
 	[MT8173_POWER_DOMAIN_ISP] = {
+		.name = "isp",
 		.sta_mask = PWR_STATUS_ISP,
 		.ctl_offs = SPM_ISP_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(13, 12),
 	},
 	[MT8173_POWER_DOMAIN_MM] = {
+		.name = "mm",
 		.sta_mask = PWR_STATUS_DISP,
 		.ctl_offs = SPM_DIS_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -40,18 +44,21 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8173_POWER_DOMAIN_VENC_LT] = {
+		.name = "venc_lt",
 		.sta_mask = PWR_STATUS_VENC_LT,
 		.ctl_offs = SPM_VEN2_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(15, 12),
 	},
 	[MT8173_POWER_DOMAIN_AUDIO] = {
+		.name = "audio",
 		.sta_mask = PWR_STATUS_AUDIO,
 		.ctl_offs = SPM_AUDIO_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(15, 12),
 	},
 	[MT8173_POWER_DOMAIN_USB] = {
+		.name = "usb",
 		.sta_mask = PWR_STATUS_USB,
 		.ctl_offs = SPM_USB_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -59,18 +66,21 @@ static const struct scpsys_domain_data s
 		.caps = MTK_SCPD_ACTIVE_WAKEUP,
 	},
 	[MT8173_POWER_DOMAIN_MFG_ASYNC] = {
+		.name = "mfg_async",
 		.sta_mask = PWR_STATUS_MFG_ASYNC,
 		.ctl_offs = SPM_MFG_ASYNC_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = 0,
 	},
 	[MT8173_POWER_DOMAIN_MFG_2D] = {
+		.name = "mfg_2d",
 		.sta_mask = PWR_STATUS_MFG_2D,
 		.ctl_offs = SPM_MFG_2D_PWR_CON,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(13, 12),
 	},
 	[MT8173_POWER_DOMAIN_MFG] = {
+		.name = "mfg",
 		.sta_mask = PWR_STATUS_MFG,
 		.ctl_offs = SPM_MFG_PWR_CON,
 		.sram_pdn_bits = GENMASK(13, 8),
--- a/drivers/soc/mediatek/mtk-pm-domains.c
+++ b/drivers/soc/mediatek/mtk-pm-domains.c
@@ -397,7 +397,11 @@ generic_pm_domain *scpsys_add_one_domain
 		goto err_unprepare_subsys_clocks;
 	}
 
-	pd->genpd.name = node->name;
+	if (!pd->data->name)
+		pd->genpd.name = node->name;
+	else
+		pd->genpd.name = pd->data->name;
+
 	pd->genpd.power_off = scpsys_power_off;
 	pd->genpd.power_on = scpsys_power_on;
 
--- a/drivers/soc/mediatek/mtk-pm-domains.h
+++ b/drivers/soc/mediatek/mtk-pm-domains.h
@@ -74,6 +74,7 @@ struct scpsys_bus_prot_data {
 
 /**
  * struct scpsys_domain_data - scp domain data for power on/off flow
+ * @name: The name of the power domain.
  * @sta_mask: The mask for power on/off status bit.
  * @ctl_offs: The offset for main power control register.
  * @sram_pdn_bits: The mask for sram power control bits.
@@ -83,6 +84,7 @@ struct scpsys_bus_prot_data {
  * @bp_smi: bus protection for smi subsystem
  */
 struct scpsys_domain_data {
+	const char *name;
 	u32 sta_mask;
 	int ctl_offs;
 	u32 sram_pdn_bits;


