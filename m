Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2E751A624
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353822AbiEDQxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353827AbiEDQwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3847544;
        Wed,  4 May 2022 09:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56E6AB82554;
        Wed,  4 May 2022 16:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0021FC385AF;
        Wed,  4 May 2022 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682920;
        bh=MLY81sk510OJLkxwkZwh0Ccm8v4sy0ctp6+z8ceDhLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlJL7R3DbO0PQSMmGVvCvFKTjSI3ZyLbZPAhyH2l3HH82mgMvFt7Ja6Lc7cY0Xiz5
         kFuWWa/qnX6uCXuCEOO4tOMQPx3pkTUaPQVCRPclQZxHlsmCQ3HwUrijT83GqC5RRY
         EOydwptUQtukvbtX8msmHb+grclqvKAZS59718wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/84] phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks
Date:   Wed,  4 May 2022 18:44:19 +0200
Message-Id: <20220504152930.522335096@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 3588060befff75ff39fab7122b94c6fb3148fcda ]

The corresponding API for clk_prepare_enable is clk_disable_unprepare.
Make sure that the clock is unprepared on exit by changing clk_disable
to clk_disable_unprepare.

Fixes: ed31ee7cf1fe ("phy: ti: usb2: Fix logic on -EPROBE_DEFER")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220318105748.19532-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-omap-usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-omap-usb2.c b/drivers/phy/ti/phy-omap-usb2.c
index 3d74629d7423..471fe2e80f4e 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -157,7 +157,7 @@ static int omap_usb2_enable_clocks(struct omap_usb *phy)
 	return 0;
 
 err1:
-	clk_disable(phy->wkupclk);
+	clk_disable_unprepare(phy->wkupclk);
 
 err0:
 	return ret;
-- 
2.35.1



