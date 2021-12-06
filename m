Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5203346A97B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350450AbhLFVRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350631AbhLFVRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078D6C061746;
        Mon,  6 Dec 2021 13:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5409ECE1864;
        Mon,  6 Dec 2021 21:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4B1C341C6;
        Mon,  6 Dec 2021 21:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825251;
        bh=hPhWCMSayHBcfhH1bYNvUK2TzdlMPbkcPiari3gUW8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HifX9u3b7ByiKL041rOqp4WLYpVinxYj+QzNtIHh3oobvMl8lQDwy4HjbWdaf6kdb
         3Pv2se0ZZU+9nEUW8Xt8+T6YjFySKHNrQ6qfpF7h4rJ6jpHvBR5v+zgxYd7at8aVLH
         pNGgpf/7eRSceGUaYnhOpy26z/F4HWuBbzG9CV4/qNGpDPToRP3nA0PEcPrBYyAG7t
         geARE2AeNTk39DwORIAKQB12ExmmTixo+p2KT3oVY2NSRrKIBYfGwfo4D5HyDIyxAb
         InFokQ2UhEv34+bHeMvTsnw8eJQF5prBIRf1RkkSExkg1V9NOe8B5m2QGi+8ftXRZr
         Ao43p4apd24FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        John Keeping <john@metanate.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        heiko@sntech.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/24] i2c: rk3x: Handle a spurious start completion interrupt flag
Date:   Mon,  6 Dec 2021 16:12:20 -0500
Message-Id: <20211206211230.1660072-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
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
index 819ab4ee517e1..02ddb237f69af 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -423,8 +423,8 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
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

