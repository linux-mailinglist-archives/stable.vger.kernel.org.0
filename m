Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EFC13F1EC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391865AbgAPRZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391855AbgAPRZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF1E2468C;
        Thu, 16 Jan 2020 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195501;
        bh=IVGWB140nrt+GHipb+qYIHmKcToavEP9uvo3bLo7vEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vst+L/ggAj8ZqtIDXs9l4Xo+pD+4hz7ZwH3JGVGaVBhsD8cmOcTbOF7Y919czT1Vn
         SxhRzfA9Gi5jy5fe1AOfEdiB4o+7y5Z6e08gJ5Fi3BTzJ2oHsWZ3oBfn2f1zZPjhUL
         uz+3MdLf15wHfW+baRgOlAg3xh6TgzymEfEWY/Xo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@mellanox.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 102/371] hwmon: (pmbus/tps53679) Fix driver info initialization in probe routine
Date:   Thu, 16 Jan 2020 12:19:34 -0500
Message-Id: <20200116172403.18149-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit ff066653aeed8ee2d4dadb1e35774dd91ecbb19f ]

Fix tps53679_probe() by using dynamically allocated "pmbus_driver_info"
structure instead of static. Usage of static structures causes
overwritten of the field "vrm_version", in case the system is equipped
with several tps53679 devices with the different "vrm_version".
In such case the last probed device overwrites this field for all
others.

Fixes: 610526527a13 ("hwmon: (pmbus) Add support for Texas Instruments tps53679 device")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/tps53679.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/tps53679.c b/drivers/hwmon/pmbus/tps53679.c
index 85b515cd9df0..2bc352c5357f 100644
--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -80,7 +80,14 @@ static struct pmbus_driver_info tps53679_info = {
 static int tps53679_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	return pmbus_do_probe(client, id, &tps53679_info);
+	struct pmbus_driver_info *info;
+
+	info = devm_kmemdup(&client->dev, &tps53679_info, sizeof(*info),
+			    GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	return pmbus_do_probe(client, id, info);
 }
 
 static const struct i2c_device_id tps53679_id[] = {
-- 
2.20.1

