Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2691B747B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgDXMYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgDXMYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6925217BA;
        Fri, 24 Apr 2020 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731085;
        bh=q71kAljo8EsKoOPHLSzW1gYD6pwZKfe8hSDVn1gDtrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqKv8cZnKytcVFaGwWhJ0SDASp0M/xqzpMg92pG5zoTPIHb2cUoaYGcYUM86INBii
         Y3DXoOhBZ86FRKxUR7GZ1B5JZLnrKb31ZT9SaPIGEdhAYrMP49XXGDvbGUV7oq2AIS
         w6LeRwMKss1LUauPHzWE/piUHl1L6xso59aYqGzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/21] hwmon: (jc42) Fix name to have no illegal characters
Date:   Fri, 24 Apr 2020 08:24:19 -0400
Message-Id: <20200424122419.10648-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122419.10648-1-sashal@kernel.org>
References: <20200424122419.10648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit c843b382e61b5f28a3d917712c69a344f632387c ]

The jc42 driver passes I2C client's name as hwmon device name. In case
of device tree probed devices this ends up being part of the compatible
string, "jc-42.4-temp". This name contains hyphens and the hwmon core
doesn't like this:

jc42 2-0018: hwmon: 'jc-42.4-temp' is not a valid name attribute, please fix

This changes the name to "jc42" which doesn't have any illegal
characters.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20200417092853.31206-1-s.hauer@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index e5234f953a6d1..b6e5aaa54963d 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -527,7 +527,7 @@ static int jc42_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 	data->config = config;
 
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, "jc42",
 							 data, &jc42_chip_info,
 							 NULL);
 	return PTR_ERR_OR_ZERO(hwmon_dev);
-- 
2.20.1

