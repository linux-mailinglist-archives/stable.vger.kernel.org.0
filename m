Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA463C4F7A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243625AbhGLH0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240236AbhGLHXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925E36136D;
        Mon, 12 Jul 2021 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074423;
        bh=Z2P7qrfrAgc1aezjJxPNFbCWzvfeh9Bh8dU1w8jdcp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huj93dKxVPXYkgfuwFuf03yRpIO2QYXQ+CKlXNUoe/Hm35J30Pje38tE5JiGWwmtD
         q1vHEDL3Rlf5UIMKBBJv/dKw4AWlbKMsLCekUvxqso0+TgRhK2/Xmdy8LmmzgumzMc
         3e+Q61vKM9AEek3z95SsM0PYNA11cFnhCxg+5F+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 573/700] leds: lm3692x: Put fwnode in any case during ->probe()
Date:   Mon, 12 Jul 2021 08:10:56 +0200
Message-Id: <20210712061037.031626368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



