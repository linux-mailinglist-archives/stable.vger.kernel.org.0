Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7764520BB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245047AbhKPA4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343542AbhKOTVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F3D2632F9;
        Mon, 15 Nov 2021 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001711;
        bh=taXsYublzmRyRE1/FD9cNG/sIo4pWFdfz4fMuwuu8bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVaBnasbEI32gtVwO3tQqDtTqV7g4xOri1IOjmxbmkaMtNOFywyCM9oIPhF5QootX
         jR8mysslPd9XE/B2FsCo+iMOpmOesWWRO8gWS4shZskGrJeweyoPmsx/e+5lJsnO65
         rFV2wtJow2+cihcHewJQbVjz98yXO6i5XCyeRlO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/917] net: dsa: lantiq_gswip: serialize access to the PCE table
Date:   Mon, 15 Nov 2021 17:56:26 +0100
Message-Id: <20211115165438.632409127@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 49753a75b9a32de4c0393bb8d1e51ea223fda8e4 ]

Looking at the code, the GSWIP switch appears to hold bridging service
structures (VLANs, FDBs, forwarding rules) in PCE table entries.
Hardware access to the PCE table is non-atomic, and is comprised of
several register reads and writes.

These accesses are currently serialized by the rtnl_lock, but DSA is
changing its driver API and that lock will no longer be held when
calling ->port_fdb_add() and ->port_fdb_del().

So this driver needs to serialize the access to the PCE table using its
own locking scheme. This patch adds that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173ff..1a96df70d1e85 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -276,6 +276,7 @@ struct gswip_priv {
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 	u32 port_vlan_filter;
+	struct mutex pce_table_lock;
 };
 
 struct gswip_pce_table_entry {
@@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
 		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
@@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
 	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
 
+	mutex_unlock(&priv->pce_table_lock);
+
 	return 0;
 }
 
@@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
 	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
 
-	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
-				      GSWIP_PCE_TBL_CTRL_BAS);
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+
+	mutex_unlock(&priv->pce_table_lock);
+
+	return err;
 }
 
 /* Add the LAN port into a bridge with the CPU port by
@@ -2106,6 +2123,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->priv = priv;
 	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
+	mutex_init(&priv->pce_table_lock);
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
 	np = dev->of_node;
-- 
2.33.0



