Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE7111AF49
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfLKPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731127AbfLKPM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCC0222C4;
        Wed, 11 Dec 2019 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077146;
        bh=oh40QEE5ttlEKYSROoAylS8040I4r7PyyUN5hmOebRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9w8tbhXuk/fcsExp84PQnemUKrYtyS/REnkgyIhdXuX0sCy/MJFnR3r4wnwrdBEH
         HpHf2Ko/YObWeADwcXQjKCEDyVfia0v+1fr0lzPomaBqkTOAE3yeM7yQLxjeh6rx6X
         SABESV3cARdq0bTQ4eJ5MU/Ed1/eoGsJxyEjl4UE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/134] leds: an30259a: add a check for devm_regmap_init_i2c
Date:   Wed, 11 Dec 2019 10:10:09 -0500
Message-Id: <20191211151150.19073-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit fc7b5028f2627133c7c18734715a08829eab4d1f ]

an30259a_probe misses a check for devm_regmap_init_i2c and may cause
problems.
Add a check and print errors like other leds drivers.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-an30259a.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/leds/leds-an30259a.c b/drivers/leds/leds-an30259a.c
index 250dc9d6f6350..82350a28a5644 100644
--- a/drivers/leds/leds-an30259a.c
+++ b/drivers/leds/leds-an30259a.c
@@ -305,6 +305,13 @@ static int an30259a_probe(struct i2c_client *client)
 
 	chip->regmap = devm_regmap_init_i2c(client, &an30259a_regmap_config);
 
+	if (IS_ERR(chip->regmap)) {
+		err = PTR_ERR(chip->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			err);
+		goto exit;
+	}
+
 	for (i = 0; i < chip->num_leds; i++) {
 		struct led_init_data init_data = {};
 
-- 
2.20.1

