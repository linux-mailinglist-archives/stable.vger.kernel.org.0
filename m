Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99D544465A
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhKCQ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:57:04 -0400
Received: from finn.gateworks.com ([108.161.129.64]:59556 "EHLO
        finn.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232960AbhKCQ5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 12:57:04 -0400
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1miJWj-007u4e-Tl; Wed, 03 Nov 2021 16:54:18 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        BOUGH CHEN <haibo.chen@nxp.com>, linux-mmc@vger.kernel.org,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        Adam Ford <aford173@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org
Subject: [PATCH] mmc: sdhci-esdhc-imx: disable CMDQ support
Date:   Wed,  3 Nov 2021 09:54:15 -0700
Message-Id: <20211103165415.2016-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAJ+vNU3zKEVz=fHu2hLmEpsQKzinUFW-28Lm=2wSEghjMvQtmw@mail.gmail.com>
References: <CAJ+vNU3zKEVz=fHu2hLmEpsQKzinUFW-28Lm=2wSEghjMvQtmw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On IMX SoC's which support CMDQ the following can occur during high a
high cpu load:

mmc2: cqhci: ============ CQHCI REGISTER DUMP ===========
mmc2: cqhci: Caps:      0x0000310a | Version:  0x00000510
mmc2: cqhci: Config:    0x00001001 | Control:  0x00000000
mmc2: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
mmc2: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
mmc2: cqhci: TDL base:  0x8003f000 | TDL up32: 0x00000000
mmc2: cqhci: Doorbell:  0xbf01dfff | TCN:      0x00000000
mmc2: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x08000000
mmc2: cqhci: Task clr:  0x00000000 | SSC1:     0x00011000
mmc2: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000800
mmc2: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
mmc2: cqhci: Resp idx:  0x0000000d | Resp arg: 0x00000000
mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
mmc2: sdhci: Sys addr:  0x7c722000 | Version:  0x00000002
mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000020
mmc2: sdhci: Argument:  0x00018000 | Trn mode: 0x00000023
mmc2: sdhci: Present:   0x01f88008 | Host ctl: 0x00000030
mmc2: sdhci: Power:     0x00000002 | Blk gap:  0x00000080
mmc2: sdhci: Wake-up:   0x00000008 | Clock:    0x0000000f
mmc2: sdhci: Timeout:   0x0000008f | Int stat: 0x00000000
mmc2: sdhci: Int enab:  0x107f4000 | Sig enab: 0x107f4000
mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000502
mmc2: sdhci: Caps:      0x07eb0000 | Caps_1:   0x8000b407
mmc2: sdhci: Cmd:       0x00000d1a | Max curr: 0x00ffffff
mmc2: sdhci: Resp[0]:   0x00000000 | Resp[1]:  0xffc003ff
mmc2: sdhci: Resp[2]:   0x328f5903 | Resp[3]:  0x00d07f01
mmc2: sdhci: Host ctl2: 0x00000088
mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0xfe179020
mmc2: sdhci-esdhc-imx: ========= ESDHC IMX DEBUG STATUS DUMP ====
mmc2: sdhci-esdhc-imx: cmd debug status:  0x2120
mmc2: sdhci-esdhc-imx: data debug status:  0x2200
mmc2: sdhci-esdhc-imx: trans debug status:  0x2300
mmc2: sdhci-esdhc-imx: dma debug status:  0x2400
mmc2: sdhci-esdhc-imx: adma debug status:  0x2510
mmc2: sdhci-esdhc-imx: fifo debug status:  0x2680
mmc2: sdhci-esdhc-imx: async fifo debug status:  0x2750
mmc2: sdhci: ============================================

For now, disable CMDQ support on the imx8qm/imx8qxp/imx8mm until the
issue is found and resolved.

Fixes: bb6e358169bf6 ("mmc: sdhci-esdhc-imx: add CMDQ support")
Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data
for i.MX8MM")

Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index e658f0174242..60f19369de84 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -300,7 +300,6 @@ static struct esdhc_soc_data usdhc_imx8qxp_data = {
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
-			| ESDHC_FLAG_CQHCI
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE
 			| ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
 };
@@ -309,7 +308,6 @@ static struct esdhc_soc_data usdhc_imx8mm_data = {
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
-			| ESDHC_FLAG_CQHCI
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
 };
 
-- 
2.17.1

