Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F115414A1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356669AbiFGUVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359613AbiFGUUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B31C1D1061;
        Tue,  7 Jun 2022 11:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA3EB822C0;
        Tue,  7 Jun 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE7EC385A5;
        Tue,  7 Jun 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626618;
        bh=e+hc29pBLZsMe6PI4BEPi4bMoIro/89iPVAskzB7OPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMITi/YA7wrcjS9AR+SljSP56gjaPZLeV6bLZBwlM3eGaredA46/uCaSG9KvUsgt2
         psSvlZER8c4udfyD5/g9xFGtYJLYsBanR0aBdk9kqH1MnrAZHK6nVwHs9RXdsQak1L
         lBcVOvoRFrd3j7EAklxb1DpB0HR6MOalDn+8F5rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mans Rullgard <mans@mansr.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 444/772] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Date:   Tue,  7 Jun 2022 19:00:36 +0200
Message-Id: <20220607165002.084522718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0a3ad7d323686fbaae8688326cc5ea0d185c6fca ]

Since kconfig 'select' does not follow dependency chains, if symbol KSA
selects KSB, then KSA should also depend on the same symbols that KSB
depends on, in order to prevent Kconfig warnings and possible build
errors.

Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
they are limited to VLAN_8021Q if the latter is enabled. This prevents
the Kconfig warning:

WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
  Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
  Selected by [y]:
  - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]

Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Juergen Borleis <jbe@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mans Rullgard <mans@mansr.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 37a3dabdce31..6d1fcb08bba1 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -72,7 +72,6 @@ source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
 	tristate
-	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
@@ -82,6 +81,7 @@ config NET_DSA_SMSC_LAN9303
 config NET_DSA_SMSC_LAN9303_I2C
 	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
 	depends on I2C
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_SMSC_LAN9303
 	select REGMAP_I2C
 	help
@@ -91,6 +91,7 @@ config NET_DSA_SMSC_LAN9303_I2C
 config NET_DSA_SMSC_LAN9303_MDIO
 	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in MDIO managed mode"
 	select NET_DSA_SMSC_LAN9303
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	help
 	  Enable access functions if the SMSC/Microchip LAN9303 is configured
 	  for MDIO managed mode.
-- 
2.35.1



