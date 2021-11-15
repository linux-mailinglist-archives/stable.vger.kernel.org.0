Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C039450E8F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhKOSQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240641AbhKOSLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 192DE633C2;
        Mon, 15 Nov 2021 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998454;
        bh=hRgGveg67O4YaQdaBJBoise6YYevgIu8X342+sr0c6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5Ry6F4KxbcYMX6MsTqZ46d6plKaL2ts8TFJOHipfGCe5qoL1VXIWNN2OmCvU5niw
         2Q+5sKQ4HPTFOdQhS3t1gOM7bifIKQ6N/Q1xifQNQ5F/bi9/HMV2YJZF2s4XAcrSO9
         Df7ofwedP8xmIKxYLsRlWPPkQfgqIZgy4dCWavtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 516/575] ataflop: remove ataflop_probe_lock mutex
Date:   Mon, 15 Nov 2021 18:04:01 +0100
Message-Id: <20211115165401.523895690@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 4ddb85d36613c45bde00d368bf9f357bd0708a0c ]

Commit bf9c0538e485b591 ("ataflop: use a separate gendisk for each media
format") introduced ataflop_probe_lock mutex, but forgot to unlock the
mutex when atari_floppy_init() (i.e. module loading) succeeded. This will
result in double lock deadlock if ataflop_probe() is called. Also,
unregister_blkdev() must not be called from atari_floppy_init() with
ataflop_probe_lock held when atari_floppy_init() failed, for
ataflop_probe() waits for ataflop_probe_lock with major_names_lock held
(i.e. AB-BA deadlock).

__register_blkdev() needs to be called last in order to avoid calling
ataflop_probe() when atari_floppy_init() is about to fail, for memory for
completing already-started ataflop_probe() safely will be released as soon
as atari_floppy_init() released ataflop_probe_lock mutex.

As with commit 8b52d8be86d72308 ("loop: reorder loop_exit"),
unregister_blkdev() needs to be called first in order to avoid calling
ataflop_alloc_disk() from ataflop_probe() after del_gendisk() from
atari_floppy_exit().

By relocating __register_blkdev() / unregister_blkdev() as explained above,
we can remove ataflop_probe_lock mutex, for probe function and __exit
function are serialized by major_names_lock mutex.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: bf9c0538e485b591 ("ataflop: use a separate gendisk for each media format")
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Link: https://lore.kernel.org/r/20211103230437.1639990-11-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 2d3a66362dcf9..3a29f1992d971 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2016,8 +2016,6 @@ static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 	return 0;
 }
 
-static DEFINE_MUTEX(ataflop_probe_lock);
-
 static void ataflop_probe(dev_t dev)
 {
 	int drive = MINOR(dev) & 3;
@@ -2025,14 +2023,32 @@ static void ataflop_probe(dev_t dev)
 
 	if (drive >= FD_MAX_UNITS || type > NUM_DISK_MINORS)
 		return;
-	mutex_lock(&ataflop_probe_lock);
 	if (!unit[drive].disk[type]) {
 		if (ataflop_alloc_disk(drive, type) == 0) {
 			add_disk(unit[drive].disk[type]);
 			unit[drive].registered[type] = true;
 		}
 	}
-	mutex_unlock(&ataflop_probe_lock);
+}
+
+static void atari_floppy_cleanup(void)
+{
+	int i;
+	int type;
+
+	for (i = 0; i < FD_MAX_UNITS; i++) {
+		for (type = 0; type < NUM_DISK_MINORS; type++) {
+			if (!unit[i].disk[type])
+				continue;
+			del_gendisk(unit[i].disk[type]);
+			blk_cleanup_queue(unit[i].disk[type]->queue);
+			put_disk(unit[i].disk[type]);
+		}
+		blk_mq_free_tag_set(&unit[i].tag_set);
+	}
+
+	del_timer_sync(&fd_timer);
+	atari_stram_free(DMABuffer);
 }
 
 static void atari_cleanup_floppy_disk(struct atari_floppy_struct *fs)
@@ -2058,11 +2074,6 @@ static int __init atari_floppy_init (void)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
 		return -ENODEV;
 
-	mutex_lock(&ataflop_probe_lock);
-	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
-	if (ret)
-		goto out_unlock;
-
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		memset(&unit[i].tag_set, 0, sizeof(unit[i].tag_set));
 		unit[i].tag_set.ops = &ataflop_mq_ops;
@@ -2116,15 +2127,17 @@ static int __init atari_floppy_init (void)
 	       UseTrackbuffer ? "" : "no ");
 	config_types();
 
-	return 0;
+	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
+	if (ret) {
+		printk(KERN_ERR "atari_floppy_init: cannot register block device\n");
+		atari_floppy_cleanup();
+	}
+	return ret;
 
 err:
 	while (--i >= 0)
 		atari_cleanup_floppy_disk(&unit[i]);
 
-	unregister_blkdev(FLOPPY_MAJOR, "fd");
-out_unlock:
-	mutex_unlock(&ataflop_probe_lock);
 	return ret;
 }
 
@@ -2169,14 +2182,8 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i;
-
-	for (i = 0; i < FD_MAX_UNITS; i++)
-		atari_cleanup_floppy_disk(&unit[i]);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-
-	del_timer_sync(&fd_timer);
-	atari_stram_free( DMABuffer );
+	atari_floppy_cleanup();
 }
 
 module_init(atari_floppy_init)
-- 
2.33.0



