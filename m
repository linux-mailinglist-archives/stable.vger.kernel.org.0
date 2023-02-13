Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4AD6948D2
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjBMOxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjBMOxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A02518A81
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEAFE61146
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7928C433D2;
        Mon, 13 Feb 2023 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300000;
        bh=P28wWRqcE4Yv3InFizkeWzNhezR7Zr8Cr8C4IZaUoiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlKDNhtX/fPiHyfQ8oAPOCMQrRA94hYuxoMwtxBMrYjemT1xSrP79JUyuiKmlb8GX
         v5DOk8PgejbgPkQFMaQGBvNa+kkxanrQN+TJssXVvQ72IdqfQJ11GTgWllX6FPmkFl
         BOpecK4Af0oOxKizmNGSfDlL33Q1KnFwsWexRYtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/114] net: phylink: move phy_device_free() to correctly release phy device
Date:   Mon, 13 Feb 2023 15:47:40 +0100
Message-Id: <20230213144743.443479433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit ce93fdb5f2ca5c9e2a9668411cc39091507f8dc9 ]

After calling fwnode_phy_find_device(), the phy device refcount is
incremented. Then, when the phy device is attached to a netdev with
phy_attach_direct(), the refcount is also incremented but only
decremented in the caller if phy_attach_direct() fails. Move
phy_device_free() before the "if" to always release it correctly.
Indeed, either phy_attach_direct() failed and we don't want to keep a
reference to the phydev or it succeeded and a reference has been taken
internally.

Fixes: 25396f680dd6 ("net: phylink: introduce phylink_fwnode_phy_connect()")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2805b04d64028..a202ce6611fde 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1793,10 +1793,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
-	if (ret) {
-		phy_device_free(phy_dev);
+	phy_device_free(phy_dev);
+	if (ret)
 		return ret;
-	}
 
 	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
-- 
2.39.0



