Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD360ACAB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiJXOLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiJXOKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79234C4DA8;
        Mon, 24 Oct 2022 05:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED3D612BB;
        Mon, 24 Oct 2022 12:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6CCC433C1;
        Mon, 24 Oct 2022 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615830;
        bh=64gELA0nUsV9N2NViMDvTXlYD/PS9XrRDXeAPBJL2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vplQIgJsOsmA8kKKAkssKf7WW8u3SvGuXdpbJNG5BRehyXDoTv+rcNjKPaZJ0d2lB
         1WBPEZY9TC/A84GEzWBjt4Tqd1U1xPsOx7lENOGTdqyJUYFvuLnXAieNpsyFu6sndT
         /Scc6pxAgoUbXiQx/knDiVKiTZxHYNgOMb1fpuFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/530] clk: ast2600: BCLK comes from EPLL
Date:   Mon, 24 Oct 2022 13:31:42 +0200
Message-Id: <20221024113101.242236415@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit b8c1dc9c00b252b3be853720a71b05ed451ddd9f ]

This correction was made in the u-boot SDK recently. There are no
in-tree users of this clock so the impact is minimal.

Fixes: d3d04f6c330a ("clk: Add support for AST2600 SoC")
Link: https://github.com/AspeedTech-BMC/u-boot/commit/8ad54a5ae15f27fea5e894cc2539a20d90019717
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220421040426.171256-1-joel@jms.id.au
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-ast2600.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-ast2600.c b/drivers/clk/clk-ast2600.c
index 24dab2312bc6..9c3305bcb27a 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -622,7 +622,7 @@ static int aspeed_g6_clk_probe(struct platform_device *pdev)
 	regmap_write(map, 0x308, 0x12000); /* 3x3 = 9 */
 
 	/* P-Bus (BCLK) clock divider */
-	hw = clk_hw_register_divider_table(dev, "bclk", "hpll", 0,
+	hw = clk_hw_register_divider_table(dev, "bclk", "epll", 0,
 			scu_g6_base + ASPEED_G6_CLK_SELECTION1, 20, 3, 0,
 			ast2600_div_table,
 			&aspeed_g6_clk_lock);
-- 
2.35.1



