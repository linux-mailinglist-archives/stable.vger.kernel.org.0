Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4E14E2976
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbiCUOFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348802AbiCUODx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6091D18114A;
        Mon, 21 Mar 2022 07:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0413DB816CE;
        Mon, 21 Mar 2022 14:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65531C340ED;
        Mon, 21 Mar 2022 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871270;
        bh=aZf76KE9DN5cxUeQ8w5mlraiAepMF2EIiwiv9GroYyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQh0yM0bJ+jxkhzJ9501otf9GGxI2Es3tIvKc/y62zUfxqdlLJwrPdLrchBI/pWpX
         GtUCByu7jeKiBel8rzyklHlr/UtY6tBBVRkvw97d/uuBbbGCinkxCgmG5CbI2NPfbE
         GnyfwguyT0ccMkIsjDD5kT/bF9kzbDqD3vWUtXUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 04/32] block: release rq qos structures for queue without disk
Date:   Mon, 21 Mar 2022 14:52:40 +0100
Message-Id: <20220321133220.691523932@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit daaca3522a8e67c46e39ef09c1d542e866f85f3b upstream.

blkcg_init_queue() may add rq qos structures to request queue, previously
blk_cleanup_queue() calls rq_qos_exit() to release them, but commit
8e141f9eb803 ("block: drain file system I/O on del_gendisk")
moves rq_qos_exit() into del_gendisk(), so memory leak is caused
because queues may not have disk, such as un-present scsi luns, nvme
admin queue, ...

Fixes the issue by adding rq_qos_exit() to blk_cleanup_queue() back.

BTW, v5.18 won't need this patch any more since we move
blkcg_init_queue()/blkcg_exit_queue() into disk allocation/release
handler, and patches have been in for-5.18/block.

Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Fixes: 8e141f9eb803 ("block: drain file system I/O on del_gendisk")
Reported-by: syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220314043018.177141-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,7 @@
 #include "blk-mq.h"
 #include "blk-mq-sched.h"
 #include "blk-pm.h"
+#include "blk-rq-qos.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -380,6 +381,9 @@ void blk_cleanup_queue(struct request_qu
 	 */
 	blk_freeze_queue(q);
 
+	/* cleanup rq qos structures for queue without disk */
+	rq_qos_exit(q);
+
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
 	blk_sync_queue(q);


