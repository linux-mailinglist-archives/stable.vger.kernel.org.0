Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FDA4BDBBD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346691AbiBUJto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352910AbiBUJsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D120199;
        Mon, 21 Feb 2022 01:21:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC3060EDF;
        Mon, 21 Feb 2022 09:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C2DC340E9;
        Mon, 21 Feb 2022 09:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435275;
        bh=OXvfCS9PD0SNk8WUZWIhK1lM9qzjLIKjwNP/Cekcf6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs3uHlCzBGTpb4Fpk8rTBUaPXesGLgGvMlQ6HkKp1sJcPFUoHySeFzxlEBcguUUjE
         gPAxh7jcqJ7z7OBSeQKS6fhWaxLyW1Rq/Wk/ouYR4zwUt/CL3PikUFQAIlWQjDl/PI
         ROBpe3d7wMoeYdWwEhQtW94z9VMIFo+uL3FS5mCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 105/227] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
Date:   Mon, 21 Feb 2022 09:48:44 +0100
Message-Id: <20220221084938.366020326@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 6aba04ee3263669b335458c4cf4c7d97d6940229 upstream.

This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.

Since idm_base and nicpm_base are still optional resources not present
on all platforms, this breaks the driver for everything except Northstar
2 (which has both).

The same change was already reverted once with 755f5738ff98 ("net:
broadcom: fix a mistake about ioremap resource").

So let's do it again.

Fixes: 3710e80952cf ("net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
[florian: Added comments to explain the resources are optional]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220216184634.2032460-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,6 +172,7 @@ static int bgmac_probe(struct platform_d
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
+	struct resource *regs;
 	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -208,15 +209,23 @@ static int bgmac_probe(struct platform_d
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
-	if (IS_ERR(bgmac->plat.idm_base))
-		return PTR_ERR(bgmac->plat.idm_base);
-	else
+	/* The idm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
+	if (regs) {
+		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
+		if (IS_ERR(bgmac->plat.idm_base))
+			return PTR_ERR(bgmac->plat.idm_base);
 		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
+	}
 
-	bgmac->plat.nicpm_base = devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
-	if (IS_ERR(bgmac->plat.nicpm_base))
-		return PTR_ERR(bgmac->plat.nicpm_base);
+	/* The nicpm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
+	if (regs) {
+		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
+							       regs);
+		if (IS_ERR(bgmac->plat.nicpm_base))
+			return PTR_ERR(bgmac->plat.nicpm_base);
+	}
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;


