Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1073664884
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbjAJSMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbjAJSLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE94BE34
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 491EFB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9872DC433D2;
        Tue, 10 Jan 2023 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374199;
        bh=tiz+G0ydZ3N5yFs+PGFF9ty06T6IidQpYrgAaZoLfgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+b75bNJ06ZflST9RLjkoIHZs8cD7KoD6DLPbKNgvBfdt38V4THEGmkP44pxWfGP0
         1/RJzElSnjOxJGtuTn0YN/MoF8+TGKlgq/yCYOJMPPvMFFtRYm8EJnVl/MP1mqJC7c
         4mjvyTprDJMLt9+d+QyjWkJi6W54eOF73l5A7GYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 083/148] net: sparx5: Fix reading of the MAC address
Date:   Tue, 10 Jan 2023 19:03:07 +0100
Message-Id: <20230110180019.834629281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index e58de119186a..a2d0631f7ac7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -819,7 +819,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_config;
 
-	if (!of_get_mac_address(np, sparx5->base_mac)) {
+	if (of_get_mac_address(np, sparx5->base_mac)) {
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
-- 
2.35.1



