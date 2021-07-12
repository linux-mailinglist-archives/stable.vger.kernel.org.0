Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB93C4F79
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbhGLH0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242729AbhGLHXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751EA61364;
        Mon, 12 Jul 2021 07:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074420;
        bh=+aKlfOpXTWW0aBttBOjoTHH8sdSifCqeNs0g4GNCclc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SF/UoZ9lRwLNrigzd5WVXzixhp9IhvagkWBz2I3W1PzT0cPRQ/jEqUO85UCjCp7bU
         6B/Xbzenaj/ALLgBh4ogN1sGafZ4NvomyLpHKyd2pp9gqRpvvBA+GgcM5QMi+H6oMS
         bP800Wt2gvpS2YOw3eSmC/5+xGTrrEid1GX27K2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 572/700] leds: lm36274: Put fwnode in error case during ->probe()
Date:   Mon, 12 Jul 2021 08:10:55 +0200
Message-Id: <20210712061036.933778120@linuxfoundation.org>
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

[ Upstream commit 3c5f655c44bb65cb7e3c219d08c130ce5fa45d7f ]

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

In the older code the same is implied with device_for_each_child_node().

Fixes: 11e1bbc116a7 ("leds: lm36274: Introduce the TI LM36274 LED driver")
Fixes: a448fcf19c9c ("leds: lm36274: don't iterate through children since there is only one")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm36274.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-lm36274.c b/drivers/leds/leds-lm36274.c
index aadb03468a40..a23a9424c2f3 100644
--- a/drivers/leds/leds-lm36274.c
+++ b/drivers/leds/leds-lm36274.c
@@ -127,6 +127,7 @@ static int lm36274_probe(struct platform_device *pdev)
 
 	ret = lm36274_init(chip);
 	if (ret) {
+		fwnode_handle_put(init_data.fwnode);
 		dev_err(chip->dev, "Failed to init the device\n");
 		return ret;
 	}
-- 
2.30.2



