Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52E1576B8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgBJMyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbgBJMly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD86D2080C;
        Mon, 10 Feb 2020 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338514;
        bh=t6b3cf5dVcO7i53kHMkoUtfy5mf7eRqbnoiTklD04cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGyld83Uwa5soNEJrbzRL2NHtX5CN++eilmGVhhpOe8ydH9VEfIP/mwMZAAs8Zq1+
         wRzgd48YRbrJQfvgWFvbJ/Sq/j87fB35Va+5FHJK7rRyeZAddXeTJsc6h5CjvtZACH
         cirX3HCurfwiBWNNpU580nkK66wLI8VaIrZ0eo2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 320/367] net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
Date:   Mon, 10 Feb 2020 04:33:53 -0800
Message-Id: <20200210122452.606843490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit de34d7084edd069dac5aa010cfe32bd8c4619fa6 ]

The 7445 switch clocking profiles do not allow us to run the IMP port at
2Gb/sec in a way that it is reliable and consistent. Make sure that the
setting is only applied to the 7278 family.

Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -68,7 +68,9 @@ static void bcm_sf2_imp_setup(struct dsa
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
+		reg |= (MII_SW_OR | LINK_STS);
+		if (priv->type == BCM7278_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */


