Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D844E38EDBA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhEXPlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhEXPjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D146142A;
        Mon, 24 May 2021 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870431;
        bh=TNxXa//VQgKbqojkS+8vIrKVZ1my+B8M9BNV93vhruU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0twaVkVzuPMjHh7ORov8NFr0AILwZROOEU5LH5COcYWeRNw4NJdWCPk/yWm8oBKmX
         VoV9x6+e/idJdA7w5V03YUH+ktuVa6zGddWwAzeLRNYfXWZFsBfrzqJg6M8kTEHqUg
         bR2HkTeHnsTxvVCiFAs1oM9ZlhrzG+CK3JG+WaRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 30/37] net: stmicro: handle clk_prepare() failure during init
Date:   Mon, 24 May 2021 17:25:34 +0200
Message-Id: <20210524152325.188252816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 0c32a96d000f260b5ebfabb4145a86ae1cd71847 upstream.

In case clk_prepare() fails, capture and propagate the error code up the
stack. If regulator_enable() was called earlier, properly unwind it by
calling regulator_disable().

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-22-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -39,7 +39,7 @@ struct sunxi_priv_data {
 static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 {
 	struct sunxi_priv_data *gmac = priv;
-	int ret;
+	int ret = 0;
 
 	if (gmac->regulator) {
 		ret = regulator_enable(gmac->regulator);
@@ -59,10 +59,12 @@ static int sun7i_gmac_init(struct platfo
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


