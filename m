Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1711C79D80
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 02:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfG3AoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 20:44:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbfG3AoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 20:44:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 796283082E57;
        Tue, 30 Jul 2019 00:44:17 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3F706012C;
        Tue, 30 Jul 2019 00:44:05 +0000 (UTC)
Date:   Tue, 30 Jul 2019 08:44:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V4 0/2] block/scsi/dm-rq: fix leak of request private
 data in dm-mpath
Message-ID: <20190730004359.GA28708@ming.t460p>
References: <20190725020500.4317-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725020500.4317-1-ming.lei@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 30 Jul 2019 00:44:17 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 10:04:58AM +0800, Ming Lei wrote:
> Hi,
> 
> When one request is dispatched to LLD via dm-rq, if the result is
> BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> private data for this request, so this way will cause memory leak.
> 
> Add .cleanup_rq() callback and implement it in SCSI for fixing the issue,
> since SCSI is the only driver which allocates private requst data in
> .queue_rq() path.
> 
> Another use case of this callback is to free the request and re-submit
> bios during cpu hotplug when the hctx is dead, see the following link:
> 
> https://lore.kernel.org/linux-block/f122e8f2-5ede-2d83-9ca0-bc713ce66d01@huawei.com/T/#t
> 
> V4:
> 	- add more commit log on the new .cleanup_rq callback, as suggested
> 	  by Mike
> 
> V3:
> 	- run .cleanup_rq() from dm-rq because this issue is dm-rq specific,
> 	and even in future it should be still very unusual to free request
> 	in this way. If we call .cleanup_rq() in generic rq free code(fast
> 	path), cost will be introduced unnecessarily, also we have to
> 	consider related race.
> 
> V2:
> 	- run .cleanup_rq() in blk_mq_free_request(), as suggested by Mike 
> 
> 
> 
> Ming Lei (2):
>   blk-mq: add callback of .cleanup_rq
>   scsi: implement .cleanup_rq callback
> 
>  drivers/md/dm-rq.c      |  1 +
>  drivers/scsi/scsi_lib.c | 13 +++++++++++++
>  include/linux/blk-mq.h  | 13 +++++++++++++
>  3 files changed, 27 insertions(+)
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: <stable@vger.kernel.org>
> Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")

Hello Jens & guys,

Ping on this fix.


Thanks,
Ming
