Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF8246432
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHQKPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:15:43 -0400
Received: from verein.lst.de ([213.95.11.211]:56133 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgHQKPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 06:15:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 15E8468B02; Mon, 17 Aug 2020 12:15:40 +0200 (CEST)
Date:   Mon, 17 Aug 2020 12:15:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        David Jeffery <djeffery@redhat.com>,
        kernel test robot <rong.a.chen@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND] blk-mq: order adding requests to hctx->dispatch
 and checking SCHED_RESTART
Message-ID: <20200817101539.GB25336@lst.de>
References: <20200817100115.2495988-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817100115.2495988-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:01:15PM +0800, Ming Lei wrote:
> SCHED_RESTART code path is relied to re-run queue for dispatch requests
> in hctx->dispatch. Meantime the SCHED_RSTART flag is checked when adding
> requests to hctx->dispatch.
> 
> memory barriers have to be used for ordering the following two pair of OPs:
> 
> 1) adding requests to hctx->dispatch and checking SCHED_RESTART in
> blk_mq_dispatch_rq_list()
> 
> 2) clearing SCHED_RESTART and checking if there is request in hctx->dispatch
> in blk_mq_sched_restart().
> 
> Without the added memory barrier, either:
> 
> 1) blk_mq_sched_restart() may miss requests added to hctx->dispatch meantime
> blk_mq_dispatch_rq_list() observes SCHED_RESTART, and not run queue in
> dispatch side
> 
> or
> 
> 2) blk_mq_dispatch_rq_list still sees SCHED_RESTART, and not run queue
> in dispatch side, meantime checking if there is request in
> hctx->dispatch from blk_mq_sched_restart() is missed.
> 
> IO hang in ltp/fs_fill test is reported by kernel test robot:
> 
> 	https://lkml.org/lkml/2020/7/26/77
> 
> Turns out it is caused by the above out-of-order OPs. And the IO hang
> can't be observed any more after applying this patch.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: David Jeffery <djeffery@redhat.com>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Can you add a Fixes: tag so that the commit gets backported?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
