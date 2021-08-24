Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EB53F561A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhHXC7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234452AbhHXC65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E4161181;
        Tue, 24 Aug 2021 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773894;
        bh=jAg9es8Z/Ar6y2dDImtNKiMYHIRpU49HNcaL6VyG9TA=;
        h=From:To:Cc:Subject:Date:From;
        b=TPc8VQ7U1l7HG6R66oXR3F4/iLckqPJ21lllluwxxgaJeuAm3aRCsV5/unSVpiD8C
         c3WwP6i6z89PJEF9mxaENxrr7jvGbySf+qKjF+NRdsOLto93KdiUQlgX8z+Wft/9iD
         LgOG/Q/LJvOtN1UcPQen4b0/SCuKnKcvSKKPVooiesVGjExZ3bbuC6itV9e0OTtUZt
         T+lPNHmZi+E/kh2d5C50DxJPxHDXr60wLwfjLE+rWUYljCWGtSvvtSNrAq6NAqed9L
         QMC89pJFDuhMSbDxf0NHqFBvW/fCOMgFJHQcIYhR6C8LX189hMrFeZf0dIOMSnoMQQ
         7auvpTs1I9WgA==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, sbhanu@codeaurora.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: FAILED: Patch "mmc: sdhci-msm: Update the software timeout value for sdhc" failed to apply to 4.19-stable tree
Date:   Mon, 23 Aug 2021 22:58:12 -0400
Message-Id: <20210824025812.658905-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 67b13f3e221ed81b46a657e2b499bf8b20162476 Mon Sep 17 00:00:00 2001
From: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
Date: Fri, 16 Jul 2021 17:16:14 +0530
Subject: [PATCH] mmc: sdhci-msm: Update the software timeout value for sdhc

Whenever SDHC run at clock rate 50MHZ or below, the hardware data
timeout value will be 21.47secs, which is approx. 22secs and we have
a current software timeout value as 10secs. We have to set software
timeout value more than the hardware data timeout value to avioid seeing
the below register dumps.

[  332.953670] mmc2: Timeout waiting for hardware interrupt.
[  332.959608] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[  332.966450] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00007202
[  332.973256] mmc2: sdhci: Blk size:  0x00000200 | Blk cnt:  0x00000001
[  332.980054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000027
[  332.986864] mmc2: sdhci: Present:   0x01f801f6 | Host ctl: 0x0000001f
[  332.993671] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
[  333.000583] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
[  333.007386] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
[  333.014182] mmc2: sdhci: Int enab:  0x03ff100b | Sig enab: 0x03ff100b
[  333.020976] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
[  333.027771] mmc2: sdhci: Caps:      0x322dc8b2 | Caps_1:   0x0000808f
[  333.034561] mmc2: sdhci: Cmd:       0x0000183a | Max curr: 0x00000000
[  333.041359] mmc2: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x00000000
[  333.048157] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
[  333.054945] mmc2: sdhci: Host ctl2: 0x00000000
[  333.059657] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
0x0000000ffffff218
[  333.067178] mmc2: sdhci_msm: ----------- VENDOR REGISTER DUMP
-----------
[  333.074343] mmc2: sdhci_msm: DLL sts: 0x00000000 | DLL cfg:
0x6000642c | DLL cfg2: 0x0020a000
[  333.083417] mmc2: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl:
0x00000000 | DDR cfg: 0x80040873
[  333.092850] mmc2: sdhci_msm: Vndr func: 0x00008a9c | Vndr func2 :
0xf88218a8 Vndr func3: 0x02626040
[  333.102371] mmc2: sdhci: ============================================

So, set software timeout value more than hardware timeout value.

Signed-off-by: Shaik Sajida Bhanu <sbhanu@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1626435974-14462-1-git-send-email-sbhanu@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-msm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e44b7a66b73c..290a14cdc1cf 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -2089,6 +2089,23 @@ static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)
 	sdhci_cqe_disable(mmc, recovery);
 }
 
+static void sdhci_msm_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+{
+	u32 count, start = 15;
+
+	__sdhci_set_timeout(host, cmd);
+	count = sdhci_readb(host, SDHCI_TIMEOUT_CONTROL);
+	/*
+	 * Update software timeout value if its value is less than hardware data
+	 * timeout value. Qcom SoC hardware data timeout value was calculated
+	 * using 4 * MCLK * 2^(count + 13). where MCLK = 1 / host->clock.
+	 */
+	if (cmd && cmd->data && host->clock > 400000 &&
+	    host->clock <= 50000000 &&
+	    ((1 << (count + start)) > (10 * host->clock)))
+		host->data_timeout = 22LL * NSEC_PER_SEC;
+}
+
 static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
 	.enable		= sdhci_msm_cqe_enable,
 	.disable	= sdhci_msm_cqe_disable,
@@ -2438,6 +2455,7 @@ static const struct sdhci_ops sdhci_msm_ops = {
 	.irq	= sdhci_msm_cqe_irq,
 	.dump_vendor_regs = sdhci_msm_dump_vendor_regs,
 	.set_power = sdhci_set_power_noreg,
+	.set_timeout = sdhci_msm_set_timeout,
 };
 
 static const struct sdhci_pltfm_data sdhci_msm_pdata = {
-- 
2.30.2




