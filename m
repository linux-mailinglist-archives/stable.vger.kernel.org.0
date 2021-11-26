Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287A445E5F5
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358345AbhKZCqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358051AbhKZCoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:44:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32566128B;
        Fri, 26 Nov 2021 02:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894149;
        bh=D6YlDbXDV9QyhA7hVPbR93FDDp0n1BRxJDJz+Qb9WJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=repj6+Xtr9BL4+rYRPcBVEjG/5sy4kj+KFssG4aHd4OKVAcFStVOI933K2wwtT6e2
         nKfncWO2JjiN6AUO8FJN608xYfh8zA0FKjndNj25MryUk0EMhdEj1Kis+XpIiQQGzY
         vKOWyBgQ9cETIpzOilEWrU0MR/9slPxQSElEjGzOb1Y1vFfYadgDADAKWMS6L1mMtO
         K6oCOu4bamb/GdEEID90LaZPxxa7ZT105IQxL2eBrWXOkO+UdMUxYowIVzQ57wuLax
         C4KBqzhyOaEOSMJF5qP2KrLOZIjsyhVWC14byIy4jHTeh/GHfNJ2TaqKjsQ3jHlc84
         aXnHK6rULNGFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/15] thermal: core: Reset previous low and high trip during thermal zone init
Date:   Thu, 25 Nov 2021 21:35:27 -0500
Message-Id: <20211126023533.442895-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023533.442895-1-sashal@kernel.org>
References: <20211126023533.442895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>

[ Upstream commit 99b63316c39988039965693f5f43d8b4ccb1c86c ]

During the suspend is in process, thermal_zone_device_update bails out
thermal zone re-evaluation for any sensor trip violation without
setting next valid trip to that sensor. It assumes during resume
it will re-evaluate same thermal zone and update trip. But when it is
in suspend temperature goes down and on resume path while updating
thermal zone if temperature is less than previously violated trip,
thermal zone set trip function evaluates the same previous high and
previous low trip as new high and low trip. Since there is no change
in high/low trip, it bails out from thermal zone set trip API without
setting any trip. It leads to a case where sensor high trip or low
trip is disabled forever even though thermal zone has a valid high
or low trip.

During thermal zone device init, reset thermal zone previous high
and low trip. It resolves above mentioned scenario.

Signed-off-by: Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index ae60599c462b9..6c7825c581b5f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -454,6 +454,8 @@ static void thermal_zone_device_init(struct thermal_zone_device *tz)
 {
 	struct thermal_instance *pos;
 	tz->temperature = THERMAL_TEMP_INVALID;
+	tz->prev_low_trip = -INT_MAX;
+	tz->prev_high_trip = INT_MAX;
 	list_for_each_entry(pos, &tz->thermal_instances, tz_node)
 		pos->initialized = false;
 }
-- 
2.33.0

