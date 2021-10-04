Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BFA421008
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhJDNkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238469AbhJDNif (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9719261872;
        Mon,  4 Oct 2021 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353451;
        bh=/iEj+Dy6csfBsYnHFRL20+7jzqNMnO/aEswdmbKKV8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QYKrpfdtZIvqE9bYPiKA9PEDVoYSj6rDvQJAADOgNx7UFP0YnknmP5oiiDriJbLS
         sYgcGQv7tDo7zwQsbqdMSbL9AWTEXVAHf88Jw7YXWLnXgUqk2twRDT2EqyHZwNoA4Y
         1nNihIxuhSFSUgoNjcGJ0YgJ2xmQnpUh6P8LyR4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 100/172] hwmon: (tmp421) fix rounding for negative values
Date:   Mon,  4 Oct 2021 14:52:30 +0200
Message-Id: <20211004125048.210616434@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

[ Upstream commit 724e8af85854c4d3401313b6dd7d79cf792d8990 ]

Old code produces -24999 for 0b1110011100000000 input in standard format due to
always rounding up rather than "away from zero".

Use the common macro for division, unify and simplify the conversion code along
the way.

Fixes: 9410700b881f ("hwmon: Add driver for Texas Instruments TMP421/422/423 sensor chips")
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/r/20210924093011.26083-3-fercerpav@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp421.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index c9ef83627bb7..b963a369c5ab 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -100,23 +100,17 @@ struct tmp421_data {
 	s16 temp[4];
 };
 
-static int temp_from_s16(s16 reg)
+static int temp_from_raw(u16 reg, bool extended)
 {
 	/* Mask out status bits */
 	int temp = reg & ~0xf;
 
-	return (temp * 1000 + 128) / 256;
-}
-
-static int temp_from_u16(u16 reg)
-{
-	/* Mask out status bits */
-	int temp = reg & ~0xf;
-
-	/* Add offset for extended temperature range. */
-	temp -= 64 * 256;
+	if (extended)
+		temp = temp - 64 * 256;
+	else
+		temp = (s16)temp;
 
-	return (temp * 1000 + 128) / 256;
+	return DIV_ROUND_CLOSEST(temp * 1000, 256);
 }
 
 static int tmp421_update_device(struct tmp421_data *data)
@@ -172,10 +166,8 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 
 	switch (attr) {
 	case hwmon_temp_input:
-		if (tmp421->config & TMP421_CONFIG_RANGE)
-			*val = temp_from_u16(tmp421->temp[channel]);
-		else
-			*val = temp_from_s16(tmp421->temp[channel]);
+		*val = temp_from_raw(tmp421->temp[channel],
+				     tmp421->config & TMP421_CONFIG_RANGE);
 		return 0;
 	case hwmon_temp_fault:
 		/*
-- 
2.33.0



