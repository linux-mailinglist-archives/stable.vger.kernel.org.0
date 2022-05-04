Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9092051A715
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354313AbiEDRBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354885AbiEDQ7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4CD48310;
        Wed,  4 May 2022 09:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB0E617C4;
        Wed,  4 May 2022 16:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C5FC385B1;
        Wed,  4 May 2022 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683064;
        bh=JD/ygaqNAPbJJVlFYWXUglaqn74YGk482auv9jzluJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pp4e/7fW2bwC94SqE1Qr4EDOdYU2fw3riXJD8gJdWLoPtVAxcB0oWmgqwO5iXSSqe
         10uTpQ2j/7p5nVvkOFFK1zk4tCAiQ457xAimF9BGJJ0QXgewBO5CddP4VpfJcH26qV
         5nGRPq3M/BtsMdXbdUKzh2W+CmejguSWGoonvCQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/129] phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks
Date:   Wed,  4 May 2022 18:44:01 +0200
Message-Id: <20220504153024.984373871@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
index 4fec90d2624f..f77ac041d836 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -215,7 +215,7 @@ static int omap_usb2_enable_clocks(struct omap_usb *phy)
 	return 0;
 
 err1:
-	clk_disable(phy->wkupclk);
+	clk_disable_unprepare(phy->wkupclk);
 
 err0:
 	return ret;
-- 
2.35.1



