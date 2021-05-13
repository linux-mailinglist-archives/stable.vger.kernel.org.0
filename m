Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898F937FAC8
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhEMPfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhEMPfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE3D611AC;
        Thu, 13 May 2021 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920052;
        bh=lBJ/fK0+GSSX5GlkiYkNQy5WyAvI+50B4PuCxDKWNa4=;
        h=Subject:To:From:Date:From;
        b=oi5hpygoLssj0VUOsF+hiOA6GRy/L5LQG2waGr9Ug2syrgV+eas4ryaP77qj779o4
         bvktZbB5CDOZjam6FskZmDyjQxumPx47rC7DzlZM9niOaWoz/BBvkb+afpqQ+HyiD7
         U8mneXnfzhRkuECHMiWqBMHgS7Ciw09HXPMQkL9Q=
Subject: patch "net: stmicro: handle clk_prepare() failure during init" added to char-misc-linus
To:     mail@anirudhrb.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:10 +0200
Message-ID: <1620920050137113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    net: stmicro: handle clk_prepare() failure during init

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0c32a96d000f260b5ebfabb4145a86ae1cd71847 Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Mon, 3 May 2021 13:56:48 +0200
Subject: net: stmicro: handle clk_prepare() failure during init

In case clk_prepare() fails, capture and propagate the error code up the
stack. If regulator_enable() was called earlier, properly unwind it by
calling regulator_disable().

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-22-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index fc68e90acbea..fc3b0acc8f99 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -30,7 +30,7 @@ struct sunxi_priv_data {
 static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 {
 	struct sunxi_priv_data *gmac = priv;
-	int ret;
+	int ret = 0;
 
 	if (gmac->regulator) {
 		ret = regulator_enable(gmac->regulator);
@@ -50,10 +50,12 @@ static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 		gmac->clk_enabled = 1;
 	} else {
 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_MII_RATE);
-		clk_prepare(gmac->tx_clk);
+		ret = clk_prepare(gmac->tx_clk);
+		if (ret && gmac->regulator)
+			regulator_disable(gmac->regulator);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void sun7i_gmac_exit(struct platform_device *pdev, void *priv)
-- 
2.31.1


