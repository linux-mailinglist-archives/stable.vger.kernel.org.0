Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85AF5EA57F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbiIZMGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiIZMDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:03:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCD87D79E;
        Mon, 26 Sep 2022 03:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C9CB80906;
        Mon, 26 Sep 2022 10:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE6BC433C1;
        Mon, 26 Sep 2022 10:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189515;
        bh=ozJJzteAivKTxCNtCjbQSEkkc2fO/BrN+rWsBuy/hbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHG/+NXw/4rfiXlOSVKjQcy3YaDJM/k/TceNUG7vtWcRFyuI+u9ihn6DkMwlVl2zC
         wAL0iPfS/FCB1sKR+wS8/rtIvZgkqQ65rnoVI96Ax5nxrs2nXv/U2gMuKifUGECMR5
         Qve/uL4ZSnADtYL3KwMe70q6C52jPqzZ8JamHswQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 207/207] Revert "block: freeze the queue earlier in del_gendisk"
Date:   Mon, 26 Sep 2022 12:13:16 +0200
Message-Id: <20220926100815.885168198@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 4c66a326b5ab784cddd72de07ac5b6210e9e1b06 upstream.

This reverts commit a09b314005f3a0956ebf56e01b3b80339df577cc.

Dusty Mabe reported consistent hang during CoreOS shutdown with a MD
RAID1 setup.  Although apparently similar hangs happened before,
and this patch most likely is not the root cause it made it much
more severe.  Revert it until we can figure out what is going on
with the md driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220919144049.978907-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -625,7 +625,6 @@ void del_gendisk(struct gendisk *disk)
 	 * Prevent new I/O from crossing bio_queue_enter().
 	 */
 	blk_queue_start_drain(q);
-	blk_mq_freeze_queue_wait(q);
 
 	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
@@ -649,6 +648,8 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 
+	blk_mq_freeze_queue_wait(q);
+
 	blk_throtl_cancel_bios(disk->queue);
 
 	blk_sync_queue(q);


