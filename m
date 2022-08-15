Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E122B5937DF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiHOTXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344800AbiHOTVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968B39B80;
        Mon, 15 Aug 2022 11:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B99EFB81092;
        Mon, 15 Aug 2022 18:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC08EC433D6;
        Mon, 15 Aug 2022 18:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588829;
        bh=wh6oA0bfx8XoMes9N0kUyWQLjD1kB7YEXaTdqVFx3jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSpg9xf1W0QEnDsCGNbPn/naDn4ceV+PszL6WIDBU0eoL2lkPc1NHQbaWV++J+Fop
         GNJGlm23oP5cfl++iAOk6pyERnZQAnc3FCkD1Ua8NZR9T/6NPYISzfzs+Wg1nMftNs
         SUjX2RQBEzhQ/rlDnDURU7CG5vJe8vY0pM1IPPD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/779] phy: stm32: fix error return in stm32_usbphyc_phy_init
Date:   Mon, 15 Aug 2022 20:02:20 +0200
Message-Id: <20220815180358.486937276@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 32b378a9179ae4db61cfc5d502717214e6cd1e1c ]

Error code is overridden, in case the PLL doesn't lock. So, the USB
initialization can continue. This leads to a platform freeze.
This can be avoided by returning proper error code to avoid USB probe
freezing the platform. It also displays proper errors in log.

Fixes: 5b1af71280ab ("phy: stm32: rework PLL Lock detection")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220713133953.595134-1-fabrice.gasnier@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index da05642d3bd4..cd0747ab6267 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -279,7 +279,9 @@ static int stm32_usbphyc_phy_init(struct phy *phy)
 	return 0;
 
 pll_disable:
-	return stm32_usbphyc_pll_disable(usbphyc);
+	stm32_usbphyc_pll_disable(usbphyc);
+
+	return ret;
 }
 
 static int stm32_usbphyc_phy_exit(struct phy *phy)
-- 
2.35.1



