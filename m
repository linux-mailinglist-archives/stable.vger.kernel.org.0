Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F02498F63
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351589AbiAXTwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356497AbiAXTq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A976153B;
        Mon, 24 Jan 2022 19:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CECC340E5;
        Mon, 24 Jan 2022 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053587;
        bh=hSnyDgOnkCgKuwYcR+1NOauOe0CVhqfyNm4Nyh+3WZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tyhmd3pzfwQ9m8UqOHfyQzb6Uddcpm5GvY7bC9hkhoIwSy5g5S0QwrrL/bMXl3qt5
         53H+rkwPn6pvrR+lucQJF6pWA15If97/ZOraN06Fn18rm/QSgE6JfKH1ZqDvg+dlsd
         9jKf7EW0AvD05g1UJnN/lPGkKMQ5ELfDaw7dLvnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fritz Koenig <frkoenig@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/563] media: venus: pm_helpers: Control core power domain manually
Date:   Mon, 24 Jan 2022 19:37:58 +0100
Message-Id: <20220124184028.332819166@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit a76f43a490542ecb8c57176730b6eb665d716139 ]

Presently we use device_link to control core power domain. But this
leads to issues because the genpd doesn't guarantee synchronous on/off
for supplier devices. Switch to manually control by pmruntime calls.

Tested-by: Fritz Koenig <frkoenig@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.h      |  2 --
 .../media/platform/qcom/venus/pm_helpers.c    | 36 ++++++++++---------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 05c9fbd51f0c0..f2a0ef9ee884e 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -123,7 +123,6 @@ struct venus_caps {
  * @clks:	an array of struct clk pointers
  * @vcodec0_clks: an array of vcodec0 struct clk pointers
  * @vcodec1_clks: an array of vcodec1 struct clk pointers
- * @pd_dl_venus: pmdomain device-link for venus domain
  * @pmdomains:	an array of pmdomains struct device pointers
  * @vdev_dec:	a reference to video device structure for decoder instances
  * @vdev_enc:	a reference to video device structure for encoder instances
@@ -161,7 +160,6 @@ struct venus_core {
 	struct icc_path *cpucfg_path;
 	struct opp_table *opp_table;
 	bool has_opp_table;
-	struct device_link *pd_dl_venus;
 	struct device *pmdomains[VIDC_PMDOMAINS_NUM_MAX];
 	struct device_link *opp_dl_venus;
 	struct device *opp_pmdomain;
diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index 2946547a0df4a..bce9a370015fb 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -773,13 +773,6 @@ static int vcodec_domains_get(struct device *dev)
 		core->pmdomains[i] = pd;
 	}
 
-	core->pd_dl_venus = device_link_add(dev, core->pmdomains[0],
-					    DL_FLAG_PM_RUNTIME |
-					    DL_FLAG_STATELESS |
-					    DL_FLAG_RPM_ACTIVE);
-	if (!core->pd_dl_venus)
-		return -ENODEV;
-
 skip_pmdomains:
 	if (!core->has_opp_table)
 		return 0;
@@ -806,14 +799,12 @@ skip_pmdomains:
 opp_dl_add_err:
 	dev_pm_opp_detach_genpd(core->opp_table);
 opp_attach_err:
-	if (core->pd_dl_venus) {
-		device_link_del(core->pd_dl_venus);
-		for (i = 0; i < res->vcodec_pmdomains_num; i++) {
-			if (IS_ERR_OR_NULL(core->pmdomains[i]))
-				continue;
-			dev_pm_domain_detach(core->pmdomains[i], true);
-		}
+	for (i = 0; i < res->vcodec_pmdomains_num; i++) {
+		if (IS_ERR_OR_NULL(core->pmdomains[i]))
+			continue;
+		dev_pm_domain_detach(core->pmdomains[i], true);
 	}
+
 	return ret;
 }
 
@@ -826,9 +817,6 @@ static void vcodec_domains_put(struct device *dev)
 	if (!res->vcodec_pmdomains_num)
 		goto skip_pmdomains;
 
-	if (core->pd_dl_venus)
-		device_link_del(core->pd_dl_venus);
-
 	for (i = 0; i < res->vcodec_pmdomains_num; i++) {
 		if (IS_ERR_OR_NULL(core->pmdomains[i]))
 			continue;
@@ -916,16 +904,30 @@ static void core_put_v4(struct device *dev)
 static int core_power_v4(struct device *dev, int on)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *pmctrl = core->pmdomains[0];
 	int ret = 0;
 
 	if (on == POWER_ON) {
+		if (pmctrl) {
+			ret = pm_runtime_get_sync(pmctrl);
+			if (ret < 0) {
+				pm_runtime_put_noidle(pmctrl);
+				return ret;
+			}
+		}
+
 		ret = core_clks_enable(core);
+		if (ret < 0 && pmctrl)
+			pm_runtime_put_sync(pmctrl);
 	} else {
 		/* Drop the performance state vote */
 		if (core->opp_pmdomain)
 			dev_pm_opp_set_rate(dev, 0);
 
 		core_clks_disable(core);
+
+		if (pmctrl)
+			pm_runtime_put_sync(pmctrl);
 	}
 
 	return ret;
-- 
2.34.1



