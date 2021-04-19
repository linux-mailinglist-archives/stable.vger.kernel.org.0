Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64778364BFE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbhDSUsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242655AbhDSUqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8FA761369;
        Mon, 19 Apr 2021 20:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865108;
        bh=M+N2MxbnGQjhURZ3gS5hwFCV7PfmBdMis2chExCLoZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g64W9gIfxwa9PIQeVkw0WepEvbGvEfe+NRaWNiXKv83nheMzTdoHECSUrpAtCOzFp
         wm7kwsyuYhSxFNmu/JblTpqn3wvy5rlYWSDnP+YNtetPSrtj8+efWB8M5RgbUV8NRy
         UK0MFKh9BDbbxjGci/Go7EtVa05zidpKyRNJLf6PP1R2t9xCBTreIMmpTYXkFx9Cq3
         JmnehzzP4rRtjX9J0U3QtmhufX1BqJ67X/yY64LwYhif0LN5ME3QKcXmvLiZqQLlRD
         3cejFjg9BJeGjtJLCeQ3klol3OPFniyBc7dHFB+t7o6mUc1n4rgay/7kODfH0hAZla
         E5E3ZRR3LLPrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/14] i2c: mv64xxx: Fix random system lock caused by runtime PM
Date:   Mon, 19 Apr 2021 16:44:49 -0400
Message-Id: <20210419204454.6601-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 39930213e7779b9c4257499972b8afb8858f1a2d ]

I noticed a weird bug with this driver on Marvell CN9130 Customer
Reference Board.

Sometime after boot, the system locks with the following message:
 [104.071363] i2c i2c-0: mv64xxx: I2C bus locked, block: 1, time_left: 0

The system does not respond afterwards, only warns about RCU stalls.

This first appeared with commit e5c02cf54154 ("i2c: mv64xxx: Add runtime
PM support").

With further experimentation I discovered that adding a delay into
mv64xxx_i2c_hw_init() fixes this issue. This function is called before
every xfer, due to how runtime PM works in this driver. It seems that in
order to work correctly, a delay is needed after the bus is reset in
this function.

Since there already is a known erratum with this controller needing a
delay, I assume that this is just another place this needs to be
applied. Therefore I apply the delay only if errata_delay is true.

Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index a5a95ea5b81a..7409cfba2195 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -218,6 +218,10 @@ mv64xxx_i2c_hw_init(struct mv64xxx_i2c_data *drv_data)
 	writel(0, drv_data->reg_base + drv_data->reg_offsets.ext_addr);
 	writel(MV64XXX_I2C_REG_CONTROL_TWSIEN | MV64XXX_I2C_REG_CONTROL_STOP,
 		drv_data->reg_base + drv_data->reg_offsets.control);
+
+	if (drv_data->errata_delay)
+		udelay(5);
+
 	drv_data->state = MV64XXX_I2C_STATE_IDLE;
 }
 
-- 
2.30.2

