Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FAA51A81E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347605AbiEDRIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354588AbiEDRFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257BE51323;
        Wed,  4 May 2022 09:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D16D461505;
        Wed,  4 May 2022 16:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B1C385AA;
        Wed,  4 May 2022 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683252;
        bh=RYtp1i53ScDXczlIDSN87PZNZT1pdmCQ3DDS44by5LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMVv852LbKinRwBB1RpB6bOWbvT73Pgqgt9fLSAfTumtYCGVg4uYcq9dHkSn8PONj
         iMlkbd0POuDhZ1zBAGvp3Gv6nAYwd/zlTHm3ckYtYbpdH1x63/Tke/usMzDwdSMVry
         DUbva5BNJ8hoflIQr4rc9WMFWpQ1fnFRfymNyXaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/177] cpufreq: qcom-cpufreq-hw: Clear dcvs interrupts
Date:   Wed,  4 May 2022 18:44:58 +0200
Message-Id: <20220504153102.641150753@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit e4e6448638a01905faeda9bf96aa9df7c8ef463c ]

It's noted that dcvs interrupts are not self-clearing, thus an interrupt
handler runs constantly, which leads to a severe regression in runtime.
To fix the problem an explicit write to clear interrupt register is
required, note that on OSM platforms the register may not be present.

Fixes: 275157b367f4 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index e73ecab23c85..bb2f59fd0de4 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -24,6 +24,8 @@
 #define CLK_HW_DIV			2
 #define LUT_TURBO_IND			1
 
+#define GT_IRQ_STATUS			BIT(2)
+
 #define HZ_PER_KHZ			1000
 
 struct qcom_cpufreq_soc_data {
@@ -31,6 +33,7 @@ struct qcom_cpufreq_soc_data {
 	u32 reg_domain_state;
 	u32 reg_freq_lut;
 	u32 reg_volt_lut;
+	u32 reg_intr_clr;
 	u32 reg_current_vote;
 	u32 reg_perf_state;
 	u8 lut_row_size;
@@ -349,6 +352,10 @@ static irqreturn_t qcom_lmh_dcvs_handle_irq(int irq, void *data)
 	disable_irq_nosync(c_data->throttle_irq);
 	schedule_delayed_work(&c_data->throttle_work, 0);
 
+	if (c_data->soc_data->reg_intr_clr)
+		writel_relaxed(GT_IRQ_STATUS,
+			       c_data->base + c_data->soc_data->reg_intr_clr);
+
 	return IRQ_HANDLED;
 }
 
@@ -366,6 +373,7 @@ static const struct qcom_cpufreq_soc_data epss_soc_data = {
 	.reg_domain_state = 0x20,
 	.reg_freq_lut = 0x100,
 	.reg_volt_lut = 0x200,
+	.reg_intr_clr = 0x308,
 	.reg_perf_state = 0x320,
 	.lut_row_size = 4,
 };
-- 
2.35.1



