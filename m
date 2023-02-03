Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839D2689641
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjBCKan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbjBCKaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F999D052
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3574AB82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B0EC433EF;
        Fri,  3 Feb 2023 10:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420158;
        bh=qH4QXqyPvRmd+QS7Ty0I9LpKvU/mMAQ+gY0AYtANOh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJIf1Izp/TIJGmLqbpGXznFxWqhQ+L7IHpMaIK32yIoeV1oPNYXUH4GeGKa+gZkQz
         MWyjfQpRVikrwsiReunoXerDqdRZTm0w6tyUTGZrX7164golI+P9Tlo3gQ3o/BxKVB
         EWTMzLoaZBxYWm7hZpdUb28gykOzHj/5xa1denYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/134] net: xgene: Move shared header file into include/linux
Date:   Fri,  3 Feb 2023 11:13:25 +0100
Message-Id: <20230203101028.339758122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 232e15e1d7ddb191c28248cb681f4544c0ff1c54 ]

This header file is currently included into the ethernet driver via a
relative path into the PHY subsystem. This is bad practice, and causes
issues for the upcoming move of the MDIO driver. Move the header file
into include/linux to clean this up.

v2:
Move header to include/linux/mdio

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7083df59abbc ("net: mdio-mux-meson-g12a: force internal PHY off on mux switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h     | 2 +-
 drivers/net/phy/mdio-xgene.c                         | 2 +-
 {drivers/net/phy => include/linux/mdio}/mdio-xgene.h | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {drivers/net/phy => include/linux/mdio}/mdio-xgene.h (100%)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
index 18f4923b1723..6a253f81c555 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
@@ -18,6 +18,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
+#include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
 #include <net/ip.h>
 #include <linux/prefetch.h>
@@ -26,7 +27,6 @@
 #include "xgene_enet_hw.h"
 #include "xgene_enet_cle.h"
 #include "xgene_enet_ring2.h"
-#include "../../../phy/mdio-xgene.h"
 
 #define XGENE_DRV_VERSION	"v1.0"
 #define ETHER_MIN_PACKET	64
diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/phy/mdio-xgene.c
index 34990eaa3298..461207cdf5d6 100644
--- a/drivers/net/phy/mdio-xgene.c
+++ b/drivers/net/phy/mdio-xgene.c
@@ -11,6 +11,7 @@
 #include <linux/efi.h>
 #include <linux/if_vlan.h>
 #include <linux/io.h>
+#include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
@@ -18,7 +19,6 @@
 #include <linux/prefetch.h>
 #include <linux/phy.h>
 #include <net/ip.h>
-#include "mdio-xgene.h"
 
 static bool xgene_mdio_status;
 
diff --git a/drivers/net/phy/mdio-xgene.h b/include/linux/mdio/mdio-xgene.h
similarity index 100%
rename from drivers/net/phy/mdio-xgene.h
rename to include/linux/mdio/mdio-xgene.h
-- 
2.39.0



