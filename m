Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D557F6AB797
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCFH5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjCFH5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FE1F5DC;
        Sun,  5 Mar 2023 23:57:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28BCB80CA7;
        Mon,  6 Mar 2023 07:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DE2C4339B;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=Gq0h6KWRJ7+7NQjJFlZM0IIfLOQXyWOu463epBupeVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRVn3Mena1i634HIHPWixQ/g1cfQETDXfXhBJGyPbNQ2zD0uRLBLLdX6lmKQBQRkf
         0w0PC3EPFc1n7Gfqg6Tt+p005RchBMtNChwFTj+ZAyCoAaZFy0unjM0ozuy9HwFIEQ
         fJVXcORUbnHtC6JYGafTiUcBCtJcj1Y/rWtvG2qcpuHixgnRcis+MncYc4/RdtuflY
         KO10M3uLJUpywRlZZvIU9pN9ZeLKNPZS2uvrDkTRjP4AANF8rQhZz8j0DI5j94hyHv
         ScxbeNuAwSau22/oKtyISv9Joc28MZrW40YPJFc4Wsy5LjMYjfI4QcZSx7r1lrD13c
         1Y//i9567+Kng==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jb-0000hv-Rs; Mon, 06 Mar 2023 08:58:15 +0100
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
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 02/23] interconnect: fix icc_provider_del() error handling
Date:   Mon,  6 Mar 2023 08:56:30 +0100
Message-Id: <20230306075651.2449-3-johan+linaro@kernel.org>
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

The interconnect framework currently expects that providers are only
removed when there are no users and after all nodes have been removed.

There is currently nothing that guarantees this to be the case and the
framework does not do any reference counting, but refusing to remove the
provider is never correct as that would leave a dangling pointer to a
resource that is about to be released in the global provider list (e.g.
accessible through debugfs).

Replace the current sanity checks with WARN_ON() so that the provider is
always removed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1: 680f8666baf6: interconnect: Make icc_provider_del() return void
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/core.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 5217f449eeec..cabb6f5df83e 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1065,18 +1065,8 @@ EXPORT_SYMBOL_GPL(icc_provider_add);
 void icc_provider_del(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
-	if (provider->users) {
-		pr_warn("interconnect provider still has %d users\n",
-			provider->users);
-		mutex_unlock(&icc_lock);
-		return;
-	}
-
-	if (!list_empty(&provider->nodes)) {
-		pr_warn("interconnect provider still has nodes\n");
-		mutex_unlock(&icc_lock);
-		return;
-	}
+	WARN_ON(provider->users);
+	WARN_ON(!list_empty(&provider->nodes));
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);
-- 
2.39.2

