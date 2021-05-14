Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337B2380610
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 11:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhENJVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 05:21:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhENJVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 05:21:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BEA7AE86;
        Fri, 14 May 2021 09:20:32 +0000 (UTC)
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20210511045635.12494-1-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <0b5714c4-0182-3fa9-ee93-d7fa50441707@suse.de>
Date:   Fri, 14 May 2021 11:20:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511045635.12494-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/11/21 6:56 AM, James Smart wrote:
> The __nvmf_check_ready() routine used to bounce all filesystem io if
> the controller state isn't LIVE. However, a later patch changed the
> logic so that it rejection ends up being based on the Q live check.
> The fc transport has a slightly different sequence from rdma and tcp
> for shutting down queues/marking them non-live. FC marks its queue
> non-live after aborting all ios and waiting for their termination,
> leaving a rather large window for filesystem io to continue to hit the
> transport. Unfortunately this resulted in filesystem io or applications
> seeing I/O errors.
> 
> Change the fc transport to mark the queues non-live at the first
> sign of teardown for the association (when i/o is initially terminated).
> 
> Fixes: 73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> stable trees for 5.8 and 5.9 will require a slightly modified patch
> ---
>  drivers/nvme/host/fc.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index d9ab9e7871d0..256e87721a01 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -2461,6 +2461,18 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
>  static void
>  __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
>  {
> +	int q;
> +
> +	/*
> +	 * if aborting io, the queues are no longer good, mark them
> +	 * all as not live.
> +	 */
> +	if (ctrl->ctrl.queue_count > 1) {
> +		for (q = 1; q < ctrl->ctrl.queue_count; q++)
> +			clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[q].flags);
> +	}
> +	clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[0].flags);
> +
>  	/*
>  	 * If io queues are present, stop them and terminate all outstanding
>  	 * ios on them. As FC allocates FC exchange for each io, the
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
