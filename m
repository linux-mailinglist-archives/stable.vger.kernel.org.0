Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A69473383
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfGXQST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 12:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfGXQST (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 12:18:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBD5D30917AC;
        Wed, 24 Jul 2019 16:18:18 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52E6B102482F;
        Wed, 24 Jul 2019 16:18:14 +0000 (UTC)
Date:   Wed, 24 Jul 2019 12:18:13 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V3 1/2] blk-mq: add callback of .cleanup_rq
Message-ID: <20190724161813.GA13896@redhat.com>
References: <20190724031258.31688-1-ming.lei@redhat.com>
 <20190724031258.31688-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724031258.31688-2-ming.lei@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 24 Jul 2019 16:18:19 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23 2019 at 11:12pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> dm-rq needs to free request which has been dispatched and not completed
> by underlying queue. However, the underlying queue may have allocated
> private data for this request in .queue_rq(), so the request private data
> will be leaked in dm multipath IO code path.
> 
> Add one new callback of .cleanup_rq() to fix the memory leak.

Think the above kind of glosses over the nature of the issue.  While
this issue _is_ unique to request-based DM multipath's use of blk-mq it
ultimately is a failing of the existing blk-mq interface that SCSI's
per-request private data is leaking.  SO all said, I'd rather this patch
header reflect the nuance of why you skinned the cat like you have.

Something like this would be a better header IMHO:

SCSI maintains its own driver private data hooked off of each SCSI
request.  An upper layer driver (e.g. dm-rq) may need to retry these
SCSI requests, before SCSI has fully dispatched them, due to a lower
level SCSI driver's resource limitation identified in scsi_queue_rq().
Currently SCSI's per-request private data is leaked when the upper layer
driver (dm-rq) frees and then retries these requests in response to
BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE returns from scsi_queue_rq().

This usecase is so specialized that it doesn't warrant training an
existing blk-mq interface (e.g. blk_mq_free_request) to allow SCSI to
account for freeing its driver private data -- doing so would add an
extra branch for handling a special case that all other consumers of
SCSI (and blk-mq) won't ever need to worry about.

So the most pragmatic way forward is to delegate freeing SCSI driver
private data to the upper layer driver (dm-rq).  Do so by calling a new
blk_mq_cleanup_rq() method from dm-rq.  A following commit will
implement the .cleanup_rq() hook in scsi_mq_ops.


> Another use case is to free request when the hctx is dead during
> cpu hotplug context.

Not seeing any point forecasting this .cleanup_rq() hook's potential
ability to address that cpu hotplug case; the future patch that provides
that fix can deal with it.  Reality is the existing SCSI per-request
private data leak justifies this new hook on its own.

Mike
