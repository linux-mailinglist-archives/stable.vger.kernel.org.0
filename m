Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37468A61E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjBCW0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjBCW0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:26:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F178B7DD
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:26:21 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n13so6697253plf.11
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=d9t0hT6GiqnRHp4PDpDtSjes5ppgJHVckiZj+66c3rI8mTBGp1eIr5V7jtncsLYobk
         ccIW5PqZL9jddlPKCVmZmjbI3ZuOkihTKOcN6KyekmzflS71kwrA/rfCAuyBMAQJY864
         iNMs7b1jGM70GCQlgSYZ8X2GdiGnr8cDww7gE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=Mfwdp4wVjvxJdHp6oy2JbeM5q4ap23LW0BOlWuE6t2fs8xuWR1ZLgr8O1Jw2cBF3wz
         NutfA22JeSCklLN1jHlMDJ2WMnJeAQ1gKtxVLH2ghJ0egXrFLfPPJm6OjMdhHGXzXkam
         /aC7fHEd101Csrpox1QjQdZvQkjw8kiYAziqz7R9jQQBIMl0ONXgdcSG4/aVKtuW5+ix
         +L2Dh4Cy0LBvyp5N4pcZR/a4Q+xphEKnLpmyHoOkxH4PfD/oQUqLs+5a8ppjMbW/ooif
         vRSZQvau+PdUU1Q43KPPU40B8OFzV4kcgZpbVgw6KYsbVhmJRKyMGW8EDSlzD2p+XqdA
         Hx9w==
X-Gm-Message-State: AO0yUKWwITPRb7lhfMmFHsdQqNQ487xBj2NcH0Tt0jUsIV0RD0900O0W
        bRLBvvkMweyZwp4HBoCi8cp9ZF8YK1FpQfpq
X-Google-Smtp-Source: AK7set+RkDPC8r53YF5/SDwMLYOuXoF2Kt+2qGSlJTPwKp4XmX/yFLUkxvUaOxom+XYX0c1+8XrZfg==
X-Received: by 2002:a17:902:f0c4:b0:198:e5f7:8cf4 with SMTP id v4-20020a170902f0c400b00198e5f78cf4mr1886550pla.53.1675463180852;
        Fri, 03 Feb 2023 14:26:20 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:20 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 1/5] phy: qcom-qmp-combo: disable runtime PM on unbind
Date:   Fri,  3 Feb 2023 14:26:12 -0800
Message-Id: <20230203222616.2935268-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
References: <20230203222616.2935268-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 4382d518d1887e62234560ea08a0203d11d28cc1 upstream.

Make sure to disable runtime PM also on driver unbind.

Fixes: ac0d239936bd ("phy: qcom-qmp: Add support for runtime PM").
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220907110728.19092-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index a9687e040960..7b7557c35af6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5740,7 +5740,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 	/*
 	 * Prevent runtime pm from being ON by default. Users can enable
 	 * it using power/control in sysfs.
@@ -5790,13 +5792,10 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QMP phy\n");
-	else
-		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 err_node_put:
-	pm_runtime_disable(dev);
 	of_node_put(child);
 	return ret;
 }
-- 
https://chromeos.dev

