Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7230369CCCB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjBTNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjBTNna (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:43:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE71C302
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D29B860E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E29C433D2;
        Mon, 20 Feb 2023 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900608;
        bh=UkU42FwtnoqM34MiFodoP+gigTYxMOJjHXJ86iLa1Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L54BK4cWDUMG7mldiEMpGyQJYUZ+5e4+QuulUKPmX6RpILFTrlsE5qGm3b3KHmGwE
         2K4fgNKCrislJpXrqeM+/sfAgKgxMZiM5w56sECj8jCI6QO4vuhInjslE1mIEUOM14
         b60czd4FE+iLJYJoi1FjTjg1a2FtzPQf8dpMeNAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 82/89] net: stmmac: Restrict warning on disabling DMA store and fwd mode
Date:   Mon, 20 Feb 2023 14:36:21 +0100
Message-Id: <20230220133556.055964788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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
@@ -518,7 +518,7 @@ stmmac_probe_config_dt(struct platform_d
 	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
 
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
-	if (plat->force_thresh_dma_mode) {
+	if (plat->force_thresh_dma_mode && plat->force_sf_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		pr_warn("force_sf_dma_mode is ignored if force_thresh_dma_mode is set.");
 	}


