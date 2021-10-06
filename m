Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C8D42435A
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhJFQwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 12:52:06 -0400
Received: from cmyk.emenem.pl ([217.79.154.63]:34220 "EHLO smtp.emenem.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231528AbhJFQwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 12:52:06 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 12:52:05 EDT
X-Virus-Scanned: amavisd-new at emenem.pl
Received: from [192.168.1.10] (50-78-106-33-static.hfc.comcastbusiness.net [50.78.106.33])
        (authenticated bits=0)
        by cmyk.emenem.pl (8.17.1/8.17.1) with ESMTPSA id 196GKUd3031686
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 6 Oct 2021 18:20:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ans.pl; s=20190507;
        t=1633537232; bh=iZYJajBI7qo+fWZS+OrO7LAOIR9dOIbM1re9x+FMGjQ=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=TNLPpF50c/puVi57OTdu/2c8+g74bBU16WvDYB+cmAtguDCxSEMMpVpFfL6jj9Hzb
         Lxpvkvo1qXvBAVMnZKYt1ROW3tqZaTzXDcJPcBxsqY9cWcaer4JYlHjZrwLQvZ4EAv
         ko4yAMLwNiaDMicjDwVfGqvbK6ZuyvfUUf5UOJLM=
Subject: Re: Backporting "silence nfscache allocation warnings with kvzalloc"
 - 8c38b705b4f4ca4e7f9cc116141bc38391917c30 into 5.4-stable and potentially
 older stable kernels?
From:   =?UTF-8?Q?Krzysztof_Ol=c4=99dzki?= <ole@ans.pl>
To:     stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Rik van Riel <riel@surriel.com>
References: <c510950d-6755-3c1e-4703-e224abaf3566@ans.pl>
Message-ID: <2eb2d5f5-c00d-9c24-ce38-20df150f05e3@ans.pl>
Date:   Wed, 6 Oct 2021 09:20:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c510950d-6755-3c1e-4703-e224abaf3566@ans.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(re-sent with the proper stable@ address)

On 2021-06-10 at 16:37, Krzysztof Olędzki wrote:
> Hi,
> 
> I noticed sporadic "page allocation failure" errors in my systems
> running 5.4-stable kernels, that look like this:
> 
> [1530107.418557] emerge: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0
> [1530107.418575] CPU: 7 PID: 673 Comm: emerge Not tainted 5.4.121-o3 #1
> [1530107.418576] Hardware name: Dell Inc. PowerEdge T110 II/0PM2CW, BIOS 2.10.0 05/24/2018
> [1530107.418577] Call Trace:
> [1530107.418585]  dump_stack+0x50/0x63
> [1530107.418589]  warn_alloc+0xde/0x15c
> [1530107.418591]  __alloc_pages_slowpath+0x759/0x786
> [1530107.418594]  ? kernfs_add_one+0xf6/0x10d
> [1530107.418597]  ? preempt_latency_start+0x2b/0x3e
> [1530107.418600]  ? ida_alloc_range+0x2bc/0x378
> [1530107.418602]  __alloc_pages_nodemask+0x17d/0x243
> [1530107.418605]  kmalloc_order+0x1b/0x69
> [1530107.418607]  kmalloc_order_trace+0x18/0xa1
> [1530107.418609]  nfsd_reply_cache_init+0xae/0x13a
> [1530107.418612]  nfsd_init_net+0x66/0xfe
> [1530107.418615]  ops_init+0xa9/0xd5
> [1530107.418617]  setup_net+0xb3/0x19b
> [1530107.418619]  copy_net_ns+0xec/0x140
> [1530107.418621]  create_new_namespaces+0x125/0x19a
> [1530107.418623]  unshare_nsproxy_namespaces+0x86/0x9c
> [1530107.418626]  ksys_unshare+0x14b/0x2e3
> [1530107.418628]  __x64_sys_unshare+0x9/0xc
> [1530107.418630]  do_syscall_64+0x72/0x7f
> [1530107.418633]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [1530107.418636] RIP: 0033:0x7f47d7161f97
> [1530107.418638] Code: 73 01 c3 48 8b 0d d1 fe 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 fe 0b 00 f7 d8 64 89 01 48
> [1530107.418639] RSP: 002b:00007ffd9a1f61f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> [1530107.418641] RAX: ffffffffffffffda RBX: 00007ffd9a1f6200 RCX: 00007f47d7161f97
> [1530107.418642] RDX: 0000000000000000 RSI: 00007f47c95d2800 RDI: 000000006c020000
> [1530107.418643] RBP: 00007ffd9a1f6200 R08: 0000000000000000 R09: 00007ffd9a1f6250
> [1530107.418643] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd9a1f6348
> [1530107.418644] R13: 0000000000000000 R14: 00007ffd9a1f62c0 R15: 00007ffd9a1f6328
> [1530107.418646] Mem-Info:
> [1530107.418650] active_anon:507099 inactive_anon:153606 isolated_anon:0
>                    active_file:2413575 inactive_file:4701878 isolated_file:0
>                    unevictable:2557 dirty:2354 writeback:0 unstable:0
>                    slab_reclaimable:275977 slab_unreclaimable:23789
>                    mapped:27516 shmem:12726 pagetables:5087 bounce:0
>                    free:83786 free_pcp:0 free_cma:0
> [1530107.418653] Node 0 active_anon:2028396kB inactive_anon:614424kB active_file:9654300kB inactive_file:18807512kB unevictable:10228kB isolated(anon):0kB isolated(file):0kB mapped:110064kB dirty:9416kB writeback:0kB shmem:50904kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> [1530107.418656] DMA free:15888kB min:8kB low:20kB high:32kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15988kB managed:15904kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [1530107.418657] lowmem_reserve[]: 0 2422 32068 32068
> [1530107.418661] DMA32 free:248688kB min:1728kB low:4208kB high:6688kB active_anon:94588kB inactive_anon:108056kB active_file:976696kB inactive_file:792500kB unevictable:104kB writepending:2744kB present:2574428kB managed:2549240kB mlocked:104kB kernel_stack:192kB pagetables:968kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [1530107.418662] lowmem_reserve[]: 0 0 29645 29645
> [1530107.418666] Normal free:70568kB min:21180kB low:51536kB high:81892kB active_anon:1934340kB inactive_anon:506132kB active_file:8677844kB inactive_file:18015144kB unevictable:10124kB writepending:6672kB present:30932992kB managed:30357820kB mlocked:10124kB kernel_stack:5732kB pagetables:19380kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [1530107.418666] lowmem_reserve[]: 0 0 0 0
> [1530107.418668] DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15888kB
> [1530107.418674] DMA32: 10702*4kB (UME) 3914*8kB (UME) 4900*16kB (UME) 1794*32kB (UME) 623*64kB (UM) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 249800kB
> [1530107.418680] Normal: 1795*4kB (UMEH) 635*8kB (UMEH) 284*16kB (UMH) 297*32kB (UMEH) 703*64kB (MEH) 3*128kB (H) 0*256kB 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 72196kB
> [1530107.418687] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> [1530107.418688] 7129905 total pagecache pages
> [1530107.418690] 13 pages in swap cache
> [1530107.418691] Swap cache stats: add 121, delete 108, find 15/20
> [1530107.418692] Free swap  = 4191732kB
> [1530107.418692] Total swap = 4193276kB
> [1530107.418693] 8380852 pages RAM
> [1530107.418694] 0 pages HighMem/MovableOnly
> [1530107.418694] 150111 pages reserved
> 
> If I'm not mistaken, 5.10 and newer kernels have a fix for this:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c38b705b4f4ca4e7f9cc116141bc38391917c30
> 
> I wonder if it would be possible to include it in 5.4-stable and potentially older stable kernels?
> 
>  From 8c38b705b4f4ca4e7f9cc116141bc38391917c30 Mon Sep 17 00:00:00 2001
> From: Rik van Riel <riel@surriel.com>
> Date: Mon, 14 Sep 2020 13:07:19 -0400
> Subject: silence nfscache allocation warnings with kvzalloc
> 
> silence nfscache allocation warnings with kvzalloc
> 
> Currently nfsd_reply_cache_init attempts hash table allocation through
> kmalloc, and manually falls back to vzalloc if that fails. This makes
> the code a little larger than needed, and creates a significant amount
> of serial console spam if you have enough systems.
> 
> Switching to kvzalloc gets rid of the allocation warnings, and makes
> the code a little cleaner too as a side effect.
> 
> Freeing of nn->drc_hashtbl is already done using kvfree currently.
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> ---
>   fs/nfsd/nfscache.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
> index 0a0cf1fd77d33..80c90fc231a53 100644
> --- a/fs/nfsd/nfscache.c
> +++ b/fs/nfsd/nfscache.c
> @@ -172,14 +172,10 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
>   	if (status)
>   		goto out_nomem;
>   
> -	nn->drc_hashtbl = kcalloc(hashsize,
> -				sizeof(*nn->drc_hashtbl), GFP_KERNEL);
> -	if (!nn->drc_hashtbl) {
> -		nn->drc_hashtbl = vzalloc(array_size(hashsize,
> -						 sizeof(*nn->drc_hashtbl)));
> -		if (!nn->drc_hashtbl)
> -			goto out_shrinker;
> -	}
> +	nn->drc_hashtbl = kvzalloc(array_size(hashsize,
> +				sizeof(*nn->drc_hashtbl)), GFP_KERNEL);
> +	if (!nn->drc_hashtbl)
> +		goto out_shrinker;
>   
>   	for (i = 0; i < hashsize; i++) {
>   		INIT_LIST_HEAD(&nn->drc_hashtbl[i].lru_head);
> 

