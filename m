Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F6F28B83D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389898AbgJLNu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgJLNsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F8E022260;
        Mon, 12 Oct 2020 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510455;
        bh=fU80wknSWsHOXHgEdxw63HE/A6MJ53UVkuxp1fWW7EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZjwRG+Qva2z7fDnkjwVtZ0LL2ekcwbb4L1dF5di7g1Gfo4N4I9WpWbigxx7Z9U2T
         1khq3Tf7EsTZIHb3TznVSuCh7ZKW+6ixIwfyK9fQM+m3+vre35VxnifrEmFJMZ7G/n
         nLBCaEFvQsjwcIBYLpxPByYKnh6iqHM5fffvmVkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 106/124] net: mscc: ocelot: extend watermark encoding function
Date:   Mon, 12 Oct 2020 15:31:50 +0200
Message-Id: <20201012133151.992252113@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit aa92d836d5c40a7e21e563a272ad177f1bfd44dd ]

The ocelot_wm_encode function deals with setting thresholds for pause
frame start and stop. In Ocelot and Felix the register layout is the
same, but for Seville, it isn't. The easiest way to accommodate Seville
hardware configuration is to introduce a function pointer for setting
this up.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 13 +++++++++++++
 drivers/net/ethernet/mscc/ocelot.c         | 16 ++--------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h                  |  1 +
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a83ecd1c5d6c2..259a612da0030 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1105,8 +1105,21 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
 	}
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+static u16 vsc9959_wm_enc(u16 value)
+{
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
+	.wm_enc			= vsc9959_wm_enc,
 };
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6e68713c0ac6b..1438839e3f6ea 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -396,18 +396,6 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	}
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev)
 {
@@ -2037,9 +2025,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	/* Tail dropping watermark */
 	atop_wm = (ocelot->shared_queue_sz - 9 * maxlen) /
 		   OCELOT_BUFFER_CELL_SZ;
-	ocelot_write_rix(ocelot, ocelot_wm_enc(9 * maxlen),
+	ocelot_write_rix(ocelot, ocelot->ops->wm_enc(9 * maxlen),
 			 SYS_ATOP, port);
-	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
+	ocelot_write(ocelot, ocelot->ops->wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 EXPORT_SYMBOL(ocelot_port_set_maxlen);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4a15d2ff8b706..66b58b242f778 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -240,8 +240,21 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+static u16 ocelot_wm_enc(u16 value)
+{
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
+	.wm_enc			= ocelot_wm_enc,
 };
 
 static const struct vcap_field vsc7514_vcap_is2_keys[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4953e9994df34..8e174a24c5757 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -468,6 +468,7 @@ struct ocelot;
 
 struct ocelot_ops {
 	int (*reset)(struct ocelot *ocelot);
+	u16 (*wm_enc)(u16 value);
 };
 
 struct ocelot_acl_block {
-- 
2.25.1



