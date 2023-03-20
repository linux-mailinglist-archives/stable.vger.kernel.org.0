Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328786C1946
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjCTPcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjCTPcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E781D36099
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C7D615AF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3022DC433EF;
        Mon, 20 Mar 2023 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325860;
        bh=D6EkapIyWhW4x39keVUwiNunYJGLru/48kj7qxejMvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0Oav7Dw8eqSf1kBSG1/1vAzFFGZAl0J2eyIJFCKFGCwlOz4ILgjp0Tudw/AyqH5+
         wNOMRejhfNcyxqJZOb8hGKSLgyGdgR5wRE9ImO1QiOTHq4T4ngSJr6cFP4IEA2PcsK
         Hxj3/2bHVmqih7fUtOaQZPtyWqnKcWQKX/Sghx1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Osipenko <digetx@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 124/198] memory: tegra20-emc: fix interconnect registration race
Date:   Mon, 20 Mar 2023 15:54:22 +0100
Message-Id: <20230320145512.749434238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit c5587f61ec050f7e9ebb3e2da29d12af63e833d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/tegra/tegra20-emc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -1034,15 +1034,13 @@ static int tegra_emc_interconnect_init(s
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
@@ -1063,12 +1061,14 @@ static int tegra_emc_interconnect_init(s
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
 


