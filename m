Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E2A4522F1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbhKPBQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243070AbhKOTJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC036349B;
        Mon, 15 Nov 2021 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000297;
        bh=c5yxrEJnwau+suMAyOuzhQ2bfIaHk8i+Shg85MDrnsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e49DlPgB24/3qVOYl/LKlTjXRT6Fk2/jLr0kgYbfs7mbkfQpOMFphNCxskx6kUajY
         p8fDigWDfI2/LOxzgy9Y2yBHmK2xCJq9G8HuyFodJTju4FiPAcyWj8QAeQsu4BrqIk
         vNnw2bb2D7dhLcP5UqKYfSWxCN0llCSX4pnBjFo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 602/849] power: supply: max17040: fix null-ptr-deref in max17040_probe()
Date:   Mon, 15 Nov 2021 18:01:25 +0100
Message-Id: <20211115165440.619915036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1d422ecfc48ee683ae1ccc9217764f6310c0ffce ]

Add check the return value of devm_regmap_init_i2c(), otherwise
later access may cause null-ptr-deref as follows:

KASAN: null-ptr-deref in range [0x0000000000000360-0x0000000000000367]
RIP: 0010:regmap_read+0x33/0x170
Call Trace:
  max17040_probe+0x61b/0xff0 [max17040_battery]
 ? write_comp_data+0x2a/0x90
 ? max17040_set_property+0x1d0/0x1d0 [max17040_battery]
 ? tracer_hardirqs_on+0x33/0x520
 ? __sanitizer_cov_trace_pc+0x1d/0x50
 ? _raw_spin_unlock_irqrestore+0x4b/0x60
 ? trace_hardirqs_on+0x63/0x2d0
 ? write_comp_data+0x2a/0x90
 ? __sanitizer_cov_trace_pc+0x1d/0x50
 ? max17040_set_property+0x1d0/0x1d0 [max17040_battery]
 i2c_device_probe+0xa31/0xbe0

Fixes: 6455a8a84bdf ("power: supply: max17040: Use regmap i2c")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 3cea92e28dc3e..a9aef1e8b186e 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -449,6 +449,8 @@ static int max17040_probe(struct i2c_client *client,
 
 	chip->client = client;
 	chip->regmap = devm_regmap_init_i2c(client, &max17040_regmap);
+	if (IS_ERR(chip->regmap))
+		return PTR_ERR(chip->regmap);
 	chip_id = (enum chip_id) id->driver_data;
 	if (client->dev.of_node) {
 		ret = max17040_get_of_data(chip);
-- 
2.33.0



