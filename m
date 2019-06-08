Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF51439BBF
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 10:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFHIPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 04:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFHIPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 04:15:48 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F689214AE;
        Sat,  8 Jun 2019 08:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559981747;
        bh=+fIMrvePbI5yDYH3qDsNTRsCEXZWnpBoeKnnxMc8TjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qi02LV5iIUGdxLJy0FdX1iSC98jqpOieBqfiFHBTtmiNpcPkQulYajST2LoFr/WTP
         GGvosr49hpkb7kXnW8bLM3ssmhVFvwA+khMTfKJn4SHAeSfHd0VJR+aYxAxcdj+Sr3
         TdUzaGjbfe2EjhLYHURitItHDd39dcvmJArWm46A=
Date:   Sat, 8 Jun 2019 11:15:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc 3/3] IB/hfi1: Correct tid qp rcd to match verbs
 context
Message-ID: <20190608081533.GO5261@mtr-leonro.mtl.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607122538.158478.62945.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 08:25:38AM -0400, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
>
> The qp priv rcd pointer doesn't match the context being
> used for verbs causing issues when 9B and kdeth packets
> are processed by different receive contexts and hence
> different CPUs.
>
> When running on different CPUs the following panic can
> occur:
> [476262.398106] WARNING: CPU: 3 PID: 2584 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0
> [476262.398109] list_del corruption. prev->next should be ffff9a7ac31f7a30, but was ffff9a7c3bc89230
> [476262.398266] CPU: 3 PID: 2584 Comm: z_wr_iss Kdump: loaded Tainted: P           OE  ------------   3.10.0-862.2.3.el7_lustre.x86_64 #1
> [476262.398272] Call Trace:
> [476262.398277]  <IRQ>  [<ffffffffb7b0d78e>] dump_stack+0x19/0x1b
> [476262.398314]  [<ffffffffb74916d8>] __warn+0xd8/0x100
> [476262.398317]  [<ffffffffb749175f>] warn_slowpath_fmt+0x5f/0x80
> [476262.398320]  [<ffffffffb7768671>] __list_del_entry+0xa1/0xd0
> [476262.398402]  [<ffffffffc0c7a945>] process_rcv_qp_work+0xb5/0x160 [hfi1]
> [476262.398424]  [<ffffffffc0c7bc2b>] handle_receive_interrupt_nodma_rtail+0x20b/0x2b0 [hfi1]
> [476262.398438]  [<ffffffffc0c70683>] receive_context_interrupt+0x23/0x40 [hfi1]
> [476262.398447]  [<ffffffffb7540a94>] __handle_irq_event_percpu+0x44/0x1c0
> [476262.398450]  [<ffffffffb7540c42>] handle_irq_event_percpu+0x32/0x80
> [476262.398454]  [<ffffffffb7540ccc>] handle_irq_event+0x3c/0x60
> [476262.398460]  [<ffffffffb7543a1f>] handle_edge_irq+0x7f/0x150
> [476262.398469]  [<ffffffffb742d504>] handle_irq+0xe4/0x1a0
> [476262.398475]  [<ffffffffb7b23f7d>] do_IRQ+0x4d/0xf0
> [476262.398481]  [<ffffffffb7b16362>] common_interrupt+0x162/0x162
> [476262.398482]  <EOI>  [<ffffffffb775a326>] ? memcpy+0x6/0x110
> [476262.398645]  [<ffffffffc109210d>] ? abd_copy_from_buf_off_cb+0x1d/0x30 [zfs]
> [476262.398678]  [<ffffffffc10920f0>] ? abd_copy_to_buf_off_cb+0x30/0x30 [zfs]
> [476262.398696]  [<ffffffffc1093257>] abd_iterate_func+0x97/0x120 [zfs]
> [476262.398710]  [<ffffffffc10934d9>] abd_copy_from_buf_off+0x39/0x60 [zfs]
> [476262.398726]  [<ffffffffc109b828>] arc_write_ready+0x178/0x300 [zfs]
> [476262.398732]  [<ffffffffb7b11032>] ? mutex_lock+0x12/0x2f
> [476262.398734]  [<ffffffffb7b11032>] ? mutex_lock+0x12/0x2f
> [476262.398837]  [<ffffffffc1164d05>] zio_ready+0x65/0x3d0 [zfs]
> [476262.398884]  [<ffffffffc04d725e>] ? tsd_get_by_thread+0x2e/0x50 [spl]
> [476262.398893]  [<ffffffffc04d1318>] ? taskq_member+0x18/0x30 [spl]
> [476262.398968]  [<ffffffffc115ef22>] zio_execute+0xa2/0x100 [zfs]
> [476262.398982]  [<ffffffffc04d1d2c>] taskq_thread+0x2ac/0x4f0 [spl]
> [476262.399001]  [<ffffffffb74cee80>] ? wake_up_state+0x20/0x20
> [476262.399043]  [<ffffffffc115ee80>] ? zio_taskq_member.isra.7.constprop.10+0x80/0x80 [zfs]
> [476262.399055]  [<ffffffffc04d1a80>] ? taskq_thread_spawn+0x60/0x60 [spl]
> [476262.399067]  [<ffffffffb74bae31>] kthread+0xd1/0xe0
> [476262.399072]  [<ffffffffb74bad60>] ? insert_kthread_work+0x40/0x40
> [476262.399082]  [<ffffffffb7b1f5f7>] ret_from_fork_nospec_begin+0x21/0x21
> [476262.399087]  [<ffffffffb74bad60>] ? insert_kthread_work+0x40/0x40
>
> Fix by reading the map entry in the same manner as the
> hardware so that the kdeth and verbs contexts match.
>
> Fixes: 5190f052a365 ("IB/hfi1: Allow the driver to initialize QP priv struct")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/hw/hfi1/chip.c     |   13 +++++++++++++
>  drivers/infiniband/hw/hfi1/chip.h     |    1 +
>  drivers/infiniband/hw/hfi1/tid_rdma.c |    5 ++---
>  3 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
> index 4221a99e..674f62a 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -14032,6 +14032,19 @@ static void init_kdeth_qp(struct hfi1_devdata *dd)
>  }
>
>  /**
> + * hfi1_get_qp_map
> + * @dd: device data
> + * @idx: index to read
> + */
> +u8 hfi1_get_qp_map(struct hfi1_devdata *dd, u8 idx)
> +{
> +	u64 reg = read_csr(dd, RCV_QP_MAP_TABLE + (idx / 8) * 8);
> +
> +	reg >>= (idx % 8) * 8;
> +	return (u8)reg;
> +}
> +
> +/**
>   * init_qpmap_table
>   * @dd - device data
>   * @first_ctxt - first context
> diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
> index 4e6c355..b76cf81 100644
> --- a/drivers/infiniband/hw/hfi1/chip.h
> +++ b/drivers/infiniband/hw/hfi1/chip.h
> @@ -1445,6 +1445,7 @@ int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, struct hfi1_ctxtdata *ctxt,
>  void remap_intr(struct hfi1_devdata *dd, int isrc, int msix_intr);
>  void remap_sdma_interrupts(struct hfi1_devdata *dd, int engine, int msix_intr);
>  void reset_interrupts(struct hfi1_devdata *dd);
> +u8 hfi1_get_qp_map(struct hfi1_devdata *dd, u8 idx);
>
>  /*
>   * Interrupt source table.
> diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
> index 6fb9303..d77276d 100644
> --- a/drivers/infiniband/hw/hfi1/tid_rdma.c
> +++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
> @@ -312,9 +312,8 @@ static struct hfi1_ctxtdata *qp_to_rcd(struct rvt_dev_info *rdi,
>  	if (qp->ibqp.qp_num == 0)
>  		ctxt = 0;
>  	else
> -		ctxt = ((qp->ibqp.qp_num >> dd->qos_shift) %
> -			(dd->n_krcv_queues - 1)) + 1;
> -
> +		ctxt = hfi1_get_qp_map(dd,
> +				       (u8)(qp->ibqp.qp_num >> dd->qos_shift));

It is one time use functions, why don't you handle this (u8) casting
inside of hfi1_get_qp_map()?

Thanks

>  	return dd->rcd[ctxt];
>  }
>
>
