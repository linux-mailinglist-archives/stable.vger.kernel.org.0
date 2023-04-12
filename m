Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548686DEE80
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjDLImG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDLIlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D827EE3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B274E63039
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C679EC433EF;
        Wed, 12 Apr 2023 08:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288857;
        bh=6lWKfKBulpNklmb+GAvy3/ZlKbxPIwivjxix0FnIlcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llGxHILfaOIe7wF2rE0qpELlTx6SR3ZbPw2EzeMNs6sxZcHNOvYab7R6XAB6LILPP
         FYD1kNYJWoQa8lzmMYcMbXNxhlWRKbMTbUKdDhfYOEcXqcILnVp5mB2CUQhTjh7b+G
         uGwO51QFrRwXrkJnL74+hZAkpcT009deQiUNLXmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/164] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
Date:   Wed, 12 Apr 2023 10:32:44 +0200
Message-Id: <20230412082838.638651795@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit c6b486fb33680ad5a3a6390ce693c835caaae3f7 ]

In the am65_cpsw_nuss_probe() function's cleanup path, the call to
of_platform_device_destroy() for the common->mdio_dev device is invoked
unconditionally. It is possible that either the MDIO node is not present
in the device-tree, or the MDIO node is disabled in the device-tree. In
both these cases, the MDIO device is not created, resulting in a NULL
pointer dereference when the of_platform_device_destroy() function is
invoked on the common->mdio_dev device on the cleanup path.

Fix this by ensuring that the common->mdio_dev device exists, before
attempting to invoke of_platform_device_destroy().

Fixes: a45cfcc69a25 ("net: ethernet: ti: am65-cpsw-nuss: use of_platform_device_create() for mdio")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230403090321.835877-1-s-vadapalli@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8ff1c84a23ce7..25466cbdc16bd 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2819,7 +2819,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2848,7 +2849,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.2



