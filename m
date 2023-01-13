Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBDE66A452
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjAMUp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjAMUpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:45:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3350588DD8
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso25545490pjo.3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=Bk0IWpPecl/O/TDwZ0QOdESqr6Zk5qYmXoE7OVj3ynKjewF1Rg1fDbPfzyFRa8K40U
         LJfzekoRATjBbgAaGvkiEYTL3P+XjjkE7mOLJvku9+zQHQugdRsZgyeYnGTohCTmT93o
         b4FfVO+qDuxe4DlkcKogEN727pajt14vxaH1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=dZjPh1AcLRiQppEXfnlCvBpgcrmULbN2lBY9G//honmDpSCUBuJ7MoN8qioRjncfEP
         kUsA/NWlrvV748pSo0h0wqOglnkUexhk79u/TNSGSErIQR4SRQm4WKGax/7lI7slbs1n
         7Vzq/cnAKb+7TenyzbbrrgFyfwLLh/P2MBTlRyxZe+WNVtDAYa5PKwfi1GqCqNdjVeXU
         midNuG/0dg8uTwtaiUsxL3M4jme2fgk4oNAHm2DRE9nri/Kj2dNi1f0WoWdTNMdfrs1T
         pAsgHkontvsxvh2iJJIN7lqDO9HJGTLh6oyKdDNVQGgEVO0gMx1Wfz+KmUxl0Fww9tgu
         85NA==
X-Gm-Message-State: AFqh2kqjWpFM/JRnSkdUo53plE8vJZRMMB+rTL8x4ZSO0VdMMuaftPq8
        BIbUXzEMoyX8qmDh9ZQDpxQ8UEXuqrQoehrJ
X-Google-Smtp-Source: AMrXdXvjFDqqv5LXuw9EMZqIQeligGqs3tcgL4coCCLoaghRb4BWIhdTQPe9rtpQbAoKrG+r1WTY/w==
X-Received: by 2002:a17:903:1355:b0:193:3a92:f4bd with SMTP id jl21-20020a170903135500b001933a92f4bdmr12657981plb.47.1673642753165;
        Fri, 13 Jan 2023 12:45:53 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:52 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 1/5] phy: qcom-qmp-combo: disable runtime PM on unbind
Date:   Fri, 13 Jan 2023 12:45:44 -0800
Message-Id: <20230113204548.578798-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113204548.578798-1-swboyd@chromium.org>
References: <20230113204548.578798-1-swboyd@chromium.org>
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

