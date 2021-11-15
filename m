Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1717450E91
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhKOSQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240637AbhKOSLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B5DA633BD;
        Mon, 15 Nov 2021 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998449;
        bh=P0d2m5FFg/r22weIH39KJYBBCnwHaglm6q+j2jIKp00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNfYXp+WCm67j/QWciReDHrKg+/BJLcCYViYBHU4xPsCI/SqSZkSjBNkCoY7ezmWF
         XWdFRHLj7XBdgm1umPBieRqgZtxP4R+NjUDhLq/jstRLkmTKmwQwBdFAr0mUympHCO
         r0V969XSHMvmJ8qtZmSGYfOMCbd4ZslUAIQ9T19U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 514/575] block/ataflop: add registration bool before calling del_gendisk()
Date:   Mon, 15 Nov 2021 18:03:59 +0100
Message-Id: <20211115165401.456152953@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 573effb298011d3fcabc9b12025cf637f8a07911 ]

The ataflop assumes del_gendisk() is safe to call, this is only
true because add_disk() does not return a failure, but that will
change soon. And so, before we get to adding error handling for
that case, let's make sure we keep track of which disks actually
get registered. Then we use this to only call del_gendisk for them.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-13-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 359417a016e43..c8a999086060f 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -298,6 +298,7 @@ static struct atari_floppy_struct {
 				   disk change detection) */
 	int flags;		/* flags */
 	struct gendisk *disk[NUM_DISK_MINORS];
+	bool registered[NUM_DISK_MINORS];
 	int ref;
 	int type;
 	struct blk_mq_tag_set tag_set;
@@ -2026,8 +2027,10 @@ static void ataflop_probe(dev_t dev)
 		return;
 	mutex_lock(&ataflop_probe_lock);
 	if (!unit[drive].disk[type]) {
-		if (ataflop_alloc_disk(drive, type) == 0)
+		if (ataflop_alloc_disk(drive, type) == 0) {
 			add_disk(unit[drive].disk[type]);
+			unit[drive].registered[type] = true;
+		}
 	}
 	mutex_unlock(&ataflop_probe_lock);
 }
@@ -2091,6 +2094,7 @@ static int __init atari_floppy_init (void)
 		unit[i].track = -1;
 		unit[i].flags = 0;
 		add_disk(unit[i].disk[0]);
+		unit[i].registered[0] = true;
 	}
 
 	printk(KERN_INFO "Atari floppy driver: max. %cD, %strack buffering\n",
@@ -2159,7 +2163,8 @@ static void __exit atari_floppy_exit(void)
 		for (type = 0; type < NUM_DISK_MINORS; type++) {
 			if (!unit[i].disk[type])
 				continue;
-			del_gendisk(unit[i].disk[type]);
+			if (unit[i].registered[type])
+				del_gendisk(unit[i].disk[type]);
 			blk_cleanup_disk(unit[i].disk[type]);
 		}
 		blk_mq_free_tag_set(&unit[i].tag_set);
-- 
2.33.0



