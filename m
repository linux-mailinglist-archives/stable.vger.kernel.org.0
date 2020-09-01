Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A392596D8
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgIAQHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgIAPkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1E5205F4;
        Tue,  1 Sep 2020 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974814;
        bh=q7P9cCFpxlN9x+tDV5Y/GkV8ckZpzIKgx//emIyFi1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyRyvbjHUuAZ7n1Xv/SUYwe5s4swllGPu5YxZnCyUnb3DyMPKnDv2HjwELPzFy9a2
         RWeF0bcovqlQCl/xDQbeEfKXFH9VtQO8PxfTmXAIwsFt586ew4aLlVpb8PlrpBukQg
         3R9IBMKsn1L65T7QLeE8QmQIDdq9FXcI9oXltpU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 101/255] i2c: rcar: in slave mode, clear NACK earlier
Date:   Tue,  1 Sep 2020 17:09:17 +0200
Message-Id: <20200901151005.553708812@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 914a7b3563b8fb92f976619bbd0fa3a4a708baae ]

Currently, a NACK in slave mode is set/cleared when SCL is held low by
the IP core right before the bit is about to be pushed out. This is too
late for clearing and then a NACK from the previous byte is still used
for the current one. Now, let's clear the NACK right after we detected
the STOP condition following the NACK.

Fixes: de20d1857dd6 ("i2c: rcar: add slave support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 9e883474db8ce..c7c543483b08c 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -590,6 +590,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 	/* master sent stop */
 	if (ssr_filtered & SSR) {
 		i2c_slave_event(priv->slave, I2C_SLAVE_STOP, &value);
+		rcar_i2c_write(priv, ICSCR, SIE | SDBS); /* clear our NACK */
 		rcar_i2c_write(priv, ICSIER, SAR);
 		rcar_i2c_write(priv, ICSSR, ~SSR & 0xff);
 	}
-- 
2.25.1



