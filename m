Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D21E65A5
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 17:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404273AbgE1POa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 11:14:30 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:59867 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404271AbgE1PO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 11:14:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590678868; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=h4qi7yJ1wKkDLO7TOjVp4zfX/ugxHLRzaf+TIRV8OVw=; b=qruXaQh20mV5/e587tBs6oU6Fl2d9GnU1TZstbf1XUhQk+v60gv5BZM6k7XrQSm0Qjg2Dzgp
 xXkDb/OlAOYUCvT3KksCs/PKK0HBtiBxbFyU0EcV6s1Q9DvIKp+vALiFNCCuGlpy8jYrQYlO
 VJ+UzZag7T0yFuiWUASZM29FMXY=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5ecfd54f4776d1da6d686379 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 May 2020 15:14:23
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C996C433C6; Thu, 28 May 2020 15:14:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from vbadigan-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vbadigan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2423C433C9;
        Thu, 28 May 2020 15:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E2423C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=vbadigan@codeaurora.org
From:   Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
To:     adrian.hunter@intel.com, ulf.hansson@linaro.org,
        bjorn.andersson@linaro.org
Cc:     linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: [PATCH V1] mmc: sdhci-msm: Clear tuning done flag while hs400 tuning
Date:   Thu, 28 May 2020 20:43:52 +0530
Message-Id: <1590678838-18099-1-git-send-email-vbadigan@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clear tuning_done flag while executing tuning to ensure vendor
specific HS400 settings are applied properly when the controller
is re-initialized in HS400 mode.

Without this, re-initialization of the qcom SDHC in HS400 mode fails
while resuming the driver from runtime-suspend or system-suspend.

Fixes: ff06ce4 ("mmc: sdhci-msm: Add HS400 platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
---
 drivers/mmc/host/sdhci-msm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 95cd973..b277dd7 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1174,6 +1174,12 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	msm_host->use_cdr = true;
 
 	/*
+	 * Clear tuning_done flag before tuning to ensure proper
+	 * HS400 settings.
+	 */
+	msm_host->tuning_done = 0;
+
+	/*
 	 * For HS400 tuning in HS200 timing requires:
 	 * - select MCLK/2 in VENDOR_SPEC
 	 * - program MCLK to 400MHz (or nearest supported) in GCC
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

