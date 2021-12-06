Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A8469D5B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355818AbhLFP3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385734AbhLFPZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BFD561327;
        Mon,  6 Dec 2021 15:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C153C341C2;
        Mon,  6 Dec 2021 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804133;
        bh=JJ3YwcHOB6bMQkb4axkI40dxO53oFz6vFS8TV7o3ROY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5q8n1K3RoPE48rim0FgidnU2+O7VHS1QTiugx/bmGkKPvMZcSRF4nAZXEHDGFzID
         S34AEa9Il4jIq48qlJaMLN/fSMXWcCUTfFijppUVBmWf2nq5ayj3r1WCAOQ1unaPv3
         J29Il4wvorHI1oCwX4Q84C+sQCVCPMVv9QjBPWxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/207] thermal: core: Reset previous low and high trip during thermal zone init
Date:   Mon,  6 Dec 2021 15:54:45 +0100
Message-Id: <20211206145611.294788874@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 30134f49b037a..13891745a9719 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -419,6 +419,8 @@ static void thermal_zone_device_init(struct thermal_zone_device *tz)
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



