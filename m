Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC08D24BCA4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgHTMuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729003AbgHTJpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5670222CB1;
        Thu, 20 Aug 2020 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916658;
        bh=Jz2TqGB+t3NpsqrwkafQ0cJY9nsMIM6mZHXjxl9L9ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuxMHlTWCuqmMvZIL90HMoJszx0yDQna8w/YUUJq1pFHbDXySqYkc/1DqtkKGy0Rk
         dbgfrseqIS5fkl+Uu/FHerTsdidwtJIAe8lZ7grKHKmEfoGUp9jcrM73jiPfZFz4Nw
         P98VVx5uKAHjfgTZR0BMYED8UTeGw7HC/+Aw9rek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.7 191/204] ASoC: tegra: Add audio mclk parent configuration
Date:   Thu, 20 Aug 2020 11:21:28 +0200
Message-Id: <20200820091615.733460520@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit 1e4e0bf136aa4b4aa59c1e6af19844bd6d807794 upstream.

Tegra PMC clock clk_out_1 is dedicated for audio mclk from Tegra30
through Tegra210 and currently Tegra clock driver does the initial
parent configuration for audio mclk and keeps it enabled by default.

With the move of PMC clocks from clock driver into PMC driver, audio
clocks parent configuration can be specified through the device tree
using assigned-clock-parents property and audio mclk control should be
taken care of by the audio driver.

This patch has implementation for parent configuration when default
parent configuration through assigned-clock-parents property is not
specified in the device tree.

Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Sameer Pujar <spujar@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_asoc_utils.c |   68 +++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 28 deletions(-)

--- a/sound/soc/tegra/tegra_asoc_utils.c
+++ b/sound/soc/tegra/tegra_asoc_utils.c
@@ -60,8 +60,6 @@ int tegra_asoc_utils_set_rate(struct teg
 	data->set_mclk = 0;
 
 	clk_disable_unprepare(data->clk_cdev1);
-	clk_disable_unprepare(data->clk_pll_a_out0);
-	clk_disable_unprepare(data->clk_pll_a);
 
 	err = clk_set_rate(data->clk_pll_a, new_baseclock);
 	if (err) {
@@ -77,18 +75,6 @@ int tegra_asoc_utils_set_rate(struct teg
 
 	/* Don't set cdev1/extern1 rate; it's locked to pll_a_out0 */
 
-	err = clk_prepare_enable(data->clk_pll_a);
-	if (err) {
-		dev_err(data->dev, "Can't enable pll_a: %d\n", err);
-		return err;
-	}
-
-	err = clk_prepare_enable(data->clk_pll_a_out0);
-	if (err) {
-		dev_err(data->dev, "Can't enable pll_a_out0: %d\n", err);
-		return err;
-	}
-
 	err = clk_prepare_enable(data->clk_cdev1);
 	if (err) {
 		dev_err(data->dev, "Can't enable cdev1: %d\n", err);
@@ -109,8 +95,6 @@ int tegra_asoc_utils_set_ac97_rate(struc
 	int err;
 
 	clk_disable_unprepare(data->clk_cdev1);
-	clk_disable_unprepare(data->clk_pll_a_out0);
-	clk_disable_unprepare(data->clk_pll_a);
 
 	/*
 	 * AC97 rate is fixed at 24.576MHz and is used for both the host
@@ -130,18 +114,6 @@ int tegra_asoc_utils_set_ac97_rate(struc
 
 	/* Don't set cdev1/extern1 rate; it's locked to pll_a_out0 */
 
-	err = clk_prepare_enable(data->clk_pll_a);
-	if (err) {
-		dev_err(data->dev, "Can't enable pll_a: %d\n", err);
-		return err;
-	}
-
-	err = clk_prepare_enable(data->clk_pll_a_out0);
-	if (err) {
-		dev_err(data->dev, "Can't enable pll_a_out0: %d\n", err);
-		return err;
-	}
-
 	err = clk_prepare_enable(data->clk_cdev1);
 	if (err) {
 		dev_err(data->dev, "Can't enable cdev1: %d\n", err);
@@ -158,6 +130,7 @@ EXPORT_SYMBOL_GPL(tegra_asoc_utils_set_a
 int tegra_asoc_utils_init(struct tegra_asoc_utils_data *data,
 			  struct device *dev)
 {
+	struct clk *clk_out_1, *clk_extern1;
 	int ret;
 
 	data->dev = dev;
@@ -193,6 +166,45 @@ int tegra_asoc_utils_init(struct tegra_a
 		return PTR_ERR(data->clk_cdev1);
 	}
 
+	/*
+	 * If clock parents are not set in DT, configure here to use clk_out_1
+	 * as mclk and extern1 as parent for Tegra30 and higher.
+	 */
+	if (!of_find_property(dev->of_node, "assigned-clock-parents", NULL) &&
+	    data->soc > TEGRA_ASOC_UTILS_SOC_TEGRA20) {
+		dev_warn(data->dev,
+			 "Configuring clocks for a legacy device-tree\n");
+		dev_warn(data->dev,
+			 "Please update DT to use assigned-clock-parents\n");
+		clk_extern1 = devm_clk_get(dev, "extern1");
+		if (IS_ERR(clk_extern1)) {
+			dev_err(data->dev, "Can't retrieve clk extern1\n");
+			return PTR_ERR(clk_extern1);
+		}
+
+		ret = clk_set_parent(clk_extern1, data->clk_pll_a_out0);
+		if (ret < 0) {
+			dev_err(data->dev,
+				"Set parent failed for clk extern1\n");
+			return ret;
+		}
+
+		clk_out_1 = devm_clk_get(dev, "pmc_clk_out_1");
+		if (IS_ERR(clk_out_1)) {
+			dev_err(data->dev, "Can't retrieve pmc_clk_out_1\n");
+			return PTR_ERR(clk_out_1);
+		}
+
+		ret = clk_set_parent(clk_out_1, clk_extern1);
+		if (ret < 0) {
+			dev_err(data->dev,
+				"Set parent failed for pmc_clk_out_1\n");
+			return ret;
+		}
+
+		data->clk_cdev1 = clk_out_1;
+	}
+
 	ret = tegra_asoc_utils_set_rate(data, 44100, 256 * 44100);
 	if (ret)
 		return ret;


