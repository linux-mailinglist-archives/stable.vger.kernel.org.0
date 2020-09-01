Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE5F259BAF
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgIARFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgIAPTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1FA8207D3;
        Tue,  1 Sep 2020 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973552;
        bh=5jkb5ORFpuR8LeeWXfWRUo27oTfjZ/NpAkPvzWqZAxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBTrlgKAeJTA/qveSLeTNkjivw6nmErzmixWerWcgFGXG/Eh/J6k9XyPNs3XPb0/c
         WoqsPS5AqE1E4AHXEohP1O8faw0ewoxQVOaONagcnVcQ8JFKyNDu68RQ6XQ2HVeW1d
         GVNVtpFAqK9GgyzcNOADVA9vtaAGRn03L31w0/DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/91] i2c: rcar: in slave mode, clear NACK earlier
Date:   Tue,  1 Sep 2020 17:10:19 +0200
Message-Id: <20200901150930.374217439@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
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
index ed0f068109785..d5d0809a6283c 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -545,6 +545,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 	/* master sent stop */
 	if (ssr_filtered & SSR) {
 		i2c_slave_event(priv->slave, I2C_SLAVE_STOP, &value);
+		rcar_i2c_write(priv, ICSCR, SIE | SDBS); /* clear our NACK */
 		rcar_i2c_write(priv, ICSIER, SAR);
 		rcar_i2c_write(priv, ICSSR, ~SSR & 0xff);
 	}
-- 
2.25.1



