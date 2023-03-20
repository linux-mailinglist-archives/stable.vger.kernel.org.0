Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1486C0DE5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCTJ5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCTJ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:57:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26C620D30
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFCFFB80DD2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC6C43444;
        Mon, 20 Mar 2023 09:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679306174;
        bh=8TH8TZgCwPx66joBWqLm4H4OoKCANXQMxiYkUPvA+w0=;
        h=Subject:To:Cc:From:Date:From;
        b=bIpo0v8lRhAo7DoPHRED/b6n5DSmCO6xjwqxKybY8twoCPbCqbU6b7ViCDp8ew2pe
         pcw6WGQj9joHN/aRu/SL1GO/XNf/qP+9Z7AnRmiCiABoyek4PbxVKAeecc8N4yURSV
         TRjDF5g5gbqGh1VvSUCpOznBIMenYypCqRU1A+UE=
Subject: FAILED: patch "[PATCH] memory: tegra: fix interconnect registration race" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, digetx@gmail.com, djakov@kernel.org,
        krzysztof.kozlowski@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:56:11 +0100
Message-ID: <167930617133113@kroah.com>
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
git cherry-pick -x 5553055c62683ce339f9ef5fb2a26c8331485d68
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930617133113@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

5553055c6268 ("memory: tegra: fix interconnect registration race")
77b14c9d05bd ("memory: tegra: Remove interconnect state syncing hack")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5553055c62683ce339f9ef5fb2a26c8331485d68 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:45 +0100
Subject: [PATCH] memory: tegra: fix interconnect registration race

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
Link: https://lore.kernel.org/r/20230306075651.2449-18-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

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

