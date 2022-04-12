Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20924FD764
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377371AbiDLHt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359000AbiDLHmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E8254BEA;
        Tue, 12 Apr 2022 00:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21260616B2;
        Tue, 12 Apr 2022 07:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3363FC385A5;
        Tue, 12 Apr 2022 07:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747992;
        bh=/MhjeC+qeq6mCrT31vIqxllJ2jeahzxHNttzVwcFrsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wxq/Fn8ZaHfFhc8Q+OqjCd0Fp10+VZv4+v9t9jp+dUuha03ZyuRw57bM/yKFmJP3N
         HzHd0m39Fp5rBkrPHUzmwQ4i9WJqiN2jlziDHKf8seG5v8F9N/b+wpOQnbMzSgYHaJ
         a3un6qG/yc7Db5m6FPRFbnQxFGx4J6ZhTWawNqNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <maukka@ext.kapsi.fi>,
        Thomas Walther <walther-it@gmx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 240/343] net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()
Date:   Tue, 12 Apr 2022 08:30:58 +0200
Message-Id: <20220412062958.260214223@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 143ca8be5eb5..4008596963be 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2751,7 +2751,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	}
 
 	ret = of_get_mac_address(pnp, ppd.mac_addr);
-	if (ret)
+	if (ret == -EPROBE_DEFER)
 		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
-- 
2.35.1



