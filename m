Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B94D8401
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbiCNMWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242947AbiCNMT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:19:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF4522F5;
        Mon, 14 Mar 2022 05:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6CA2B80DFF;
        Mon, 14 Mar 2022 12:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3A9C340E9;
        Mon, 14 Mar 2022 12:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260103;
        bh=5dn8+/NyVA/eNrucFxQnoSAcjC8HjqGn5cqpg5UYb6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yk7zxjGitFsSnQrAjIzHR+9dj4nQHKHtk/EVllim5eoHS790yrCYNQxKwSoLyPBWY
         wDWPhJZxG3amlSnG/R7Ew7nscuhrK2IpISVyRuJcO3OHR2L6iK1N9UKaLf4vt6CH6F
         /6gWyrkfcuMsicaRKI33iGzIfG2CRadE4xYpTXG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 057/121] net: arc_emac: Fix use after free in arc_mdio_probe()
Date:   Mon, 14 Mar 2022 12:54:00 +0100
Message-Id: <20220314112745.717795416@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit bc0e610a6eb0d46e4123fafdbe5e6141d9fff3be ]

If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
the "bus". But bus->name is still used in the next line, which will lead
to a use after free.

We can fix it by putting the name in a local variable and make the
bus->name point to the rodata section "name",then use the name in the
error message without referring to bus to avoid the uaf.

Fixes: 95b5fc03c189 ("net: arc_emac: Make use of the helper function dev_err_probe()")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Link: https://lore.kernel.org/r/20220309121824.36529-1-niejianglei2021@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 9acf589b1178..87f40c2ba904 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -132,6 +132,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 {
 	struct arc_emac_mdio_bus_data *data = &priv->bus_data;
 	struct device_node *np = priv->dev->of_node;
+	const char *name = "Synopsys MII Bus";
 	struct mii_bus *bus;
 	int error;
 
@@ -142,7 +143,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	priv->bus = bus;
 	bus->priv = priv;
 	bus->parent = priv->dev;
-	bus->name = "Synopsys MII Bus";
+	bus->name = name;
 	bus->read = &arc_mdio_read;
 	bus->write = &arc_mdio_write;
 	bus->reset = &arc_mdio_reset;
@@ -167,7 +168,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	if (error) {
 		mdiobus_free(bus);
 		return dev_err_probe(priv->dev, error,
-				     "cannot register MDIO bus %s\n", bus->name);
+				     "cannot register MDIO bus %s\n", name);
 	}
 
 	return 0;
-- 
2.34.1



