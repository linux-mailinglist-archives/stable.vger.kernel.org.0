Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E555EA6F6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiIZNTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiIZNSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:18:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D3DB;
        Mon, 26 Sep 2022 04:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B8A2CE111C;
        Mon, 26 Sep 2022 10:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1923AC433C1;
        Mon, 26 Sep 2022 10:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189474;
        bh=LgrIYa0at/wSsDhTrNC+RUwDkoQVOs7ROK/IsjTDK8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=intx3gVkN2TpnFO2WOtfqLjpfVpwQJyUDh0AhTFP+Y/F9idjS7X9FO3V9YdoFKdR9
         xBATgYzsdZIaE0nGSvAVK3Q80MBYeeaevTGLrqtfvhabxoZ2vFOBQX2Ol/7WxFF8Dz
         8gYhB/dL8ICfZOqDEshXvOI38v/CFORKr7v1kny0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+31c9594f6e43b9289b25@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 170/207] block: Do not call blk_put_queue() if gendisk allocation fails
Date:   Mon, 26 Sep 2022 12:12:39 +0200
Message-Id: <20220926100814.266479156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

commit aa0c680c3aa96a5f9f160d90dd95402ad578e2b0 upstream.

Commit 6f8191fdf41d ("block: simplify disk shutdown") removed the call
to blk_get_queue() during gendisk allocation but missed to remove the
corresponding cleanup code blk_put_queue() for it. Thus, if the gendisk
allocation fails, the request_queue refcount gets decremented and
reaches 0, causing blk_mq_release() to be called with a hctx still
alive. That triggers a WARNING report, as found by syzkaller:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 23016 at block/blk-mq.c:3881
blk_mq_release+0xf8/0x3e0 block/blk-mq.c:3881
[...] stripped
RIP: 0010:blk_mq_release+0xf8/0x3e0 block/blk-mq.c:3881
[...] stripped
Call Trace:
 <TASK>
 blk_release_queue+0x153/0x270 block/blk-sysfs.c:780
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 __alloc_disk_node+0x4f7/0x610 block/genhd.c:1388
 __blk_mq_alloc_disk+0x13b/0x1f0 block/blk-mq.c:3961
 loop_add+0x3e2/0xaf0 drivers/block/loop.c:1978
 loop_control_ioctl+0x133/0x620 drivers/block/loop.c:2150
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
[...] stripped

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Reported-by: syzbot+31c9594f6e43b9289b25@syzkaller.appspotmail.com
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220811232338.254673-1-rafaelmendsr@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1359,7 +1359,7 @@ struct gendisk *__alloc_disk_node(struct
 
 	disk = kzalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
 	if (!disk)
-		goto out_put_queue;
+		return NULL;
 
 	disk->bdi = bdi_alloc(node_id);
 	if (!disk->bdi)
@@ -1403,8 +1403,6 @@ out_free_bdi:
 	bdi_put(disk->bdi);
 out_free_disk:
 	kfree(disk);
-out_put_queue:
-	blk_put_queue(q);
 	return NULL;
 }
 


