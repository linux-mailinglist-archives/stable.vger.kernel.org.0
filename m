Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B88148056
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbgAXLKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgAXLKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:10:02 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E78220663;
        Fri, 24 Jan 2020 11:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864201;
        bh=AJcb+fpv4vT7OwUY85kfR67AG/2ZUu9M8DTVDDCTCds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfgKBe15mw67Ecmbrv24dHR0WEm+Ogm/gCd7O2aTW8sjj2gJIK9zcFXCVFdV66v/+
         3zjTUZDNQOPneCKvZHmJinTalxF6E9Mc6Yj8nIYgCnBLY46rw+ZnvUn1y+ZWIoA2GS
         Sjg1piRtrlTJbKaXLxCt+rlLy2HwsrAPIUpU+ZuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/639] net: dsa: b53: Fix default VLAN ID
Date:   Fri, 24 Jan 2020 10:26:10 +0100
Message-Id: <20200124093112.105839069@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit fea83353177a55540c71c140887737c282137aa2 ]

We were not consistent in how the default VID of a given port was
defined, b53_br_leave() would make sure the VLAN ID would be either 0/1
depending on the switch generation, but b53_configure_vlan(), which is
the default configuration would unconditionally set it to 1. The correct
value is 1 for 5325/5365 series and 0 otherwise. To avoid repeating that
mistake ever again, introduce a helper function: b53_default_pvid() to
factor that out.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 2d3a2cb026d26..bceda1e884426 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -622,15 +622,25 @@ static void b53_enable_mib(struct b53_device *dev)
 	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, gc);
 }
 
+static u16 b53_default_pvid(struct b53_device *dev)
+{
+	if (is5325(dev) || is5365(dev))
+		return 1;
+	else
+		return 0;
+}
+
 int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan vl = { 0 };
-	int i;
+	int i, def_vid;
+
+	def_vid = b53_default_pvid(dev);
 
 	/* clear all vlan entries */
 	if (is5325(dev) || is5365(dev)) {
-		for (i = 1; i < dev->num_vlans; i++)
+		for (i = def_vid; i < dev->num_vlans; i++)
 			b53_set_vlan_entry(dev, i, &vl);
 	} else {
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
@@ -640,7 +650,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,
-			    B53_VLAN_PORT_DEF_TAG(i), 1);
+			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
 
 	if (!is5325(dev) && !is5365(dev))
 		b53_set_jumbo(dev, dev->enable_jumbo, false);
@@ -1142,12 +1152,8 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 
 		vl->members &= ~BIT(port);
 
-		if (pvid == vid) {
-			if (is5325(dev) || is5365(dev))
-				pvid = 1;
-			else
-				pvid = 0;
-		}
+		if (pvid == vid)
+			pvid = b53_default_pvid(dev);
 
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag &= ~(BIT(port));
@@ -1460,10 +1466,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
-	if (is5325(dev) || is5365(dev))
-		pvid = 1;
-	else
-		pvid = 0;
+	pvid = b53_default_pvid(dev);
 
 	/* Make this port join all VLANs without VLAN entries */
 	if (is58xx(dev)) {
-- 
2.20.1



