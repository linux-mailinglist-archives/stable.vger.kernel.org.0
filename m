Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649E4364C73
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbhDSUu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242906AbhDSUs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18AC613E4;
        Mon, 19 Apr 2021 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865164;
        bh=Ry2FBu05OwJNz5UGUVif65mrp/FqZv3IvVOo+BEE0bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5JRFTYu1UA4GfKKUeZT3FBz8CzD0S7pM5YM2abDik4fv8TB757abWWWSwYCARuqy
         Gw0S5ef84z2YDtn4Ch159VC7rt3xSr2yUi6W88Rwd5sUnBAQ/xB3J7ImzdRDDZZl41
         rl2fYkGZOMk/UD5PkuVxcEXPU6A+V+MgxCbvoO7fRnJVjWWw92585mMcaTbnmRplvu
         b0lOe2DDTk5bowKEm8D79H7WzQsULYm1fNTKlA7nduUgMOWd+K233klLcqwD9xsPyn
         OWUQwh7loetrq730Emr+vsSViPgajNYQ22/16HVVunjGtRJYGiJ3ImOyRn7H7pl2nP
         0QhOR6Fn/dZMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/8] i2c: mv64xxx: Fix random system lock caused by runtime PM
Date:   Mon, 19 Apr 2021 16:45:52 -0400
Message-Id: <20210419204554.7071-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204554.7071-1-sashal@kernel.org>
References: <20210419204554.7071-1-sashal@kernel.org>
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
index 5c9dea7a40bc..b10e89b4f8e9 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -217,6 +217,10 @@ mv64xxx_i2c_hw_init(struct mv64xxx_i2c_data *drv_data)
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

