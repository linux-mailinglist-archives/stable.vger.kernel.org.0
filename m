Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DCD6688BD
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbjAMAyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbjAMAyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:54:11 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E58F1275A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:10 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d15so21904389pls.6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 16:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=Osh1B7zp7tQhU+9MxWPY/yAEEmUj1gtkg7jmpWJk9NgmbGtaRDmTSetrchIDDB96H+
         p/qRxiUkZPIgdLp122//Q4wMQJBff8z5Wllf5G5VRmLI1m4fSX5EcrMKZqaReT11PdfM
         P6fr4Mh9AH5OB+SOA9myUKG6PNEbejlcVIpio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PobSF2/MDkJrX0shmq4Y9cOMyGXHMWsuX8BGemf4VBw=;
        b=Cka1f3t6pVAmwJ8TqP7aR2z3wx7fgcMc9MjwL7Nwur6jqmViurGFy6nE6v5NVGQFKB
         KVSheRvXBN2gfBWYxhCxcoD2yrYcej5oh9HeZlGrFh6kUz3YW7EmsCCdadSgiNGjPC1W
         58z2Er0rzZ1+5I1BwwTNoAMxTHeYerLOSHM1CGv8tp6nCxVOlSnlfZKySGHES+5NPk/L
         8NKbCXHrivTockjRFEh5+lHeByKU2tH1ZTersJTdhC/nQ4hpUxZUt2ukNn+2hZP1jWsM
         NAvlDSyuCgT07T/lxgRzf8FyWqp28EudxAUO2G64B2lCk1AMN638SkSsFvmO7U1iJNfE
         XlZw==
X-Gm-Message-State: AFqh2krWfVgDh+j/an3hqLZv5LFfFVwmI/u1yldsoMEcoSle8YMqnW1B
        Huh19COxJvYdOTJdtotkmrbEZfhN/0et79mr
X-Google-Smtp-Source: AMrXdXsvI3zs4GuDkNa8TpijaRhFnlRVYdPGEVTOzyqt4I2mkh0WJTBPXLb075HpeSi0t5xXkCE3Ug==
X-Received: by 2002:a05:6a20:9588:b0:b2:549c:b0eb with SMTP id iu8-20020a056a20958800b000b2549cb0ebmr99249330pzb.36.1673571249545;
        Thu, 12 Jan 2023 16:54:09 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:08 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 1/4] phy: qcom-qmp-combo: disable runtime PM on unbind
Date:   Thu, 12 Jan 2023 16:54:02 -0800
Message-Id: <20230113005405.3992011-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113005405.3992011-1-swboyd@chromium.org>
References: <20230113005405.3992011-1-swboyd@chromium.org>
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

