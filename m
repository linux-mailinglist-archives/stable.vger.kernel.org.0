Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC90729B1F3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760773AbgJ0OgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760768AbgJ0OgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D1E207BB;
        Tue, 27 Oct 2020 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809381;
        bh=YkkYWDzcsvDDMuqk9l3jQRFPM0NSm00iUyOHSx3m5YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+aStNhFNsWofUw6M5sVpym/UCjJK0USq3knuM76g/J6TIRU7kHFeQt8Qrkiaa98d
         26jtfJgfNejwqsrYQNbrcG9PPjN1iEBOVoqEH+epf1wuX4IhPoaYdUwe+h43HSche7
         mhtJYlpuoH1sn9wyfpZfPZ42KM02cr3AiavUX61Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/408] iio: adc: stm32-adc: fix runtime autosuspend delay when slow polling
Date:   Tue, 27 Oct 2020 14:51:53 +0100
Message-Id: <20201027135503.211263196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit c537d3457542a398caa1fe58e0976c5f83cf7281 ]

When the ADC is runtime suspended and starting a conversion, the stm32-adc
driver calls pm_runtime_get_sync() that gets cascaded to the parent
(e.g. runtime resume of stm32-adc-core driver). This also kicks the
autosuspend delay (e.g. 2s) of the parent.
Once the ADC is active, calling pm_runtime_get_sync() again (upon a new
capture) won't kick the autosuspend delay for the parent (stm32-adc-core
driver) as already active.

Currently, this makes the stm32-adc-core driver go in suspend state
every 2s when doing slow polling. As an example, doing a capture, e.g.
cat in_voltageY_raw at a 0.2s rate, the auto suspend delay for the parent
isn't refreshed. Once it expires, the parent immediately falls into
runtime suspended state, in between two captures, as soon as the child
driver falls into runtime suspend state:
- e.g. after 2s, + child calls pm_runtime_put_autosuspend() + 100ms
  autosuspend delay of the child.
- stm32-adc-core switches off regulators, clocks and so on.
- They get switched on back again 100ms later in this example (at 2.2s).

So, use runtime_idle() callback in stm32-adc-core driver to call
pm_runtime_mark_last_busy() for the parent driver (stm32-adc-core),
to avoid this.

Fixes: 9bdbb1139ca1 ("iio: adc: stm32-adc: add power management support")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/1593615328-5180-1-git-send-email-fabrice.gasnier@st.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index 74f3a2be17a64..14d6a537289cb 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -780,6 +780,13 @@ static int stm32_adc_core_runtime_resume(struct device *dev)
 {
 	return stm32_adc_core_hw_start(dev);
 }
+
+static int stm32_adc_core_runtime_idle(struct device *dev)
+{
+	pm_runtime_mark_last_busy(dev);
+
+	return 0;
+}
 #endif
 
 static const struct dev_pm_ops stm32_adc_core_pm_ops = {
@@ -787,7 +794,7 @@ static const struct dev_pm_ops stm32_adc_core_pm_ops = {
 				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(stm32_adc_core_runtime_suspend,
 			   stm32_adc_core_runtime_resume,
-			   NULL)
+			   stm32_adc_core_runtime_idle)
 };
 
 static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
-- 
2.25.1



