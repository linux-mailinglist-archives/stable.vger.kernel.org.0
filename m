Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87D746AA1D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbhLFVXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351232AbhLFVX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4AAC0613FE;
        Mon,  6 Dec 2021 13:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55882CE169F;
        Mon,  6 Dec 2021 21:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193A8C341C6;
        Mon,  6 Dec 2021 21:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825595;
        bh=3dMq2PJ2XAZkl3Gogfslwj469eWupVU1ITCKufkSN8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6/bW/fPGlm3JCnVsArzpnFG35y6HxivIjhmluEoS8GrQUopcICuR+EH8k58sdzf7
         /d7aWjFtN0O4wDSe4fvApDite/gaas5Iz4I/tIBlO9G5R09yAnRGM50ToI5wQDVE4O
         Kn8VGnHZbxkWsbrJzB4NoOMw0wQ9Br180TZIF4TaoUPahAoy7HekyVQp4oUqkXbRNu
         F3mIbtCnKuEjropavBQVhirxF88U1FGL5999FP9OePecTYGoAYuhMVxKWHGQFyWGH0
         Cp2ayD6zN1+LBXlruuzJVzvsE/6eun7aJV0Q1QHbEFKICWAYkcDhcg8RfNxOcPNXIC
         KsMXe77sEjkzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        John Keeping <john@metanate.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        heiko@sntech.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/7] i2c: rk3x: Handle a spurious start completion interrupt flag
Date:   Mon,  6 Dec 2021 16:19:25 -0500
Message-Id: <20211206211934.1661294-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211934.1661294-1-sashal@kernel.org>
References: <20211206211934.1661294-1-sashal@kernel.org>
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
index b8a2728dd4b69..e76ad020a5420 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -425,8 +425,8 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
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

