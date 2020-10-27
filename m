Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66229B090
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901177AbgJ0OVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901171AbgJ0OU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796C2206F7;
        Tue, 27 Oct 2020 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808459;
        bh=NfJ78gsJONFQnIQ4JVyyRaGf5FOAgd2ichQ5ZQl/DTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPngve7S/B19pBOlfe8NH58T2H87WthgXMSDLCzgqm6qwkF4HU7bLmq2N3Ng2jKWQ
         eesDvn9kBpF3Gv/v4LsOKkeWHFRZAu1zCXeUW+8OdbTD2EnGOEJMc+i44Fc+O7vED+
         olzcL5lFTB7zuNwRx0Jvzr+igbl5hbEdrNjLNdhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/264] net: dsa: rtl8366: Refactor VLAN/PVID init
Date:   Tue, 27 Oct 2020 14:52:37 +0100
Message-Id: <20201027135435.347622559@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7e1301ed1881447d2a25f9c6423738c33cbca133 ]

The VLANs and PVIDs on the RTL8366 utilizes a "member
configuration" (MC) which is largely unexplained in the
code.

This set-up requires a special ordering: rtl8366_set_pvid()
must be called first, followed by rtl8366_set_vlan(),
else the MC will not be properly allocated. Relax this
by factoring out the code obtaining an MC and reuse
the helper in both rtl8366_set_pvid() and
rtl8366_set_vlan() so we remove this strict ordering
requirement.

In the process, add some better comments and debug prints
so people who read the code understand what is going on.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek-smi.h |   4 +-
 drivers/net/dsa/rtl8366.c     | 273 ++++++++++++++++++----------------
 2 files changed, 146 insertions(+), 131 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi.h b/drivers/net/dsa/realtek-smi.h
index 9a63b51e1d82f..6f2dab7e33d65 100644
--- a/drivers/net/dsa/realtek-smi.h
+++ b/drivers/net/dsa/realtek-smi.h
@@ -25,6 +25,9 @@ struct rtl8366_mib_counter {
 	const char	*name;
 };
 
+/**
+ * struct rtl8366_vlan_mc - Virtual LAN member configuration
+ */
 struct rtl8366_vlan_mc {
 	u16	vid;
 	u16	untag;
@@ -119,7 +122,6 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi);
 int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used);
 int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		     u32 untag, u32 fid);
-int rtl8366_get_pvid(struct realtek_smi *smi, int port, int *val);
 int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 		     unsigned int vid);
 int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index c854fea473f76..4e1a2427fc314 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -36,12 +36,110 @@ int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used)
 }
 EXPORT_SYMBOL_GPL(rtl8366_mc_is_used);
 
+/**
+ * rtl8366_obtain_mc() - retrieve or allocate a VLAN member configuration
+ * @smi: the Realtek SMI device instance
+ * @vid: the VLAN ID to look up or allocate
+ * @vlanmc: the pointer will be assigned to a pointer to a valid member config
+ * if successful
+ * @return: index of a new member config or negative error number
+ */
+static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
+			     struct rtl8366_vlan_mc *vlanmc)
+{
+	struct rtl8366_vlan_4k vlan4k;
+	int ret;
+	int i;
+
+	/* Try to find an existing member config entry for this VID */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+		if (ret) {
+			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+				i, vid);
+			return ret;
+		}
+
+		if (vid == vlanmc->vid)
+			return i;
+	}
+
+	/* We have no MC entry for this VID, try to find an empty one */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+		if (ret) {
+			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+				i, vid);
+			return ret;
+		}
+
+		if (vlanmc->vid == 0 && vlanmc->member == 0) {
+			/* Update the entry from the 4K table */
+			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			if (ret) {
+				dev_err(smi->dev, "error looking for 4K VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+
+			vlanmc->vid = vid;
+			vlanmc->member = vlan4k.member;
+			vlanmc->untag = vlan4k.untag;
+			vlanmc->fid = vlan4k.fid;
+			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			if (ret) {
+				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+
+			dev_dbg(smi->dev, "created new MC at index %d for VID %d\n",
+				i, vid);
+			return i;
+		}
+	}
+
+	/* MC table is full, try to find an unused entry and replace it */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		int used;
+
+		ret = rtl8366_mc_is_used(smi, i, &used);
+		if (ret)
+			return ret;
+
+		if (!used) {
+			/* Update the entry from the 4K table */
+			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			if (ret)
+				return ret;
+
+			vlanmc->vid = vid;
+			vlanmc->member = vlan4k.member;
+			vlanmc->untag = vlan4k.untag;
+			vlanmc->fid = vlan4k.fid;
+			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			if (ret) {
+				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+			dev_dbg(smi->dev, "recycled MC at index %i for VID %d\n",
+				i, vid);
+			return i;
+		}
+	}
+
+	dev_err(smi->dev, "all VLAN member configurations are in use\n");
+	return -ENOSPC;
+}
+
 int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		     u32 untag, u32 fid)
 {
+	struct rtl8366_vlan_mc vlanmc;
 	struct rtl8366_vlan_4k vlan4k;
+	int mc;
 	int ret;
-	int i;
 
 	if (!smi->ops->is_vlan_valid(smi, vid))
 		return -EINVAL;
@@ -66,136 +164,58 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		"resulting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, vlan4k.member, vlan4k.untag);
 
-	/* Try to find an existing MC entry for this VID */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		struct rtl8366_vlan_mc vlanmc;
-
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vid == vlanmc.vid) {
-			/* update the MC entry */
-			vlanmc.member |= member;
-			vlanmc.untag |= untag;
-			vlanmc.fid = fid;
-
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+	/* Find or allocate a member config for this VID */
+	ret = rtl8366_obtain_mc(smi, vid, &vlanmc);
+	if (ret < 0)
+		return ret;
+	mc = ret;
 
-			dev_dbg(smi->dev,
-				"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
-				vid, vlanmc.member, vlanmc.untag);
+	/* Update the MC entry */
+	vlanmc.member |= member;
+	vlanmc.untag |= untag;
+	vlanmc.fid = fid;
 
-			break;
-		}
-	}
+	/* Commit updates to the MC entry */
+	ret = smi->ops->set_vlan_mc(smi, mc, &vlanmc);
+	if (ret)
+		dev_err(smi->dev, "failed to commit changes to VLAN MC index %d for VID %d\n",
+			mc, vid);
+	else
+		dev_dbg(smi->dev,
+			"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
+			vid, vlanmc.member, vlanmc.untag);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rtl8366_set_vlan);
 
