Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792FE542565
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiFHBaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346973AbiFHBYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:24:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3A19EC11;
        Tue,  7 Jun 2022 12:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62515B8237B;
        Tue,  7 Jun 2022 19:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D83C385A2;
        Tue,  7 Jun 2022 19:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629982;
        bh=0uxE18e2AfanWQQDQShi5sm63VVmRKaaDhXCasV9Sko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6zbQPewaYi0+QnD1xnfRzQ3x7ZgjeZooTygp4NrO84mTo93R5jThop7YqhD+EKHn
         mNPHpMT1DwvGngwQtNF8qGLqCeZqBblTdaG2TTEYHCFzD2quEjLDMxP5VFIjRQ6ez8
         L/8FF/CZBmVRpJ95JS0jqyI4LGJF+NbfnC/7LCoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.18 848/879] clk: tegra: Add missing reset deassertion
Date:   Tue,  7 Jun 2022 19:06:06 +0200
Message-Id: <20220607165027.465901379@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

commit 23a43cc437e747473d5f8f98b4fe189fb5c433b7 upstream.

Commit 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling
clocks") removed deassertion of reset lines when enabling peripheral
clocks. This breaks the initialization of the DFLL driver which relied
on this behaviour.

Fix this problem by adding explicit deassert/assert requests to the
driver. Tested on Google Pixel C.

Cc: stable@vger.kernel.org
Fixes: 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling clocks")
Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/tegra/clk-dfll.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/clk/tegra/clk-dfll.c
+++ b/drivers/clk/tegra/clk-dfll.c
@@ -271,6 +271,7 @@ struct tegra_dfll {
 	struct clk			*ref_clk;
 	struct clk			*i2c_clk;
 	struct clk			*dfll_clk;
+	struct reset_control		*dfll_rst;
 	struct reset_control		*dvco_rst;
 	unsigned long			ref_rate;
 	unsigned long			i2c_clk_rate;
@@ -1464,6 +1465,7 @@ static int dfll_init(struct tegra_dfll *
 		return -EINVAL;
 	}
 
+	reset_control_deassert(td->dfll_rst);
 	reset_control_deassert(td->dvco_rst);
 
 	ret = clk_prepare(td->ref_clk);
@@ -1509,6 +1511,7 @@ di_err1:
 	clk_unprepare(td->ref_clk);
 
 	reset_control_assert(td->dvco_rst);
+	reset_control_assert(td->dfll_rst);
 
 	return ret;
 }
@@ -1530,6 +1533,7 @@ int tegra_dfll_suspend(struct device *de
 	}
 
 	reset_control_assert(td->dvco_rst);
+	reset_control_assert(td->dfll_rst);
 
 	return 0;
 }
@@ -1548,6 +1552,7 @@ int tegra_dfll_resume(struct device *dev
 {
 	struct tegra_dfll *td = dev_get_drvdata(dev);
 
+	reset_control_deassert(td->dfll_rst);
 	reset_control_deassert(td->dvco_rst);
 
 	pm_runtime_get_sync(td->dev);
@@ -1951,6 +1956,12 @@ int tegra_dfll_register(struct platform_
 
 	td->soc = soc;
 
+	td->dfll_rst = devm_reset_control_get_optional(td->dev, "dfll");
+	if (IS_ERR(td->dfll_rst)) {
+		dev_err(td->dev, "couldn't get dfll reset\n");
+		return PTR_ERR(td->dfll_rst);
+	}
+
 	td->dvco_rst = devm_reset_control_get(td->dev, "dvco");
 	if (IS_ERR(td->dvco_rst)) {
 		dev_err(td->dev, "couldn't get dvco reset\n");
@@ -2087,6 +2098,7 @@ struct tegra_dfll_soc_data *tegra_dfll_u
 	clk_unprepare(td->i2c_clk);
 
 	reset_control_assert(td->dvco_rst);
+	reset_control_assert(td->dfll_rst);
 
 	return td->soc;
 }


