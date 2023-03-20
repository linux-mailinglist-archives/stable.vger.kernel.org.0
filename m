Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC53F6C196C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjCTPda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjCTPdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F03D34F53
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 995C36157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADA8C4339C;
        Mon, 20 Mar 2023 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325956;
        bh=hFcIikj1mDKjeQuTUK9pVgnuAW8pKQ8py83+y1206JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcJelWwLWAfaBCRs2UZ+w1ACXybSOP3bVN1RqEiyooHPaQiS+pgTjlNTU/V/qNeHw
         oO83WaMuHmr9Phuy8/s7HGSg5dx6PBhNfCJ2PCSRGGMDRO1Lo8kvLVjV1z1cjM9Ahc
         lawi+upc/NSYSSdJKWF0cZ8RF9AQ8r9XoYHHzLBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.2 131/211] interconnect: fix provider registration API
Date:   Mon, 20 Mar 2023 15:54:26 +0100
Message-Id: <20230320145518.909502554@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

commit eb59eca0d8ac15f8c1b7f1cd35999455a90292c0 upstream.

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
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-4-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c           |   52 ++++++++++++++++++++++++----------
 include/linux/interconnect-provider.h |   12 +++++++
 2 files changed, 50 insertions(+), 14 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1029,44 +1029,68 @@ int icc_nodes_remove(struct icc_provider
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
 
 static int of_count_icc_providers(struct device_node *np)
--- a/include/linux/interconnect-provider.h
+++ b/include/linux/interconnect-provider.h
@@ -122,6 +122,9 @@ int icc_link_destroy(struct icc_node *sr
 void icc_node_add(struct icc_node *node, struct icc_provider *provider);
 void icc_node_del(struct icc_node *node);
 int icc_nodes_remove(struct icc_provider *provider);
+void icc_provider_init(struct icc_provider *provider);
+int icc_provider_register(struct icc_provider *provider);
+void icc_provider_deregister(struct icc_provider *provider);
 int icc_provider_add(struct icc_provider *provider);
 void icc_provider_del(struct icc_provider *provider);
 struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec);
@@ -167,6 +170,15 @@ static inline int icc_nodes_remove(struc
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


