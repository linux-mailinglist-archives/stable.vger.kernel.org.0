Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31F064A053
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiLLNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiLLNXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:23:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FEAF24
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:23:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD3CB80D39
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5741C433D2;
        Mon, 12 Dec 2022 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851406;
        bh=Bsp+gK2dKd9CfUFU0p60ha7X0yqHeu41RNEYkfiI3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoLzzAtosBTHLsu7vtDf4ozlIn4Q0v2ZasGqnyJLRlIu3qArhevJWqQLd4uPgZjSj
         PA2PZrudAEq+odDaCr4ZSyMKQTTyuHaxg38uOLC9It+9KS5JlPt/G3+tYVu6ZSDoJJ
         xA7MddEuJHTIqOuqlOz0CZpxmAY4jyTM3PxfQbGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/67] net: stmmac: fix "snps,axi-config" node property parsing
Date:   Mon, 12 Dec 2022 14:17:30 +0100
Message-Id: <20221212130920.253544045@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 61d4f140943c47c1386ed89f7260e00418dfad9d ]

In dt-binding snps,dwmac.yaml, some properties under "snps,axi-config"
node are named without "axi_" prefix, but the driver expects the
prefix. Since the dt-binding has been there for a long time, we'd
better make driver match the binding for compatibility.

Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221202161739.2203-1-jszhang@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 70cbf48c2c03..a2ff9b4727ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -107,10 +107,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
-- 
2.35.1



