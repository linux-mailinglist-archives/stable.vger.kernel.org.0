Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C5534C80A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhC2IT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232748AbhC2ISn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6ABC61932;
        Mon, 29 Mar 2021 08:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005923;
        bh=BST6BERa959iMhTwUiAolYvYPSiDPLKLUM2upjFG3ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krfCfn8Zu3v7U25SeEXfQGxLsSDTd3P/ZhIPb9hdwlvbpmlylxLEPobiljzNOOtYt
         7toYU7YgxTRTPfw1+ecdOC96o/BUkzpwj7ITrIgsckfrevSYEfHmqp22oYhZ18npDf
         boIPycWpCZRkKvb8x4PvBS0L6nTb/rhf4AUuI+kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Martin Wilck <mwilck@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/221] block: Suppress uevent for hidden device when removed
Date:   Mon, 29 Mar 2021 09:56:24 +0200
Message-Id: <20210329075630.953928489@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index ec6264e2ed67..796baf761202 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -732,10 +732,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
-	if (disk->flags & GENHD_FL_HIDDEN) {
-		dev_set_uevent_suppress(ddev, 0);
+	if (disk->flags & GENHD_FL_HIDDEN)
 		return;
-	}
 
 	disk_scan_partitions(disk);
 
-- 
2.30.1



