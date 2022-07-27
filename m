Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3550858302E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiG0RfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242457AbiG0Rd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9C882F87;
        Wed, 27 Jul 2022 09:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F22A600BE;
        Wed, 27 Jul 2022 16:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3430EC43470;
        Wed, 27 Jul 2022 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940518;
        bh=acifiAZYGGEyPLvFGkAq/4jyGT+ETtNuHd0sN+qjSQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+t8jjQni1Qh7LXmWAhUeQfbCsCO2dKGy6Uacn3dBp5lcSAjr1sNm5ky7zJdH1+Wp
         THlzn/7Jp/a5Elnp7kndCw7Vz7UyJawzNRgQarTjabtiY5CIjEEhjGopUHoaOIckN5
         7P2Coo8V0Pux0/Hr7PdC1ESIFFYVww4NsWg9loCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 051/158] net: dsa: microchip: ksz_common: Fix refcount leak bug
Date:   Wed, 27 Jul 2022 18:11:55 +0200
Message-Id: <20220727161023.569878060@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit a14bd7475452c51835dd5a0cee4c8fa48dd0b539 ]

In ksz_switch_register(), we should call of_node_put() for the
reference returned by of_get_child_by_name() which has increased
the refcount.

Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220714153138.375919-1-windhl@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8014b18d9391..aa0bcf01e20a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -447,18 +447,21 @@ int ksz_switch_register(struct ksz_device *dev,
 		ports = of_get_child_by_name(dev->dev->of_node, "ethernet-ports");
 		if (!ports)
 			ports = of_get_child_by_name(dev->dev->of_node, "ports");
-		if (ports)
+		if (ports) {
 			for_each_available_child_of_node(ports, port) {
 				if (of_property_read_u32(port, "reg",
 							 &port_num))
 					continue;
 				if (!(dev->port_mask & BIT(port_num))) {
 					of_node_put(port);
+					of_node_put(ports);
 					return -EINVAL;
 				}
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
 			}
+			of_node_put(ports);
+		}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
-- 
2.35.1



