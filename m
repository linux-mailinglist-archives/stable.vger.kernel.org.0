Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10221133FE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfLDSG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbfLDSGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:55 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6B920674;
        Wed,  4 Dec 2019 18:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482814;
        bh=yX1fRkoZa9hfgOfU+yD5L5Gfs4/CUrl+xZh79cZVmSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKcPC8qPQaV8Gk8YevIUZzyTEbWcW/MpJ5chUjm0rSuYoksuEpLqx9gAhrLf1p7YT
         l22JXpe1jEpaKRNt8T3762zykCCj1CBgDR4ewg+uJBaH+y5D6Ad3FPPOtZ9Gsfrz8v
         n6JYvtIeexmUtXH9I63MYcxFOWuv1ZTgHKgDSpDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/209] drbd: do not block when adjusting "disk-options" while IO is frozen
Date:   Wed,  4 Dec 2019 18:55:13 +0100
Message-Id: <20191204175328.815507288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a675a0f61f9c0..31d7fe4480afd 100644
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



