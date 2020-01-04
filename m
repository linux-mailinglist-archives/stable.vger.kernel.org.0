Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31213007C
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 04:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgADDg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 22:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbgADDg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F762465A;
        Sat,  4 Jan 2020 03:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578109016;
        bh=RtDViwFbpD+zIa7NXhWNX8VfgaADNVrAScFsojEl+4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbk3v+oxE6eQyIb8NwV4dOzrnSneyjuE9vIGuH3oMKnTguljwY0etnPOtsrf2k25g
         t+YZ79zig6IRWZZM2UON7tw+e9OUzVl3GVjneEnC3jfA5HZ0NBdnzLRq75MwLgHbFL
         n8w86TVB8LDAjwf/LZOEQtdWmd0nfJIQ+Iw08ekM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/4] gpio: Fix error message on out-of-range GPIO in lookup table
Date:   Fri,  3 Jan 2020 22:36:51 -0500
Message-Id: <20200104033653.11217-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200104033653.11217-1-sashal@kernel.org>
References: <20200104033653.11217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d935bd50dd14a7714cbdba9a76435dbb56edb1ae ]

When a GPIO offset in a lookup table is out-of-range, the printed error
message (1) does not include the actual out-of-range value, and (2)
contains an off-by-one error in the upper bound.

Avoid user confusion by also printing the actual GPIO offset, and
correcting the upper bound of the range.
While at it, use "%u" for unsigned int.

Sample impact:

    -requested GPIO 0 is out of range [0..32] for chip e6052000.gpio
    +requested GPIO 0 (45) is out of range [0..31] for chip e6052000.gpio

Fixes: 2a3cf6a3599e9015 ("gpiolib: return -ENOENT if no GPIO mapping exists")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191127095919.4214-1-geert+renesas@glider.be
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c7f5f0be2d74..8ce5133cccbd 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3159,8 +3159,9 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 
 		if (chip->ngpio <= p->chip_hwnum) {
 			dev_err(dev,
-				"requested GPIO %d is out of range [0..%d] for chip %s\n",
-				idx, chip->ngpio, chip->label);
+				"requested GPIO %u (%u) is out of range [0..%u] for chip %s\n",
+				idx, p->chip_hwnum, chip->ngpio - 1,
+				chip->label);
 			return ERR_PTR(-EINVAL);
 		}
 
-- 
2.20.1

