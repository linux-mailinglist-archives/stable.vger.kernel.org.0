Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB626D48EF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjDCOdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjDCOdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:33:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270AB35002
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98DF0B81C82
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FF5C433EF;
        Mon,  3 Apr 2023 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532380;
        bh=1uwUJhUCoaNMzhfqPPFtqrupiM6OX4o+zK6d1+ejq2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2r08RItvuely3nYXn7oAZzU57PtBIpiGLt/ZpUVbQNU36jW55RnJQ0SJqR1cNXi4
         lPTDA9yHyg3VLVYG2lhgNglFzkDT2KEC6UY2PZD5NDrJ7oYLPQU8YDn+lL8IwFLYAs
         ybwklfvIe4/QplBlXHn1eJKprMNTy4vnSm3S+7vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/99] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only
Date:   Mon,  3 Apr 2023 16:09:24 +0200
Message-Id: <20230403140405.717743165@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

From: Steffen Bätz <steffen@innosonix.de>

[ Upstream commit 7bcad0f0e6fbc1d613e49e0ee35c8e5f2e685bb0 ]

Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.

This allows the host CPU port to be a regular IGMP listener by sending out
IGMP Membership Reports, which would otherwise not be forwarded by the
mv88exxx chip, but directly looped back to the CPU port itself.

Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230329150140.701559-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 99c4e45c62e33..8a030dc0b8a36 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2912,9 +2912,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
-- 
2.39.2