-int rtl8366_get_pvid(struct realtek_smi *smi, int port, int *val)
-{
-	struct rtl8366_vlan_mc vlanmc;
-	int ret;
-	int index;
-
-	ret = smi->ops->get_mc_index(smi, port, &index);
-	if (ret)
-		return ret;
-
-	ret = smi->ops->get_vlan_mc(smi, index, &vlanmc);
-	if (ret)
-		return ret;
-
-	*val = vlanmc.vid;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rtl8366_get_pvid);
-
 int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 		     unsigned int vid)
 {
 	struct rtl8366_vlan_mc vlanmc;
-	struct rtl8366_vlan_4k vlan4k;
+	int mc;
 	int ret;
-	int i;
 
 	if (!smi->ops->is_vlan_valid(smi, vid))
 		return -EINVAL;
 
-	/* Try to find an existing MC entry for this VID */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vid == vlanmc.vid) {
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
-
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
-	}
-
-	/* We have no MC entry for this VID, try to find an empty one */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vlanmc.vid == 0 && vlanmc.member == 0) {
-			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
-			if (ret)
-				return ret;
-
-			vlanmc.vid = vid;
-			vlanmc.member = vlan4k.member;
-			vlanmc.untag = vlan4k.untag;
-			vlanmc.fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
-
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
-	}
-
-	/* MC table is full, try to find an unused entry and replace it */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		int used;
-
-		ret = rtl8366_mc_is_used(smi, i, &used);
-		if (ret)
-			return ret;
-
-		if (!used) {
-			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
-			if (ret)
-				return ret;
-
-			vlanmc.vid = vid;
-			vlanmc.member = vlan4k.member;
-			vlanmc.untag = vlan4k.untag;
-			vlanmc.fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
+	/* Find or allocate a member config for this VID */
+	ret = rtl8366_obtain_mc(smi, vid, &vlanmc);
+	if (ret < 0)
+		return ret;
+	mc = ret;
 
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
+	ret = smi->ops->set_mc_index(smi, port, mc);
+	if (ret) {
+		dev_err(smi->dev, "set PVID: failed to set MC index %d for port %d\n",
+			mc, port);
+		return ret;
 	}
 
-	dev_err(smi->dev,
-		"all VLAN member configurations are in use\n");
+	dev_dbg(smi->dev, "set PVID: the PVID for port %d set to %d using existing MC index %d\n",
+		port, vid, mc);
 
-	return -ENOSPC;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_set_pvid);
 
@@ -395,7 +415,8 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		if (!smi->ops->is_vlan_valid(smi, vid))
 			return;
 
-	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
+	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
+		 vlan->vid_begin,
 		 port,
 		 untagged ? "untagged" : "tagged",
 		 pvid ? " PVID" : "no PVID");
@@ -404,34 +425,26 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int pvid_val = 0;
-
-		dev_info(smi->dev, "add VLAN %04x\n", vid);
 		member |= BIT(port);
 
 		if (untagged)
 			untag |= BIT(port);
 
-		/* To ensure that we have a valid MC entry for this VLAN,
-		 * initialize the port VLAN ID here.
-		 */
-		ret = rtl8366_get_pvid(smi, port, &pvid_val);
-		if (ret < 0) {
-			dev_err(smi->dev, "could not lookup PVID for port %d\n",
-				port);
-			return;
-		}
-		if (pvid_val == 0) {
-			ret = rtl8366_set_pvid(smi, port, vid);
-			if (ret < 0)
-				return;
-		}
-
 		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
 		if (ret)
 			dev_err(smi->dev,
 				"failed to set up VLAN %04x",
 				vid);
+
+		ret = rtl8366_set_pvid(smi, port, vid);
+		if (ret)
+			dev_err(smi->dev,
+				"failed to set PVID on port %d to VLAN %04x",
+				port, vid);
+
+		if (!ret)
+			dev_dbg(smi->dev, "VLAN add: added VLAN %d with PVID on port %d\n",
+				vid, port);
 	}
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
-- 
2.25.1



