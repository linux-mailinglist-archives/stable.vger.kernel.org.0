Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDD5F2C4C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJCIr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJCIro (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFD8303FD;
        Mon,  3 Oct 2022 01:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D94D660FC7;
        Mon,  3 Oct 2022 07:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8898C433C1;
        Mon,  3 Oct 2022 07:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781814;
        bh=yJH+DH/MBw06qOQ7zGKisV+IjR/x0YMvHP50zzRHvQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ8KA2r8RyGwwK4X+TM7ZTzlF2nfBA1qN1n5GEhrti927zweH62xSo5qt7eo3aOUf
         zLD4Wk+Q0wzjLprkTUjH1TpvAhdswERycFH23QMCH4Q0PGfaQq+9ZaGplciSWoM+EQ
         9dvoZmjs9R+J3yzvf62lSEFuJ8lMS04Xm4TspDFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cai Huoqing <caihuoqing@baidu.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/30] soc: sunxi_sram: Make use of the helper function devm_platform_ioremap_resource()
Date:   Mon,  3 Oct 2022 09:12:02 +0200
Message-Id: <20221003070716.891253183@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
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

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit 1f3753a5f042fea6539986f9caf2552877527d8a ]

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210908071716.772-1-caihuoqing@baidu.com
Stable-dep-of: 49fad91a7b89 ("soc: sunxi: sram: Fix probe function ordering issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 50f6af90017b..3a350828965e 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -321,7 +321,6 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 
 static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct dentry *d;
 	struct regmap *emac_clock;
 	const struct sunxi_sramc_variant *variant;
@@ -332,8 +331,7 @@ static int __init sunxi_sram_probe(struct platform_device *pdev)
 	if (!variant)
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.35.1



