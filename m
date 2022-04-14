Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91768500EF6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbiDNNXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244131AbiDNNWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:22:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDC9986C9;
        Thu, 14 Apr 2022 06:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E236AB82985;
        Thu, 14 Apr 2022 13:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336C2C385A1;
        Thu, 14 Apr 2022 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942264;
        bh=Q4wNoLp5L+7nNfRO8LA//Pno1XBtwFxiTZA5cUzfUFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kxniU3Iz+gQRQpKUfYhiiq/w5Bd+bS+tO0ZKWZyR1WtEpK/EdqOr+BsDVDVa9Hsu
         OKBhyh64iw6epZ/EnejFTas7zQ0qNmJLtmHOgPuddwKzol8/Ya6//8xqAMpJojR/RB
         h23SI73ob8KgbBj6k9eAgkjnLyeuvpstYWELdkZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Eric Biggers <ebiggers@google.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/338] block: dont delete queue kobject before its children
Date:   Thu, 14 Apr 2022 15:09:37 +0200
Message-Id: <20220414110841.006123971@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0f69288253e9fc7c495047720e523b9f1aba5712 ]

kobjects aren't supposed to be deleted before their child kobjects are
deleted.  Apparently this is usually benign; however, a WARN will be
triggered if one of the child kobjects has a named attribute group:

    sysfs group 'modes' not found for kobject 'crypto'
    WARNING: CPU: 0 PID: 1 at fs/sysfs/group.c:278 sysfs_remove_group+0x72/0x80
    ...
    Call Trace:
      sysfs_remove_groups+0x29/0x40 fs/sysfs/group.c:312
      __kobject_del+0x20/0x80 lib/kobject.c:611
      kobject_cleanup+0xa4/0x140 lib/kobject.c:696
      kobject_release lib/kobject.c:736 [inline]
      kref_put include/linux/kref.h:65 [inline]
      kobject_put+0x53/0x70 lib/kobject.c:753
      blk_crypto_sysfs_unregister+0x10/0x20 block/blk-crypto-sysfs.c:159
      blk_unregister_queue+0xb0/0x110 block/blk-sysfs.c:962
      del_gendisk+0x117/0x250 block/genhd.c:610

Fix this by moving the kobject_del() and the corresponding
kobject_uevent() to the correct place.

Fixes: 2c2086afc2b8 ("block: Protect less code with sysfs_lock in blk_{un,}register_queue()")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220124215938.2769-3-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 07494deb1a26..67836f212e2d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -1002,9 +1002,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	 */
 	if (q->mq_ops)
 		blk_mq_unregister_dev(disk_to_dev(disk), q);
-
-	kobject_uevent(&q->kobj, KOBJ_REMOVE);
-	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
 	mutex_lock(&q->sysfs_lock);
@@ -1015,6 +1012,11 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (q->request_fn || q->elevator)
 		elv_unregister_queue(q);
 	mutex_unlock(&q->sysfs_lock);
+
+	/* Now that we've deleted all child objects, we can delete the queue. */
+	kobject_uevent(&q->kobj, KOBJ_REMOVE);
+	kobject_del(&q->kobj);
+
 	mutex_unlock(&q->sysfs_dir_lock);
 
 	kobject_put(&disk_to_dev(disk)->kobj);
-- 
2.34.1



