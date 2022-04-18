Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC585050F7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbiDRMaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238853AbiDRM0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39DA1C923;
        Mon, 18 Apr 2022 05:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 142EEB80ED7;
        Mon, 18 Apr 2022 12:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7502BC385A7;
        Mon, 18 Apr 2022 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284446;
        bh=nalTxQnhUJKqDr2j0DbblOwFjGxGPdimyiSX8khqBHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNPno7taa5p0/XXeA2teky/ZTST9ofpyGfI6cC8zrW3EqS8DkXV5K2La134kKu45x
         58q5Kf0EG2tLbhuUzZzubj9l/4PJ8mBgsBr+oY06ZjFg7oAJ4xA951gQ2EQBFHOdsa
         8+Z39/MkGoso14zGbiTCJmAhnEQoCC5+67XUlj2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 118/219] net: ftgmac100: access hardware register after clock ready
Date:   Mon, 18 Apr 2022 14:11:27 +0200
Message-Id: <20220418121210.202112283@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Dylan Hung <dylan_hung@aspeedtech.com>

[ Upstream commit 3d2504524531990b32a0629cc984db44f399d161 ]

AST2600 MAC register 0x58 is writable only when the MAC clock is
enabled.  Usually, the MAC clock is enabled by the bootloader so
register 0x58 is set normally when the bootloader is involved.  To make
ast2600 ftgmac100 work without the bootloader, postpone the register
write until the clock is ready.

Fixes: 137d23cea1c0 ("net: ftgmac100: Fix Aspeed ast2600 TX hang issue")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index d5356db7539a..caf48023f8ea 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1835,11 +1835,6 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		priv->rxdes0_edorr_mask = BIT(30);
 		priv->txdes0_edotr_mask = BIT(30);
 		priv->is_aspeed = true;
-		/* Disable ast2600 problematic HW arbitration */
-		if (of_device_is_compatible(np, "aspeed,ast2600-mac")) {
-			iowrite32(FTGMAC100_TM_DEFAULT,
-				  priv->base + FTGMAC100_OFFSET_TM);
-		}
 	} else {
 		priv->rxdes0_edorr_mask = BIT(15);
 		priv->txdes0_edotr_mask = BIT(15);
@@ -1911,6 +1906,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		err = ftgmac100_setup_clk(priv);
 		if (err)
 			goto err_phy_connect;
+
+		/* Disable ast2600 problematic HW arbitration */
+		if (of_device_is_compatible(np, "aspeed,ast2600-mac"))
+			iowrite32(FTGMAC100_TM_DEFAULT,
+				  priv->base + FTGMAC100_OFFSET_TM);
 	}
 
 	/* Default ring sizes */
-- 
2.35.1



