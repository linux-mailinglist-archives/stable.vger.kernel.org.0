Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2428501404
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244651AbiDNOGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiDNN7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FC840A22;
        Thu, 14 Apr 2022 06:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15D561DF2;
        Thu, 14 Apr 2022 13:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C024DC385A9;
        Thu, 14 Apr 2022 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944201;
        bh=VxIjDwH7eRyRaCftgapw72SxFpbdfPP7dZX6OClGp/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+xSDk9TGLSoEOD8vv5AQhUtDcLhuXqy7eVLX386XDO8k2SbTTtgxQmk9gcew55/f
         KJfBz/m0YriIfkd6qSfiLcvWm0M/l8qucxC2bSATOpqTELtlwAl0zEQ7VlzpdlWMZF
         MiEGbe/dqBQbzYwAxuD9fxiQQFBa6EwcQzCFAOA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 429/475] net: stmmac: Fix unset max_speed difference between DT and non-DT platforms
Date:   Thu, 14 Apr 2022 15:13:34 +0200
Message-Id: <20220414110907.069616917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit c21cabb0fd0b54b8b54235fc1ecfe1195a23bcb2 ]

In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
property"), when DT platforms don't set "max-speed", max_speed is set to
-1; for non-DT platforms, it stays the default 0.

Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
the check for a valid max_speed setting was to check if it was greater
than zero. This commit got it right, but subsequent patches just checked
for non-zero, which is incorrect for DT platforms.

In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
the conversion switched completely to checking for non-zero value as a
valid value, which caused 1000base-T to stop getting advertised by
default.

Instead of trying to fix all the checks, simply leave max_speed alone if
DT property parsing fails.

Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220331184832.16316-1-wens@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index a46fea472bc4..70cbf48c2c03 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -428,8 +428,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->phylink_node = np;
 
 	/* Get max speed of operation from device tree */
-	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
-		plat->max_speed = -1;
+	of_property_read_u32(np, "max-speed", &plat->max_speed);
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
-- 
2.35.1



