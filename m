Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA482E3FFA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502884AbgL1OXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502875AbgL1OXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED6E120791;
        Mon, 28 Dec 2020 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165384;
        bh=dKFIqJAkreP7x4OwIFF3ICRl8vZM4yI8GJOz+q8JmpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGKBdZtvTAHf5g0Qqb/997Rs8zyrDcpDHXvAxmhn4foxBZ3vtn8dQFyJUW6FontRU
         vVallKgODw9tDq7ZxBEiaTCmeKQkDbciMX8SkdmmYI/xgyUVGI4WQB/K5aNqZjBusT
         L2PTCkm6LoZ7P3KHJw7dTrE0cK+6jp1LjBebMfAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Johannes Pointner <johannes.pointner@br-automation.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/717] pwm: imx27: Fix overflow for bigger periods
Date:   Mon, 28 Dec 2020 13:47:59 +0100
Message-Id: <20201228125044.013444789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <uwe@kleine-koenig.org>

[ Upstream commit 1ce65396e6b2386b4fd54f87beff0647a772e1cd ]

The second parameter of do_div is an u32 and NSEC_PER_SEC * prescale
overflows this for bigger periods. Assuming the usual pwm input clk rate
of 66 MHz this happens starting at requested period > 606060 ns.

Splitting the division into two operations doesn't loose any precision.
It doesn't need to be feared that c / NSEC_PER_SEC doesn't fit into the
unsigned long variable "duty_cycles" because in this case the assignment
above to period_cycles would already have been overflowing as
period >= duty_cycle and then the calculation is moot anyhow.

Fixes: aef1a3799b5c ("pwm: imx27: Fix rounding behavior")
Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Tested-by: Johannes Pointner <johannes.pointner@br-automation.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index c50d453552bd4..86bcafd23e4f6 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -235,8 +235,9 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	period_cycles /= prescale;
 	c = clkrate * state->duty_cycle;
-	do_div(c, NSEC_PER_SEC * prescale);
+	do_div(c, NSEC_PER_SEC);
 	duty_cycles = c;
+	duty_cycles /= prescale;
 
 	/*
 	 * according to imx pwm RM, the real period value should be PERIOD
-- 
2.27.0



