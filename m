Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E6D3C54
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 11:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfJKJbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 05:31:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:58142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbfJKJbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 05:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10706B37E;
        Fri, 11 Oct 2019 09:31:21 +0000 (UTC)
Subject: Re: [PATCH RESEND] mm: memcg/slab: fix panic in __free_slab() caused
 by premature memcg pointer release
To:     Roman Gushchin <guro@fb.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
References: <20191010160549.1584316-1-guro@fb.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6e853d43-adfa-ab65-094e-b4a871e52ca4@suse.cz>
Date:   Fri, 11 Oct 2019 11:31:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191010160549.1584316-1-guro@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I believe it's better to include To: Andrew directly to have the patch
picked up?

On 10/10/19 6:05 PM, Roman Gushchin wrote:
> Karsten reported the following panic in __free_slab() happening on a s390x
> machine:
> 
> 349.361168¨ Unable to handle kernel pointer dereference in virtual kernel address space
> 349.361210¨ Failing address: 0000000000000000 TEID: 0000000000000483
> 349.361223¨ Fault in home space mode while using kernel ASCE.
> 349.361240¨ AS:00000000017d4007 R3:000000007fbd0007 S:000000007fbff000 P:000000000000003d
> 349.361340¨ Oops: 0004 ilc:3 Ý#1¨ PREEMPT SMP
> 349.361349¨ Modules linked in: tcp_diag inet_diag xt_tcpudp ip6t_rpfilter ip6t_REJECT \
> nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat ip6table_mangle \
> ip6table_raw ip6table_security iptable_at nf_nat
> 349.361436¨ CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-05872-g6133e3e4bada-dirty #14
> 349.361445¨ Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
> 349.361450¨ Krnl PSW : 0704d00180000000 00000000003cadb6 (__free_slab+0x686/0x6b0)
> 349.361464¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> 349.361470¨ Krnl GPRS: 00000000f3a32928 0000000000000000 000000007fbf5d00 000000000117c4b8
> 349.361475¨            0000000000000000 000000009e3291c1 0000000000000000 0000000000000000
> 349.361481¨            0000000000000003 0000000000000008 000000002b478b00 000003d080a97600
> 349.361481¨            0000000000000003 0000000000000008 000000002b478b00 000003d080a97600
> 349.361486¨            000000000117ba00 000003e000057db0 00000000003cabcc 000003e000057c78
> 349.361500¨ Krnl Code: 00000000003cada6: e310a1400004        lg      %r1,320(%r10)
> 349.361500¨            00000000003cadac: c0e50046c286        brasl   %r14,ca32b8
> 349.361500¨           #00000000003cadb2: a7f4fe36            brc     15,3caa1e
> 349.361500¨           >00000000003cadb6: e32060800024        stg     %r2,128(%r6)
> 349.361500¨            00000000003cadbc: a7f4fd9e            brc     15,3ca8f8
> 349.361500¨            00000000003cadc0: c0e50046790c        brasl   %r14,c99fd8
> 349.361500¨            00000000003cadc6: a7f4fe2c            brc     15,3caa
> 349.361500¨            00000000003cadc6: a7f4fe2c            brc     15,3caa1e
> 349.361500¨            00000000003cadca: ecb1ffff00d9        aghik   %r11,%r1,-1
> 349.361619¨ Call Trace:
> 349.361627¨ (Ý<00000000003cabcc>¨ __free_slab+0x49c/0x6b0)
> 349.361634¨  Ý<00000000001f5886>¨ rcu_core+0x5a6/0x7e0
> 349.361643¨  Ý<0000000000ca2dea>¨ __do_softirq+0xf2/0x5c0
> 349.361652¨  Ý<0000000000152644>¨ irq_exit+0x104/0x130
> 349.361659¨  Ý<000000000010d222>¨ do_IRQ+0x9a/0xf0
> 349.361667¨  Ý<0000000000ca2344>¨ ext_int_handler+0x130/0x134
> 349.361674¨  Ý<0000000000103648>¨ enabled_wait+0x58/0x128
> 349.361681¨ (Ý<0000000000103634>¨ enabled_wait+0x44/0x128)
> 349.361688¨  Ý<0000000000103b00>¨ arch_cpu_idle+0x40/0x58
> 349.361695¨  Ý<0000000000ca0544>¨ default_idle_call+0x3c/0x68
> 349.361704¨  Ý<000000000018eaa4>¨ do_idle+0xec/0x1c0
> 349.361748¨  Ý<000000000018ee0e>¨ cpu_startup_entry+0x36/0x40
> 349.361756¨  Ý<000000000122df34>¨ arch_call_rest_init+0x5c/0x88
> 349.361761¨  Ý<0000000000000000>¨ 0x0
> 349.361765¨ INFO: lockdep is turned off.
> 349.361769¨ Last Breaking-Event-Address:
> 349.361774¨  Ý<00000000003ca8f4>¨ __free_slab+0x1c4/0x6b0
> 349.361781¨ Kernel panic - not syncing: Fatal exception in interrupt
> 
> The kernel panics on an attempt to dereference the NULL memcg pointer.
> When shutdown_cache() is called from the kmem_cache_destroy() context,
> a memcg kmem_cache might have empty slab pages in a partial list,
> which are still charged to the memory cgroup. These pages are released
> by free_partial() at the beginning of shutdown_cache(): either
> directly or by scheduling a RCU-delayed work (if the kmem_cache has
> the SLAB_TYPESAFE_BY_RCU flag). The latter case is when the reported
> panic can happen: memcg_unlink_cache() is called immediately after
> shrinking partial lists, without waiting for scheduled RCU works.
> It sets the kmem_cache->memcg_params.memcg pointer to NULL,
> and the following attempt to dereference it by __free_slab()
> from the RCU work context causes the panic.
> 
> To fix the issue, let's postpone the release of the memcg pointer
> to destroy_memcg_params(). It's called from a separate work context
> by slab_caches_to_rcu_destroy_workfn(), which contains a full RCU
> barrier. This guarantees that all scheduled page release RCU works
> will complete before the memcg pointer will be zeroed.
> 
> Big thanks for Karsten for the perfect report containing all necessary
> information, his help with the analysis of the problem and testing
> of the fix.
> 
> Fixes: fb2f2b0adb98 ("mm: memcg/slab: reparent memcg kmem_caches on cgroup removal")
> Reported-by: Karsten Graul <kgraul@linux.ibm.com>
> Tested-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: stable@vger.kernel.org

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/slab_common.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 0b94a37da531..8afa188f6e20 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -178,10 +178,13 @@ static int init_memcg_params(struct kmem_cache *s,
>  
>  static void destroy_memcg_params(struct kmem_cache *s)
>  {
> -	if (is_root_cache(s))
> +	if (is_root_cache(s)) {
>  		kvfree(rcu_access_pointer(s->memcg_params.memcg_caches));
> -	else
> +	} else {
> +		mem_cgroup_put(s->memcg_params.memcg);
> +		WRITE_ONCE(s->memcg_params.memcg, NULL);
>  		percpu_ref_exit(&s->memcg_params.refcnt);
> +	}
>  }
>  
>  static void free_memcg_params(struct rcu_head *rcu)
> @@ -253,8 +256,6 @@ static void memcg_unlink_cache(struct kmem_cache *s)
>  	} else {
>  		list_del(&s->memcg_params.children_node);
>  		list_del(&s->memcg_params.kmem_caches_node);
> -		mem_cgroup_put(s->memcg_params.memcg);
> -		WRITE_ONCE(s->memcg_params.memcg, NULL);
>  	}
>  }
>  #else
> 

