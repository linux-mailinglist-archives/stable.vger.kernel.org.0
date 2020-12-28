Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787AC2E3F1F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505210AbgL1OfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505022AbgL1Od1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB4D20715;
        Mon, 28 Dec 2020 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165992;
        bh=IxFc7aTdCQTIMkYAxsagQUyI2b3lyctfvlzezdqIlAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgDNz5/hU2tznEgxnxfNH+k3IoaLUJ0guIK4YeIjZXOTc0Q/jBZ81JdKkf/bbVuRS
         6NQ+sXd7Ro9VoK4JoyD1UA+0ajeo6nqQzLcNOkuz6Qh113NpTrkZqsF6zXyxswAYgP
         q12rbqZIj7EMn+mfstgDChRz0hdzbwuxLKxneXAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/717] leds: netxbig: add missing put_device() call in netxbig_leds_get_of_pdata()
Date:   Mon, 28 Dec 2020 13:43:21 +0100
Message-Id: <20201228125030.706869763@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 311066aa9ebcd6f1789c829da5039ca02f2dfe46 ]

if of_find_device_by_node() succeed, netxbig_leds_get_of_pdata() doesn't
have a corresponding put_device(). Thus add jump target to fix the
exception handling for this function implementation.

Fixes: 2976b1798909 ("leds: netxbig: add device tree binding")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index e6fd47365b588..68fbf0b66fadd 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -448,31 +448,39 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 	gpio_ext = devm_kzalloc(dev, sizeof(*gpio_ext), GFP_KERNEL);
 	if (!gpio_ext) {
 		of_node_put(gpio_ext_np);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put_device;
 	}
 	ret = netxbig_gpio_ext_get(dev, gpio_ext_dev, gpio_ext);
 	of_node_put(gpio_ext_np);
 	if (ret)
-		return ret;
+		goto put_device;
 	pdata->gpio_ext = gpio_ext;
 
 	/* Timers (optional) */
 	ret = of_property_count_u32_elems(np, "timers");
 	if (ret > 0) {
-		if (ret % 3)
-			return -EINVAL;
+		if (ret % 3) {
+			ret = -EINVAL;
+			goto put_device;
+		}
+
 		num_timers = ret / 3;
 		timers = devm_kcalloc(dev, num_timers, sizeof(*timers),
 				      GFP_KERNEL);
-		if (!timers)
-			return -ENOMEM;
+		if (!timers) {
+			ret = -ENOMEM;
+			goto put_device;
+		}
 		for (i = 0; i < num_timers; i++) {
 			u32 tmp;
 
 			of_property_read_u32_index(np, "timers", 3 * i,
 						   &timers[i].mode);
-			if (timers[i].mode >= NETXBIG_LED_MODE_NUM)
-				return -EINVAL;
+			if (timers[i].mode >= NETXBIG_LED_MODE_NUM) {
+				ret = -EINVAL;
+				goto put_device;
+			}
 			of_property_read_u32_index(np, "timers",
 						   3 * i + 1, &tmp);
 			timers[i].delay_on = tmp;
@@ -488,12 +496,15 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 	num_leds = of_get_available_child_count(np);
 	if (!num_leds) {
 		dev_err(dev, "No LED subnodes found in DT\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put_device;
 	}
 
 	leds = devm_kcalloc(dev, num_leds, sizeof(*leds), GFP_KERNEL);
-	if (!leds)
-		return -ENOMEM;
+	if (!leds) {
+		ret = -ENOMEM;
+		goto put_device;
+	}
 
 	led = leds;
 	for_each_available_child_of_node(np, child) {
@@ -574,6 +585,8 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 
 err_node_put:
 	of_node_put(child);
+put_device:
+	put_device(gpio_ext_dev);
 	return ret;
 }
 
-- 
2.27.0



