Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0811B05F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbfLKPWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbfLKPWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035672077B;
        Wed, 11 Dec 2019 15:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077729;
        bh=+KgFr1WTVtExSSrgWrvLQz3fY25SyK3dsgybXHRYDL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHarXUEvp2nRrZTTHLC2FaU6mBS/8zeMectnTuAORi6v6P9HWjbKn/J8TJvbTM90v
         qacgLn0gCrK+WcZBb2cAO2UWKBCLdKUapnRHWm5zJ1/T/vWX2Duh2FoDV6tQpgjy2/
         FuZRd3xlcLOQp7nyjLxA7mKTIgoip5tybnCwAQOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Rob Herring <robh@kernel.org>,
        Wenzhen Yu <wenzhen.yu@mediatek.com>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/243] clk: mediatek: Drop more __init markings for driver probe
Date:   Wed, 11 Dec 2019 16:05:09 +0100
Message-Id: <20191211150349.092000983@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 553604c041b8c18cd6a8e1d785a77f3e4be61cdb ]

This function is called from driver probe, which isn't the same as
__init code because driver probe can happen later. Drop the __init
marking here to fix this potential problem.

Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Wenzhen Yu <wenzhen.yu@mediatek.com>
Cc: Weiyi Lu <weiyi.lu@mediatek.com>
Fixes: 2fc0a509e4ee ("clk: mediatek: add clock support for MT7622 SoC")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt7622.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/mediatek/clk-mt7622.c
+++ b/drivers/clk/mediatek/clk-mt7622.c
@@ -513,7 +513,7 @@ static const struct mtk_gate peri_clks[]
 	GATE_PERI1(CLK_PERI_IRTX_PD, "peri_irtx_pd", "irtx_sel", 2),
 };
 
-static struct mtk_composite infra_muxes[] __initdata = {
+static struct mtk_composite infra_muxes[] = {
 	MUX(CLK_INFRA_MUX1_SEL, "infra_mux1_sel", infra_mux1_parents,
 	    0x000, 2, 2),
 };
@@ -652,7 +652,7 @@ static int mtk_topckgen_init(struct plat
 	return of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
 }
 
-static int __init mtk_infrasys_init(struct platform_device *pdev)
+static int mtk_infrasys_init(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct clk_onecell_data *clk_data;


