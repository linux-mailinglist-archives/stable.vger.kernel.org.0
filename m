Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4337F461EDC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379335AbhK2SlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:41:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379534AbhK2SjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:39:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968A8B815DE;
        Mon, 29 Nov 2021 18:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47EDC53FAD;
        Mon, 29 Nov 2021 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210947;
        bh=Jz1cqIOMmDPtgH5wSYyvSCNbYK7HOuxV9Kbrd6KpoTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPGoJerr2x0UgujtCVycFUvtyaZ7asx9zU7yhL3369AELzEb8bDJ01bsgpucdcg2z
         WeZy8WEsZraNqCy+kr7WVlFDPfkcwdv/q0hIu0c3x1aRbAvvr12iPTjGSQS0+qzork
         y2vfWdf1H6vl/SXv0aG/YS3MGv2MpWVdHwZiayRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 050/179] mmc: sdhci-esdhc-imx: disable CMDQ support
Date:   Mon, 29 Nov 2021 19:17:24 +0100
Message-Id: <20211129181720.624044012@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

commit adab993c25191b839b415781bdc7173a77315240 upstream.

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
Fixes: cde5e8e9ff146 ("mmc: sdhci-esdhc-imx: Add an new esdhc_soc_data for i.MX8MM")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20211103165415.2016-1-tharvey@gateworks.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -300,7 +300,6 @@ static struct esdhc_soc_data usdhc_imx8q
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
-			| ESDHC_FLAG_CQHCI
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE
 			| ESDHC_FLAG_CLK_RATE_LOST_IN_PM_RUNTIME,
 };
@@ -309,7 +308,6 @@ static struct esdhc_soc_data usdhc_imx8m
 	.flags = ESDHC_FLAG_USDHC | ESDHC_FLAG_STD_TUNING
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
-			| ESDHC_FLAG_CQHCI
 			| ESDHC_FLAG_STATE_LOST_IN_LPMODE,
 };
 


