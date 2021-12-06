Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C649646AA33
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351397AbhLFVX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351248AbhLFVXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0E2C0698C0;
        Mon,  6 Dec 2021 13:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB32ACE1582;
        Mon,  6 Dec 2021 21:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0619AC341C1;
        Mon,  6 Dec 2021 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825615;
        bh=IOp27fWHEyFabm28nK96fSbGm+oP2n3zr0PYA2P6JFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXbjry83MiOcXft7Ex9dVSe2B/nAZZqCzr381k/sAfdBWTxLwJGGkjohAeixksvYi
         XuiGWxFm0NH+CAzMsyG4oe4tTdc8/cVZODEC5/l5vMdl6WF+H5dnkF0ASWky59kFZ/
         lgdIh8ldC68ZRYehQ1egwVUzYeohOYRB3gNGHpPa7oj7O+1yS96kl5A5K5wbzIHL6T
         hk9v76Ha3yU0iXpAUtywlfJaI9z2X0yr4H3fxd9pVNTEG9uQGeFEwHLAS5qKtQZTFU
         4kt3NFRhQL3fw1KtmTTGFDW24CKcRkm7ZueEXfc29vzFZeciPiCwQXN4ahnlMSuMFc
         ZnGLHd8am6wKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        John Keeping <john@metanate.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        heiko@sntech.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/6] i2c: rk3x: Handle a spurious start completion interrupt flag
Date:   Mon,  6 Dec 2021 16:20:00 -0500
Message-Id: <20211206212004.1661417-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206212004.1661417-1-sashal@kernel.org>
References: <20211206212004.1661417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit 02fe0fbd8a21e183687925c3a266ae27dda9840f ]

In a typical read transfer, start completion flag is being set after
read finishes (notice ipd bit 4 being set):

trasnfer poll=0
i2c start
rk3x-i2c fdd40000.i2c: IRQ: state 1, ipd: 10
i2c read
rk3x-i2c fdd40000.i2c: IRQ: state 2, ipd: 1b
i2c stop
rk3x-i2c fdd40000.i2c: IRQ: state 4, ipd: 33

This causes I2C transfer being aborted in polled mode from a stop completion
handler:

trasnfer poll=1
i2c start
rk3x-i2c fdd40000.i2c: IRQ: state 1, ipd: 10
i2c read
rk3x-i2c fdd40000.i2c: IRQ: state 2, ipd: 0
rk3x-i2c fdd40000.i2c: IRQ: state 2, ipd: 1b
i2c stop
rk3x-i2c fdd40000.i2c: IRQ: state 4, ipd: 13
i2c stop
rk3x-i2c fdd40000.i2c: unexpected irq in STOP: 0x10

Clearing the START flag after read fixes the issue without any obvious
side effects.

This issue was dicovered on RK3566 when adding support for powering
off the RK817 PMIC.

Signed-off-by: Ondrej Jirman <megous@megous.com>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rk3x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index fe234578380ac..548089aa9aba5 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -424,8 +424,8 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
 	if (!(ipd & REG_INT_MBRF))
 		return;
 
-	/* ack interrupt */
-	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
+	/* ack interrupt (read also produces a spurious START flag, clear it too) */
+	i2c_writel(i2c, REG_INT_MBRF | REG_INT_START, REG_IPD);
 
 	/* Can only handle a maximum of 32 bytes at a time */
 	if (len > 32)
-- 
2.33.0

