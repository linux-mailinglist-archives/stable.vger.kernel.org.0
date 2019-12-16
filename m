Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0158121684
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfLPS3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731103AbfLPSN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:13:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0601C207FF;
        Mon, 16 Dec 2019 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520008;
        bh=40qkxjhWCccXDQIPoVhHJt3I9NYsDbe/8jQ7XFJETiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcHxzzm0H1WfFsJBVe4Fp0VM6mjjBXrTmS8UgW0BjUCLvdfgkR5BTrsnZrZ5QrQLu
         Nvd0xsmytjqD2xt79iSc+T7kF+tCWMcUa01OmaHPhV2cmhBiv15TqxoPolVHXpUdLA
         BzHc2S4Ow3+v0mmGaFbfMB/DYeDTMQtpoxyqDkZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 120/180] RDMA/core: Fix ib_dma_max_seg_size()
Date:   Mon, 16 Dec 2019 18:49:20 +0100
Message-Id: <20191216174840.759185995@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit ecdfdfdbe4d4c74029f2b416b7ee6d0aeb56364a upstream.

If dev->dma_device->params == NULL then the maximum DMA segment size is 64
KB. See also the dma_get_max_seg_size() implementation. This patch fixes
the following kernel warning:

  DMA-API: infiniband rxe0: mapping sg segment longer than device claims to support [len=126976] [max=65536]
  WARNING: CPU: 4 PID: 4848 at kernel/dma/debug.c:1220 debug_dma_map_sg+0x3d9/0x450
  RIP: 0010:debug_dma_map_sg+0x3d9/0x450
  Call Trace:
   srp_queuecommand+0x626/0x18d0 [ib_srp]
   scsi_queue_rq+0xd02/0x13e0 [scsi_mod]
   __blk_mq_try_issue_directly+0x2b3/0x3f0
   blk_mq_request_issue_directly+0xac/0xf0
   blk_insert_cloned_request+0xdf/0x170
   dm_mq_queue_rq+0x43d/0x830 [dm_mod]
   __blk_mq_try_issue_directly+0x2b3/0x3f0
   blk_mq_request_issue_directly+0xac/0xf0
   blk_mq_try_issue_list_directly+0xb8/0x170
   blk_mq_sched_insert_requests+0x23c/0x3b0
   blk_mq_flush_plug_list+0x529/0x730
   blk_flush_plug_list+0x21f/0x260
   blk_mq_make_request+0x56b/0xf20
   generic_make_request+0x196/0x660
   submit_bio+0xae/0x290
   blkdev_direct_IO+0x822/0x900
   generic_file_direct_write+0x110/0x200
   __generic_file_write_iter+0x124/0x2a0
   blkdev_write_iter+0x168/0x270
   aio_write+0x1c4/0x310
   io_submit_one+0x971/0x1390
   __x64_sys_io_submit+0x12a/0x390
   do_syscall_64+0x6f/0x2e0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Link: https://lore.kernel.org/r/20191025225830.257535-2-bvanassche@acm.org
Cc: <stable@vger.kernel.org>
Fixes: 0b5cb3300ae5 ("RDMA/srp: Increase max_segment_size")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/rdma/ib_verbs.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3978,9 +3978,7 @@ static inline void ib_dma_unmap_sg_attrs
  */
 static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
 {
-	struct device_dma_parameters *p = dev->dma_device->dma_parms;
-
-	return p ? p->max_segment_size : UINT_MAX;
+	return dma_get_max_seg_size(dev->dma_device);
 }
 
 /**


