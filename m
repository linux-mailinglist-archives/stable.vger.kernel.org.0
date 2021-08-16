Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D03ED663
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhHPNUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239656AbhHPNSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758C8632F9;
        Mon, 16 Aug 2021 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119625;
        bh=X8NKRLGz8e8PimhZQl7d/Gas/88Ik0dokun3w6gMjN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBdUn271/k5tb1yUw3+ry9L221XmAAiFOq1nsD29sQWpu+Aa7/LqjBZxicXdo/qkz
         G/W77NwM90Jucqor9ceZBrWM5hg0BZ3k61hnqQi9cWTAnu1XmH4HRIqSwKgbggg26v
         VQSSeeVhLlPb4KpTZmfUA7gLH7dYmg32DYExgYeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 065/151] net: dsa: qca: ar9331: make proper initial port defaults
Date:   Mon, 16 Aug 2021 15:01:35 +0200
Message-Id: <20210816125446.205760045@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 47fac45600aafc5939d9620055c3c46f7135d316 ]

Make sure that all external port are actually isolated from each other,
so no packets are leaked.

Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/ar9331.c | 73 +++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 6686192e1883..563d8a279030 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -101,6 +101,23 @@
 	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
 	 AR9331_SW_PORT_STATUS_SPEED_M)
 
+#define AR9331_SW_REG_PORT_CTRL(_port)			(0x104 + (_port) * 0x100)
+#define AR9331_SW_PORT_CTRL_HEAD_EN			BIT(11)
+#define AR9331_SW_PORT_CTRL_PORT_STATE			GENMASK(2, 0)
+#define AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED		0
+#define AR9331_SW_PORT_CTRL_PORT_STATE_BLOCKING		1
+#define AR9331_SW_PORT_CTRL_PORT_STATE_LISTENING	2
+#define AR9331_SW_PORT_CTRL_PORT_STATE_LEARNING		3
+#define AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD		4
+
+#define AR9331_SW_REG_PORT_VLAN(_port)			(0x108 + (_port) * 0x100)
+#define AR9331_SW_PORT_VLAN_8021Q_MODE			GENMASK(31, 30)
+#define AR9331_SW_8021Q_MODE_SECURE			3
+#define AR9331_SW_8021Q_MODE_CHECK			2
+#define AR9331_SW_8021Q_MODE_FALLBACK			1
+#define AR9331_SW_8021Q_MODE_NONE			0
+#define AR9331_SW_PORT_VLAN_PORT_VID_MEMBER		GENMASK(25, 16)
+
 /* MIB registers */
 #define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
 
@@ -371,12 +388,60 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 	return 0;
 }
 
-static int ar9331_sw_setup(struct dsa_switch *ds)
+static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
 	struct regmap *regmap = priv->regmap;
+	u32 port_mask, port_ctrl, val;
 	int ret;
 
+	/* Generate default port settings */
+	port_ctrl = FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
+			       AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD);
+
+	if (dsa_is_cpu_port(ds, port)) {
+		/* CPU port should be allowed to communicate with all user
+		 * ports.
+		 */
+		port_mask = dsa_user_ports(ds);
+		/* Enable Atheros header on CPU port. This will allow us
+		 * communicate with each port separately
+		 */
+		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
+	} else if (dsa_is_user_port(ds, port)) {
+		/* User ports should communicate only with the CPU port.
+		 */
+		port_mask = BIT(dsa_upstream_port(ds, port));
+	} else {
+		/* Other ports do not need to communicate at all */
+		port_mask = 0;
+	}
+
+	val = FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
+			 AR9331_SW_8021Q_MODE_NONE) |
+		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask);
+
+	ret = regmap_write(regmap, AR9331_SW_REG_PORT_VLAN(port), val);
+	if (ret)
+		goto error;
+
+	ret = regmap_write(regmap, AR9331_SW_REG_PORT_CTRL(port), port_ctrl);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	dev_err(priv->dev, "%s: error: %i\n", __func__, ret);
+
+	return ret;
+}
+
+static int ar9331_sw_setup(struct dsa_switch *ds)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct regmap *regmap = priv->regmap;
+	int ret, i;
+
 	ret = ar9331_sw_reset(priv);
 	if (ret)
 		return ret;
@@ -402,6 +467,12 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
 	if (ret)
 		goto error;
 
+	for (i = 0; i < ds->num_ports; i++) {
+		ret = ar9331_sw_setup_port(ds, i);
+		if (ret)
+			goto error;
+	}
+
 	ds->configure_vlan_while_not_filtering = false;
 
 	return 0;
-- 
2.30.2



