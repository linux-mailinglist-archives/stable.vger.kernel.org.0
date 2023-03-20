Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB93E6C0D03
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjCTJUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCTJTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA8849D8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59CB0B80C88
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5154C433EF;
        Mon, 20 Mar 2023 09:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303990;
        bh=Fm8VmZjCOxEg5X7eYFUAUS560JFD/8LTLg5Z10A6vD8=;
        h=Subject:To:Cc:From:Date:From;
        b=F/orMyj3GvAJA3nwFnjq8+aa68/QJv1fXGy3LjgqLBBRaLpV2RWz4wt3vPQpDKC9m
         fxqLtCdwD/KvL2G/6zbvD9obydLByoyrfhNwfS3qRyE4RAAfT4pyfUAvrUgfzwTGbv
         8QvIemijDZes+8/v2k04ZM4PgkpUaHQt2VnhNcXs=
Subject: FAILED: patch "[PATCH] interconnect: imx: fix registration race" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, abailon@baylibre.com, djakov@kernel.org,
        konrad.dybcio@linaro.org, luca.ceresoli@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:19:39 +0100
Message-ID: <167930397951185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
git cherry-pick -x 9fbd35520f1f7f3cbe1873939a27ad9b009f21f9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930397951185@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

9fbd35520f1f ("interconnect: imx: fix registration race")
f62e3f595c5f ("interconnect: imx: Make imx_icc_unregister() return void")
7ec26b8dcc5c ("interconnect: imx: Ignore return value of icc_provider_del() in .remove()")
c14ec5c93dc8 ("interconnect: imx: Add platform driver for imx8mp")
7980d85a9443 ("interconnect: imx: configure NoC mode/prioriry/ext_control")
12db59e8e0a2 ("interconnect: imx: introduce imx_icc_provider")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fbd35520f1f7f3cbe1873939a27ad9b009f21f9 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:32 +0100
Subject: [PATCH] interconnect: imx: fix registration race

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
Cc: stable@vger.kernel.org      # 5.8
Cc: Alexandre Bailon <abailon@baylibre.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-5-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/interconnect/imx/imx.c b/drivers/interconnect/imx/imx.c
index 823d9be9771a..979ed610f704 100644
--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -295,6 +295,9 @@ int imx_icc_register(struct platform_device *pdev,
 	provider->xlate = of_icc_xlate_onecell;
 	provider->data = data;
 	provider->dev = dev->parent;
+
+	icc_provider_init(provider);
+
 	platform_set_drvdata(pdev, imx_provider);
 
 	if (settings) {
@@ -306,20 +309,18 @@ int imx_icc_register(struct platform_device *pdev,
 		}
 	}
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
+	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	if (ret)
 		return ret;
-	}
 
-	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	ret = icc_provider_register(provider);
 	if (ret)
-		goto provider_del;
+		goto err_unregister_nodes;
 
 	return 0;
 
-provider_del:
-	icc_provider_del(provider);
+err_unregister_nodes:
+	imx_icc_unregister_nodes(&imx_provider->provider);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(imx_icc_register);
@@ -328,9 +329,8 @@ void imx_icc_unregister(struct platform_device *pdev)
 {
 	struct imx_icc_provider *imx_provider = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&imx_provider->provider);
 	imx_icc_unregister_nodes(&imx_provider->provider);
-
-	icc_provider_del(&imx_provider->provider);
 }
 EXPORT_SYMBOL_GPL(imx_icc_unregister);
 

