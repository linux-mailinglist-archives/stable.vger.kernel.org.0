Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F276A6ED6F
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 05:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfGTDGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 23:06:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfGTDGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 23:06:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6457030832C8;
        Sat, 20 Jul 2019 03:06:51 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A835619AB;
        Sat, 20 Jul 2019 03:06:43 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH V2 0/2] block/scsi/dm-rq: fix leak of request private data in dm-mpath
Date:   Sat, 20 Jul 2019 11:06:35 +0800
Message-Id: <20190720030637.14447-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 20 Jul 2019 03:06:51 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

When one request is dispatched to LLD via dm-rq, if the result is
BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
private data for this request, so this way will cause memory leak.

Add .cleanup_rq() callback and implement it in SCSI for fixing the issue,
since SCSI is the only driver which allocates private requst data in
.queue_rq() path.

Another use case of this callback is to free the request and re-submit
bios during cpu hotplug when the hctx is dead, see the following link:

https://lore.kernel.org/linux-block/f122e8f2-5ede-2d83-9ca0-bc713ce66d01@huawei.com/T/#t

V2:
	- run .cleanup_rq() in blk_mq_free_request(), as suggested by Mike 


Ming Lei (2):
  blk-mq: add callback of .cleanup_rq
  scsi: implement .cleanup_rq callback

 block/blk-mq.c          |  3 +++
 drivers/scsi/scsi_lib.c | 28 ++++++++++++++++++++--------
 include/linux/blk-mq.h  |  7 +++++++
 3 files changed, 30 insertions(+), 8 deletions(-)

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")

-- 
2.20.1

