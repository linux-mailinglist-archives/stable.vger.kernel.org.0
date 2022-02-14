Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815B54B49BC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345307AbiBNKJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:09:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344614AbiBNKI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:08:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9526C907;
        Mon, 14 Feb 2022 01:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 862B5612BF;
        Mon, 14 Feb 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69699C340EF;
        Mon, 14 Feb 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832215;
        bh=yBRwaPPBX7oiofAb7QQqNGhdMzKYQcdZ2HG2mnhRb+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uabF6/4CJKINkK3byvm4CJTJFIJtZSbjWgWN8pKHTQilyad/fvSYvEaND5stMOlgi
         V4HkJNhWRQ/AaJoOnBeSF9z37qUTMlzMbIsAQwV/JOBnFB86GCn640faQ9us9tsPG3
         GeW09AEfcqpvaoAaD8YqbQfqdgYN7Z6d04fZzU1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/172] net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding
Date:   Mon, 14 Feb 2022 10:26:13 +0100
Message-Id: <20220214092510.399068887@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 9ffe3d09e32da45bb5a29cf2e80ec8d7534010c5 ]

Nobody in this driver calls mdiobus_unregister(), which is necessary if
mdiobus_register() completes successfully. So if the devres callbacks
that free the mdiobus get invoked (this is the case when unbinding the
driver), mdiobus_free() will BUG if the mdiobus is still registered,
which it is.

My speculation is that this is due to the fact that prior to commit
ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
from June 2020, _devm_mdiobus_free() used to call mdiobus_unregister().
But at the time that the mt7530 support was introduced in May 2021, the
API was already changed. It's therefore likely that the blamed patch was
developed on an older tree, and incorrectly adapted to net-next. This
makes the Fixes: tag correct.

Fix the problem by using the devres variant of mdiobus_register.

Fixes: ba751e28d442 ("net: dsa: mt7530: add interrupt support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9890672a206d0..fb59efc7f9266 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2066,7 +2066,7 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	if (priv->irq)
 		mt7530_setup_mdio_irq(priv);
 
-	ret = mdiobus_register(bus);
+	ret = devm_mdiobus_register(dev, bus);
 	if (ret) {
 		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
 		if (priv->irq)
-- 
2.34.1



