Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75A6C0D00
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCTJTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjCTJTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70DF19B9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58881B80DAC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1B4C433EF;
        Mon, 20 Mar 2023 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303968;
        bh=JToK1mqf7RCPHkZ8DfqNpMkagfhC8koHv2wzZHcCSD8=;
        h=Subject:To:Cc:From:Date:From;
        b=Q/7//d1Vl3u7uvmbB/HrnqgEJL83yTjyw7qeakNWsPnbQcrbMhiXl3jqygsvYkW5A
         wyV5vgJvqeSdrOt6iDm9wzWNE5OGYd/iGGxDV3gyP00O5CzwpREoSQ2NJ1kXjZwAcC
         VKgDAmMF4D6DaeXpCxj1nPT72UIOCn7Jf3keoFq4=
Subject: FAILED: patch "[PATCH] interconnect: fix provider registration API" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org,
        konrad.dybcio@linaro.org, luca.ceresoli@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:19:23 +0100
Message-ID: <1679303963252165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x eb59eca0d8ac15f8c1b7f1cd35999455a90292c0
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679303963252165@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

eb59eca0d8ac ("interconnect: fix provider registration API")
e0e7089bf9a8 ("interconnect: fix icc_provider_del() error handling")
680f8666baf6 ("interconnect: Make icc_provider_del() return void")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb59eca0d8ac15f8c1b7f1cd35999455a90292c0 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:31 +0100
Subject: [PATCH] interconnect: fix provider registration API

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

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index cabb6f5df83e..7a24c1444ace 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1033,44 +1033,68 @@ int icc_nodes_remove(struct icc_provider *provider)
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

