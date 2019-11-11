Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AFDF7DE5
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKKSyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730557AbfKKSyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC8621655;
        Mon, 11 Nov 2019 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498460;
        bh=y5DKw5yfXLhHf/OzhUNTYiVPxLFGGc6JHFsKSap5NbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azDzptFGrI0OS1CqpZmLMsGy4pp4gJUKb2TpXSo9vvwiswVB22e0QcTX1NkYXA2q+
         ef9CwciFWl9qRDLkthauv10NyB2j/yHKTeNeE5UtCoOr3FCMrWLosNP36eNiBZbSsK
         esIjQmL6P81nqIQ1XcoIwIMBUUAmzWbLFibqbZB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 127/193] net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag
Date:   Mon, 11 Nov 2019 19:28:29 +0100
Message-Id: <20191111181510.552217950@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit 76db2d466f6a929a04775f0f87d837e3bcba44e8 ]

The LAN8740, like the 8720, also requires a reset after enabling clock.
The datasheet [1] 3.8.5.1 says:
	"During a Hardware reset, an external clock must be supplied
	to the XTAL1/CLKIN signal."

I have observed this issue on a custom i.MX6 based board with
the LAN8740A.

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/8740a.pdf

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index dc3d92d340c4d..b732982507939 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -327,6 +327,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.name		= "SMSC LAN8740",
 
 	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_RST_AFTER_CLK_EN,
 
 	.probe		= smsc_phy_probe,
 
-- 
2.20.1



