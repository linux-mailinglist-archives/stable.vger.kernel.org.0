Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BEE66C6C9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjAPQZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbjAPQYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:24:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F55E2B2BF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02555B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E1C433D2;
        Mon, 16 Jan 2023 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885603;
        bh=tUpAQGzYdEgZQTfBZmWD+v/2SpFVMnWDI3sUBOoKY4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2X0oB9wlwX8Mn5nD/IvyomYTxmD10dBajYvF46xb/Vt6J0bgBveV3x1/6CVwH0rmF
         iGv9/eVcTfYyAor4QIgA3YnGySR7v97lqdwLUfT5/dzNOGT9cP6miEripWg0vuO1x4
         oHq2lrzcdpPicgZao45hZx7V20iZlIajeGkYIcus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ralph Siemsen <ralph.siemsen@linaro.org>,
        Marek Vasut <marex@denx.de>,
        Gareth Williams <gareth.williams.jx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/658] clk: renesas: r9a06g032: Repair grave increment error
Date:   Mon, 16 Jan 2023 16:43:22 +0100
Message-Id: <20230116154914.722828523@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 80df4eb041cc..75954ac1fb9b 100644
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



