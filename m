Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8614C6DEFAB
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjDLIww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjDLIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8983CA5C5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F14631A4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95935C433EF;
        Wed, 12 Apr 2023 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289540;
        bh=W+Vjlm2iY0I/9rDEX9/aNsvHrOsLd5xaqaAFZVmLpBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX5EeqfHainBgZ6g+IG1JKE0jYy2jwfUDvx/VzXINwHe82PGSI1d1eszb2MQKCSTe
         urzkIFhwOd1pbxzhQ9AYZ1X5esknto/m6ubLe9FLh3Z2By7PvLZWR0r9mhBKIH5rz1
         gch+kNsonWW/2gliK3P13F8roKQKWK/1IuUfXBk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Ming Lei <ming.lei@redhat.com>, Yu Kuai <yukuai3@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 138/173] block: dont set GD_NEED_PART_SCAN if scan partition failed
Date:   Wed, 12 Apr 2023 10:34:24 +0200
Message-Id: <20230412082843.689956796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 3723091ea1884d599cc8b8bf719d6f42e8d4d8b1 ]

Currently if disk_scan_partitions() failed, GD_NEED_PART_SCAN will still
set, and partition scan will be proceed again when blkdev_get_by_dev()
is called. However, this will cause a problem that re-assemble partitioned
raid device will creat partition for underlying disk.

Test procedure:

mdadm -CR /dev/md0 -l 1 -n 2 /dev/sda /dev/sdb -e 1.0
sgdisk -n 0:0:+100MiB /dev/md0
blockdev --rereadpt /dev/sda
blockdev --rereadpt /dev/sdb
mdadm -S /dev/md0
mdadm -A /dev/md0 /dev/sda /dev/sdb

Test result: underlying disk partition and raid partition can be
observed at the same time

Note that this can still happen in come corner cases that
GD_NEED_PART_SCAN can be set for underlying disk while re-assemble raid
device.

Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9c4c9aa559ab8..7082032636035 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -368,7 +368,6 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 	if (disk->open_partitions)
 		return -EBUSY;
 
-	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	/*
 	 * If the device is opened exclusively by current thread already, it's
 	 * safe to scan partitons, otherwise, use bd_prepare_to_claim() to
@@ -381,12 +380,19 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 			return ret;
 	}
 
+	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	bdev = blkdev_get_by_dev(disk_devt(disk), mode & ~FMODE_EXCL, NULL);
 	if (IS_ERR(bdev))
 		ret =  PTR_ERR(bdev);
 	else
 		blkdev_put(bdev, mode & ~FMODE_EXCL);
 
+	/*
+	 * If blkdev_get_by_dev() failed early, GD_NEED_PART_SCAN is still set,
+	 * and this will cause that re-assemble partitioned raid device will
+	 * creat partition for underlying disk.
+	 */
+	clear_bit(GD_NEED_PART_SCAN, &disk->state);
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(disk->part0, disk_scan_partitions);
 	return ret;
-- 
2.39.2



