Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D026B2269D6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbgGTP7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732124AbgGTP7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E06E206E9;
        Mon, 20 Jul 2020 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260747;
        bh=fra+96VQKFgP3IACQaR2naE/me3ML7PhEZDuOGT3y6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUpYSXp/gRMyA73t+VXm2AVI60JwU3IG25lqTRSyXYWiZP1hiP+94DSELUnnbOyn9
         yOF2BiHir6Fbp2umhQPV8li8fwyvgyYIAySklocdAL5PPwDyU5gUUgNffcfEFoZVIS
         v7v3HVKJIPRV4o6oFdPDPayz2N5BRytJu2bIfYXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/215] net: sfp: add support for module quirks
Date:   Mon, 20 Jul 2020 17:35:46 +0200
Message-Id: <20200720152823.257580873@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit b34bb2cb5b62c7397c28fcc335e8047a687eada4 ]

Add support for applying module quirks to the list of supported
ethtool link modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index b23fc41896ef5..35caf2eb2c275 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -9,6 +9,12 @@
 
 #include "sfp.h"
 
+struct sfp_quirk {
+	const char *vendor;
+	const char *part;
+	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+};
+
 /**
  * struct sfp_bus - internal representation of a sfp bus
  */
@@ -21,6 +27,7 @@ struct sfp_bus {
 	const struct sfp_socket_ops *socket_ops;
 	struct device *sfp_dev;
 	struct sfp *sfp;
+	const struct sfp_quirk *sfp_quirk;
 
 	const struct sfp_upstream_ops *upstream_ops;
 	void *upstream;
@@ -30,6 +37,46 @@ struct sfp_bus {
 	bool started;
 };
 
+static const struct sfp_quirk sfp_quirks[] = {
+};
+
+static size_t sfp_strlen(const char *str, size_t maxlen)
+{
+	size_t size, i;
+
+	/* Trailing characters should be filled with space chars */
+	for (i = 0, size = 0; i < maxlen; i++)
+		if (str[i] != ' ')
+			size = i + 1;
+
+	return size;
+}
+
+static bool sfp_match(const char *qs, const char *str, size_t len)
+{
+	if (!qs)
+		return true;
+	if (strlen(qs) != len)
+		return false;
+	return !strncmp(qs, str, len);
+}
+
+static const struct sfp_quirk *sfp_lookup_quirk(const struct sfp_eeprom_id *id)
+{
+	const struct sfp_quirk *q;
+	unsigned int i;
+	size_t vs, ps;
+
+	vs = sfp_strlen(id->base.vendor_name, ARRAY_SIZE(id->base.vendor_name));
+	ps = sfp_strlen(id->base.vendor_pn, ARRAY_SIZE(id->base.vendor_pn));
+
+	for (i = 0, q = sfp_quirks; i < ARRAY_SIZE(sfp_quirks); i++, q++)
+		if (sfp_match(q->vendor, id->base.vendor_name, vs) &&
+		    sfp_match(q->part, id->base.vendor_pn, ps))
+			return q;
+
+	return NULL;
+}
 /**
  * sfp_parse_port() - Parse the EEPROM base ID, setting the port type
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
@@ -233,6 +280,9 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 			phylink_set(modes, 1000baseX_Full);
 	}
 
+	if (bus->sfp_quirk)
+		bus->sfp_quirk->modes(id, modes);
+
 	bitmap_or(support, support, modes, __ETHTOOL_LINK_MODE_MASK_NBITS);
 
 	phylink_set(support, Autoneg);
@@ -553,6 +603,8 @@ int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
 	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
 	int ret = 0;
 
+	bus->sfp_quirk = sfp_lookup_quirk(id);
+
 	if (ops && ops->module_insert)
 		ret = ops->module_insert(bus->upstream, id);
 
@@ -566,6 +618,8 @@ void sfp_module_remove(struct sfp_bus *bus)
 
 	if (ops && ops->module_remove)
 		ops->module_remove(bus->upstream);
+
+	bus->sfp_quirk = NULL;
 }
 EXPORT_SYMBOL_GPL(sfp_module_remove);
 
-- 
2.25.1



