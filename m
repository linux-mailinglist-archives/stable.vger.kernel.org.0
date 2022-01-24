Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F67499A8F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573518AbiAXVpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378443AbiAXVha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C58C05A1AD;
        Mon, 24 Jan 2022 12:23:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42605B81229;
        Mon, 24 Jan 2022 20:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DF1C340E5;
        Mon, 24 Jan 2022 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055820;
        bh=wfcsLF7GIouIju6cw/S1WOUfuc/YG6E3MeAJ34xQqVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsSmn6vQnSZrTBpIllBXkq0Ib4cv3EEMINfpjAk1eRxfWOwKLsHDLBoW4qf4fECMU
         0tWpKsk2+rT6UXcacfLy3qUPwLVr4XUAMOOTlouXzUmp0LoC4MbozFa5pNCZQzTHM+
         Xi24UyV1nVgY8qgq3kSBQl9h0ZE2TXgo9qxSIdt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+28a66a9fbc621c939000@syzkaller.appspotmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/846] block: fix error unwinding in device_add_disk
Date:   Mon, 24 Jan 2022 19:36:33 +0100
Message-Id: <20220124184110.463545039@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 99d8690aae4b2f0d1d90075de355ac087f820a66 ]

One device_add is called disk->ev will be freed by disk_release, so we
should free it twice.  Fix this by allocating disk->ev after device_add
so that the extra local unwinding can be removed entirely.

Based on an earlier patch from Tetsuo Handa.

Reported-by: syzbot <syzbot+28a66a9fbc621c939000@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+28a66a9fbc621c939000@syzkaller.appspotmail.com>
Fixes: 83cbce9574462c6b ("block: add error handling for device_add_disk / add_disk")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211221161851.788424-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index f091a60dcf1ea..22f899615801c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -432,10 +432,6 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 		disk->flags |= GENHD_FL_EXT_DEVT;
 	}
 
-	ret = disk_alloc_events(disk);
-	if (ret)
-		goto out_free_ext_minor;
-
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
@@ -446,7 +442,12 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 		ddev->devt = MKDEV(disk->major, disk->first_minor);
 	ret = device_add(ddev);
 	if (ret)
-		goto out_disk_release_events;
+		goto out_free_ext_minor;
+
+	ret = disk_alloc_events(disk);
+	if (ret)
+		goto out_device_del;
+
 	if (!sysfs_deprecated) {
 		ret = sysfs_create_link(block_depr, &ddev->kobj,
 					kobject_name(&ddev->kobj));
@@ -534,8 +535,6 @@ out_del_block_link:
 		sysfs_remove_link(block_depr, dev_name(ddev));
 out_device_del:
 	device_del(ddev);
-out_disk_release_events:
-	disk_release_events(disk);
 out_free_ext_minor:
 	if (disk->major == BLOCK_EXT_MAJOR)
 		blk_free_ext_minor(disk->first_minor);
-- 
2.34.1



