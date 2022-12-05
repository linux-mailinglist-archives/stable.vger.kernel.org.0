Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A74F643283
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiLET0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiLET03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B133D1DF05
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAE461307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D299C433C1;
        Mon,  5 Dec 2022 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268180;
        bh=mO4+0MV9ypLmcFQnzSlGrOJoQoVyQmjx2f/8zZZnomw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nJgwLPTaGMljcujFXsZDwiekqdftGJeNNzY3pW5ynWamBCi3mBDAvnwWo9CPXuVm
         EaHGw60CgmHKNXu3Q6EVWmjHVaatWp5hPkV55GHD5QexmOZ7FiGiQ7jK44oyPT+iya
         dCBzvCKqbAFIOGZLeVFaxp91YJ4cpNJ1Q+FNwSjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 010/124] clk: qcom: gdsc: add missing error handling
Date:   Mon,  5 Dec 2022 20:08:36 +0100
Message-Id: <20221205190808.735986082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit eab4c1ebdd657957bf7ae66ffb8849b462db78b3 ]

Since commit 7eb231c337e0 ("PM / Domains: Convert pm_genpd_init() to
return an error code") pm_genpd_init() can return an error which the
caller must handle.

The current error handling was also incomplete as the runtime PM and
regulator use counts were not balanced in all error paths.

Add the missing error handling to the GDSC initialisation to avoid
continuing as if nothing happened on errors.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220929155816.17425-1-johan+linaro@kernel.org
Stable-dep-of: 4cc47e8add63 ("clk: qcom: gdsc: Remove direct runtime PM calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index d3244006c661..4b66ce0f1940 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -439,11 +439,8 @@ static int gdsc_init(struct gdsc *sc)
 
 		/* ...and the power-domain */
 		ret = gdsc_pm_runtime_get(sc);
-		if (ret) {
-			if (sc->rsupply)
-				regulator_disable(sc->rsupply);
-			return ret;
-		}
+		if (ret)
+			goto err_disable_supply;
 
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
@@ -452,14 +449,14 @@ static int gdsc_init(struct gdsc *sc)
 		if (sc->flags & VOTABLE) {
 			ret = gdsc_update_collapse_bit(sc, false);
 			if (ret)
-				return ret;
+				goto err_put_rpm;
 		}
 
 		/* Turn on HW trigger mode if supported */
 		if (sc->flags & HW_CTRL) {
 			ret = gdsc_hwctrl(sc, true);
 			if (ret < 0)
-				return ret;
+				goto err_put_rpm;
 		}
 
 		/*
@@ -486,9 +483,21 @@ static int gdsc_init(struct gdsc *sc)
 		sc->pd.power_off = gdsc_disable;
 	if (!sc->pd.power_on)
 		sc->pd.power_on = gdsc_enable;
-	pm_genpd_init(&sc->pd, NULL, !on);
+
+	ret = pm_genpd_init(&sc->pd, NULL, !on);
+	if (ret)
+		goto err_put_rpm;
 
 	return 0;
+
+err_put_rpm:
+	if (on)
+		gdsc_pm_runtime_put(sc);
+err_disable_supply:
+	if (on && sc->rsupply)
+		regulator_disable(sc->rsupply);
+
+	return ret;
 }
 
 int gdsc_register(struct gdsc_desc *desc,
-- 
2.35.1



