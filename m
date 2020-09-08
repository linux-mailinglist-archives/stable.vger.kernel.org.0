Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282E1261752
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIHRbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731746AbgIHRbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 13:31:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D61F20738;
        Tue,  8 Sep 2020 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599586261;
        bh=Ab6EA6ceLAz7RJxJePWU1hmFTBIR4uJTxutFsHvQBSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CW//NNFIH//LBxRHG+UNXHCrX3gxDiebGnZBRTi5MmZfJMd+AkAHnI+aB1pQ3aTeG
         2KaiMY8E3N4SFApa9G+6FVQw8Oi1DLIhN5PxBuG475TS1sUXQEmHtiv4JIUvxZatal
         kv5ZxcyeAdJT/CLFyrino5XTWIcl5ITMrFS0J+Qo=
Date:   Tue, 8 Sep 2020 19:31:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, david@redhat.com, salvador@suse.de,
        rafael@kernel.org, nathanl@linux.ibm.com, mhocko@kernel.org,
        cheloha@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200908173113.GB218801@kroah.com>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200908170835.85440-1-ldufour@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 07:08:35PM +0200, Laurent Dufour wrote:
> In register_mem_sect_under_node() the system_state’s value is checked to
> detect whether the operation the call is made during boot time or during an
> hot-plug operation. Unfortunately, that check is wrong on some
> architecture, and may lead to sections being registered under multiple
> nodes if node's memory ranges are interleaved.
> 
> This can be seen on PowerPC LPAR after multiple memory hot-plug and
> hot-unplug operations are done. At the next reboot the node's memory ranges
> can be interleaved and since the call to link_mem_sections() is made in
> topology_init() while the system is in the SYSTEM_SCHEDULING state, the
> node's id is not checked, and the sections registered multiple times. In
> that case, the system is able to boot but later hot-plug operation may lead
> to this panic because the node's links are correctly broken:
> 
> ------------[ cut here ]------------
> kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
> Oops: Exception in kernel mode, sig: 5 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
> CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
> NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
> REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
> MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
> CFAR: c000000000846d20 IRQMASK: 0
> GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
> GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
> GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
> GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
> GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
> GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
> GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
> GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
> NIP [c000000000403f34] add_memory_resource+0x244/0x340
> LR [c000000000403f2c] add_memory_resource+0x23c/0x340
> Call Trace:
> [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
> [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
> [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
> [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
> [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
> [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
> [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
> [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
> [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
> [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
> [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
> [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
> [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
> Instruction dump:
> 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
> 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
> ---[ end trace 562fd6c109cd0fb2 ]---
> 
> This patch addresses the root cause by not relying on the system_state
> value to detect whether the call is due to a hot-plug operation or not. An
> additional parameter is added to link_mem_sections() to tell the context of
> the call and this parameter is propagated to register_mem_sect_under_node()
> throuugh the walk_memory_blocks()'s call.
> 
> Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/base/node.c  | 20 +++++++++++++++-----
>  include/linux/node.h |  6 +++---
>  mm/memory_hotplug.c  |  3 ++-
>  3 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 508b80f6329b..27f828eeb531 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -762,14 +762,19 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>  }
>  
>  /* register memory section under specified node if it spans that node */
> +struct rmsun_args {
> +	int	nid;
> +	bool	hotadd;
> +};
>  static int register_mem_sect_under_node(struct memory_block *mem_blk,
> -					 void *arg)
> +					void *args)
>  {
>  	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
>  	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
>  	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
> -	int ret, nid = *(int *)arg;
> +	int ret, nid = ((struct rmsun_args *)args)->nid;
>  	unsigned long pfn;
> +	bool hotadd = ((struct rmsun_args *)args)->hotadd;
>  
>  	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
>  		int page_nid;
> @@ -789,7 +794,7 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
>  		 * case, during hotplug we know that all pages in the memory
>  		 * block belong to the same node.
>  		 */
> -		if (system_state == SYSTEM_BOOTING) {
> +		if (!hotadd) {
>  			page_nid = get_nid_for_pfn(pfn);
>  			if (page_nid < 0)
>  				continue;
> @@ -832,10 +837,15 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
>  			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
>  }
>  
> -int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
> +int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
> +		      bool hotadd)
>  {
> +	struct rmsun_args args;
> +
> +	args.nid = nid;
> +	args.hotadd = hotadd;
>  	return walk_memory_blocks(PFN_PHYS(start_pfn),
> -				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
> +				  PFN_PHYS(end_pfn - start_pfn), (void *)&args,
>  				  register_mem_sect_under_node);
>  }
>  
> diff --git a/include/linux/node.h b/include/linux/node.h
> index 4866f32a02d8..6df9a4548650 100644
> --- a/include/linux/node.h
> +++ b/include/linux/node.h
> @@ -100,10 +100,10 @@ typedef  void (*node_registration_func_t)(struct node *);
>  
>  #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
>  extern int link_mem_sections(int nid, unsigned long start_pfn,
> -			     unsigned long end_pfn);
> +			     unsigned long end_pfn, bool hotadd);
>  #else
>  static inline int link_mem_sections(int nid, unsigned long start_pfn,
> -				    unsigned long end_pfn)
> +				    unsigned long end_pfn, bool hotadd)

Adding a random boolean flag to a function is a horrible way to do
anything.

Now you need to look up what that flag means every time you run across a
caller, breaking your reading of what is happening.

Make this two different functions please, that describe what they do,
and have them call a common "helper function" that does the work with
the flag if you really want to do this type of thing.

link_mem_sections() and link_mem_sections_hotadd()?

But not this way, please no.

thanks,

greg k-h
