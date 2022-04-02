Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F36C4F03E1
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 16:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356169AbiDBOWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 10:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiDBOWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 10:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DCE12D0B1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 07:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E12615A6
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 14:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B5AC340EC;
        Sat,  2 Apr 2022 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648909237;
        bh=wUHAZNHbn8CAUadjGVThGOZAqy+J0N8yv/elc2536LU=;
        h=Subject:To:Cc:From:Date:From;
        b=rB1t0oKkZbninxoVq/a2XmJFEnbm1s8sfC+ddQGbQB34O30Hh49ozajquakbi4/In
         SRq1GpzGT/eU+y9wDIbk2d9zGeusUwHJqEk0rycYau68hgYPfCT5CxHJ79nqxYbx6/
         bONneQt8lvr7+mtfIfL3e+Jx3rwySfYtUCDo4JYc=
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash during module load unload test" failed to apply to 5.15-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, mpatalan@redhat.com,
        njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 16:20:26 +0200
Message-ID: <164890922647116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0972252450f90db56dd5415a20e2aec21a08d036 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Thu, 10 Mar 2022 01:25:56 -0800
Subject: [PATCH] scsi: qla2xxx: Fix crash during module load unload test

During purex packet handling the driver was incorrectly freeing a
pre-allocated structure. Fix this by skipping that entry.

System crashed with the following stack during a module unload test.

Call Trace:
	sbitmap_init_node+0x7f/0x1e0
	sbitmap_queue_init_node+0x24/0x150
	blk_mq_init_bitmaps+0x3d/0xa0
	blk_mq_init_tags+0x68/0x90
	blk_mq_alloc_map_and_rqs+0x44/0x120
	blk_mq_alloc_set_map_and_rqs+0x63/0x150
	blk_mq_alloc_tag_set+0x11b/0x230
	scsi_add_host_with_dma.cold+0x3f/0x245
	qla2x00_probe_one+0xd5a/0x1b80 [qla2xxx]

Call Trace with slub_debug and debug kernel:
	kasan_report_invalid_free+0x50/0x80
	__kasan_slab_free+0x137/0x150
	slab_free_freelist_hook+0xc6/0x190
	kfree+0xe8/0x2e0
	qla2x00_free_device+0x3bb/0x5d0 [qla2xxx]
	qla2x00_remove_one+0x668/0xcf0 [qla2xxx]

Link: https://lore.kernel.org/r/20220310092604.22950-6-njavali@marvell.com
Fixes: 62e9dd177732 ("scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests")
Cc: stable@vger.kernel.org
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 58c83525f006..9c4f2b38b34e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3901,6 +3901,8 @@ qla24xx_free_purex_list(struct purex_list *list)
 	spin_lock_irqsave(&list->lock, flags);
 	list_for_each_entry_safe(item, next, &list->head, list) {
 		list_del(&item->list);
+		if (item == &item->vha->default_item)
+			continue;
 		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);

