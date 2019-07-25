Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8A74312
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 04:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbfGYCFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 22:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388438AbfGYCFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 22:05:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 994EA4E92A;
        Thu, 25 Jul 2019 02:05:17 +0000 (UTC)
Received: from localhost (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B68719C7F;
        Thu, 25 Jul 2019 02:05:08 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH V4 0/2] block/scsi/dm-rq: fix leak of request private data in dm-mpath
Date:   Thu, 25 Jul 2019 10:04:58 +0800
Message-Id: <20190725020500.4317-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 25 Jul 2019 02:05:17 +0000 (UTC)
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

V4:
	- add more commit log on the new .cleanup_rq callback, as suggested
	  by Mike

V3:
	- run .cleanup_rq() from dm-rq because this issue is dm-rq specific,
	and even in future it should be still very unusual to free request
	in this way. If we call .cleanup_rq() in generic rq free code(fast
	path), cost will be introduced unnecessarily, also we have to
	consider related race.

V2:
	- run .cleanup_rq() in blk_mq_free_request(), as suggested by Mike 



Ming Lei (2):
  blk-mq: add callback of .cleanup_rq
  scsi: implement .cleanup_rq callback

 drivers/md/dm-rq.c      |  1 +
 drivers/scsi/scsi_lib.c | 13 +++++++++++++
 include/linux/blk-mq.h  | 13 +++++++++++++
 3 files changed, 27 insertions(+)

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

