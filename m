Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12DC6C0D02
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCTJUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjCTJTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:19:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FE199E8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:19:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB724B80D84
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025A9C433EF;
        Mon, 20 Mar 2023 09:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303981;
        bh=04Eyj2bsOOtfxtOddp/B9Qzc+fxXweufEoGDqvfo3ys=;
        h=Subject:To:Cc:From:Date:From;
        b=cOJSHSKEz+h23+Iuqdv+0JIc5EmgTdXjFDkZfq67G+4CS+5GvUy3c7eWBUklXdF94
         n59p/FQ3VwAZAi8eVBujlBHQT7iHnZ+5TkIfef4Ejc4H42LIdcakIYuCN0i8hu+eGA
         5lCcgTTxDkrPSFVVFlgK1J4tOjw/RiXIQvhuA274=
Subject: FAILED: patch "[PATCH] interconnect: imx: fix registration race" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, abailon@baylibre.com, djakov@kernel.org,
        konrad.dybcio@linaro.org, luca.ceresoli@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:19:38 +0100
Message-ID: <1679303978128132@kroah.com>
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
git cherry-pick -x 9fbd35520f1f7f3cbe1873939a27ad9b009f21f9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679303978128132@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

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
 

