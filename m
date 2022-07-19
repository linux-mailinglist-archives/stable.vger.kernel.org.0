Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDC579E65
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbiGSNBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243033AbiGSNAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D5B60697;
        Tue, 19 Jul 2022 05:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7104CB81B21;
        Tue, 19 Jul 2022 12:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D647DC341CB;
        Tue, 19 Jul 2022 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233527;
        bh=4Ae9WzvhYzV9DqfC1sH5vWDfWr4NdbtZgH8jm50vzHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or90O26Uq3doL5sixqECZLD7q6fa9O9r5zpWg0OaoxT2mmagojxyu+6r9vuJq5hUY
         vQms5nvLoIRp3rwXA2tyxi8Y58GXFKw8QJEz8v9FEYey3phpOuKNfl9N8gEazWEQ85
         Y08yhjbYnjHXQZZMmg9u2wevx2LdDyg+q4Fw2IJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 125/231] net: stmmac: fix leaks in probe
Date:   Tue, 19 Jul 2022 13:53:30 +0200
Message-Id: <20220719114724.968377404@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 23aa6d5088e3bd65de77c5c307237b9937f8b48a ]

These two error paths should clean up before returning.

Fixes: 2bb4b98b60d7 ("net: stmmac: Add Ingenic SoCs MAC support.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 9a6d819b84ae..378b4dd826bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -273,7 +273,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->tx_delay = tx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid TX clock delay: %dps\n", tx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
@@ -283,7 +284,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->rx_delay = rx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid RX clock delay: %dps\n", rx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
-- 
2.35.1



