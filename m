Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88933E8009
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhHJRpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235974AbhHJRoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0A161078;
        Tue, 10 Aug 2021 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617171;
        bh=RxHK1u20b/F8+DvhuvxB1aZdwvVr2uSLvIftHo8/y8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZLIe5/1YKmd6k5a0hGp+J0cvl2+ysaTm+Zc/yVwB6qshCMyCYbCqC4sVltItU/x/
         AdoRTTDe/4BMQX/vne0m37v+VhV69jC4reRnOb+Y7QBzTZdio9KtZRb87z53g/jqHr
         LqhwTkT8h3lYyCjueYkYV7XxExZosG/dRbZ9U/YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/135] net: dsa: qca: ar9331: reorder MDIO write sequence
Date:   Tue, 10 Aug 2021 19:29:36 +0200
Message-Id: <20210810172957.113381223@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit d1a58c013a5837451e3213e7a426d350fa524ead ]

In case of this switch we work with 32bit registers on top of 16bit
bus. Some registers (for example access to forwarding database) have
trigger bit on the first 16bit half of request and the result +
configuration of request in the second half. Without this patch, we would
trigger database operation and overwrite result in one run.

To make it work properly, we should do the second part of transfer
before the first one is done.

So far, this rule seems to work for all registers on this switch.

Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20210803063746.3600-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/ar9331.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 4d49c5f2b790..661745932a53 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -689,16 +689,24 @@ static int ar9331_mdio_write(void *ctx, u32 reg, u32 val)
 		return 0;
 	}
 
-	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg, val);
+	/* In case of this switch we work with 32bit registers on top of 16bit
+	 * bus. Some registers (for example access to forwarding database) have
+	 * trigger bit on the first 16bit half of request, the result and
+	 * configuration of request in the second half.
+	 * To make it work properly, we should do the second part of transfer
+	 * before the first one is done.
+	 */
+	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg + 2,
+				  val >> 16);
 	if (ret < 0)
 		goto error;
 
-	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg + 2,
-				  val >> 16);
+	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg, val);
 	if (ret < 0)
 		goto error;
 
 	return 0;
+
 error:
 	dev_err_ratelimited(&sbus->dev, "Bus error. Failed to write register.\n");
 	return ret;
-- 
2.30.2



