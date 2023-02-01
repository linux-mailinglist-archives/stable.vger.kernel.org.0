Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4348686400
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjBAKRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjBAKQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C834F86D;
        Wed,  1 Feb 2023 02:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D0DB82157;
        Wed,  1 Feb 2023 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA49C4339C;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=zGJKd1HoSpXdCOGyBtYMQrEgqsyLqZtoHxPBl2njZF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=talcQpudDREYMWp7pi7qMgEwntZSk6OqGdo/uGwl1fFtCD7eoR3Li5C7VTqqsm5+3
         850Su7OkwukpvX54VWhH3QEic+pFR5+6/kimvq3H1bVQBK6VPBNCUPyXnVJNzkhIC2
         b9F7wxe0gcSzvkTbhqeq+WrTrZW/B60PRexLRIK0E/kNB9mdVjRlZkG1cu9/U1nud3
         tdt7Dhf/1KBiqfxZgUb/CDWWeK7U+VTTyBYkzPf6e8HsCC/9CvkJjf8UfBpwrd3FR3
         7Aewe1RLUD4INvwqepU8kxnJRiKaODMRo7Ryy+7uvoy93Jqz+ZfOpRTJpni0t7f861
         Yge/cTaQhJ8BA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-00043m-7d; Wed, 01 Feb 2023 11:16:53 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?q?Artur=20=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 03/23] interconnect: fix provider registration API
Date:   Wed,  1 Feb 2023 11:15:39 +0100
Message-Id: <20230201101559.15529-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201101559.15529-1-johan+linaro@kernel.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
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

The current interconnect provider interface is inherently racy as
providers are expected to be added before being fully initialised.

Specifically, nodes are currently not added and the provider data is not
initialised until after registering the provider which can cause racing
DT lookups to fail.

Add a new provider API which will be used to fix up the interconnect
drivers.

The old API is reimplemented using the new interface and will be removed
once all drivers have been fixed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Fixes: 87e3031b6fbd ("interconnect: Allow endpoints translation via DT")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/core.c           | 52 +++++++++++++++++++--------
 include/linux/interconnect-provider.h | 12 +++++++
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 43c5c8503ee8..93d27ff8eef6 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1030,44 +1030,68 @@ int icc_nodes_remove(struct icc_provider *provider)
 EXPORT_SYMBOL_GPL(icc_nodes_remove);
 
 /**
- * icc_provider_add() - add a new interconnect provider
- * @provider: the interconnect provider that will be added into topology
+ * icc_provider_init() - initialize a new interconnect provider
+ * @provider: the interconnect provider to initialize
+ *
+ * Must be called before adding nodes to the provider.
+ */
+void icc_provider_init(struct icc_provider *provider)
+{
+	WARN_ON(!provider->set);
+
+	INIT_LIST_HEAD(&provider->nodes);
+}
+EXPORT_SYMBOL_GPL(icc_provider_init);
+
+/**
+ * icc_provider_register() - register a new interconnect provider
+ * @provider: the interconnect provider to register
  *
  * Return: 0 on success, or an error code otherwise
  */
-int icc_provider_add(struct icc_provider *provider)
+int icc_provider_register(struct icc_provider *provider)
 {
-	if (WARN_ON(!provider->set))
-		return -EINVAL;
 	if (WARN_ON(!provider->xlate && !provider->xlate_extended))
 		return -EINVAL;
 
 	mutex_lock(&icc_lock);
-
-	INIT_LIST_HEAD(&provider->nodes);
 	list_add_tail(&provider->provider_list, &icc_providers);
-
 	mutex_unlock(&icc_lock);
 
-	dev_dbg(provider->dev, "interconnect provider added to topology\n");
+	dev_dbg(provider->dev, "interconnect provider registered\n");
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(icc_provider_add);
+EXPORT_SYMBOL_GPL(icc_provider_register);
 
 /**
- * icc_provider_del() - delete previously added interconnect provider
- * @provider: the interconnect provider that will be removed from topology
+ * icc_provider_deregister() - deregister an interconnect provider
+ * @provider: the interconnect provider to deregister
  */
-void icc_provider_del(struct icc_provider *provider)
+void icc_provider_deregister(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
 	WARN_ON(provider->users);
-	WARN_ON(!list_empty(&provider->nodes));
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);
 }
+EXPORT_SYMBOL_GPL(icc_provider_deregister);
+
+int icc_provider_add(struct icc_provider *provider)
+{
+	icc_provider_init(provider);
+
+	return icc_provider_register(provider);
+}
+EXPORT_SYMBOL_GPL(icc_provider_add);
+
+void icc_provider_del(struct icc_provider *provider)
+{
+	WARN_ON(!list_empty(&provider->nodes));
+
+	icc_provider_deregister(provider);
+}
 EXPORT_SYMBOL_GPL(icc_provider_del);
 
 static const struct of_device_id __maybe_unused ignore_list[] = {
diff --git a/include/linux/interconnect-provider.h b/include/linux/interconnect-provider.h
index cd5c5a27557f..d12cd18aab3f 100644
--- a/include/linux/interconnect-provider.h
+++ b/include/linux/interconnect-provider.h
@@ -122,6 +122,9 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst);
 void icc_node_add(struct icc_node *node, struct icc_provider *provider);
 void icc_node_del(struct icc_node *node);
 int icc_nodes_remove(struct icc_provider *provider);
+void icc_provider_init(struct icc_provider *provider);
+int icc_provider_register(struct icc_provider *provider);
+void icc_provider_deregister(struct icc_provider *provider);
 int icc_provider_add(struct icc_provider *provider);
 void icc_provider_del(struct icc_provider *provider);
 struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec);
@@ -167,6 +170,15 @@ static inline int icc_nodes_remove(struct icc_provider *provider)
 	return -ENOTSUPP;
 }
 
+static inline void icc_provider_init(struct icc_provider *provider) { }
+
+static inline int icc_provider_register(struct icc_provider *provider)
+{
+	return -ENOTSUPP;
+}
+
+static inline void icc_provider_deregister(struct icc_provider *provider) { }
+
 static inline int icc_provider_add(struct icc_provider *provider)
 {
 	return -ENOTSUPP;
-- 
2.39.1

