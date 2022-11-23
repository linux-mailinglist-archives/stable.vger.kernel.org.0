Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB663584A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbiKWJyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237227AbiKWJxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:53:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D8759858
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:49:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F8AB81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B91C43470;
        Wed, 23 Nov 2022 09:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196980;
        bh=g8WVvdd57OrwfvIwlzkMT4xFDAf/yGTsnBiPaEF5orA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PC6Yb5m7H/hIq9YGhapP0u+ZDouNaj+GmOhGITL6biKIGB2DXV1eTIssIaR1PIPFJ
         A2v5TmnEKNcOukovcUG6uVdeHJUD278UXaFD2nCkYWNgE67x1E3si7s5hrFAO0sLpu
         mdX52Q+oCC6l6i/327O3FuTRMIjlQhV69YO915ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Viresh Kumar <viresh.kumar@linaro.org>,
        Erico Nunes <nunes.erico@gmail.com>,
        Qiang Yu <yuq825@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 164/314] drm/lima: Fix opp clkname setting in case of missing regulator
Date:   Wed, 23 Nov 2022 09:50:09 +0100
Message-Id: <20221123084633.002608525@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Erico Nunes <nunes.erico@gmail.com>

[ Upstream commit e17a025a47c66ca8499ae88d8046c4f0d7c9c057 ]

Commit d8c32d3971e4 ("drm/lima: Migrate to dev_pm_opp_set_config()")
introduced a regression as it may undo the clk_names setting in case
the optional regulator is missing. This resulted in test and performance
regressions with lima.

Restore the old behavior where clk_names is set separately so it is not
undone in case of a missing optional regulator.

Fixes: d8c32d3971e4 ("drm/lima: Migrate to dev_pm_opp_set_config()")
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221027073200.3885839-1-nunes.erico@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_devfreq.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/lima/lima_devfreq.c b/drivers/gpu/drm/lima/lima_devfreq.c
index 011be7ff51e1..bc8fb4e38d0a 100644
--- a/drivers/gpu/drm/lima/lima_devfreq.c
+++ b/drivers/gpu/drm/lima/lima_devfreq.c
@@ -112,11 +112,6 @@ int lima_devfreq_init(struct lima_device *ldev)
 	unsigned long cur_freq;
 	int ret;
 	const char *regulator_names[] = { "mali", NULL };
-	const char *clk_names[] = { "core", NULL };
-	struct dev_pm_opp_config config = {
-		.regulator_names = regulator_names,
-		.clk_names = clk_names,
-	};
 
 	if (!device_property_present(dev, "operating-points-v2"))
 		/* Optional, continue without devfreq */
@@ -124,7 +119,15 @@ int lima_devfreq_init(struct lima_device *ldev)
 
 	spin_lock_init(&ldevfreq->lock);
 
-	ret = devm_pm_opp_set_config(dev, &config);
+	/*
+	 * clkname is set separately so it is not affected by the optional
+	 * regulator setting which may return error.
+	 */
+	ret = devm_pm_opp_set_clkname(dev, "core");
+	if (ret)
+		return ret;
+
+	ret = devm_pm_opp_set_regulators(dev, regulator_names);
 	if (ret) {
 		/* Continue if the optional regulator is missing */
 		if (ret != -ENODEV)
-- 
2.35.1



