Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71439E1F1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhFGQOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhFGQO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C02613C5;
        Mon,  7 Jun 2021 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082357;
        bh=GhkXtGXIL0fNxS3zp4DWV6PenphHRFaLCBus3LYh8hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUmrij2w60fB8KaYEJAnMuNxPrqy8MDGkEpNUEZvci3U1h/zs4Aef+5f6yIHzetxa
         MW2tsbObSVqI98v8DjZ50Pq0of4YuXpLLI17k89/htzOt35R/ZNlO3v2EBgXta6OR9
         flnzxHmtYH0Q00wFFs1cIf171d8Z9KLMVJ1UYko2HqftunAYeYQS7SsiCGift2mMpy
         mCBLzJ+/TlhfDHpPpTSTRdWzHzuG4mLUmsWCX6nfwz1GAI3e5z10GYqjcvU8cJVAHU
         T0L0JFO7Y5HaQSEDdBn6hA09m4FinUolqKvBIvmlGAmRnxMGLXVhf36MltJruanRvR
         K6rBwAXfEQS1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chu Lin <linchuyuan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 17/49] hwmon/pmbus: (q54sj108a2) The PMBUS_MFR_ID is actually 6 chars instead of 5
Date:   Mon,  7 Jun 2021 12:11:43 -0400
Message-Id: <20210607161215.3583176-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chu Lin <linchuyuan@google.com>

[ Upstream commit f0fb26c456a30d6009faa2c9d44aa22f5bf88c90 ]

The PMBUS_MFR_ID block is actually 6 chars for q54sj108a2.
/sys/bus/i2c/drivers/q54sj108a2_test# iotools smbus_read8 $BUS $ADDR 0x99
0x06

Tested: Devices are able to bind to the q54sj108a2 driver successfully.

Signed-off-by: Chu Lin <linchuyuan@google.com>
Link: https://lore.kernel.org/r/20210517222606.3457594-1-linchuyuan@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/q54sj108a2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/q54sj108a2.c b/drivers/hwmon/pmbus/q54sj108a2.c
index aec512766c31..0976268b2670 100644
--- a/drivers/hwmon/pmbus/q54sj108a2.c
+++ b/drivers/hwmon/pmbus/q54sj108a2.c
@@ -299,7 +299,7 @@ static int q54sj108a2_probe(struct i2c_client *client)
 		dev_err(&client->dev, "Failed to read Manufacturer ID\n");
 		return ret;
 	}
-	if (ret != 5 || strncmp(buf, "DELTA", 5)) {
+	if (ret != 6 || strncmp(buf, "DELTA", 5)) {
 		buf[ret] = '\0';
 		dev_err(dev, "Unsupported Manufacturer ID '%s'\n", buf);
 		return -ENODEV;
-- 
2.30.2

