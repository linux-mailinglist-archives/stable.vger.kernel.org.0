Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39971A5072
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgDKMR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbgDKMR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EBB220673;
        Sat, 11 Apr 2020 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607477;
        bh=sqva4+Ggkq97LE42151fQKh3k+UYPryCd/RE+EzPuJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHDkDHi1c045JTTAR3RTab3WytgMfBCxqqVifF1fUz8opuFRkQWz/gB7rUihYQqx4
         OYuRx8x4dwbKLHy2COE6f29YyUJym2mzd03VwzEWWE84yJ8vCU6ZHx7ot/2L5Yqg++
         pW5mMY6Yf1ZxkE8tmOM5vg7CLzZBUgIo2Iuxtxww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 06/41] net: dsa: mt7530: fix null pointer dereferencing in port5 setup
Date:   Sat, 11 Apr 2020 14:09:15 +0200
Message-Id: <20200411115504.545233797@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuanhong Guo <gch981213@gmail.com>

[ Upstream commit 0452800f6db4ed0a42ffb15867c0acfd68829f6a ]

The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
and a phy-handle isn't always available.
Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
connected to switch port 5 and setup mt7530 according to phy address
of 2nd gmac node, causing null pointer dereferencing when phy-handle
isn't defined in dts.
This commit fix this setup code by checking return value of
of_parse_phandle before using it.

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1353,6 +1353,9 @@ mt7530_setup(struct dsa_switch *ds)
 				continue;
 
 			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
+			if (!phy_node)
+				continue;
+
 			if (phy_node->parent == priv->dev->of_node->parent) {
 				interface = of_get_phy_mode(mac_np);
 				id = of_mdio_parse_addr(ds->dev, phy_node);


