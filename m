Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3270329B732
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760762AbgJ0PaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797737AbgJ0PaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52FB722264;
        Tue, 27 Oct 2020 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812604;
        bh=7eJIhGU+LhBF44KrW7v9gCBclDyX+xR1ykuZGzElen8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fn5ZrxIBNhLCqDKnXm2MIaoV3JhvPqeRjA8o6UKiI5BK6dzIWCNREOcfNoa4kpwE2
         NR2vhYODXG+pMPJY/GwBk65KhSi92ABD4gR2FpGCSwA2Q07IREBhjTW/uphdaTZIMp
         N9MInOeotdgkIPJK8wq8nWaP8v73xwoGqa4oZEHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 267/757] cpufreq: qcom: Dont add frequencies without an OPP
Date:   Tue, 27 Oct 2020 14:48:37 +0100
Message-Id: <20201027135503.097951412@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit bc9b9c5ab9d8d16157737db539929d57562926e9 ]

The driver currently adds all frequencies from the hardware LUT to
the cpufreq table, regardless of whether the corresponding OPP
exists. This prevents devices from disabling certain OPPs through
the device tree and can result in CPU frequencies for which the
interconnect bandwidth can't be adjusted. Only add frequencies
with an OPP entry.

Fixes: 55538fbc79e9 ("cpufreq: qcom: Read voltage LUT and populate OPP")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 3fb044b907a83..47b7d394d2abb 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -177,10 +177,15 @@ static int qcom_cpufreq_hw_read_lut(struct device *cpu_dev,
 			freq = cpu_hw_rate / 1000;
 
 		if (freq != prev_freq && core_count != LUT_TURBO_IND) {
-			table[i].frequency = freq;
-			qcom_cpufreq_update_opp(cpu_dev, freq, volt);
-			dev_dbg(cpu_dev, "index=%d freq=%d, core_count %d\n", i,
+			if (!qcom_cpufreq_update_opp(cpu_dev, freq, volt)) {
+				table[i].frequency = freq;
+				dev_dbg(cpu_dev, "index=%d freq=%d, core_count %d\n", i,
 				freq, core_count);
+			} else {
+				dev_warn(cpu_dev, "failed to update OPP for freq=%d\n", freq);
+				table[i].frequency = CPUFREQ_ENTRY_INVALID;
+			}
+
 		} else if (core_count == LUT_TURBO_IND) {
 			table[i].frequency = CPUFREQ_ENTRY_INVALID;
 		}
@@ -197,9 +202,13 @@ static int qcom_cpufreq_hw_read_lut(struct device *cpu_dev,
 			 * as the boost frequency
 			 */
 			if (prev->frequency == CPUFREQ_ENTRY_INVALID) {
-				prev->frequency = prev_freq;
-				prev->flags = CPUFREQ_BOOST_FREQ;
-				qcom_cpufreq_update_opp(cpu_dev, prev_freq, volt);
+				if (!qcom_cpufreq_update_opp(cpu_dev, prev_freq, volt)) {
+					prev->frequency = prev_freq;
+					prev->flags = CPUFREQ_BOOST_FREQ;
+				} else {
+					dev_warn(cpu_dev, "failed to update OPP for freq=%d\n",
+						 freq);
+				}
 			}
 
 			break;
-- 
2.25.1



