Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29F636C1C7
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhD0Jdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:33:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:43198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhD0Jdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 05:33:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 44760B13E;
        Tue, 27 Apr 2021 09:33:05 +0000 (UTC)
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
To:     mwilck@suse.com, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Chao Leng <lengchao@huawei.com>
Cc:     Daniel Wagner <dwagner@suse.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
References: <20210427085246.13728-1-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
Date:   Tue, 27 Apr 2021 11:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210427085246.13728-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 10:52 AM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We have observed a few crashes run_timer_softirq(), where a broken
> timer_list struct belonging to an anatt_timer was encountered. The broken
> structures look like this, and we see actually multiple ones attached to
> the same timer base:
> 
> crash> struct timer_list 0xffff92471bcfdc90
> struct timer_list {
>   entry = {
>     next = 0xdead000000000122,  // LIST_POISON2
>     pprev = 0x0
>   },
>   expires = 4296022933,
>   function = 0xffffffffc06de5e0 <nvme_anatt_timeout>,
>   flags = 20
> }
> 
> If such a timer is encountered in run_timer_softirq(), the kernel
> crashes. The test scenario was an I/O load test with lots of NVMe
> controllers, some of which were removed and re-added on the storage side.
> 
> I think this may happen if the rdma recovery_work starts, in this call
> chain:
> 
> nvme_rdma_error_recovery_work()
>   /* this stops all sorts of activity for the controller, but not
>      the multipath-related work queue and timer */
>   nvme_rdma_reconnect_or_remove(ctrl)
>     => kicks reconnect_work
> 
> work queue: reconnect_work
> 
> nvme_rdma_reconnect_ctrl_work()
>   nvme_rdma_setup_ctrl()
>     nvme_rdma_configure_admin_queue()
>        nvme_init_identify()
>           nvme_mpath_init()
> 	     # this sets some fields of the timer_list without taking a lock
>              timer_setup()
>              nvme_read_ana_log()
> 	         mod_timer() or del_timer_sync()
> 
> Similar for TCP. The idea for the patch is based on the observation that
> nvme_rdma_reset_ctrl_work() calls nvme_stop_ctrl()->nvme_mpath_stop(),
> whereas nvme_rdma_error_recovery_work() stops only the keepalive timer, but
> not the anatt timer.
> 
> I admit that the root cause analysis isn't rock solid yet. In particular, I
> can't explain why we see LIST_POISON2 in the "next" pointer, which would
> indicate that the timer has been detached before; yet we find it linked to
> the timer base when the crash occurs.
> 
> OTOH, the anatt_timer is only touched in nvme_mpath_init() (see above) and
> nvme_mpath_stop(), so the hypothesis that modifying active timers may cause
> the issue isn't totally out of sight. I suspect that the LIST_POISON2 may
> come to pass in multiple steps.
> 
> If anyone has better ideas, please advise. The issue occurs very
> sporadically; verifying this by testing will be difficult.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chao Leng <lengchao@huawei.com>
> Cc: stable@vger.kernel.org
> 
As indicated in my previous mail, please change the description. We have
since established a actual reason (duplicate calls to add_timer()), so
please list it here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
