Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C26D4755
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbjDCOTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjDCOTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A22CAD6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A19B81BA8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6BCC4339B;
        Mon,  3 Apr 2023 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531556;
        bh=oTYcsKz5mlHTMJn7GtLdLz8Ts0xxU/HsY4xWh9XaYkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cBt3M7rs3kSzkNJZ8Ww9yjBrHfXjHS+6CYZo3bB/RIhxUR7jkMKeveChy08sz9rx
         +oK4yx/+ICxX7jZZEA0zVzJVebNmz5W6CBz5dCfSos52hX+wGbdKsitpF8bCeMMmsQ
         0B/44yjADw5Yob5d1tFG27lG0FPv1f9pAgXnJ4FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/104] net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case
Date:   Mon,  3 Apr 2023 16:08:15 +0200
Message-Id: <20230403140405.153933489@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]

Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
case as it's only needed when trgmii is used.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230320190520.124513-3-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2d8382eb9add3..5bd282cb3d9f2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -396,6 +396,10 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
+		if (xtal == HWTRAP_XTAL_25MHZ)
+			ssc_delta = 0x57;
+		else
+			ssc_delta = 0x87;
 		if (priv->id == ID_MT7621) {
 			/* PLL frequency: 150MHz: 1.2GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
@@ -414,11 +418,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 		return -EINVAL;
 	}
 
-	if (xtal == HWTRAP_XTAL_25MHZ)
-		ssc_delta = 0x57;
-	else
-		ssc_delta = 0x87;
-
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
-- 
2.39.2



