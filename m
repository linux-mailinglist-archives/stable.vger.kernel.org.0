Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2F92C0036
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 07:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgKWGqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 01:46:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:36788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgKWGqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 01:46:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8F5EEABCE;
        Mon, 23 Nov 2020 06:46:41 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] block: Fix a race in the runtime power management
 code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
 <20201123031749.14912-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <adeb251b-bfda-e3c5-e098-4105c2835922@suse.de>
Date:   Mon, 23 Nov 2020 07:46:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201123031749.14912-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 4:17 AM, Bart Van Assche wrote:
> With the current implementation the following race can happen:
> * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
>    blk_mq_unfreeze_queue().
> * blk_queue_enter() calls blk_queue_pm_only() and that function returns
>    true.
> * blk_queue_enter() calls blk_pm_request_resume() and that function does
>    not call pm_request_resume() because the queue runtime status is
>    RPM_ACTIVE.
> * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> 
> Fix this race by changing the queue runtime status into RPM_SUSPENDING
> before switching q_usage_counter to atomic mode.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-pm.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
