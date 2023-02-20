Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68EA69CE18
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjBTNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbjBTNzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:55:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D531CF46
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6DFC60E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC64C433D2;
        Mon, 20 Feb 2023 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901351;
        bh=w7ivuMPiJfkJTymSHg/3v8lZR4QPyBRC426Jftrj+v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+nwPBKQgyGf1h/NpYbm5TpSlVth8hhlfEX3zh1dnXYpy5CXcMj/7ZeTKOCfIf75B
         gmeXVcxFvvu535OLz1MCGJdXDILE7BNvCgNJJ+Ey/DrlbeXpLtqESmu8u7j0Yltxtq
         YixHJjv7buqrCflqXlS47KmbsZ+UYjA1zqO6n85I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 41/57] net: stmmac: Restrict warning on disabling DMA store and fwd mode
Date:   Mon, 20 Feb 2023 14:36:49 +0100
Message-Id: <20230220133550.801475080@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 05d7623a892a9da62da0e714428e38f09e4a64d8 upstream.

When setting 'snps,force_thresh_dma_mode' DT property, the following
warning is always emitted, regardless the status of force_sf_dma_mode:

dwmac-starfive 10020000.ethernet: force_sf_dma_mode is ignored if force_thresh_dma_mode is set.

Do not print the rather misleading message when DMA store and forward
mode is already disabled.

Fixes: e2a240c7d3bc ("driver:net:stmmac: Disable DMA store and forward mode if platform data force_thresh_dma_mode is set.")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230210202126.877548-1-cristian.ciocaltea@collabora.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -559,7 +559,7 @@ stmmac_probe_config_dt(struct platform_d
 	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
 
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
-	if (plat->force_thresh_dma_mode) {
+	if (plat->force_thresh_dma_mode && plat->force_sf_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		dev_warn(&pdev->dev,
 			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");


