Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6867E49978E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448709AbiAXVNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33854 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447083AbiAXVKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB4461451;
        Mon, 24 Jan 2022 21:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C8CC340E5;
        Mon, 24 Jan 2022 21:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058599;
        bh=xLe6OIxRf5HXXv5JzxhjAzembg+iCLkQRK2lINkvGpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdhOq8FhvLNKosgAgbk+IqRGc7ely3TkTwxfQ7sR6nfce2f6frId8naGvXnp0xYFe
         +oaVsfaXLEsHAnUVrC7+cMH+VwXZIQQLwUYjtVnU7/PRn4VDKBIfm5U/IbKWPl5h5P
         jKYiw1/AYUk95744hGzPX8N/XDGy0EazkZJBsz+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+28a66a9fbc621c939000@syzkaller.appspotmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0334/1039] block: fix error unwinding in device_add_disk
Date:   Mon, 24 Jan 2022 19:35:23 +0100
Message-Id: <20220124184136.533605897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 30362aeacac4b..596e43764846b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -437,10 +437,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		disk->flags |= GENHD_FL_EXT_DEVT;
 	}
 
-	ret = disk_alloc_events(disk);
-	if (ret)
-		goto out_free_ext_minor;
-
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
@@ -451,7 +447,12 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
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
@@ -539,8 +540,6 @@ out_del_block_link:
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



