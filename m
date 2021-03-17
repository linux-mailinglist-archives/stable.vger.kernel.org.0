Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91BE33E3B2
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhCQA5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D56D64F8F;
        Wed, 17 Mar 2021 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942607;
        bh=gOMOVCnoTGjPjB6RH8Q4v6SnzGKeivtoZ0N8xUOMArQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGpIOq6s1Wugj//CkhjRukT4akETZJRTSh8mUBW5Pup+QGhnJbveQem120m6sBsqv
         rfgPZ0vXIxs/xFSd61WhgPYzTEkBKQXtT6xRUHNUWDNUQuig544hri5AqjIkqDhAs+
         E+Z+N+WPjIqCJ/AInu8JwQ8+S924wNaJtlPkMm30evK6vpxQI9uY1fpyvUoMOiL1uh
         E8L4CoJo/C3LfFLJ2Z+1YA/RTtvmpvNSNTIGJfZUn/Iglq7gUJ2dr8Fw/t0/dp+7c6
         8f5M54cDMFyuEMnxGCoEPgw1XJ5Z0C+GR3Lso0XL4OfLe1yDlYMc8LBF1Va2cs6yn9
         09qAoKthzX9XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Christoph Hellwig <hch@lst.de>,
        Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 57/61] block: Suppress uevent for hidden device when removed
Date:   Tue, 16 Mar 2021 20:55:31 -0400
Message-Id: <20210317005536.724046-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 07a0ef741de1..12940cfa68af 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -658,10 +658,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 		kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
-	if (disk->flags & GENHD_FL_HIDDEN) {
-		dev_set_uevent_suppress(ddev, 0);
+	if (disk->flags & GENHD_FL_HIDDEN)
 		return;
-	}
 
 	disk_scan_partitions(disk);
 
-- 
2.30.1

