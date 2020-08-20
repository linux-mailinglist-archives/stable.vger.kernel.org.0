Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E334924B8DB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgHTLaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbgHTKFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B4F520738;
        Thu, 20 Aug 2020 10:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917948;
        bh=/tn2C9sMZ3N8al5pyHXYeWvuudYtqcDjzQ1Yqw5bKyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPZ5RPdPz4ANqauT3XwjLln/eDjgjUYQ3AUfxOFZ/PRQQpER4txQ/eFHyxViIX6i3
         U4253cD9amA2hyEY9Fj1xMk2wdYcNtcV3uV1IGM+Wm9vRiplVvm7+bViNknMcAUl6r
         qTcJHJ/jejBszMYtxUo9rwVVN6WC5mG3ERPIOXI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 199/212] i2c: rcar: slave: only send STOP event when we have been addressed
Date:   Thu, 20 Aug 2020 11:22:52 +0200
Message-Id: <20200820091612.407762309@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 314139f9f0abdba61ed9a8463bbcb0bf900ac5a2 ]

When the SSR interrupt is activated, it will detect every STOP condition
on the bus, not only the ones after we have been addressed. So, enable
this interrupt only after we have been addressed, and disable it
otherwise.

Fixes: de20d1857dd6 ("i2c: rcar: add slave support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 93b8069041bb1..4231673435e7b 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -527,13 +527,14 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 			rcar_i2c_write(priv, ICSIER, SDR | SSR | SAR);
 		}
 
-		rcar_i2c_write(priv, ICSSR, ~SAR & 0xff);
+		/* Clear SSR, too, because of old STOPs to other clients than us */
+		rcar_i2c_write(priv, ICSSR, ~(SAR | SSR) & 0xff);
 	}
 
 	/* master sent stop */
 	if (ssr_filtered & SSR) {
 		i2c_slave_event(priv->slave, I2C_SLAVE_STOP, &value);
-		rcar_i2c_write(priv, ICSIER, SAR | SSR);
+		rcar_i2c_write(priv, ICSIER, SAR);
 		rcar_i2c_write(priv, ICSSR, ~SSR & 0xff);
 	}
 
@@ -762,7 +763,7 @@ static int rcar_reg_slave(struct i2c_client *slave)
 	priv->slave = slave;
 	rcar_i2c_write(priv, ICSAR, slave->addr);
 	rcar_i2c_write(priv, ICSSR, 0);
-	rcar_i2c_write(priv, ICSIER, SAR | SSR);
+	rcar_i2c_write(priv, ICSIER, SAR);
 	rcar_i2c_write(priv, ICSCR, SIE | SDBS);
 
 	return 0;
-- 
2.25.1



