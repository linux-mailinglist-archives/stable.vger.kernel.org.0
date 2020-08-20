Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1874124BB1B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgHTMXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbgHTJyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2B72075E;
        Thu, 20 Aug 2020 09:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917276;
        bh=YJIOkrnDLtvjSdQPBkT7qqKl3C3DwVHsZlnDQUDsGLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2stVS8f+R60QbN6Hl8x9k6FzIQiZFbed6QusRKBVk1sfvg+xG6SnKF/AMGc2b3FcJ
         749L/wITYUklEvEhKmZlxbS11o9WrIF02bgeRPWWz2lD9reOjGorAKRh+yTAtU/WVI
         pQanElE306P9ntwJKHzlUYI+krEcGQfHVCnD2Ug0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 65/92] i2c: rcar: slave: only send STOP event when we have been addressed
Date:   Thu, 20 Aug 2020 11:21:50 +0200
Message-Id: <20200820091540.998682796@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
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
index 6e49e438ef5a5..11d1977616858 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -587,13 +587,14 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
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
 
@@ -848,7 +849,7 @@ static int rcar_reg_slave(struct i2c_client *slave)
 	priv->slave = slave;
 	rcar_i2c_write(priv, ICSAR, slave->addr);
 	rcar_i2c_write(priv, ICSSR, 0);
-	rcar_i2c_write(priv, ICSIER, SAR | SSR);
+	rcar_i2c_write(priv, ICSIER, SAR);
 	rcar_i2c_write(priv, ICSCR, SIE | SDBS);
 
 	return 0;
-- 
2.25.1



