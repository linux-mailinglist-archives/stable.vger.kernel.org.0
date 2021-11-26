Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9D45E5BD
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357893AbhKZCob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345381AbhKZCmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5F861153;
        Fri, 26 Nov 2021 02:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894109;
        bh=tB//n0tYS1KCTrFcXku2NlsdtCOW+4IRGkpsk+eUch8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTCbW05ZDc7hw3lDKLO9ypjpJi2FMYdKl7IfoxZEHmou8ulnRWOv7DXi2JI3XZfvj
         mC3tLNdP0moGvS3z5629v+MXlIMbumqYCLXxrPLCO0zOmcU2oe9okn//Yiwiqdp9ax
         OmtpTtrc1qGUCRIPfkNvHJuNYwh+zH9l9TyQ8GhOHKHwAEvHbQAjZ4OCb9rOMzAkWn
         PNout+xtYCFbAdxH2XtnKqeCWdltA0SnwxBDx9WQrgFD6zxB4vgKSoUI70tIEYAb3R
         IfWjQqSHqKDsNEgV4P8fK87rwdcP8xCPJePK9mdMlACxntwia1fzzsrEKZjJelQqg+
         MAIN+R6i6YHRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/19] thermal: core: Reset previous low and high trip during thermal zone init
Date:   Thu, 25 Nov 2021 21:34:41 -0500
Message-Id: <20211126023448.442529-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index 20eab56b02cb9..f4490b8120176 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -460,6 +460,8 @@ static void thermal_zone_device_init(struct thermal_zone_device *tz)
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

