Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04114FD5BC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346009AbiDLHTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351674AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF2213FAB;
        Mon, 11 Apr 2022 23:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02B82B81B49;
        Tue, 12 Apr 2022 06:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C90BC385A1;
        Tue, 12 Apr 2022 06:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746284;
        bh=brRah2FuEZfM4nCDSAXpZRubw7Gb1YvCQJxvJrQ1hmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsaGjvIBagS1Y6Df1tCOL7ENUUqMBN8CXqLWhbQTUYZAA1RLQ0OKL9DddtOdzNOa2
         VH48JH3FqVqLQHHrTAtgTrz7IqBnszNmFF79a8qvxsPirTtYBcTgDVW1+z3jccfvK2
         TlJ3RIxgX8Cz33qn/qPEcJLjRmbMxVQrAx1xDOIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <maukka@ext.kapsi.fi>,
        Thomas Walther <walther-it@gmx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/277] net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()
Date:   Tue, 12 Apr 2022 08:29:50 +0200
Message-Id: <20220412062947.447835407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 11f8e7c122ce013fa745029fa8c94c6db69c2e54 ]

There is often not a MAC address available in an EEPROM accessible by
Linux with Marvell devices. Instead the bootload has the MAC address
and directly programs it into the hardware. So don't consider an error
from of_get_mac_address() has fatal. However, the check was added for
the case where there is a MAC address in an the EEPROM, but the EEPROM
has not probed yet, and -EPROBE_DEFER is returned. In that case the
error should be returned. So make the check specific to this error
code.

Cc: Mauri Sandberg <maukka@ext.kapsi.fi>
Reported-by: Thomas Walther <walther-it@gmx.de>
Fixes: 42404d8f1c01 ("net: mv643xx_eth: process retval from of_get_mac_address")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220405000404.3374734-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 1b61fe2e9b4d..90fd5588e20d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2747,7 +2747,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	}
 
 	ret = of_get_mac_address(pnp, ppd.mac_addr);
-	if (ret)
+	if (ret == -EPROBE_DEFER)
 		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
-- 
2.35.1



