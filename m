Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2C5451ECB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347811AbhKPAhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344771AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA11B632B8;
        Mon, 15 Nov 2021 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003037;
        bh=9ux/uLZEAuYk8MyRFnem9h7Mu+F1RnHP69iMpx9Z2lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QryYknh/J0eGOCwMhZKT5LPSBthSL7vcmjIHBZuk4ntMjxcKJTIC/KhuQ0Sr3bKnp
         yQZsWvrU3OJVLIXLsIhCOQ6qPjoRodFgtVrn6eeV9l38L2zY/BKt119ETozFSjeJ0E
         2dnn1va8fW5sv3iSAMciFOaZOX0+WzpGFQJ7RcmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 788/917] block/ataflop: provide a helper for cleanup up an atari disk
Date:   Mon, 15 Nov 2021 18:04:43 +0100
Message-Id: <20211115165455.678887827@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit deae1138d04758c7f8939fcb8aee330bc37e3015 ]

Instead of using two separate code paths for cleaning up an atari disk,
use one. We take the more careful approach to check for *all* disk
types, as is done on exit. The init path didn't have that check as
the alternative disk types are only probed for later, they are not
initialized by default.

Yes, there is a shared tag for all disks.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-14-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 55f6d6f6dbd34..123ad58193098 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2030,6 +2030,20 @@ static void ataflop_probe(dev_t dev)
 	mutex_unlock(&ataflop_probe_lock);
 }
 
+static void atari_cleanup_floppy_disk(struct atari_floppy_struct *fs)
+{
+	int type;
+
+	for (type = 0; type < NUM_DISK_MINORS; type++) {
+		if (!fs->disk[type])
+			continue;
+		if (fs->registered[type])
+			del_gendisk(fs->disk[type]);
+		blk_cleanup_disk(fs->disk[type]);
+	}
+	blk_mq_free_tag_set(&fs->tag_set);
+}
+
 static int __init atari_floppy_init (void)
 {
 	int i;
@@ -2100,10 +2114,8 @@ static int __init atari_floppy_init (void)
 	return 0;
 
 err:
-	while (--i >= 0) {
-		blk_cleanup_disk(unit[i].disk[0]);
-		blk_mq_free_tag_set(&unit[i].tag_set);
-	}
+	while (--i >= 0)
+		atari_cleanup_floppy_disk(&unit[i]);
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_unlock:
@@ -2152,18 +2164,10 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i, type;
+	int i;
 
-	for (i = 0; i < FD_MAX_UNITS; i++) {
-		for (type = 0; type < NUM_DISK_MINORS; type++) {
-			if (!unit[i].disk[type])
-				continue;
-			if (unit[i].registered[type])
-				del_gendisk(unit[i].disk[type]);
-			blk_cleanup_disk(unit[i].disk[type]);
-		}
-		blk_mq_free_tag_set(&unit[i].tag_set);
-	}
+	for (i = 0; i < FD_MAX_UNITS; i++)
+		atari_cleanup_floppy_disk(&unit[i]);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
 	del_timer_sync(&fd_timer);
-- 
2.33.0



