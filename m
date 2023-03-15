Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC76BB188
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjCOM2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjCOM2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631859CFED
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 063E7B81E05
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C47AC4339E;
        Wed, 15 Mar 2023 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883221;
        bh=vAANrNmZuSE++09HkgzhILixUjU4md+cKgIWW9wHNbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2KBj5CxfvPdvf+15J33YtfkceIwHILOga9TeW0SaTxzRMK/aT7Velc6Rm2VuS5Ru
         XvUlV06ykJOJD4bO5SQ24diZ0sKgalHKCPjauWZPeTHWd5lNfzZrJBHovFh51R+qXT
         dtvHnVGJsg8Uya36CXbv2cBDQ+fcExhdQKfQVujo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rongguang Wei <weirongguang@kylinos.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/145] net: stmmac: add to set device wake up flag when stmmac init phy
Date:   Wed, 15 Mar 2023 13:12:07 +0100
Message-Id: <20230315115741.047695836@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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
index d56f65338ea66..728e68971c397 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1262,6 +1262,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
-- 
2.39.2



