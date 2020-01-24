Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78B3147FFC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbgAXLGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732370AbgAXLGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:46 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B9520663;
        Fri, 24 Jan 2020 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864005;
        bh=WKygrHBUPXu8LeELmrb23tfQ4q/6bJbkRQ8amBIK0VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjmHn8Hz8c+Wi8wlNPu9HoA6YwHuF8POBuDgf7oWpbE+HSe9vk3Q02RADfNeMuW1Q
         YCW/Fk2O7WdCOh2STtlz+MA8rpTar2SE7qLVAIUiHsi5AUQZ7TjnICaKFKfxcU/xvt
         x3CbDQ1vlSVv0BSREd6jNUmBdPukNlIVKKbe8HbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/639] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ9031
Date:   Fri, 24 Jan 2020 10:25:01 +0100
Message-Id: <20200124093103.697724380@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1d16073a326891c2a964e4cb95bc18fbcafb5f74 ]

So far genphy_soft_reset was used automatically if the PHY driver
didn't implement the soft_reset callback. This changed with the
mentioned commit and broke KSZ9031. To fix this configure the
KSZ9031 PHY driver to use genphy_soft_reset.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 05a6ae32ff652..b4c67c3a928b5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -977,6 +977,7 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9031_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
-- 
2.20.1



