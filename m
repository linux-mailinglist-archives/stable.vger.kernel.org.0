Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682666D490F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjDCOes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjDCOeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDB7E47
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58CFF61DE4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2CEC433EF;
        Mon,  3 Apr 2023 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532447;
        bh=Cf/o0bEiMRTLEgap42Hv0ZhNah3vV8pQgOHzcbc0JJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7zX6i32SMg2nRtqIeN9ZW5tHqoOLtMRErUmXQNXSZjfhsq+4tLYD3eOTpzh7jiTo
         Z63h1ucpsH01gHDqIhmviJSMjbLyIvzkqEUifK4SuAo7Bessl0v6FyueoDC9urgwOB
         fFo0Hb8oFc4MzaV1oqXQTzh4jV5V+8HgYTqH40bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alyssa Ross <hi@alyssa.is>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/99] loop: LOOP_CONFIGURE: send uevents for partitions
Date:   Mon,  3 Apr 2023 16:09:10 +0200
Message-Id: <20230403140405.063368378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

[ Upstream commit bb430b69422640891b0b8db762885730579a4145 ]

LOOP_CONFIGURE is, as far as I understand it, supposed to be a way to
combine LOOP_SET_FD and LOOP_SET_STATUS64 into a single syscall.  When
using LOOP_SET_FD+LOOP_SET_STATUS64, a single uevent would be sent for
each partition found on the loop device after the second ioctl(), but
when using LOOP_CONFIGURE, no such uevent was being sent.

In the old setup, uevents are disabled for LOOP_SET_FD, but not for
LOOP_SET_STATUS64.  This makes sense, as it prevents uevents being
sent for a partially configured device during LOOP_SET_FD - they're
only sent at the end of LOOP_SET_STATUS64.  But for LOOP_CONFIGURE,
uevents were disabled for the entire operation, so that final
notification was never issued.  To fix this, reduce the critical
section to exclude the loop_reread_partitions() call, which causes
the uevents to be issued, to after uevents are re-enabled, matching
the behaviour of the LOOP_SET_FD+LOOP_SET_STATUS64 combination.

I noticed this because Busybox's losetup program recently changed from
using LOOP_SET_FD+LOOP_SET_STATUS64 to LOOP_CONFIGURE, and this broke
my setup, for which I want a notification from the kernel any time a
new partition becomes available.

Signed-off-by: Alyssa Ross <hi@alyssa.is>
[hch: reduced the critical section]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: 3448914e8cc5 ("loop: Add LOOP_CONFIGURE ioctl")
Link: https://lore.kernel.org/r/20230320125430.55367-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 032862cce6e4e..c96bdb3e7ac52 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1212,9 +1212,6 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	/* This is safe, since we have a reference from open(). */
 	__module_get(THIS_MODULE);
 
-	/* suppress uevents while reconfiguring the device */
-	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
-
 	/*
 	 * If we don't hold exclusive handle for the device, upgrade to it
 	 * here to avoid changing device under exclusive owner.
@@ -1268,6 +1265,9 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		goto out_unlock;
 	}
 
+	/* suppress uevents while reconfiguring the device */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
+
 	disk_force_media_change(lo->lo_disk, DISK_EVENT_MEDIA_CHANGE);
 	set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
@@ -1316,17 +1316,17 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	if (partscan)
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
 
+	/* enable and uncork uevent now that we are done */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
 		loop_reread_partitions(lo);
+
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(bdev, loop_configure);
 
-	error = 0;
-done:
-	/* enable and uncork uevent now that we are done */
-	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
-	return error;
+	return 0;
 
 out_unlock:
 	loop_global_unlock(lo, is_loop);
@@ -1337,7 +1337,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	fput(file);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	goto done;
+	return error;
 }
 
 static int __loop_clr_fd(struct loop_device *lo, bool release)
-- 
2.39.2



