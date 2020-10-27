Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009D0299D41
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437661AbgJ0AE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437659AbgJ0AE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDBB521D41;
        Tue, 27 Oct 2020 00:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757068;
        bh=51UMmBnBu7Ghhm3L7W/0GCc23i020ELjSf564S9sYKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+zhycjh9wChcbeM2+yDK66ydVoxhC+04neTmwV+WhMyS6qwLFNPhhSuZ5/IUDI15
         +Mx+m5ZiKEuBy42ronq5VNwcqqSHmckaaoNqoiUD0QEYTekZN48cfxv6RqjbkHy4EM
         +WgWPdA4hfuQ9GScKQ0MVTlL6i4WwBzGlsLzdcK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/60] power: supply: bq27xxx: report "not charging" on all types
Date:   Mon, 26 Oct 2020 20:03:25 -0400
Message-Id: <20201027000415.1026364-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
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
index ff02a917556a9..93e3d9c747aa0 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1680,8 +1680,6 @@ static int bq27xxx_battery_status(struct bq27xxx_device_info *di,
 			status = POWER_SUPPLY_STATUS_FULL;
 		else if (di->cache.flags & BQ27000_FLAG_CHGS)
 			status = POWER_SUPPLY_STATUS_CHARGING;
-		else if (power_supply_am_i_supplied(di->bat) > 0)
-			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
 	} else {
@@ -1693,6 +1691,10 @@ static int bq27xxx_battery_status(struct bq27xxx_device_info *di,
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

