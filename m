Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA36D4ABC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjDCOt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjDCOti (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3572A5A7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D4EB81D6D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2666C433EF;
        Mon,  3 Apr 2023 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533266;
        bh=/u36pAPOMM4FKkfVAXpYmaGcEgYao4B+nh1dPNI4ohU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTMhEDCwKy6eRrHvodYkVX6hN6l9dwHyeWhnG/+kaAL1uReYllksU6okG8anaiVQj
         LkPr2ed6tXJYmcel2jgZdec3l4Lsfz5aT96+lLReKCPUX9ML2yQtBaVG/aS/6vY50N
         PJ6BQ4SuM1oG/O1xRwangd9NZZwqyIkCNBi81r7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleksij Rempel <o.rempel@pengutronix.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 088/187] net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID
Date:   Mon,  3 Apr 2023 16:08:53 +0200
Message-Id: <20230403140418.851767989@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9aa5757e1f71d85facdc3c98028762cbab8d15c7 ]

FID is directly mapped to VID. However, configuring a MAC address with a
VID != 0 resulted in incorrect configuration due to an incorrect bit
mask. This kernel commit fixed the issue by correcting the bit mask and
ensuring proper configuration of MAC addresses with non-zero VID.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f8d04a4a303ef..8601a9e4e4d2f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -395,7 +395,7 @@ static const u32 ksz8863_masks[] = {
 	[VLAN_TABLE_VALID]		= BIT(19),
 	[STATIC_MAC_TABLE_VALID]	= BIT(19),
 	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
-	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(25, 22),
 	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
 	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
 	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
-- 
2.39.2



