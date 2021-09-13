Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EF7408CDD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbhIMNWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240225AbhIMNVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BCCB60698;
        Mon, 13 Sep 2021 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539183;
        bh=rQ5Yeo5GhD0p/1MIRkcd1uTdmIxanIN8V3aTziqonDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUExuFdKCVEfNYrcPKv8BHRLwcCfbvFhQQ9WzYKrShe0N2ZLn83toFwHA7KZ+2Kw8
         UZa0opvuzCzhgNfMzzv8yH1iXxvht2ZOGX45YLXbscddikr0X4TavoBlwMejN8oRf2
         ZmQr7k+elpQ+m9eWTr6D+8pEDx56DBQKXbyMo8Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/144] leds: lt3593: Put fwnode in any case during ->probe()
Date:   Mon, 13 Sep 2021 15:14:14 +0200
Message-Id: <20210913131050.404769959@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 7e1baaaa2407a642ea19b58e214fab9a69cda1d7 ]

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: 8cd7d6daba93 ("leds: lt3593: Add device tree probing glue")
Cc: Daniel Mack <daniel@zonque.org>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lt3593.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index c94995f0daa2..03ae33093ce6 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -103,10 +103,9 @@ static int lt3593_led_probe(struct platform_device *pdev)
 	init_data.default_label = ":";
 
 	ret = devm_led_classdev_register_ext(dev, &led_data->cdev, &init_data);
-	if (ret < 0) {
-		fwnode_handle_put(child);
+	fwnode_handle_put(child);
+	if (ret < 0)
 		return ret;
-	}
 
 	led_data->cdev.dev->of_node = dev->of_node;
 	platform_set_drvdata(pdev, led_data);
-- 
2.30.2



