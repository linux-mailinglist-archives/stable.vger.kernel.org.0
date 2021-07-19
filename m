Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CA3CE444
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhGSPm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346891AbhGSPjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC036138C;
        Mon, 19 Jul 2021 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711524;
        bh=YUEniXoGWoNOiBcC3NU1p9VwfWhDIBz0E7edYEnC7PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQF1v7O6faFQK6/QE2srawBO8KWQmWuuEh2jIYbJpFUiVk9ugbGelXUW91zDzn99U
         Peiw8HYB2XpO7LefJDNTbdiW7U7yWGEpEwLvPBwoFG0qLUoY+Z2lRaZpoE+Fk27+ea
         71fzF3SRW9Ro1XVU0T//MY5P0dvZ0POK1MDK8TTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 034/292] leds: tlc591xx: fix return value check in tlc591xx_probe()
Date:   Mon, 19 Jul 2021 16:51:36 +0200
Message-Id: <20210719144943.650279951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



