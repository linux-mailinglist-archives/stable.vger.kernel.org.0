Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38102A53AC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgKCVD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387822AbgKCVDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:03:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E38D22226;
        Tue,  3 Nov 2020 21:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437404;
        bh=Buad1p3Pd54T/Nr6y0qGXdzSJ0UaRbe76WBV4d7Jmpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6o0a4WXErAEHqCJpWa9NM/1/sTHPC7xf1Z+DmREJu9jmck4/2RCM7EUtJUQh54fp
         CKLDsJ0GupWgkPiGNTRYurUhAEWK1TptuSgFRNpjgUx2y9dbFQvNVNF0m3CxhDMSKx
         akR/Q+b21p+6heAqIl9eSZo208gZZCjxZ5SzYGiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/191] power: supply: bq27xxx: report "not charging" on all types
Date:   Tue,  3 Nov 2020 21:35:55 +0100
Message-Id: <20201103203240.510019661@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0



