Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B894996E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377220AbiAXVHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55642 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444812AbiAXVBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA38B81243;
        Mon, 24 Jan 2022 21:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDB2C340E7;
        Mon, 24 Jan 2022 21:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058094;
        bh=OwpKNv0ksLy2DW7Xq4ObVUnGJwW2RSKgFNXj5Tn8mh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJzaLQ/FVc6ljE/dX+tqxjfau6yDcEpx2cLfeHHBwm1U/T7RUksFh0dtlxG8AcTjO
         nXBvU6MONvlAMQ1HbhWKFzKDP9JIHGyINfyXNq7sZOHuhfTD5O/hjLW5SjdZ2g7jyg
         zm6Vf4dnEhfhUQCxLGS3XFreWXPlQgT46fvq0gJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0179/1039] pinctrl: apple: return an error if pinmux is missing in the DT
Date:   Mon, 24 Jan 2022 19:32:48 +0100
Message-Id: <20220124184131.296510925@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit 839930ca1bd0c79cdf370d11462ef4a81b664e44 ]

If of_property_count_u32_elems returned 0, return -EINVAL to indicate
a failure. Previously this would return 0.

Fixes: a0f160ffcb83 ("pinctrl: add pinctrl/GPIO driver for Apple SoCs")
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20211121165642.27883-12-joey.gouly@arm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-apple-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-apple-gpio.c b/drivers/pinctrl/pinctrl-apple-gpio.c
index a7861079a6502..c772e31d21223 100644
--- a/drivers/pinctrl/pinctrl-apple-gpio.c
+++ b/drivers/pinctrl/pinctrl-apple-gpio.c
@@ -114,7 +114,7 @@ static int apple_gpio_dt_node_to_map(struct pinctrl_dev *pctldev,
 		dev_err(pctl->dev,
 			"missing or empty pinmux property in node %pOFn.\n",
 			node);
-		return ret;
+		return ret ? ret : -EINVAL;
 	}
 
 	num_pins = ret;
-- 
2.34.1



