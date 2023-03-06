Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6B6AB7A5
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCFH6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCFH5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D871D1A97F;
        Sun,  5 Mar 2023 23:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2164B80CB6;
        Mon,  6 Mar 2023 07:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105BFC433AC;
        Mon,  6 Mar 2023 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089457;
        bh=48FoW8OSDpsHuQ/0wyhq7l25XV/6Z+uv3wlmnHs+SqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCJVSfmWTBOzT41dAs/tVH8H3VvdasvSRBCxDjM9qUFAWHAPIwOGeieIjwNoIUT6X
         WcQq29x8BIPxXtaTfCbsZLf4yrQoSo9hPoA1k3GcL1ara1WHrrBxU3Xp7ALqM159CS
         xz418JGMPiybro0HTDAQrwCuDAaDN5YM1hcQCUwMj+NrO9tZ+/9YmWmc71pBCjz5JT
         VyC+IK21rN0gzT2wLoWQa4zBUpRbbTPHpawr47v9N4U5pHGcjfO8KSSNpmBwrApt/I
         kapqf4HjqCXeM16L9zbdnr28sm2MsGcBmCbFc46V9wMxYazQwu6G7QFomqUPzDQcyr
         YT8qc0RobDD8w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jd-0000if-8M; Mon, 06 Mar 2023 08:58:17 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        =?UTF-8?q?Artur=20=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Jonathan Hunter" <jonathanh@nvidia.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH v2 17/23] memory: tegra: fix interconnect registration race
Date:   Mon,  6 Mar 2023 08:56:45 +0100
Message-Id: <20230306075651.2449-18-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306075651.2449-1-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 06f079816d4c ("memory: tegra-mc: Add interconnect framework")
Cc: stable@vger.kernel.org      # 5.11
Cc: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/memory/tegra/mc.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index 592907546ee6..5cd28619ea9f 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -794,16 +794,12 @@ static int tegra_mc_interconnect_setup(struct tegra_mc *mc)
 	mc->provider.aggregate = mc->soc->icc_ops->aggregate;
 	mc->provider.xlate_extended = mc->soc->icc_ops->xlate_extended;
 
-	err = icc_provider_add(&mc->provider);
-	if (err)
-		return err;
+	icc_provider_init(&mc->provider);
 
 	/* create Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_MC);
-	if (IS_ERR(node)) {
-		err = PTR_ERR(node);
-		goto del_provider;
-	}
+	if (IS_ERR(node))
+		return PTR_ERR(node);
 
 	node->name = "Memory Controller";
 	icc_node_add(node, &mc->provider);
@@ -830,12 +826,14 @@ static int tegra_mc_interconnect_setup(struct tegra_mc *mc)
 			goto remove_nodes;
 	}
 
+	err = icc_provider_register(&mc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&mc->provider);
-del_provider:
-	icc_provider_del(&mc->provider);
 
 	return err;
 }
-- 
2.39.2

