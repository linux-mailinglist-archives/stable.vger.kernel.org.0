Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A24664B1C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbjAJSiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbjAJSiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600CC10B3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F06C061846
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6B1C433EF;
        Tue, 10 Jan 2023 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375610;
        bh=pVdiIitNul5NXHt+7J2ZK1/ODbbM2U/unFVJGDXMS5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIJKANqGWEMF/O8kUBmSlO1oNpJ0qjX3hTvWEBdeebJv5wnHJCsIy9fLBcz647yuM
         SViHoGxpRsUpMARX+95DUQ4pCzOt2PTz+rnif5nf3FeZuT0aBNmaE6PeRdrn70S7fb
         /4wYGzsg/hU3MEVW2VWs1JswmMbtmMko+WAUXqUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/290] net: sparx5: Fix reading of the MAC address
Date:   Tue, 10 Jan 2023 19:05:38 +0100
Message-Id: <20230110180040.505635718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 588ab2dc25f60efeb516b4abedb6c551949cc185 ]

There is an issue with the checking of the return value of
'of_get_mac_address', which returns 0 on success and negative value on
failure. The driver interpretated the result the opposite way. Therefore
if there was a MAC address defined in the DT, then the driver was
generating a random MAC address otherwise it would use address 0.
Fix this by checking correctly the return value of 'of_get_mac_address'

Fixes: b74ef9f9cb91 ("net: sparx5: Do not use mac_addr uninitialized in mchp_sparx5_probe()")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 0463f20da17b..174d89ee6374 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -779,7 +779,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_config;
 
-	if (!of_get_mac_address(np, sparx5->base_mac)) {
+	if (of_get_mac_address(np, sparx5->base_mac)) {
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
-- 
2.35.1



