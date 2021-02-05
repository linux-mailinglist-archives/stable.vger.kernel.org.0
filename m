Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8AB311481
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhBEWHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D123C65085;
        Fri,  5 Feb 2021 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534411;
        bh=8OdlNxrunJG6LU7uUfHdslNzgyN+w9PSYl2FoMzH2pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCAc45vAkjoa+yikgbs7PRpDpkqibHIG681S4E9I8qbnJEjDYlBh+v7UVay0tob7b
         VBk3Lo2rCeci9GPMpDBScL8FhaQyyHXnjzF/l0P3BHxZX4M1SKJbyDBkPbXhyNCZQh
         NSPgfSVhy6IH1wLyDgk3AOmc/SzECn4AfNBQxcCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 01/17] net: dsa: bcm_sf2: put device node before return
Date:   Fri,  5 Feb 2021 15:07:55 +0100
Message-Id: <20210205140649.879838644@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit cf3c46631e1637582f517a574c77cd6c05793817 upstream.

Put the device node dn before return error code on failure path.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121123343.26330-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -423,15 +423,19 @@ static int bcm_sf2_mdio_register(struct
 	/* Find our integrated MDIO bus node */
 	dn = of_find_compatible_node(NULL, NULL, "brcm,unimac-mdio");
 	priv->master_mii_bus = of_mdio_find_bus(dn);
-	if (!priv->master_mii_bus)
+	if (!priv->master_mii_bus) {
+		of_node_put(dn);
 		return -EPROBE_DEFER;
+	}
 
 	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
 	priv->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
-	if (!priv->slave_mii_bus)
+	if (!priv->slave_mii_bus) {
+		of_node_put(dn);
 		return -ENOMEM;
+	}
 
 	priv->slave_mii_bus->priv = priv;
 	priv->slave_mii_bus->name = "sf2 slave mii";


