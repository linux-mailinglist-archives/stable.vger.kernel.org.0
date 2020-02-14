Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5297715D56D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgBNKWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:22:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:48928 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729017AbgBNKWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 05:22:00 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1CB4025C56B5CEFB58D7;
        Fri, 14 Feb 2020 18:21:53 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Feb 2020
 18:21:47 +0800
Subject: Re: [PATCH 4.19 091/195] padata: Remove broken queue flushing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
References: <20200210122305.731206734@linuxfoundation.org>
 <20200210122314.217904406@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5E4674BB.4020900@huawei.com>
Date:   Fri, 14 Feb 2020 18:21:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200210122314.217904406@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020/2/10 20:32, Greg Kroah-Hartman wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
>
> [ Upstream commit 07928d9bfc81640bab36f5190e8725894d93b659 ]
>
> The function padata_flush_queues is fundamentally broken because
> it cannot force padata users to complete the request that is
> underway.  IOW padata has to passively wait for the completion
> of any outstanding work.
>
> As it stands flushing is used in two places.  Its use in padata_stop
> is simply unnecessary because nothing depends on the queues to
> be flushed afterwards.
>
> The other use in padata_replace is more substantial as we depend
> on it to free the old pd structure.  This patch instead uses the
> pd->refcnt to dynamically free the pd structure once all requests
> are complete.
>
> Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/padata.c | 46 ++++++++++++----------------------------------
>   1 file changed, 12 insertions(+), 34 deletions(-)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 6c06b3039faed..11c5f9c8779ea 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -35,6 +35,8 @@
>   
>   #define MAX_OBJ_NUM 1000
>   
> +static void padata_free_pd(struct parallel_data *pd);
> +
>   static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
>   {
>   	int cpu, target_cpu;
> @@ -334,6 +336,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
>   	struct padata_serial_queue *squeue;
>   	struct parallel_data *pd;
>   	LIST_HEAD(local_list);
> +	int cnt;
>   
>   	local_bh_disable();
>   	squeue = container_of(serial_work, struct padata_serial_queue, work);
> @@ -343,6 +346,8 @@ static void padata_serial_worker(struct work_struct *serial_work)
>   	list_replace_init(&squeue->serial.list, &local_list);
>   	spin_unlock(&squeue->serial.lock);
>   
> +	cnt = 0;
> +
>   	while (!list_empty(&local_list)) {
>   		struct padata_priv *padata;
>   
> @@ -352,9 +357,12 @@ static void padata_serial_worker(struct work_struct *serial_work)
>   		list_del_init(&padata->list);
>   
>   		padata->serial(padata);
> -		atomic_dec(&pd->refcnt);
> +		cnt++;
>   	}
>   	local_bh_enable();
> +
> +	if (atomic_sub_and_test(cnt, &pd->refcnt))
> +		padata_free_pd(pd);
>   }
>   
>   /**
> @@ -501,8 +509,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
>   	timer_setup(&pd->timer, padata_reorder_timer, 0);
>   	atomic_set(&pd->seq_nr, -1);
>   	atomic_set(&pd->reorder_objects, 0);
> -	atomic_set(&pd->refcnt, 0);
> -	pd->pinst = pinst;
This patch remove this assignment, it's cause a null-ptr-deref when 
using pd->pinst in padata_reorder().

[39135.886908] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000010
[39135.886909] Mem abort info:
[39135.886910]   ESR = 0x96000004
[39135.886912]   Exception class = DABT (current EL), IL = 32 bits
[39135.886913]   SET = 0, FnV = 0
[39135.886913]   EA = 0, S1PTW = 0
[39135.886914] Data abort info:
[39135.886915]   ISV = 0, ISS = 0x00000004
[39135.886915]   CM = 0, WnR = 0
[39135.886918] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000c66d7ef5
[39135.886919] [0000000000000010] pgd=0000000000000000
[39135.886922] Internal error: Oops: 96000004 [#1] SMP
[39135.897190] Modules linked in: authenc pcrypt crypto_user cfg80211 
rfkill ib_isert iscsi_target_mod ib_srpt target_core_mod dm_mirror 
dm_region_hash rpcrdma dm_log ib_srp scsi_transport_srp sunrpc dm_mod 
ib_ipoib rdma_ucm ib_uverbs ib_umad ib_iser rdma_cm ib_cm iw_cm 
aes_ce_blk crypto_simd cryptd aes_ce_cipher hns_roce_hw_v2 ghash_ce 
sha2_ce sha256_arm64 hns_roce ib_core sha1_ce sbsa_gwdt hi_sfc sg mtd 
ipmi_ssif sch_fq_codel ip_tables realtek hclge hinic hns3 ipmi_si 
hisi_sas_v3_hw hibmc_drm hnae3 hisi_sas_main ipmi_devintf ipmi_msghandler
[39135.997870] Process kworker/0:2 (pid: 789, stack limit = 
0x0000000047f55ba6)
[39136.012707] CPU: 0 PID: 789 Comm: kworker/0:2 Kdump: loaded Not 
tainted 4.19.103+ #1
[39136.029010] Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 1.08 
12/14/2019
[39136.044587] Workqueue: pencrypt padata_parallel_worker
[39136.055396] pstate: 00c00009 (nzcv daif +PAN +UAO)
[39136.065479] pc : padata_reorder+0x144/0x2e0
[39136.074274] lr : padata_reorder+0x124/0x2e0
[39136.083070] sp : ffff0000149cbc90
[39136.090036] x29: ffff0000149cbc90 x28: 0000000000000001
[39136.101215] x27: ffffa02fd14af080 x26: ffffa02fd5fe1600
[39136.112392] x25: ffff5df7bf4c0ac8 x24: ffffa02fd5fe1628
[39136.123569] x23: 0000000000000000 x22: ffff00000828a258
[39136.134747] x21: ffffa02fd5fe1618 x20: ffff000009a79788
[39136.145924] x19: ffff5df7bf4c0ac8 x18: 00000000bef9a3f7
[39136.157102] x17: 0000000066bb7710 x16: 000000009a34db62
[39136.168280] x15: 0000000000342311 x14: 0000000037c9c538
[39136.179458] x13: 00000000deb82818 x12: 000000007abb6477
[39136.190638] x11: 000000006e0b05e5 x10: 00000000ccde2d6a
[39136.201817] x9 : 0000000000000000 x8 : a544a826aa446d6a
[39136.212996] x7 : e5050b6ea3a6345c x6 : ffffa02fd74ef030
[39136.224174] x5 : 0000000000000010 x4 : ffff5df7bf4c0ac8
[39136.235354] x3 : ffff5df7bf4c0ad8 x2 : ffff5df7bf4c0ac8
[39136.246532] x1 : ffff5df7bf4c0ad8 x0 : 0000000000000000
[39136.257712] Call trace:
[39136.262851]  padata_reorder+0x144/0x2e0
[39136.270922]  padata_do_serial+0xc8/0x128
[39136.279177]  pcrypt_aead_enc+0x60/0x70 [pcrypt]
[39136.288708]  padata_parallel_worker+0xd8/0x138
[39136.298056]  process_one_work+0x1bc/0x4b8
[39136.306489]  worker_thread+0x164/0x580
[39136.314374]  kthread+0x134/0x138
[39136.321163]  ret_from_fork+0x10/0x18
[39136.328681] Code: f900033b 52800000 91004261 089ffc20 (f9400ae1)
[39136.341508] ---[ end trace fc1b4f00385f0fee ]---
[39136.351221] Kernel panic - not syncing: Fatal exception in interrupt
[39136.364591] SMP: stopping secondary CPUs
[39136.372863] Kernel Offset: disabled
[39138.438722] CPU features: 0x12,a2200a38
[39138.446797] Memory Limit: none
[39138.463025] Starting crashdump kernel...
[39138.471295] Bye!

> +	atomic_set(&pd->refcnt, 1);
>   	spin_lock_init(&pd->lock);
>   
>   	return pd;
> @@ -526,31 +533,6 @@ static void padata_free_pd(struct parallel_data *pd)
>   	kfree(pd);
>   }
>   
> -/* Flush all objects out of the padata queues. */
> -static void padata_flush_queues(struct parallel_data *pd)
> -{
> -	int cpu;
> -	struct padata_parallel_queue *pqueue;
> -	struct padata_serial_queue *squeue;
> -
> -	for_each_cpu(cpu, pd->cpumask.pcpu) {
> -		pqueue = per_cpu_ptr(pd->pqueue, cpu);
> -		flush_work(&pqueue->work);
> -	}
> -
> -	del_timer_sync(&pd->timer);
> -
> -	if (atomic_read(&pd->reorder_objects))
> -		padata_reorder(pd);
> -
> -	for_each_cpu(cpu, pd->cpumask.cbcpu) {
> -		squeue = per_cpu_ptr(pd->squeue, cpu);
> -		flush_work(&squeue->work);
> -	}
> -
> -	BUG_ON(atomic_read(&pd->refcnt) != 0);
> -}
> -
>   static void __padata_start(struct padata_instance *pinst)
>   {
>   	pinst->flags |= PADATA_INIT;
> @@ -564,10 +546,6 @@ static void __padata_stop(struct padata_instance *pinst)
>   	pinst->flags &= ~PADATA_INIT;
>   
>   	synchronize_rcu();
> -
> -	get_online_cpus();
> -	padata_flush_queues(pinst->pd);
> -	put_online_cpus();
>   }
>   
>   /* Replace the internal control structure with a new one. */
> @@ -588,8 +566,8 @@ static void padata_replace(struct padata_instance *pinst,
>   	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
>   		notification_mask |= PADATA_CPU_SERIAL;
>   
> -	padata_flush_queues(pd_old);
> -	padata_free_pd(pd_old);
> +	if (atomic_dec_and_test(&pd_old->refcnt))
> +		padata_free_pd(pd_old);
>   
>   	if (notification_mask)
>   		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,


