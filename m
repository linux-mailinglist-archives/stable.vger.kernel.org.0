Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774BB2E171B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgLWDFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgLWCTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42B40229C5;
        Wed, 23 Dec 2020 02:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689898;
        bh=xr+1SLuzJCgsYIl4xbn8lQXyhC0ITuyAxJQRQWyyD3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbGQrgZYg/DbHsaTWQV+LRzMB9koHP3aA5WLV7f5qt7iY5Au/drm91UB/3svmKAWK
         poSeLwDuG+bJ7a2830PuuX0Id/Kg7s6ljglRDFSlhwgUaQB5wMiHMLP3Xr5xd6Erx+
         SMhDAjmG/skMcFD0RU6Q+1F1ZLIuJDtECcDjatQjTsJ4UI+8Kb13782DTWdeklJ7M/
         tYPswhzVsm4qn6q2zRalYpAcHXIPvSpLhFUuWcdnFXHWKCkuLhvnlNuWJuCZDwAozf
         veVApccleYAqBkDTRQD4t+EdhBNfQ/ACIddBIHGIm+xz9sV8nU6bajZAjNWuCoxpB6
         PqNNvGdIDnu7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 004/130] HID: hid-input: occasionally report stylus battery even if not changed
Date:   Tue, 22 Dec 2020 21:16:07 -0500
Message-Id: <20201223021813.2791612-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>

[ Upstream commit c6838eeef2fbc7e3e1f83759aa016ae6b70c643e ]

There are styluses that only report their battery status when they are
touching the touchscreen; additionally we currently suppress battery
reports if capacity has not changed. To help userspace recognize how long
ago the device reported battery status, let's send the change event through
if either capacity has changed, or at least 30 seconds have passed since
last report we've let through.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 5 ++++-
 include/linux/hid.h     | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b2da8476d0d30..54ac835b72357 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -537,9 +537,12 @@ static void hidinput_update_battery(struct hid_device *dev, int value)
 	capacity = hidinput_scale_battery_capacity(dev, value);
 
 	if (dev->battery_status != HID_BATTERY_REPORTED ||
-	    capacity != dev->battery_capacity) {
+	    capacity != dev->battery_capacity ||
+	    ktime_after(ktime_get_coarse(), dev->battery_ratelimit_time)) {
 		dev->battery_capacity = capacity;
 		dev->battery_status = HID_BATTERY_REPORTED;
+		dev->battery_ratelimit_time =
+			ktime_add_ms(ktime_get_coarse(), 30 * 1000);
 		power_supply_changed(dev->battery);
 	}
 }
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c7044a14200ea..b05f194f30db0 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -583,6 +583,7 @@ struct hid_device {							/* device report descriptor */
 	__s32 battery_report_id;
 	enum hid_battery_status battery_status;
 	bool battery_avoid_query;
+	ktime_t battery_ratelimit_time;
 #endif
 
 	unsigned long status;						/* see STAT flags above */
-- 
2.27.0

