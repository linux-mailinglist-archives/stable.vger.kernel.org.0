Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC02E17A0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgLWCRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbgLWCRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A83E22573;
        Wed, 23 Dec 2020 02:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689798;
        bh=DFA8yvXDvlr9DriokenqSfbwCOUW9PqyFErhvt3WaCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dF06B5dOHN7v89ERnn2qusXiA9ph02qcRqf+KSEsYu766DEQHhwa5iOYHCd6X20vC
         pP7jhr5ZiDeHaow++y4DfZjgsFcb7Ltj73c9Lz5gMrFRinrCzH+ga1dZ01pF4/Mv4B
         a4krsAMY3sRF+YhDbIqXRCGwUPCUiDswvJpLcrrNH1bw6jAZRuU67Q6iH7wEwO92Ff
         H/+55TSXSOszr+CPF9c1e3NJUH3hgO/Alxw2vycujLVOowL9qE/gZeb3zXeb5O1G54
         dkcpYy0VBBmtuSFP6XgLMhKqPkYnYylfKTj98bnS0Hi+WdMkdR+WGmsdzb/+PWuacq
         3sHn+zRhVXNUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 009/217] HID: hid-input: occasionally report stylus battery even if not changed
Date:   Tue, 22 Dec 2020 21:12:58 -0500
Message-Id: <20201223021626.2790791-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 4dca113924593..f797659cb9d91 100644
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
index 58684657960bf..b079146850e6e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -585,6 +585,7 @@ struct hid_device {							/* device report descriptor */
 	__s32 battery_report_id;
 	enum hid_battery_status battery_status;
 	bool battery_avoid_query;
+	ktime_t battery_ratelimit_time;
 #endif
 
 	unsigned long status;						/* see STAT flags above */
-- 
2.27.0

