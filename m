Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD876BB2B0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbjCOMiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjCOMhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64029B9A9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 270C361D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1B6C433D2;
        Wed, 15 Mar 2023 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883742;
        bh=pQklDcOpLt+p0Nb+ZBaDaCWYy/8v2Ff0jqMLgPhDK4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nP5OcYBmPLzjH7XS53Ebcl14mLoPTuNGOzx0Gdcj6Q5Do2z2Kud1TsiDSdz/n5ITQ
         gEY00Vsc1ICfzgsAhI48ntwI3yfA1zXwmf9BSdqm/cZkIpEFKDVd0mc2RNXhPZ/B//
         G18y93Fd1GckizfRqANkhq0iD94rqxiSl9qW23mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rongguang Wei <weirongguang@kylinos.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/143] net: stmmac: add to set device wake up flag when stmmac init phy
Date:   Wed, 15 Mar 2023 13:12:51 +0100
Message-Id: <20230315115743.116161536@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongguang Wei <weirongguang@kylinos.cn>

[ Upstream commit a9334b702a03b693f54ebd3b98f67bf722b74870 ]

When MAC is not support PMT, driver will check PHY's WoL capability
and set device wakeup capability in stmmac_init_phy(). We can enable
the WoL through ethtool, the driver would enable the device wake up
flag. Now the device_may_wakeup() return true.

But if there is a way which enable the PHY's WoL capability derectly,
like in BIOS. The driver would not know the enable thing and would not
set the device wake up flag. The phy_suspend may failed like this:

[   32.409063] PM: dpm_run_callback(): mdio_bus_phy_suspend+0x0/0x50 returns -16
[   32.409065] PM: Device stmmac-1:00 failed to suspend: error -16
[   32.409067] PM: Some devices failed to suspend, or early wake event detected

Add to set the device wakeup enable flag according to the get_wol
function result in PHY can fix the error in this scene.

v2: add a Fixes tag.

Fixes: 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 84e1740b12f1b..3c1d4b27668fe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1168,6 +1168,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
-- 
2.39.2



