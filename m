Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6133E475
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhCQA74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhCQA7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD3164F94;
        Wed, 17 Mar 2021 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942726;
        bh=m05uKoHPXx4Jy8SfL08GslsTqZbcXfvyQiP0aGQwkLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTfY/izRnH8OU+vEtRU/DXUg0qu94CdrZhobwWGsQzfWbjl9YXE6+UaoRHOPOv/wy
         rRIkonjJMCZ3/xpkIAQxGlOVeZhTYt+bbS+660wAvJf+7p9n3ObjKB13q/MjBPRBbn
         hXn/y3yn/KOhLYnbhSm7ltZ0CGmLoBpQqDHpLdB6qjSGlD4RYzBnqV4gX3EqNUJd2a
         k9Qcvk2pP16Z9KIW6Y3U0nBn+vo8tXBrxdkiy72lYzX2wQ6hsDHGmDOBkjMjFvM6Y/
         iey980ZCRD8cWFv7UIewkgTL6fd7TJ9pajGdqY8ZvLGx4YUzYFHPgAjuloEGa9opR/
         lrRFZ0upCaH/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Christoph Hellwig <hch@lst.de>,
        Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/37] block: Suppress uevent for hidden device when removed
Date:   Tue, 16 Mar 2021 20:58:00 -0400
Message-Id: <20210317005802.725825-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 9ec491447b90ad6a4056a9656b13f0b3a1e83043 ]

register_disk() suppress uevents for devices with the GENHD_FL_HIDDEN
but enables uevents at the end again in order to announce disk after
possible partitions are created.

When the device is removed the uevents are still on and user land sees
'remove' messages for devices which were never 'add'ed to the system.

  KERNEL[95481.571887] remove   /devices/virtual/nvme-fabrics/ctl/nvme5/nvme0c5n1 (block)

Let's suppress the uevents for GENHD_FL_HIDDEN by not enabling the
uevents at all.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20210311151917.136091-1-dwagner@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 604f0a2cbc9a..2f6f341a8fbb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -637,10 +637,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
-	if (disk->flags & GENHD_FL_HIDDEN) {
-		dev_set_uevent_suppress(ddev, 0);
+	if (disk->flags & GENHD_FL_HIDDEN)
 		return;
-	}
 
 	/* No minors to use for partitions */
 	if (!disk_part_scan_enabled(disk))
-- 
2.30.1

