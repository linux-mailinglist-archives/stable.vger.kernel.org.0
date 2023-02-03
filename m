Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3A68965C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjBCKaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjBCK34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:29:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01C9F9FC
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F3E861E42
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C365C433D2;
        Fri,  3 Feb 2023 10:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420146;
        bh=Jgvf4IAQ74ZPm7yk7Gyo3dz93avV+nmHPWYrBczU29A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJthdsmI/gn8oFUGiGbdMwEelYrh01nElukweTyKrAOxww/vZ4kkqRWdHdDnNoN8G
         Eqxt09gOeBzGRwl9QWbg+LY89ZRjmIoFLCMprgpbLy+kcyEJ4otFNfQjyE7Ci03Ucs
         w9/8am0u0THrErO5fLZ2tyCabRP39p7gODgP4g54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/134] mmc: sdhci-esdhc-imx: clear pending interrupt and halt cqhci
Date:   Fri,  3 Feb 2023 11:12:50 +0100
Message-Id: <20230203101026.798340296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 982cf37da3ee0f1e3e20d97e19f13cba79be51c7 ]

On i.MX8MM, we are running Dual Linux OS, with 1st Linux using SD Card
as rootfs storage, 2nd Linux using eMMC as rootfs storage. We let the
the 1st linux configure power/clock for the 2nd Linux.

When the 2nd Linux is booting into rootfs stage, we let the 1st Linux
to destroy the 2nd linux, then restart the 2nd linux, we met SDHCI dump
as following, after we clear the pending interrupt and halt CQCTL, issue
gone.

[ 1.334594] mmc2: Got command interrupt 0x00000001 even though no command operation was in progress.
[ 1.334595] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[ 1.334599] mmc2: sdhci: Sys addr: 0xa05dcc00 | Version: 0x00000002
[ 1.345538] mmc2: sdhci: Blk size: 0x00000200 | Blk cnt: 0x00000000
[ 1.345541] mmc2: sdhci: Argument: 0x00018000 | Trn mode: 0x00000033
[ 1.345543] mmc2: sdhci: Present: 0x01f88008 | Host ctl: 0x00000031
[ 1.345547] mmc2: sdhci: Power: 0x00000002 | Blk gap: 0x00000080
[ 1.357903] mmc2: sdhci: Wake-up: 0x00000008 | Clock: 0x0000003f
[ 1.357905] mmc2: sdhci: Timeout: 0x0000008f | Int stat: 0x00000000
[ 1.357908] mmc2: sdhci: Int enab: 0x107f100b | Sig enab: 0x107f100b
[ 1.357911] mmc2: sdhci: AC12 err: 0x00000000 | Slot int: 0x00000502
[ 1.370268] mmc2: sdhci: Caps: 0x07eb0000 | Caps_1: 0x0000b400
[ 1.370270] mmc2: sdhci: Cmd: 0x00000d1a | Max curr: 0x00ffffff
[ 1.370273] mmc2: sdhci: Resp[0]: 0x00000b00 | Resp[1]: 0xffffffff
[ 1.370276] mmc2: sdhci: Resp[2]: 0x328f5903 | Resp[3]: 0x00d00f00
[ 1.382132] mmc2: sdhci: Host ctl2: 0x00000000
[ 1.382135] mmc2: sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0xa2040208

[ 2.060932] mmc2: Unexpected interrupt 0x00004000.
[ 2.065538] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[ 2.071720] mmc2: sdhci: Sys addr: 0x00000000 | Version: 0x00000002
[ 2.077902] mmc2: sdhci: Blk size: 0x00000200 | Blk cnt: 0x00000001
[ 2.084083] mmc2: sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[ 2.090264] mmc2: sdhci: Present: 0x01f88009 | Host ctl: 0x00000011
[ 2.096446] mmc2: sdhci: Power: 0x00000002 | Blk gap: 0x00000080
[ 2.102627] mmc2: sdhci: Wake-up: 0x00000008 | Clock: 0x000010ff
[ 2.108809] mmc2: sdhci: Timeout: 0x0000008f | Int stat: 0x00004000
[ 2.114990] mmc2: sdhci: Int enab: 0x007f1003 | Sig enab: 0x007f1003
[ 2.121171] mmc2: sdhci: AC12 err: 0x00000000 | Slot int: 0x00000502
[ 2.127353] mmc2: sdhci: Caps: 0x07eb0000 | Caps_1: 0x0000b400
[ 2.133534] mmc2: sdhci: Cmd: 0x0000371a | Max curr: 0x00ffffff
[ 2.139715] mmc2: sdhci: Resp[0]: 0x00000900 | Resp[1]: 0xffffffff
[ 2.145896] mmc2: sdhci: Resp[2]: 0x328f5903 | Resp[3]: 0x00d00f00
[ 2.152077] mmc2: sdhci: Host ctl2: 0x00000000
[ 2.156342] mmc2: sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x00000000

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1582100757-20683-6-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 96cad561e1d8..22bb5499f515 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1180,6 +1180,7 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
+	struct cqhci_host *cq_host = host->mmc->cqe_private;
 	int tmp;
 
 	if (esdhc_is_usdhc(imx_data)) {
@@ -1256,6 +1257,21 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 			tmp &= ~ESDHC_STD_TUNING_EN;
 			writel(tmp, host->ioaddr + ESDHC_TUNING_CTRL);
 		}
+
+		/*
+		 * On i.MX8MM, we are running Dual Linux OS, with 1st Linux using SD Card
+		 * as rootfs storage, 2nd Linux using eMMC as rootfs storage. We let the
+		 * the 1st linux configure power/clock for the 2nd Linux.
+		 *
+		 * When the 2nd Linux is booting into rootfs stage, we let the 1st Linux
+		 * to destroy the 2nd linux, then restart the 2nd linux, we met SDHCI dump.
+		 * After we clear the pending interrupt and halt CQCTL, issue gone.
+		 */
+		if (cq_host) {
+			tmp = cqhci_readl(cq_host, CQHCI_IS);
+			cqhci_writel(cq_host, tmp, CQHCI_IS);
+			cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);
+		}
 	}
 }
 
-- 
2.39.0



