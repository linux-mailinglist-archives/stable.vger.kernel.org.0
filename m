Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E165299B39
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408777AbgJZXtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408767AbgJZXtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB7121D41;
        Mon, 26 Oct 2020 23:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756178;
        bh=ftelrFd5qq8bj6IxDaG8EjWQWBM3xxSpIdhhPwUR07o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmR5fTgLTZGZ/lTk6tb15HoxURTN1ngKmh8QhU+CgYTBhWhXzGvp+H4awZ9bFiNFR
         2oeGIWZMbdLfjS5TEiW50Dc1TMms57lAFYkeFxk/Rax+xPGbGQZufa+lCUNqz3LZTT
         +79Wqzggn6vtZWQJlZCw06edscHOyCEp4D/X0Deo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 026/147] power: supply: bq27xxx: report "not charging" on all types
Date:   Mon, 26 Oct 2020 19:47:04 -0400
Message-Id: <20201026234905.1022767-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7bf738ba110722b63e9dc8af760d3fb2aef25593 ]

Commit 6f24ff97e323 ("power: supply: bq27xxx_battery: Add the
BQ27Z561 Battery monitor") and commit d74534c27775 ("power:
bq27xxx_battery: Add support for additional bq27xxx family devices")
added support for new device types by copying most of the code and
adding necessary quirks.

However they did not copy the code in bq27xxx_battery_status()
responsible for returning POWER_SUPPLY_STATUS_NOT_CHARGING.

Unify the bq27xxx_battery_status() so for all types when charger is
supplied, it will return "not charging" status.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index a123f6e21f08a..08b9d025a3e81 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1772,8 +1772,6 @@ static int bq27xxx_battery_status(struct bq27xxx_device_info *di,
 			status = POWER_SUPPLY_STATUS_FULL;
 		else if (di->cache.flags & BQ27000_FLAG_CHGS)
 			status = POWER_SUPPLY_STATUS_CHARGING;
-		else if (power_supply_am_i_supplied(di->bat) > 0)
-			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
 	} else if (di->opts & BQ27Z561_O_BITS) {
@@ -1792,6 +1790,10 @@ static int bq27xxx_battery_status(struct bq27xxx_device_info *di,
 			status = POWER_SUPPLY_STATUS_CHARGING;
 	}
 
+	if ((status == POWER_SUPPLY_STATUS_DISCHARGING) &&
+	    (power_supply_am_i_supplied(di->bat) > 0))
+		status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+
 	val->intval = status;
 
 	return 0;
-- 
2.25.1

