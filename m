Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058792B4C61
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgKPROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:14:40 -0500
Received: from verein.lst.de ([213.95.11.211]:55218 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgKPROk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 12:14:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC3176736F; Mon, 16 Nov 2020 18:14:35 +0100 (CET)
Date:   Mon, 16 Nov 2020 18:14:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v2 1/9] block: Fix a race in the runtime power
 management code
Message-ID: <20201116171435.GA22007@lst.de>
References: <20201116030459.13963-1-bvanassche@acm.org> <20201116030459.13963-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116030459.13963-2-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 15, 2020 at 07:04:51PM -0800, Bart Van Assche wrote:
> With the current implementation the following race can happen:
> * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
>   blk_mq_unfreeze_queue().
> * blk_queue_enter() calls blk_queue_pm_only() and that function returns
>   true.
> * blk_queue_enter() calls blk_pm_request_resume() and that function does
>   not call pm_request_resume() because the queue runtime status is
>   RPM_ACTIVE.
> * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> 
> Fix this race by changing the queue runtime status into RPM_SUSPENDING
> before switching q_usage_counter to atomic mode.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
