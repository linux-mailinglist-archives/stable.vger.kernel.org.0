Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB1F6C0DE6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCTJ6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCTJ5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:57:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D70902E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E7D8B80DCC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFF6C433EF;
        Mon, 20 Mar 2023 09:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679306200;
        bh=hs4M7T5XlL+Or/yGD5u+7uX64Vlf0tLy2qw8Bvwu/lc=;
        h=Subject:To:Cc:From:Date:From;
        b=IRVUSEUDMktN527h2abHhq9ee0YdKJBO6VJoER1xndutfhr8cOI186KpasOcehNRL
         K59DzfwBHK6ohpYMmKkLpXHjQW4HLRbUdoPrPcBMlauV/RjiLS5vriBq1euO+uRjw0
         mYmjM62c/NYYoglF7KuUavNm13E9IPQcgIchAIiU=
Subject: FAILED: patch "[PATCH] memory: tegra20-emc: fix interconnect registration race" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, digetx@gmail.com, djakov@kernel.org,
        krzysztof.kozlowski@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:56:37 +0100
Message-ID: <1679306197240100@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x c5587f61ec050f7e9ebb3e2da29d12af63e833d3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679306197240100@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

c5587f61ec05 ("memory: tegra20-emc: fix interconnect registration race")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c5587f61ec050f7e9ebb3e2da29d12af63e833d3 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:47 +0100
Subject: [PATCH] memory: tegra20-emc: fix interconnect registration race

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: d5ef16ba5fbe ("memory: tegra20: Support interconnect framework")
Cc: stable@vger.kernel.org      # 5.11
Cc: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-20-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index bd4e37b6552d..fd595c851a27 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -1021,15 +1021,13 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1050,12 +1048,14 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 

