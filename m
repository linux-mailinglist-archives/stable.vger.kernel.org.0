Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE106674BF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbjALOMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjALOKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:10:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5445159303
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A12CACE1E72
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C945C433EF;
        Thu, 12 Jan 2023 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532330;
        bh=ee6Wcty2UHwoCozXUm9Reaq+Fnf52wtcFPoFY0NvyFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+GYffFkBD3UEFL56jHtzzh1A2XXph3jOsI68eQjLsf6hd5mkbniqjiddLCjnxvE9
         XiuIBvxSvht8Yt02UkFSNGPIEPeBAm48woV9yfUIFPWuBZkcH1CgHg6eR7oZdipCr6
         yJgelBrL2USj/XWx7e7cRJeP8azp+xJkJTDp8hvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ralph Siemsen <ralph.siemsen@linaro.org>,
        Marek Vasut <marex@denx.de>,
        Gareth Williams <gareth.williams.jx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/783] clk: renesas: r9a06g032: Repair grave increment error
Date:   Thu, 12 Jan 2023 14:47:22 +0100
Message-Id: <20230112135530.137460252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 02693e11611e082e3c4d8653e8af028e43d31164 ]

If condition (clkspec.np != pd->dev.of_node) is true, then the driver
ends up in an endless loop, forever, locking up the machine.

Fixes: aad03a66f902 ("clk: renesas: r9a06g032: Add clock domain support")
Reviewed-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Gareth Williams <gareth.williams.jx@renesas.com>
Link: https://lore.kernel.org/r/20221028113834.7496-1-marex@denx.de
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index 245150a5484a..285f6ac25372 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -386,7 +386,7 @@ static int r9a06g032_attach_dev(struct generic_pm_domain *pd,
 	int error;
 	int index;
 
-	while (!of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
+	while (!of_parse_phandle_with_args(np, "clocks", "#clock-cells", i++,
 					   &clkspec)) {
 		if (clkspec.np != pd->dev.of_node)
 			continue;
@@ -399,7 +399,6 @@ static int r9a06g032_attach_dev(struct generic_pm_domain *pd,
 			if (error)
 				return error;
 		}
-		i++;
 	}
 
 	return 0;
-- 
2.35.1



