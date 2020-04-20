Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE11B0BC5
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgDTM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgDTMm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD5D221F4;
        Mon, 20 Apr 2020 12:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386578;
        bh=25m4OHjRHxYq+pBnFf00VwlRPqJ/xs5F8ZNWaOoKDxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeqvT28sce90gsun/r4XZrcm4guJwOmHOFmWeNbB13U8cCOZmMl0XmFl0WzjT2k7s
         V8COuPIuxpRjygw7wwdkdlurUTfAwML9LJ9R7h0Pbg6VwiPwOvPXe2r+nJkrSU4hUI
         jCiasMadCUjCw9m0ASwYzCdy7xscfM7yTJBDG9RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 04/71] net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode
Date:   Mon, 20 Apr 2020 14:38:18 +0200
Message-Id: <20200420121509.210524210@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

[ Upstream commit e045124e93995fe01e42ed530003ddba5d55db4f ]

In VLAN-unaware mode, the Egress Tag (EG_TAG) field in Port VLAN
Control register must be set to Consistent to let tagged frames pass
through as is, otherwise their tags will be stripped.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |   18 ++++++++++++------
 drivers/net/dsa/mt7530.h |    7 +++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -857,8 +857,9 @@ mt7530_port_set_vlan_unaware(struct dsa_
 	 */
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_MATRIX_MODE);
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		if (dsa_is_user_port(ds, i) &&
@@ -874,8 +875,8 @@ mt7530_port_set_vlan_unaware(struct dsa_
 	if (all_user_ports_removed) {
 		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
 			     PCR_MATRIX(dsa_user_ports(priv->ds)));
-		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT),
-			     PORT_SPEC_TAG);
+		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
+			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 }
 
@@ -901,8 +902,9 @@ mt7530_port_set_vlan_aware(struct dsa_sw
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
 	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_USER) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
 }
 
 static void
@@ -1333,6 +1335,10 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_cpu_port_enable(priv, i);
 		else
 			mt7530_port_disable(ds, i);
+
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
 	/* Setup port 5 */
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -167,9 +167,16 @@ enum mt7530_port_mode {
 /* Register for port vlan control */
 #define MT7530_PVC_P(x)			(0x2010 + ((x) * 0x100))
 #define  PORT_SPEC_TAG			BIT(5)
+#define  PVC_EG_TAG(x)			(((x) & 0x7) << 8)
+#define  PVC_EG_TAG_MASK		PVC_EG_TAG(7)
 #define  VLAN_ATTR(x)			(((x) & 0x3) << 6)
 #define  VLAN_ATTR_MASK			VLAN_ATTR(3)
 
+enum mt7530_vlan_port_eg_tag {
+	MT7530_VLAN_EG_DISABLED = 0,
+	MT7530_VLAN_EG_CONSISTENT = 1,
+};
+
 enum mt7530_vlan_port_attr {
 	MT7530_VLAN_USER = 0,
 	MT7530_VLAN_TRANSPARENT = 3,


