Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01FA10655D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKVGX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbfKVFvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098112071C;
        Fri, 22 Nov 2019 05:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401894;
        bh=/lcAWHBkLChrSM0oXx4xjHts2xF9XpAEnOD+MzhiIF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRJGC0KenVClaPwYJX6lxBwzkXYrlorIWGUeqTeI+wLJBqAeUBBYZdMz0nZtT1lA3
         FeU/jXx+NlHs051SDJAOnZ4NpicQpGQg+n4cz0ypoI8dpph4HRU9Jgz+g7aiNejGDo
         akLr8kf0VV9Vjwuoc5DvTj+ekqOms1HjsAPCL7NU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 127/219] drbd: do not block when adjusting "disk-options" while IO is frozen
Date:   Fri, 22 Nov 2019 00:47:39 -0500
Message-Id: <20191122054911.1750-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

[ Upstream commit f708bd08ecbdc23d03aaedf5b3311ebe44cfdb50 ]

"suspending" IO is overloaded.
It can mean "do not allow new requests" (obviously),
but it also may mean "must not complete pending IO",
for example while the fencing handlers do their arbitration.

When adjusting disk options, we suspend io (disallow new requests), then
wait for the activity-log to become unused (drain all IO completions),
and possibly replace it with a new activity log of different size.

If the other "suspend IO" aspect is active, pending IO completions won't
happen, and we would block forever (unkillable drbdsetup process).

Fix this by skipping the activity log adjustment if the "al-extents"
setting did not change. Also, in case it did change, fail early without
blocking if it looks like we would block forever.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl.c | 37 ++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3366c1a91ee00..5b15ffd0c7f57 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1515,6 +1515,30 @@ static void sanitize_disk_conf(struct drbd_device *device, struct disk_conf *dis
 	}
 }
 
+static int disk_opts_check_al_size(struct drbd_device *device, struct disk_conf *dc)
+{
+	int err = -EBUSY;
+
+	if (device->act_log &&
+	    device->act_log->nr_elements == dc->al_extents)
+		return 0;
+
+	drbd_suspend_io(device);
+	/* If IO completion is currently blocked, we would likely wait
+	 * "forever" for the activity log to become unused. So we don't. */
+	if (atomic_read(&device->ap_bio_cnt))
+		goto out;
+
+	wait_event(device->al_wait, lc_try_lock(device->act_log));
+	drbd_al_shrink(device);
+	err = drbd_check_al_size(device, dc);
+	lc_unlock(device->act_log);
+	wake_up(&device->al_wait);
+out:
+	drbd_resume_io(device);
+	return err;
+}
+
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_config_context adm_ctx;
@@ -1577,15 +1601,12 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	drbd_suspend_io(device);
-	wait_event(device->al_wait, lc_try_lock(device->act_log));
-	drbd_al_shrink(device);
-	err = drbd_check_al_size(device, new_disk_conf);
-	lc_unlock(device->act_log);
-	wake_up(&device->al_wait);
-	drbd_resume_io(device);
-
+	err = disk_opts_check_al_size(device, new_disk_conf);
 	if (err) {
+		/* Could be just "busy". Ignore?
+		 * Introduce dedicated error code? */
+		drbd_msg_put_info(adm_ctx.reply_skb,
+			"Try again without changing current al-extents setting");
 		retcode = ERR_NOMEM;
 		goto fail_unlock;
 	}
-- 
2.20.1

