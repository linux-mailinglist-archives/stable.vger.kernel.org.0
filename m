Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64143C2CB7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGJCUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhGJCUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCC5613B5;
        Sat, 10 Jul 2021 02:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883471;
        bh=YUEniXoGWoNOiBcC3NU1p9VwfWhDIBz0E7edYEnC7PY=;
        h=From:To:Cc:Subject:Date:From;
        b=oJFhjhyiDa0KFohUJM4PDOYDMlmiz/Q4uQqn6a2tfAkMpNZH/fOGHbLbt6ptu6bFp
         rFo0LO7lw3rn8gBwpWEgRvA8B8biGrvvOb88LdBKABpoJpdJeeLBHJWtrE0tnvCXfQ
         XkEdskU0ddNhM3asfwArinOyP1Ewi3ryJXYQ/xT0RaBTV63L0OE4dgR9qLfE5A5ZIA
         6UECK+QLbYtDRz8Gv/EyTwM3F9gXUJS9NUUmzoCoANBb+/d5UkDqUv6qOhq0kyUmnZ
         Duw8h0jqs83suObO1DbAaiBhbf1y1gqV01vcLF4imnp28hOBU/e+bbJqiyvzSGO36q
         /enTRc5+8LAug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 001/114] leds: tlc591xx: fix return value check in tlc591xx_probe()
Date:   Fri,  9 Jul 2021 22:15:55 -0400
Message-Id: <20210710021748.3167666-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ee522bcf026ec82ada793979c3a906274430595a ]

After device_get_match_data(), tlc591xx is not checked, add
check for it and also check np after dev_of_node.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-tlc591xx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-tlc591xx.c b/drivers/leds/leds-tlc591xx.c
index 5b9dfdf743ec..cb7bd1353f9f 100644
--- a/drivers/leds/leds-tlc591xx.c
+++ b/drivers/leds/leds-tlc591xx.c
@@ -148,16 +148,20 @@ static int
 tlc591xx_probe(struct i2c_client *client,
 	       const struct i2c_device_id *id)
 {
-	struct device_node *np = dev_of_node(&client->dev), *child;
+	struct device_node *np, *child;
 	struct device *dev = &client->dev;
 	const struct tlc591xx *tlc591xx;
 	struct tlc591xx_priv *priv;
 	int err, count, reg;
 
-	tlc591xx = device_get_match_data(dev);
+	np = dev_of_node(dev);
 	if (!np)
 		return -ENODEV;
 
+	tlc591xx = device_get_match_data(dev);
+	if (!tlc591xx)
+		return -ENODEV;
+
 	count = of_get_available_child_count(np);
 	if (!count || count > tlc591xx->max_leds)
 		return -EINVAL;
-- 
2.30.2

