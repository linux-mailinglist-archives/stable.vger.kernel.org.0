Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949CE6C1605
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjCTPB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjCTPBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:01:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E6E20D1A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A5D6157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A6BC433D2;
        Mon, 20 Mar 2023 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324237;
        bh=iLCDNRV4/NxwVeMya5YBymrKnraDRowGfHfk7pLd0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHIcDRY3AF851WsEED5Kk+D4XsXGYUMPu6ApwxzM8TVLGbBrXxWPvtgc7y4Zkkv6j
         yR3rA/psYxrF6R8l787bgd2//vt2Ar0TU6o0CZ4vc9yg8uZdaBcl9EW4t06tOni/MH
         X2OE67qJKq5OViKheQtJxgy3HRPNgkIhY5SdA3iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/30] net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails
Date:   Mon, 20 Mar 2023 15:54:31 +0100
Message-Id: <20230320145420.510099260@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit c22c3bbf351e4ce905f082649cffa1ff893ea8c1 ]

If genphy_read_status fails then further access to the PHY may result
in unpredictable behavior. To prevent this bail out immediately if
genphy_read_status fails.

Fixes: 4223dbffed9f ("net: phy: smsc: Re-enable EDPD mode for LAN87xx")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 2306bfae057f0..d5d96e728683f 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -112,8 +112,11 @@ static int lan911x_config_init(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable) {
 		int i;
-- 
2.39.2



