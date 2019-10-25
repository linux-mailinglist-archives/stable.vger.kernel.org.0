Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FACE56C3
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 00:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJYW6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 18:58:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42492 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJYW6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 18:58:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id 21so2579646pfj.9;
        Fri, 25 Oct 2019 15:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=id3Jag4Ah2PkB7BKapHcKYtTL7WashnqZLKEAmMbsoE=;
        b=MZScq3UdhvrmlDVe5EBsvK0Lvfrl7WM4JQr+TE/GRKfD4gUaIR0owHKfBgG8w33fOt
         UIdAGLtdrd9FpbMX9u8jtNA4PA2GJhclvMkpkJBjyHSgOH476+AGX81P8e0qns4ZNjU8
         pFKFn7vbiu4lmtp/QbrmJagAF4N4P/FbH15/P5DWPH+z+QUjZBEcL6OcFhjkPxvbOe7J
         ioI9xXQQUfmRDqHVtsSMU9PTkzBxz0ewhrEj1bGlutnRx/w7EfYAP2AEUTlUm0mmzdtG
         7KiPBusBFv7V/Gqm9rm34EAUuQzMpyqgUCa4/e7xyu4gKOZOdVPqR/8QrY+Hkigu5RSL
         trvg==
X-Gm-Message-State: APjAAAUrC/VsFr+B1NF61C8kLAqWUQd6TeXMHIJI2M1eM8IrgIq1RIlq
        6+0F/YdHNcCZwUUEH/d2+rA=
X-Google-Smtp-Source: APXvYqxVNh2jQV3Ol7QSf63nwA0BzgNLtjQm8Jc74eJh4xlOySDdcvTkNaZoexKrf+dv3WMptsoYLQ==
X-Received: by 2002:a63:258:: with SMTP id 85mr7097403pgc.352.1572044318650;
        Fri, 25 Oct 2019 15:58:38 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id o123sm3243983pfg.161.2019.10.25.15.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 15:58:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] RDMA/core: Fix ib_dma_max_seg_size()
Date:   Fri, 25 Oct 2019 15:58:27 -0700
Message-Id: <20191025225830.257535-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191025225830.257535-1-bvanassche@acm.org>
References: <20191025225830.257535-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If dev->dma_device->params == NULL then the maximum DMA segment size is
64 KB. See also the dma_get_max_seg_size() implementation. This patch
fixes the following kernel warning:

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

Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Fixes: 0b5cb3300ae5 ("RDMA/srp: Increase max_segment_size")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/rdma/ib_verbs.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cca9985b4cbc..0626b62ed107 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4057,9 +4057,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
  */
 static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
 {
-	struct device_dma_parameters *p = dev->dma_device->dma_parms;
-
-	return p ? p->max_segment_size : UINT_MAX;
+	return dma_get_max_seg_size(dev->dma_device);
 }
 
 /**
-- 
2.24.0.rc0.303.g954a862665-goog

