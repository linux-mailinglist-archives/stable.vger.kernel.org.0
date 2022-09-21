Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739735C02EB
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIUP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiIUP4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:56:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB629F8FF;
        Wed, 21 Sep 2022 08:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B557DB827D4;
        Wed, 21 Sep 2022 15:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1115EC433C1;
        Wed, 21 Sep 2022 15:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775449;
        bh=ienKP1MV/qqUYIaRNSoy9Pszc3E/nPCebcPJi5veVjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13fYbqbT/QNXEh4FYdJsSMjJH317bP5CviRr300VxFt7mXYAWwPTzDg9pfhMNjS0E
         nJl+j0zujSxAIVAQ+UOLnTgDgk9ZXKbS8VdZWtpvbNwNZ91tCNk55dhSLMBQjtgqcU
         5W1DO1pkSBKQthaTMDkqtEDQy1/hoE3GGDzgybjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyn Welch <martyn.welch@collabora.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/39] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports
Date:   Wed, 21 Sep 2022 17:46:16 +0200
Message-Id: <20220921153646.121763439@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 04ec4e6250e5f58b525b08f3dca45c7d7427620e ]

Martyn Welch reports that his CPU port is unable to link where it has
been necessary to use one of the switch ports with an internal PHY for
the CPU port. The reason behind this is the port control register is
left forcing the link down, preventing traffic flow.

This occurs because during initialisation, phylink expects the link to
be down, and DSA forces the link down by synthesising a call to the
DSA drivers phylink_mac_link_down() method, but we don't touch the
forced-link state when we later reconfigure the port.

Resolve this by also unforcing the link state when we are operating in
PHY mode and the PPU is set to poll the PHY to retrieve link status
information.

Reported-by: Martyn Welch <martyn.welch@collabora.com>
Tested-by: Martyn Welch <martyn.welch@collabora.com>
Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
Cc: <stable@vger.kernel.org> # 5.7: 2b29cb9e3f7f: net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1mvFhP-00F8Zb-Ul@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 64 +++++++++++++++++---------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7b7a8a74405d..371b345635e6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -666,44 +666,48 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port *p;
-	int err;
+	int err = 0;
 
 	p = &chip->ports[port];
 
-	/* FIXME: is this the correct test? If we're in fixed mode on an
-	 * internal port, why should we process this any different from
-	 * PHY mode? On the other hand, the port may be automedia between
-	 * an internal PHY and the serdes...
-	 */
-	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
-		return;
-
 	mv88e6xxx_reg_lock(chip);
-	/* In inband mode, the link may come up at any time while the link
-	 * is not forced down. Force the link down while we reconfigure the
-	 * interface mode.
-	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
-		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
-
-	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
-	if (err && err != -EOPNOTSUPP)
-		goto err_unlock;
 
-	err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state->interface,
-					  state->advertising);
-	/* FIXME: we should restart negotiation if something changed - which
-	 * is something we get if we convert to using phylinks PCS operations.
-	 */
-	if (err > 0)
-		err = 0;
+	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
+		/* In inband mode, the link may come up at any time while the
+		 * link is not forced down. Force the link down while we
+		 * reconfigure the interface mode.
+		 */
+		if (mode == MLO_AN_INBAND &&
+		    p->interface != state->interface &&
+		    chip->info->ops->port_set_link)
+			chip->info->ops->port_set_link(chip, port,
+						       LINK_FORCED_DOWN);
+
+		err = mv88e6xxx_port_config_interface(chip, port,
+						      state->interface);
+		if (err && err != -EOPNOTSUPP)
+			goto err_unlock;
+
+		err = mv88e6xxx_serdes_pcs_config(chip, port, mode,
+						  state->interface,
+						  state->advertising);
+		/* FIXME: we should restart negotiation if something changed -
+		 * which is something we get if we convert to using phylinks
+		 * PCS operations.
+		 */
+		if (err > 0)
+			err = 0;
+	}
 
 	/* Undo the forced down state above after completing configuration
-	 * irrespective of its state on entry, which allows the link to come up.
+	 * irrespective of its state on entry, which allows the link to come
+	 * up in the in-band case where there is no separate SERDES. Also
+	 * ensure that the link can come up if the PPU is in use and we are
+	 * in PHY mode (we treat the PPU as an effective in-band mechanism.)
 	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
+	if (chip->info->ops->port_set_link &&
+	    ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
+	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
 		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
 
 	p->interface = state->interface;
-- 
2.35.1



