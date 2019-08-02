Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F277F27B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405938AbfHBJsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405920AbfHBJsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:48:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3D22087E;
        Fri,  2 Aug 2019 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739333;
        bh=mynAj7Y3t59ITSeNpACTfJEI8DEExoU0wLKW2Kb/djw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnesN/a74WenlpHLbG9vIfO7fL9TUMcKTmfHhvXze7byMThWgalYrOLW1TmjAo54O
         Edla8TusfsE+S+vVJDavu5dJwIom04Dk9pRnZd05D0peX+mtJ7TidbuALYB27h1syA
         NxvOnvpoqzrbbYLcqEHSzOKeqUKi8+ig19kZxOv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 171/223] phy: renesas: rcar-gen2: Fix memory leak at error paths
Date:   Fri,  2 Aug 2019 11:36:36 +0200
Message-Id: <20190802092249.004731375@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4a36e82924d3305a17ac987a510f3902df5a4b2 ]

This patch fixes memory leak at error paths of the probe function.
In for_each_child_of_node, if the loop returns, the driver should
call of_put_node() before returns.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Fixes: 1233f59f745b237 ("phy: Renesas R-Car Gen2 PHY driver")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-rcar-gen2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/phy-rcar-gen2.c b/drivers/phy/phy-rcar-gen2.c
index 97d4dd6ea924..aa02b19b7e0e 100644
--- a/drivers/phy/phy-rcar-gen2.c
+++ b/drivers/phy/phy-rcar-gen2.c
@@ -288,6 +288,7 @@ static int rcar_gen2_phy_probe(struct platform_device *pdev)
 		error = of_property_read_u32(np, "reg", &channel_num);
 		if (error || channel_num > 2) {
 			dev_err(dev, "Invalid \"reg\" property\n");
+			of_node_put(np);
 			return error;
 		}
 		channel->select_mask = select_mask[channel_num];
@@ -303,6 +304,7 @@ static int rcar_gen2_phy_probe(struct platform_device *pdev)
 						   &rcar_gen2_phy_ops);
 			if (IS_ERR(phy->phy)) {
 				dev_err(dev, "Failed to create PHY\n");
+				of_node_put(np);
 				return PTR_ERR(phy->phy);
 			}
 			phy_set_drvdata(phy->phy, phy);
-- 
2.20.1



