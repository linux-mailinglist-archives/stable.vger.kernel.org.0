Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE90ACD52
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbfIHMr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbfIHMr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:59 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28218218AC;
        Sun,  8 Sep 2019 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946878;
        bh=C1/xTk2w9kLHGUjT2ARTupMkA1Nis33kKJuHdUq1S18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9I7SfUmWXAprlnbkayk52Eml3c4JfsbmmE5XqJHQNo6o8uOln9JKutmkMhSAPc1B
         XUak4dXFnEXIGcASg6P11Y56VRGziYJeA85q0jc2fGAcqC26HZs9N1o9mfCqIggiMG
         N9erc6T71WZ1TZUCq3W7UB9YeRsupJ4xz15ig3LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/57] net: stmmac: dwmac-rk: Dont fail if phy regulator is absent
Date:   Sun,  8 Sep 2019 13:41:29 +0100
Message-Id: <20190908121127.550413578@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 3b25528e1e355c803e73aa326ce657b5606cda73 ]

The devicetree binding lists the phy phy as optional. As such, the
driver should not bail out if it can't find a regulator. Instead it
should just skip the remaining regulator related code and continue
on normally.

Skip the remainder of phy_power_on() if a regulator supply isn't
available. This also gets rid of the bogus return code.

Fixes: 2e12f536635f ("net: stmmac: dwmac-rk: Use standard devicetree property for phy regulator")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1203,10 +1203,8 @@ static int phy_power_on(struct rk_priv_d
 	int ret;
 	struct device *dev = &bsp_priv->pdev->dev;
 
-	if (!ldo) {
-		dev_err(dev, "no regulator found\n");
-		return -1;
-	}
+	if (!ldo)
+		return 0;
 
 	if (enable) {
 		ret = regulator_enable(ldo);


