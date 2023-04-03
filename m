Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5A6D486A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjDCO2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjDCO2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065582CACD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C9561DD3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FB5C4339E;
        Mon,  3 Apr 2023 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532110;
        bh=V7R50GzPEh0LA6RroHUD3MkOHCM67gpVWZSpW7uxhKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuJdGGihNBF9kKi9FMuUymRSQLyLwhGlXA6qOSKaPVx4wFfPcH4w59hUAr75Xuhny
         9cYjzB/IDO+WNqCUKQMth26mSaDOQn72Ss30nA+L339aj/9u6uwA8+dFrnot+L8Q/D
         7oHQj1Co2Uj8RSbRlQFyAtk18+pcx3POm3qoRT/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChunHao Lin <hau@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/173] r8169: fix RTL8168H and RTL8107E rx crc error
Date:   Mon,  3 Apr 2023 16:09:06 +0200
Message-Id: <20230403140418.706912277@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChunHao Lin <hau@realtek.com>

[ Upstream commit 33189f0a94b9639c058781fcf82e4ea3803b1682 ]

When link speed is 10 Mbps and temperature is under -20°C, RTL8168H and
RTL8107E may have rx crc error. Disable phy 10 Mbps pll off to fix this
issue.

Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 913d030d73eb4..e18a76f5049fd 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -970,6 +970,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
+	/* disable 10m pll off */
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
+
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
-- 
2.39.2



