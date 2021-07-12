Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3023C4ABE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbhGLGxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240398AbhGLGvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33164610CC;
        Mon, 12 Jul 2021 06:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072521;
        bh=Z2P7qrfrAgc1aezjJxPNFbCWzvfeh9Bh8dU1w8jdcp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3E4Z9KdXaNCu8n9/KEhOVcdz9NKEPl/F5bnYK78dC3QrGpFV49shxrIFqofkyyup
         QFg4J+IMR0W4gpQB7xrTmjguAV76WvVl8H5LpCkaLPWj2Znj5Fe3EPkbIugINOu9s1
         fmKoRAZvAuuuZGkLGfB1HPADkmozYu3NYvtUlJ/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/593] leds: lm3692x: Put fwnode in any case during ->probe()
Date:   Mon, 12 Jul 2021 08:10:42 +0200
Message-Id: <20210712060943.781578357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit f55db1c7fadc2a29c9fa4ff3aec98dbb111f2206 ]

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: 9a5c1c64ac0a ("leds: lm3692x: Change DT calls to fwnode calls")
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3692x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lm3692x.c b/drivers/leds/leds-lm3692x.c
index e945de45388c..55e6443997ec 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -435,6 +435,7 @@ static int lm3692x_probe_dt(struct lm3692x_led *led)
 
 	ret = fwnode_property_read_u32(child, "reg", &led->led_enable);
 	if (ret) {
+		fwnode_handle_put(child);
 		dev_err(&led->client->dev, "reg DT property missing\n");
 		return ret;
 	}
@@ -449,12 +450,11 @@ static int lm3692x_probe_dt(struct lm3692x_led *led)
 
 	ret = devm_led_classdev_register_ext(&led->client->dev, &led->led_dev,
 					     &init_data);
-	if (ret) {
+	if (ret)
 		dev_err(&led->client->dev, "led register err: %d\n", ret);
-		return ret;
-	}
 
-	return 0;
+	fwnode_handle_put(init_data.fwnode);
+	return ret;
 }
 
 static int lm3692x_probe(struct i2c_client *client,
-- 
2.30.2



