Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07511480B6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389709AbgAXLNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389600AbgAXLNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7B72075D;
        Fri, 24 Jan 2020 11:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864424;
        bh=Wl+4tBgZ6i0GU45PjF3ZMJatJ//vYjtv7Qkg3ij7kFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpTcqC//nIZeBledM5tZicw3HmM4sEF3J2RF+5IPZcdZjDcrFe1eFfDuWu725GlHV
         SSyjcrQnHmcit5UizuKpC7rtaUa5wLXBliv27viD/VuMwp1q1xlKXI5yIvgmmiUvX8
         oWOa0z3wAs+OU73TyIPuoI7k+dzu3VmfFhSx0s7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 261/639] net: sh_eth: fix a missing check of of_get_phy_mode
Date:   Fri, 24 Jan 2020 10:27:11 +0100
Message-Id: <20200124093119.433125547@linuxfoundation.org>
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

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 035a14e71f27eefa50087963b94cbdb3580d08bf ]

of_get_phy_mode may fail and return a negative error code;
the fix checks the return value of of_get_phy_mode and
returns NULL of it fails.

Fixes: b356e978e92f ("sh_eth: add device tree support")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 6068e96f5ac1e..441643670ac0e 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3133,12 +3133,16 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct sh_eth_plat_data *pdata;
 	const char *mac_addr;
+	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
 
-	pdata->phy_interface = of_get_phy_mode(np);
+	ret = of_get_phy_mode(np);
+	if (ret < 0)
+		return NULL;
+	pdata->phy_interface = ret;
 
 	mac_addr = of_get_mac_address(np);
 	if (mac_addr)
-- 
2.20.1



