Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A076E450C0B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbhKOReX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238061AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97C5632AB;
        Mon, 15 Nov 2021 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996842;
        bh=+0ulDNGKg8RNVsxOmzyqa8thwuleep5kB/nIUBxSjoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX9sTHzeaoWo6gl2GKIvIu8L1xSUbJXD/LQb9OEvIqTf9EKJRTmVUC0VvEu0RBSf9
         eppUeWUDGWxJpfgRzhSN6gHUqcK+8xCnKn4ham23bPbssapeBQyXzaeaji441eqmle
         Zw7tAeRYRjq3dFzOIksunsLbmahjJnZZ/TDipeLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/355] power: supply: bq27xxx: Fix kernel crash on IRQ handler register error
Date:   Mon, 15 Nov 2021 18:03:32 +0100
Message-Id: <20211115165323.041730815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cdf10ffe8f626d8a2edc354abf063df0078b2d71 ]

When registering the IRQ handler fails, do not just return the error code,
this will free the devm_kzalloc()-ed data struct while leaving the queued
work queued and the registered power_supply registered with both of them
now pointing to free-ed memory, resulting in various kernel crashes
soon afterwards.

Instead properly tear-down things on IRQ handler register errors.

Fixes: 703df6c09795 ("power: bq27xxx_battery: Reorganize I2C into a module")
Cc: Andrew F. Davis <afd@ti.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery_i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery_i2c.c b/drivers/power/supply/bq27xxx_battery_i2c.c
index 2677c38a8a424..34229c1f43e31 100644
--- a/drivers/power/supply/bq27xxx_battery_i2c.c
+++ b/drivers/power/supply/bq27xxx_battery_i2c.c
@@ -195,7 +195,8 @@ static int bq27xxx_battery_i2c_probe(struct i2c_client *client,
 			dev_err(&client->dev,
 				"Unable to register IRQ %d error %d\n",
 				client->irq, ret);
-			return ret;
+			bq27xxx_battery_teardown(di);
+			goto err_failed;
 		}
 	}
 
-- 
2.33.0



