Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9762F15D1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbhAKNpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:45:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbhAKNLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210D322AAF;
        Mon, 11 Jan 2021 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370651;
        bh=ccBS/hWyb3h6coi6EBSTzSoXbm+XMMwYhYsG3vq8QOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OArwEHD8IXvLNyyHfV1hHt6dTVGBimPJJ8sBOuBgnW7tuh2yfVIc8L785NhYcLyGm
         VVl6kZFRFM5ZdgC/sZC5QWofP5680tIqHBOPCIsPiIYzZta9FduvjseOalAfN+v2nE
         KIKlVUeO6rDgsCFoiPfjIsx6JmsuMfYDk5hiIFZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 39/92] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
Date:   Mon, 11 Jan 2021 14:01:43 +0100
Message-Id: <20210111130041.032614053@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit c1a9ec7e5d577a9391660800c806c53287fca991 ]

Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
Without this the PHY link is detected properly and ethtool statistics
for TX are increasing but there's no RX traffic coming in.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1522,9 +1522,7 @@ static void gswip_phylink_mac_link_up(st
 {
 	struct gswip_priv *priv = ds->priv;
 
-	/* Enable the xMII interface only for the external PHY */
-	if (interface != PHY_INTERFACE_MODE_INTERNAL)
-		gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
+	gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
 }
 
 static void gswip_get_strings(struct dsa_switch *ds, int port, u32 stringset,


