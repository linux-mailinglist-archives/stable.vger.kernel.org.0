Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2E6147E00
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389004AbgAXKE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbgAXKE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:04:58 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DDD222D9;
        Fri, 24 Jan 2020 10:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860297;
        bh=2EVrWCtV4R8qwsgK4ihB0a1LC1msbnOCLce3h+hbXMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMogTaWz7cap5vhQ4YUJgHgOUKECJrrNjh5wS9OaCCeE61HhA6m4yOyUvMfUQs5Z5
         V7IQRJMnI8drQ+j/Nl5aDvOavUQ5//mZLAQisG+OZeOll0ofWeRE6f1FZRAG4N58rL
         0Y6EVYdb8RABPxEnIEcq4q4uPbna4UOZwPY5ZEZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iker Perez del Palomar Sustatxa 
        <iker.perez@codethink.co.uk>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 285/343] hwmon: (lm75) Fix write operations for negative temperatures
Date:   Fri, 24 Jan 2020 10:31:43 +0100
Message-Id: <20200124092957.525701097@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 7d82fcc9d9e81241778aaa22fda7be753e237d86 ]

Writes into limit registers fail if the temperature written is negative.
The regmap write operation checks the value range, regmap_write accepts
an unsigned int as parameter, and the temperature value passed to
regmap_write is kept in a variable declared as long. Negative values
are converted large unsigned integers, which fails the range check.
Fix by type casting the temperature to u16 when calling regmap_write().

Cc: Iker Perez del Palomar Sustatxa <iker.perez@codethink.co.uk>
Fixes: e65365fed87f ("hwmon: (lm75) Convert to use regmap")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm75.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 005ffb5ffa92d..1737bb5fbaafe 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -165,7 +165,7 @@ static int lm75_write(struct device *dev, enum hwmon_sensor_types type,
 	temp = DIV_ROUND_CLOSEST(temp  << (resolution - 8),
 				 1000) << (16 - resolution);
 
-	return regmap_write(data->regmap, reg, temp);
+	return regmap_write(data->regmap, reg, (u16)temp);
 }
 
 static umode_t lm75_is_visible(const void *data, enum hwmon_sensor_types type,
-- 
2.20.1



