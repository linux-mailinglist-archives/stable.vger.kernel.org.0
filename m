Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F2434C77C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhC2IPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhC2IO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366206193A;
        Mon, 29 Mar 2021 08:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005656;
        bh=m05uKoHPXx4Jy8SfL08GslsTqZbcXfvyQiP0aGQwkLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L86Q5QT7a/0ETqsvZLG1tgX0A1x3Cbl7+C9s+/sUpyVOxeOBkn9+21I55bAEpqA5a
         URQqYiPwE4pMv3gE3Nb525xx4glf4LBx44zqEB1/ONNtzcwjac9nzzcN86ckFrQAXZ
         kOf5+77dpIzvKMjOfDeQ6FL2HLvvdKKDyZE3woo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Martin Wilck <mwilck@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/111] block: Suppress uevent for hidden device when removed
Date:   Mon, 29 Mar 2021 09:57:44 +0200
Message-Id: <20210329075616.378702990@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



