Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40486E6282
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjDRMdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDRMdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895B810273
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B48E63215
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7694DC433EF;
        Tue, 18 Apr 2023 12:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821143;
        bh=L9YzWPCOX6Tn37iacqmi5Bj9fqNMWIZIUte2ajJEPS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9rPA31AhC9FEsPc93FAMXtVi3icdp/ZxLqeLKSKSZUbEjbjrt3lUN2+tGH56YTE1
         3y/3adEBAun7PkcU3wp/ukKrV6qFLKzcDAu6eBR7OaSFK5koawJSlXK7/SLxCjhrsN
         RaORVuK1D2OOVhb4zPFN4HpZULYf+5Db/+z59q34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/124] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
Date:   Tue, 18 Apr 2023 14:20:34 +0200
Message-Id: <20230418120310.196071513@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 4074310abcff4..e4af1f506b833 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2153,7 +2153,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2179,7 +2180,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.2



