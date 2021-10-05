Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430024228D4
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhJENye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235735AbhJENx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9446023D;
        Tue,  5 Oct 2021 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441897;
        bh=LjyaNBioHQI0wflgWcjTsgXGj6lchXDXS+9YPalogTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HG089bnRIU4sW2I47IeHPEaP4OysyTsR7ZsDIg4+4EnPnWp11fcGD630UrXHTOpmm
         yOKPH1iRzuAruZ4VX3iXDMBzpvNzTrJuyaIQimeaBIl2jPJN8QFPznsDxdN8XDtMYQ
         0rqRYyz5RWztJqy6hm5nhXGjjc1IyevgmdWyVW0ohrlDm7A1idps+eh1+FNBUdFNsM
         Zxqevhbrw1CYL33XwqOyCfk/HbNCejTY9tJXF/Af+IzzamsPy7FjHIJbLi41Vc7Y5y
         HggicqOWEan6ol9jng08KLIjZAy5eZ0gUzrzuPaR5FGgFDSpmXLwaZfdgSqrUVlPCx
         m2OTfYbSUc/3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Wyman <bjwyman@gmail.com>,
        Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 40/40] hwmon: (pmbus/ibm-cffps) max_power_out swap changes
Date:   Tue,  5 Oct 2021 09:50:19 -0400
Message-Id: <20211005135020.214291-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Wyman <bjwyman@gmail.com>

[ Upstream commit f067d5585cda2de1e47dde914a8a4f151659e0ad ]

The bytes for max_power_out from the ibm-cffps devices differ in byte
order for some power supplies.

The Witherspoon power supply returns the bytes in MSB/LSB order.

The Rainier power supply returns the bytes in LSB/MSB order.

The Witherspoon power supply uses version cffps1. The Rainier power
supply should use version cffps2. If version is cffps1, swap the bytes
before output to max_power_out.

Tested:
    Witherspoon before: 3148. Witherspoon after: 3148.
    Rainier before: 53255. Rainier after: 2000.

Signed-off-by: Brandon Wyman <bjwyman@gmail.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210928205051.1222815-1-bjwyman@gmail.com
[groeck: Replaced yoda programming]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ibm-cffps.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/ibm-cffps.c b/drivers/hwmon/pmbus/ibm-cffps.c
index df712ce4b164..53f7d1418bc9 100644
--- a/drivers/hwmon/pmbus/ibm-cffps.c
+++ b/drivers/hwmon/pmbus/ibm-cffps.c
@@ -171,8 +171,14 @@ static ssize_t ibm_cffps_debugfs_read(struct file *file, char __user *buf,
 		cmd = CFFPS_SN_CMD;
 		break;
 	case CFFPS_DEBUGFS_MAX_POWER_OUT:
-		rc = i2c_smbus_read_word_swapped(psu->client,
-						 CFFPS_MAX_POWER_OUT_CMD);
+		if (psu->version == cffps1) {
+			rc = i2c_smbus_read_word_swapped(psu->client,
+					CFFPS_MAX_POWER_OUT_CMD);
+		} else {
+			rc = i2c_smbus_read_word_data(psu->client,
+					CFFPS_MAX_POWER_OUT_CMD);
+		}
+
 		if (rc < 0)
 			return rc;
 
-- 
2.33.0

