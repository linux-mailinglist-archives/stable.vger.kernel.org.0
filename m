Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B915949DD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244614AbiHOXP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244510AbiHOXOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4815C7B1E4;
        Mon, 15 Aug 2022 13:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D6FB80EAD;
        Mon, 15 Aug 2022 20:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D6EC433D6;
        Mon, 15 Aug 2022 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593675;
        bh=RFuo3WxZHd0czDWPWQq5UQkkkavjlJKyFlZDppA2rJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ye9a+lfIbFO4FCFcltTrjeGwHIaGb0aIYlYpzT+Zob/RDvck4G/yNvK9ZYwqdH/Sg
         rKDhKBmxEQ9BmPUjXQToNftxIaBqvdzpQs1clGyjKtaQcML0R0u4zBSsgfErbRJ6mX
         2mluBBiv8Paz5VDJovcfH0ZP1urCCSlN6VHnF80o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 5.18 0985/1095] usbnet: smsc95xx: Dont clear read-only PHY interrupt
Date:   Mon, 15 Aug 2022 20:06:24 +0200
Message-Id: <20220815180509.873447422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3108871f19221372b251f7da1ac38736928b5b3a ]

Upon receiving data from the Interrupt Endpoint, the SMSC LAN95xx driver
attempts to clear the signaled interrupts by writing "all ones" to the
Interrupt Status Register.

However the driver only ever enables a single type of interrupt, namely
the PHY Interrupt.  And according to page 119 of the LAN950x datasheet,
its bit in the Interrupt Status Register is read-only.  There's no other
way to clear it than in a separate PHY register:

https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf

Consequently, writing "all ones" to the Interrupt Status Register is
pointless and can be dropped.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index edf0492ad489..2cb44d65bbc3 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -572,10 +572,6 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	unsigned long flags;
 	int ret;
 
-	ret = smsc95xx_write_reg(dev, INT_STS, INT_STS_CLEAR_ALL_);
-	if (ret < 0)
-		return ret;
-
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
 	if (pdata->phydev->duplex != DUPLEX_FULL) {
 		pdata->mac_cr &= ~MAC_CR_FDPX_;
-- 
2.35.1



