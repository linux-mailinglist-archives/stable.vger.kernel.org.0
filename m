Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708D8355458
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbhDFM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:57:58 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54908 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243423AbhDFM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTlHB-00EYjO-1V; Tue, 06 Apr 2021 12:57:49 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:51:00 +0000
Subject: [git:media_tree/master] media: venus: pm_helpers: Set opp clock name for v1
To:     linuxtv-commits@linuxtv.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTlHB-00EYjO-1V@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: pm_helpers: Set opp clock name for v1
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Thu Feb 25 15:28:57 2021 +0100

The rate of the core clock is set through devm_pm_opp_set_rate and
to avoid errors from it we have to set the name of the clock via
dev_pm_opp_set_clkname.

Fixes: 9a538b83612c ("media: venus: core: Add support for opp tables/perf voting")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/pm_helpers.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index e349d01422c5..95b4d40ff6a5 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -279,7 +279,22 @@ set_freq:
 
 static int core_get_v1(struct venus_core *core)
 {
-	return core_clks_get(core);
+	int ret;
+
+	ret = core_clks_get(core);
+	if (ret)
+		return ret;
+
+	core->opp_table = dev_pm_opp_set_clkname(core->dev, "core");
+	if (IS_ERR(core->opp_table))
+		return PTR_ERR(core->opp_table);
+
+	return 0;
+}
+
+static void core_put_v1(struct venus_core *core)
+{
+	dev_pm_opp_put_clkname(core->opp_table);
 }
 
 static int core_power_v1(struct venus_core *core, int on)
@@ -296,6 +311,7 @@ static int core_power_v1(struct venus_core *core, int on)
 
 static const struct venus_pm_ops pm_ops_v1 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.load_scale = load_scale_v1,
 };
@@ -368,6 +384,7 @@ static int venc_power_v3(struct device *dev, int on)
 
 static const struct venus_pm_ops pm_ops_v3 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.vdec_get = vdec_get_v3,
 	.vdec_power = vdec_power_v3,
