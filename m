Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C012C794
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfL2Rn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730587AbfL2Rn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE3420718;
        Sun, 29 Dec 2019 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641437;
        bh=HsI4HK6CAwoLJvm6n9lj2FVg0txUYAxZf7lVJKezDTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIt1hdW4c3g5uUqUM1xrU/ZJ0qwfIVO5KX9E5Dkt09sqREtUMq+rov8jYbNaLhnO0
         pB34DVfjMfpaK2xr62T2Q488g24Io+7zDvCTSP3JyF3u+WHluDgcPWuzEZdcJrr2SR
         8Te5XoVE/6CqIIvY3oMfEWueKKBJ7N9UPZcqATLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 026/434] net: dsa: b53: Fix egress flooding settings
Date:   Sun, 29 Dec 2019 18:21:19 +0100
Message-Id: <20191229172703.820978630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 63cc54a6f0736a432b04308a74677ab0ba8a58ee ]

There were several issues with 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback") that resulted in breaking connectivity for standalone ports:

- both user and CPU ports must allow unicast and multicast forwarding by
  default otherwise this just flat out breaks connectivity for
  standalone DSA ports
- IP multicast is treated similarly as multicast, but has separate
  control registers
- the UC, MC and IPMC lookup failure register offsets were wrong, and
  instead used bit values that are meaningful for the
  B53_IP_MULTICAST_CTRL register

Fixes: 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -347,7 +347,7 @@ static void b53_set_forwarding(struct b5
 	 * frames should be flooded or not.
 	 */
 	b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN;
+	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 }
 
@@ -526,6 +526,8 @@ int b53_enable_port(struct dsa_switch *d
 
 	cpu_port = ds->ports[port].cpu_dp->index;
 
+	b53_br_egress_floods(ds, port, true, true);
+
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
 	if (ret)
@@ -641,6 +643,8 @@ static void b53_enable_cpu_port(struct b
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), port_ctrl);
 
 	b53_brcm_hdr_setup(dev->ds, port);
+
+	b53_br_egress_floods(dev->ds, port, true, true);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1766,19 +1770,26 @@ int b53_br_egress_floods(struct dsa_swit
 	struct b53_device *dev = ds->priv;
 	u16 uc, mc;
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, &uc);
+	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, &uc);
 	if (unicast)
 		uc |= BIT(port);
 	else
 		uc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, uc);
+	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, uc);
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, &mc);
+	if (multicast)
+		mc |= BIT(port);
+	else
+		mc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, mc);
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, &mc);
+	b53_read16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, &mc);
 	if (multicast)
 		mc |= BIT(port);
 	else
 		mc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, mc);
+	b53_write16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, mc);
 
 	return 0;
 


