Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22C5145664
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgAVN0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgAVN0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:31 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D787B2467B;
        Wed, 22 Jan 2020 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699590;
        bh=3TSY0k3j/NS0qp81sKVoj9zgSdog5u4XrMOmTpcP3dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAT8WlkKRiG/QTBSDZWy93uTXfPFwTUaKPzmfoSU+RZCkMllW3DrUOSx4FvhsC9N0
         SyxkQliiMOB+WOlCjplREYIYOo1Su+DJdSWuZ50nWHG3eHuDY+6D837PW54QBjSS9I
         yb+2v6o6T8hBzXh/0Z4CvF1ftbmMEvPIhxhuVCeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 152/222] net: ethernet: ave: Avoid lockdep warning
Date:   Wed, 22 Jan 2020 10:28:58 +0100
Message-Id: <20200122092844.606889750@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 82d5d6a638cbd12b7dfe8acafd9efd87a656cc06 ]

When building with PROVE_LOCKING=y, lockdep shows the following
dump message.

    INFO: trying to register non-static key.
    the code is fine but needs lockdep annotation.
    turning off the locking correctness validator.
     ...

Calling device_set_wakeup_enable() directly occurs this issue,
and it isn't necessary for initialization, so this patch creates
internal function __ave_ethtool_set_wol() and replaces with this
in ave_init() and ave_resume().

Fixes: 7200f2e3c9e2 ("net: ethernet: ave: Set initial wol state to disabled")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/socionext/sni_ave.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -424,16 +424,22 @@ static void ave_ethtool_get_wol(struct n
 		phy_ethtool_get_wol(ndev->phydev, wol);
 }
 
-static int ave_ethtool_set_wol(struct net_device *ndev,
-			       struct ethtool_wolinfo *wol)
+static int __ave_ethtool_set_wol(struct net_device *ndev,
+				 struct ethtool_wolinfo *wol)
 {
-	int ret;
-
 	if (!ndev->phydev ||
 	    (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE)))
 		return -EOPNOTSUPP;
 
-	ret = phy_ethtool_set_wol(ndev->phydev, wol);
+	return phy_ethtool_set_wol(ndev->phydev, wol);
+}
+
+static int ave_ethtool_set_wol(struct net_device *ndev,
+			       struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	ret = __ave_ethtool_set_wol(ndev, wol);
 	if (!ret)
 		device_set_wakeup_enable(&ndev->dev, !!wol->wolopts);
 
@@ -1216,7 +1222,7 @@ static int ave_init(struct net_device *n
 
 	/* set wol initial state disabled */
 	wol.wolopts = 0;
-	ave_ethtool_set_wol(ndev, &wol);
+	__ave_ethtool_set_wol(ndev, &wol);
 
 	if (!phy_interface_is_rgmii(phydev))
 		phy_set_max_speed(phydev, SPEED_100);
@@ -1768,7 +1774,7 @@ static int ave_resume(struct device *dev
 
 	ave_ethtool_get_wol(ndev, &wol);
 	wol.wolopts = priv->wolopts;
-	ave_ethtool_set_wol(ndev, &wol);
+	__ave_ethtool_set_wol(ndev, &wol);
 
 	if (ndev->phydev) {
 		ret = phy_resume(ndev->phydev);


