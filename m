Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D67642864
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 13:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLEM0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 07:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiLEM0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 07:26:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFEECE9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 04:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670243115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0/lPTp7lVynVMq0c+szAs3DzdDpFpUGy1TPnJKo1ThQ=;
        b=fUamYoCBLIu79zjfInTEe0LU9EGUsglPTyFWXxsIDcODdbJl/afO2zRkTOxez9tHKzxtJZ
        1GugukhcwcuEh15Fpu9C8D1KhVfqsSSXJu0TuUvyQumog5lHNGcH+oX4l0Ey+BBoEnw6Pr
        aWjST/H8ZqVN+P6+FI9v4HnMDwipuqw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-7cvNzi1OPOGPRWe7RCbykQ-1; Mon, 05 Dec 2022 07:25:14 -0500
X-MC-Unique: 7cvNzi1OPOGPRWe7RCbykQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7F77833AEE;
        Mon,  5 Dec 2022 12:25:13 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA369492B07;
        Mon,  5 Dec 2022 12:25:12 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, cuishw@inspur.com,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10.y stable] block: unhash blkdev part inode when the part is deleted
Date:   Mon,  5 Dec 2022 20:25:02 +0800
Message-Id: <20221205122502.841896-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v5.11 changes the blkdev lookup mechanism completely since commit
22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
and small part of the change is to unhash part bdev inode when
deleting partition. Turns out this kind of change does fix one
nasty issue in case of BLOCK_EXT_MAJOR:

1) when one partition is deleted & closed, disk_put_part() is always
called before bdput(bdev), see blkdev_put(); so the part's devt can
be freed & re-used before the inode is dropped

2) then new partition with same devt can be created just before the
inode in 1) is dropped, then the old inode/bdev structurein 1) is
re-used for this new partition, this way causes use-after-free and
kernel panic.

It isn't possible to backport the whole fbig patchset of "merge struct
block_device and struct hd_struct v4" for addressing this issue.

https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/

So fixes it by unhashing part bdev in delete_partition(), and this way
is actually aligned with v5.11+'s behavior.

Reported-by: cuishw@inspur.com
Tested-by: cuishw@inspur.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/partitions/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index a02e22411594..e3d61ec4a5a6 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -329,6 +329,7 @@ void delete_partition(struct hd_struct *part)
 	struct gendisk *disk = part_to_disk(part);
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
+	struct block_device *bdev;
 
 	/*
 	 * ->part_tbl is referenced in this part's release handler, so
@@ -346,6 +347,12 @@ void delete_partition(struct hd_struct *part)
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget_part(part);
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	percpu_ref_kill(&part->ref);
 }
 
-- 
2.37.3

