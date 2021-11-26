Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B4645E636
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357880AbhKZCuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347140AbhKZCqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:46:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 543AD61360;
        Fri, 26 Nov 2021 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894208;
        bh=N0rQCeL0XvL1EkFMKTp3WwvJePTceoLtNUNCB+7eYFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5y0Sn+JssiVvaBs+NI8xJJ9P453XMC3oN2Mjr7RK8JlKc+YKL0s+zYC3sBRWKTZV
         AP5rwg8eVYXBzfvDRDpIpCOg1wD4UpGt/5u5ViKHgGJM7+IyMPP/n2+9uuxrJ43YsD
         mM+NwtV9VE2ULQ1wQ0megZu9dykjBEqsQJI0jSfabwnwLWJeSGFEkE2gkqccJ98yxb
         kiY9B9vCq3U08fiCWogVzJ9qiaGVvaHzHwQJqK5g3rsxsOoEmh6LF/FYS+wcg1iUP3
         XhdStAltCuyNphkCZU2Gj1FELN4Rvw4o0PP8ABhj45Etc0y4hviJ2IN7GJ4k7J1lWQ
         j+fdgVaKN3ojA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/8] thermal: core: Reset previous low and high trip during thermal zone init
Date:   Thu, 25 Nov 2021 21:36:36 -0500
Message-Id: <20211126023640.443271-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023640.443271-1-sashal@kernel.org>
References: <20211126023640.443271-1-sashal@kernel.org>
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
index 4c2dc3a59eb59..5ef30ba3b73a4 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -601,6 +601,8 @@ static void thermal_zone_device_init(struct thermal_zone_device *tz)
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

