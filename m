Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9916E56FCBD
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiGKJri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiGKJrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E55C350;
        Mon, 11 Jul 2022 02:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CDDFB80E6D;
        Mon, 11 Jul 2022 09:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD5C341C0;
        Mon, 11 Jul 2022 09:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531377;
        bh=vKDipy7cGgRrRs2S/HoIY0V0cYNgIWXkWEb8VzIflQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUGCKluYr0Mo6ON//6LWm2ogJmmShmePi91QXjrToI6OinHz3XmYr7S48oc4ovT0a
         7Dr846TVH13FjA021OUh2DlY8MczIgDAjB3D+ZJbBhv17GGDqoc5dssEIJnrXxwOJs
         DPDBYlQJYno1BuSS6KqRxQ/ZrbYRjUixTczj4gfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/230] scsi: qla2xxx: Fix crash during module load unload test
Date:   Mon, 11 Jul 2022 11:05:38 +0200
Message-Id: <20220711090606.401106281@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 0972252450f90db56dd5415a20e2aec21a08d036 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c7ab8a8be24c..e683b1c01c9f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3892,6 +3892,8 @@ qla24xx_free_purex_list(struct purex_list *list)
 	spin_lock_irqsave(&list->lock, flags);
 	list_for_each_entry_safe(item, next, &list->head, list) {
 		list_del(&item->list);
+		if (item == &item->vha->default_item)
+			continue;
 		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
-- 
2.35.1



