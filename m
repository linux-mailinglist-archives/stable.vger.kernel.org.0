Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4F9451E49
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhKPAfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344769AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D1161ABD;
        Mon, 15 Nov 2021 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003034;
        bh=0FheslEMrfGSQyN7MCA88IHJ6w+86BGSAvBCsVviE9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01+sBSqqFMydCARDynM5yunePwJn4SLOzRQYADHTH4VEuTz+k7OFQr3Z62XmoquP+
         LSmHEE5+umgtBjcwhveu5EBwagCkbDBjAh33bVCjq06ihPizCPCZHAQe3W3XGN3+p1
         Kma+45CUatXZKxtYSvkMeE6kNes+us1omcmXmlOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 787/917] block/ataflop: add registration bool before calling del_gendisk()
Date:   Mon, 15 Nov 2021 18:04:42 +0100
Message-Id: <20211115165455.648788075@linuxfoundation.org>
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
index 1a908455ff96f..55f6d6f6dbd34 100644
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
@@ -2021,8 +2022,10 @@ static void ataflop_probe(dev_t dev)
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
@@ -2086,6 +2089,7 @@ static int __init atari_floppy_init (void)
 		unit[i].track = -1;
 		unit[i].flags = 0;
 		add_disk(unit[i].disk[0]);
+		unit[i].registered[0] = true;
 	}
 
 	printk(KERN_INFO "Atari floppy driver: max. %cD, %strack buffering\n",
@@ -2154,7 +2158,8 @@ static void __exit atari_floppy_exit(void)
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



