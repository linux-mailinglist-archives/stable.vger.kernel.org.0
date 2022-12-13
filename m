Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3A64B045
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiLMHRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiLMHRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:17:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED782BE20
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670915779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vL1aI2CeOT2r881YEwZLig2j6p/IN/XBuBuLam0vSKY=;
        b=ZSu8tyPcnSJwtZ2eukfpfnGvweWMAEj53M4uDNmCyyiLObaBe3qBYkZI4+WG3VZi8lQijx
        YZJi6OPYqNuwxB7UbjMZIangFLYQ9DpVb42r7wYiB1fhARBVKtTXax73SZQAtQeXuqnPVp
        rZMtfafFRlWtqgGUoUloSC75Ad4FMzw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-DlzHVZQ8OAKMsvuoGye0rA-1; Tue, 13 Dec 2022 02:16:15 -0500
X-MC-Unique: DlzHVZQ8OAKMsvuoGye0rA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 377BE85A588;
        Tue, 13 Dec 2022 07:16:15 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F73953AA;
        Tue, 13 Dec 2022 07:16:13 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Shiwei Cui <cuishw@inspur.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH stable 5.4.y/4.19.y] block: unhash blkdev part inode when the part is deleted
Date:   Tue, 13 Dec 2022 15:16:03 +0800
Message-Id: <20221213071603.1197703-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

It isn't possible to backport the whole big patchset of "merge struct
block_device and struct hd_struct v4" for addressing this issue.

https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/

So fixes it by unhashing part bdev in delete_partition(), and this way
is actually aligned with v5.11+'s behavior.

Backported from the following 5.10.y commit:

5f2f77560591 ("block: unhash blkdev part inode when the part is deleted")

Reported-by: Shiwei Cui <cuishw@inspur.com>
Tested-by: Shiwei Cui <cuishw@inspur.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/partition-generic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index aee643ce13d1..e69452c1f5ad 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -272,6 +272,7 @@ void delete_partition(struct gendisk *disk, int partno)
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	if (partno >= ptbl->len)
 		return;
@@ -292,6 +293,12 @@ void delete_partition(struct gendisk *disk, int partno)
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget(part_devt(part));
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	hd_struct_kill(part);
 }
 
-- 
2.38.1

