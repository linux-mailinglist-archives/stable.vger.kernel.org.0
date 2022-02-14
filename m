Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4F54B4BFA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348447AbiBNKfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348343AbiBNKes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADF6116A;
        Mon, 14 Feb 2022 02:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCC3860909;
        Mon, 14 Feb 2022 10:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C09C340EF;
        Mon, 14 Feb 2022 10:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832903;
        bh=hrcrTy0cRXNwgEcLdpsqXuhhWEcEWyiPMkeNf8MiMww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC1jJAzUd+pVOOspYzsyvv+L16D4x3rI3dfQ5nl+nAW/oak3Jok0WegHAGzE7EWZY
         UQZINjzRcISXxlnUaksu72Cihur/2+9BfbMrrZnxIGXeI7eh++wLSeb3kp3VrCRxRn
         +uSttIFg1vylxmEk/Cz6+VQFjZBHrWpQ89+v0yNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Richter <rafael.richter@gin.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 161/203] net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister
Date:   Mon, 14 Feb 2022 10:26:45 +0100
Message-Id: <20220214092515.706740856@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

[ Upstream commit 51a04ebf21122d5c76a716ecd9bfc33ea44b2b39 ]

Since struct mv88e6xxx_mdio_bus *mdio_bus is the bus->priv of something
allocated with mdiobus_alloc_size(), this means that mdiobus_free(bus)
will free the memory backing the mdio_bus as well. Therefore, the
mdio_bus->list element is freed memory, but we continue to iterate
through the list of MDIO buses using that list element.

To fix this, use the proper list iterator that handles element deletion
by keeping a copy of the list element next pointer.

Fixes: f53a2ce893b2 ("net: dsa: mv88e6xxx: don't use devres for mdiobus")
Reported-by: Rafael Richter <rafael.richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220210174017.3271099-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fcd648d0f6372..70cea1b95298a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3465,10 +3465,10 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 
 {
-	struct mv88e6xxx_mdio_bus *mdio_bus;
+	struct mv88e6xxx_mdio_bus *mdio_bus, *p;
 	struct mii_bus *bus;
 
-	list_for_each_entry(mdio_bus, &chip->mdios, list) {
+	list_for_each_entry_safe(mdio_bus, p, &chip->mdios, list) {
 		bus = mdio_bus->bus;
 
 		if (!mdio_bus->external)
-- 
2.34.1



