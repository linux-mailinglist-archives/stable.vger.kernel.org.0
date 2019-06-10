Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5633B68D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfFJNz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:55:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:32920 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389373AbfFJNz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 09:55:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBE4BABD2;
        Mon, 10 Jun 2019 13:55:53 +0000 (UTC)
Date:   Mon, 10 Jun 2019 15:55:53 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     aarcange@redhat.com, jannh@google.com, oleg@redhat.com,
        peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com,
        yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, srivatsab@vmware.com, amakhalov@vmware.com
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Message-ID: <20190610135553.GH30967@dhcp22.suse.cz>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560199937-23476-1-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 11-06-19 02:22:17, Ajay Kaher wrote:
> This patch is the extension of following upstream commit to fix
> the race condition between get_task_mm() and core dumping
> for IB->mlx4 and IB->mlx5 drivers:
> 
> commit 04f5866e41fb ("coredump: fix race condition between
> mmget_not_zero()/get_task_mm() and core dumping")'
> 
> Thanks to Jason for pointing this.
> 
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 +++-
>  drivers/infiniband/hw/mlx5/main.c | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index e2beb18..0299c06 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1197,6 +1197,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>  	 * mlx4_ib_vma_close().
>  	 */
>  	down_write(&owning_mm->mmap_sem);
> +	if (!mmget_still_valid(owning_mm))
> +		goto skip_mm;
>  	for (i = 0; i < HW_BAR_COUNT; i++) {
>  		vma = context->hw_bar_info[i].vma;
>  		if (!vma)

I have missed this part in 4.4 stable backport. Thanks for catching it.
I have updated my backport.

> @@ -1215,7 +1217,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>  		/* context going to be destroyed, should not access ops any more */
>  		context->hw_bar_info[i].vma->vm_ops = NULL;
>  	}
> -
> +skip_mm:
>  	up_write(&owning_mm->mmap_sem);
>  	mmput(owning_mm);
>  	put_task_struct(owning_process);
-- 
Michal Hocko
SUSE Labs
