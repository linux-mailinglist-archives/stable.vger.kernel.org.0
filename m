Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1213F4F1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733195AbgAPRIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389376AbgAPRIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4E0205F4;
        Thu, 16 Jan 2020 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194498;
        bh=eIgptUVK7RSEOmpu2bxskleTrU5m+xjTInP8YUwnX0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xF+D4psUuPDDH+Wn7ZZrph0K5/2zoVcjaKEdLPGsxRoeEpTnfBawiSRNzQp/CZV/b
         iXGSDD8YvXaH71H2ErV90ALtzcIHhIYEE/a1VGcMttN1c+Yfo7hgdiMxAkxKQTvoR6
         JtJNxV+TtS6DGBnTJ1RomnYQR6k+teCcWMMX0fb0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 395/671] cpufreq: brcmstb-avs-cpufreq: Fix types for voltage/frequency
Date:   Thu, 16 Jan 2020 12:00:33 -0500
Message-Id: <20200116170509.12787-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 4c5681fcc684c762b09435de3e82ffeee7769d21 ]

What we read back from the register is going to be capped at 32-bits,
and cpufreq_freq_table.frequency is an unsigned int. Avoid any possible
value truncation by using the appropriate return value.

Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index 6ed53ca8aa98..77b0e5d0fb13 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -384,12 +384,12 @@ static int brcm_avs_set_pstate(struct private_data *priv, unsigned int pstate)
 	return __issue_avs_command(priv, AVS_CMD_SET_PSTATE, true, args);
 }
 
-static unsigned long brcm_avs_get_voltage(void __iomem *base)
+static u32 brcm_avs_get_voltage(void __iomem *base)
 {
 	return readl(base + AVS_MBOX_VOLTAGE1);
 }
 
-static unsigned long brcm_avs_get_frequency(void __iomem *base)
+static u32 brcm_avs_get_frequency(void __iomem *base)
 {
 	return readl(base + AVS_MBOX_FREQUENCY) * 1000;	/* in kHz */
 }
@@ -653,14 +653,14 @@ static ssize_t show_brcm_avs_voltage(struct cpufreq_policy *policy, char *buf)
 {
 	struct private_data *priv = policy->driver_data;
 
-	return sprintf(buf, "0x%08lx\n", brcm_avs_get_voltage(priv->base));
+	return sprintf(buf, "0x%08x\n", brcm_avs_get_voltage(priv->base));
 }
 
 static ssize_t show_brcm_avs_frequency(struct cpufreq_policy *policy, char *buf)
 {
 	struct private_data *priv = policy->driver_data;
 
-	return sprintf(buf, "0x%08lx\n", brcm_avs_get_frequency(priv->base));
+	return sprintf(buf, "0x%08x\n", brcm_avs_get_frequency(priv->base));
 }
 
 cpufreq_freq_attr_ro(brcm_avs_pstate);
-- 
2.20.1

