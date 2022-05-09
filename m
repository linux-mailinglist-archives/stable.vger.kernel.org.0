Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E912651F70D
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiEIIqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbiEII22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F01E7823
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90AD06148E
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D4DC385A8;
        Mon,  9 May 2022 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652084656;
        bh=Fw4Y3FvP84jIl5OQ3/ut2dScmhJ6r8uFnwnaQvBrLgE=;
        h=Subject:To:Cc:From:Date:From;
        b=U7NqIGJZSuEd/9BykeFOLJjN0dgle837Iu/wZIPrzv3dbwmff+9LAL54yfDuV1Hr7
         hPspMkHwL9VcqnLT7FcCRvwkrwRs0PvLgwjQv/OJVGOj7VgpyBsnghNpnouXFpRYSE
         ZBeCycjylBrkvJtMniiDt+wXciVgUSonFAgnHI6k=
Subject: FAILED: patch "[PATCH] mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC" failed to apply to 4.19-stable tree
To:     quic_c_sbhanu@quicinc.com, adrian.hunter@intel.com,
        konrad.dybcio@somainline.org, p.zabel@pengutronix.de,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:24:02 +0200
Message-ID: <1652084642126203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3e5a8e8494a8122fe4eb3f167662f406cab753b9 Mon Sep 17 00:00:00 2001
From: Shaik Sajida Bhanu <quic_c_sbhanu@quicinc.com>
Date: Sun, 24 Apr 2022 21:32:33 +0530
Subject: [PATCH] mmc: sdhci-msm: Reset GCC_SDCC_BCR register for SDHC

Reset GCC_SDCC_BCR register before every fresh initilazation. This will
reset whole SDHC-msm controller, clears the previous power control
states and avoids, software reset timeout issues as below.

[ 5.458061][ T262] mmc1: Reset 0x1 never completed.
[ 5.462454][ T262] mmc1: sdhci: ============ SDHCI REGISTER DUMP ===========
[ 5.469065][ T262] mmc1: sdhci: Sys addr: 0x00000000 | Version: 0x00007202
[ 5.475688][ T262] mmc1: sdhci: Blk size: 0x00000000 | Blk cnt: 0x00000000
[ 5.482315][ T262] mmc1: sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[ 5.488927][ T262] mmc1: sdhci: Present: 0x01f800f0 | Host ctl: 0x00000000
[ 5.495539][ T262] mmc1: sdhci: Power: 0x00000000 | Blk gap: 0x00000000
[ 5.502162][ T262] mmc1: sdhci: Wake-up: 0x00000000 | Clock: 0x00000003
[ 5.508768][ T262] mmc1: sdhci: Timeout: 0x00000000 | Int stat: 0x00000000
[ 5.515381][ T262] mmc1: sdhci: Int enab: 0x00000000 | Sig enab: 0x00000000
[ 5.521996][ T262] mmc1: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
[ 5.528607][ T262] mmc1: sdhci: Caps: 0x362dc8b2 | Caps_1: 0x0000808f
[ 5.535227][ T262] mmc1: sdhci: Cmd: 0x00000000 | Max curr: 0x00000000
[ 5.541841][ T262] mmc1: sdhci: Resp[0]: 0x00000000 | Resp[1]: 0x00000000
[ 5.548454][ T262] mmc1: sdhci: Resp[2]: 0x00000000 | Resp[3]: 0x00000000
[ 5.555079][ T262] mmc1: sdhci: Host ctl2: 0x00000000
[ 5.559651][ T262] mmc1: sdhci_msm: ----------- VENDOR REGISTER DUMP-----------
[ 5.566621][ T262] mmc1: sdhci_msm: DLL sts: 0x00000000 | DLL cfg: 0x6000642c | DLL cfg2: 0x0020a000
[ 5.575465][ T262] mmc1: sdhci_msm: DLL cfg3: 0x00000000 | DLL usr ctl: 0x00010800 | DDR cfg: 0x80040873
[ 5.584658][ T262] mmc1: sdhci_msm: Vndr func: 0x00018a9c | Vndr func2 : 0xf88218a8 Vndr func3: 0x02626040

Fixes: 0eb0d9f4de34 ("mmc: sdhci-msm: Initial support for Qualcomm chipsets")
Signed-off-by: Shaik Sajida Bhanu <quic_c_sbhanu@quicinc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1650816153-23797-1-git-send-email-quic_c_sbhanu@quicinc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 50c71e0ba5e4..ff9f5b63c337 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -17,6 +17,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/interconnect.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/reset.h>
 
 #include "sdhci-pltfm.h"
 #include "cqhci.h"
@@ -2482,6 +2483,43 @@ static inline void sdhci_msm_get_of_property(struct platform_device *pdev,
 	of_property_read_u32(node, "qcom,dll-config", &msm_host->dll_config);
 }
 
+static int sdhci_msm_gcc_reset(struct device *dev, struct sdhci_host *host)
+{
+	struct reset_control *reset;
+	int ret = 0;
+
+	reset = reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(reset))
+		return dev_err_probe(dev, PTR_ERR(reset),
+				"unable to acquire core_reset\n");
+
+	if (!reset)
+		return ret;
+
+	ret = reset_control_assert(reset);
+	if (ret) {
+		reset_control_put(reset);
+		return dev_err_probe(dev, ret, "core_reset assert failed\n");
+	}
+
+	/*
+	 * The hardware requirement for delay between assert/deassert
+	 * is at least 3-4 sleep clock (32.7KHz) cycles, which comes to
+	 * ~125us (4/32768). To be on the safe side add 200us delay.
+	 */
+	usleep_range(200, 210);
+
+	ret = reset_control_deassert(reset);
+	if (ret) {
+		reset_control_put(reset);
+		return dev_err_probe(dev, ret, "core_reset deassert failed\n");
+	}
+
+	usleep_range(200, 210);
+	reset_control_put(reset);
+
+	return ret;
+}
 
 static int sdhci_msm_probe(struct platform_device *pdev)
 {
@@ -2529,6 +2567,10 @@ static int sdhci_msm_probe(struct platform_device *pdev)
 
 	msm_host->saved_tuning_phase = INVALID_TUNING_PHASE;
 
+	ret = sdhci_msm_gcc_reset(&pdev->dev, host);
+	if (ret)
+		goto pltfm_free;
+
 	/* Setup SDCC bus voter clock. */
 	msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus");
 	if (!IS_ERR(msm_host->bus_clk)) {

