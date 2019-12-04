Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006201132D6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfLDSMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731594AbfLDSMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:21 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A188120675;
        Wed,  4 Dec 2019 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483140;
        bh=LHiUdUHDdThUMjt+1McqXD4GQsQ6DLH4P+4atOmQcvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpsjrKXQCYUM6ddudViiuisxB3TRHvsHAbN1EWrIzuPVqQyFa9/rPadLX12rgbYYM
         ++EbmwfPOD60axc4gCKzbWRWh+fNFd+GiRW0H8V6ZoWfHhw+hy4x/gJXOoD/UBdnP6
         obk0/a2iyMEdTtjKLtwfqRQBXgPfdg1K2qrkBjHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/125] drbd: do not block when adjusting "disk-options" while IO is frozen
Date:   Wed,  4 Dec 2019 18:56:12 +0100
Message-Id: <20191204175323.049531441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
index ff26f676f24d1..b809f325c2bea 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1508,6 +1508,30 @@ static void sanitize_disk_conf(struct drbd_device *device, struct disk_conf *dis
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
@@ -1570,15 +1594,12 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
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



