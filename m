Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585D294F0F
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 22:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfHSUck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 16:32:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:31045 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfHSUcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 16:32:39 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46C5Fw5y57z9v0v5;
        Mon, 19 Aug 2019 22:32:36 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Uvrjz53e; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id N3v1S5YbD57A; Mon, 19 Aug 2019 22:32:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46C5Fw4SSCz9v0v4;
        Mon, 19 Aug 2019 22:32:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1566246756; bh=rMillmnFKS/ErlSfF4NLef5YT9zHq8E0WU7az2Rr9oI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Uvrjz53e6RbinKdej1jE3Cv2cdUooVoG4y2445VqjaYohvTV2KTqRVDPt1GAV9IbD
         KujZJsFGL9SsVlCLJM4fDQj0zOwPkOve7RiqKOnDgmvDLlQk986C/ak8/EkE+3YkpE
         E2K+iJgLEC0zTX+bllXHtbUf31L7RnMy9qfeIhmo=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4B2898B7BF;
        Mon, 19 Aug 2019 22:32:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id wIUA9py7n74G; Mon, 19 Aug 2019 22:32:37 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 669CB8B7B9;
        Mon, 19 Aug 2019 22:32:36 +0200 (CEST)
Subject: Re: [PATCH] btrfs: fix allocation of bitmap pages.
To:     dsterba@suse.cz, erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20190817074439.84C6C1056A3@localhost.localdomain>
 <20190819174600.GN24086@twin.jikos.cz>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <86e4d577-36f4-683d-9227-0e9b8f18d929@c-s.fr>
Date:   Mon, 19 Aug 2019 22:32:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819174600.GN24086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 19/08/2019 à 19:46, David Sterba a écrit :
> On Sat, Aug 17, 2019 at 07:44:39AM +0000, Christophe Leroy wrote:
>> Various notifications of type "BUG kmalloc-4096 () : Redzone
>> overwritten" have been observed recently in various parts of
>> the kernel. After some time, it has been made a relation with
>> the use of BTRFS filesystem.
>>
>> [   22.809700] BUG kmalloc-4096 (Tainted: G        W        ): Redzone overwritten
>> [   22.809971] -----------------------------------------------------------------------------
>>
>> [   22.810286] INFO: 0xbe1a5921-0xfbfc06cd. First byte 0x0 instead of 0xcc
>> [   22.810866] INFO: Allocated in __load_free_space_cache+0x588/0x780 [btrfs] age=22 cpu=0 pid=224
>> [   22.811193] 	__slab_alloc.constprop.26+0x44/0x70
>> [   22.811345] 	kmem_cache_alloc_trace+0xf0/0x2ec
>> [   22.811588] 	__load_free_space_cache+0x588/0x780 [btrfs]
>> [   22.811848] 	load_free_space_cache+0xf4/0x1b0 [btrfs]
>> [   22.812090] 	cache_block_group+0x1d0/0x3d0 [btrfs]
>> [   22.812321] 	find_free_extent+0x680/0x12a4 [btrfs]
>> [   22.812549] 	btrfs_reserve_extent+0xec/0x220 [btrfs]
>> [   22.812785] 	btrfs_alloc_tree_block+0x178/0x5f4 [btrfs]
>> [   22.813032] 	__btrfs_cow_block+0x150/0x5d4 [btrfs]
>> [   22.813262] 	btrfs_cow_block+0x194/0x298 [btrfs]
>> [   22.813484] 	commit_cowonly_roots+0x44/0x294 [btrfs]
>> [   22.813718] 	btrfs_commit_transaction+0x63c/0xc0c [btrfs]
>> [   22.813973] 	close_ctree+0xf8/0x2a4 [btrfs]
>> [   22.814107] 	generic_shutdown_super+0x80/0x110
>> [   22.814250] 	kill_anon_super+0x18/0x30
>> [   22.814437] 	btrfs_kill_super+0x18/0x90 [btrfs]
>> [   22.814590] INFO: Freed in proc_cgroup_show+0xc0/0x248 age=41 cpu=0 pid=83
>> [   22.814841] 	proc_cgroup_show+0xc0/0x248
>> [   22.814967] 	proc_single_show+0x54/0x98
>> [   22.815086] 	seq_read+0x278/0x45c
>> [   22.815190] 	__vfs_read+0x28/0x17c
>> [   22.815289] 	vfs_read+0xa8/0x14c
>> [   22.815381] 	ksys_read+0x50/0x94
>> [   22.815475] 	ret_from_syscall+0x0/0x38
>>
>> Commit 69d2480456d1 ("btrfs: use copy_page for copying pages instead
>> of memcpy") changed the way bitmap blocks are copied. But allthough
>> bitmaps have the size of a page, they were allocated with kzalloc().
>>
>> Most of the time, kzalloc() allocates aligned blocks of memory, so
>> copy_page() can be used. But when some debug options like SLAB_DEBUG
>> are activated, kzalloc() may return unaligned pointer.
>>
>> On powerpc, memcpy(), copy_page() and other copying functions use
>> 'dcbz' instruction which provides an entire zeroed cacheline to avoid
>> memory read when the intention is to overwrite a full line. Functions
>> like memcpy() are writen to care about partial cachelines at the start
>> and end of the destination, but copy_page() assumes it gets pages.
> 
> This assumption is not documented nor any pitfalls mentioned in
> include/asm-generic/page.h that provides the generic implementation. I
> as an API user cannot check each arch implementation for additional
> constraints or I would expect that it deals with the boundary cases the
> same way as arch-specific memcpy implementations.

For me, copy_page() is there to ... copy pages. Not to copy any piece of 
RAM having the size of a page.

But it happened to others. See commit 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d72e9a7a93e4f8e9e52491921d99e0c8aa89eb4e

> 
> Another thing that is lost is the slub debugging support for all
> architectures, because get_zeroed_pages lacking the red zones and sanity
> checks.
> 
> I find working with raw pages in this code a bit inconsistent with the
> rest of btrfs code, but that's rather minor compared to the above.

What about using kmem_cache instead ? I see kmem_cache is already widely 
used in BTRFS, so using it also for block of memory of size PAGE_SIZE 
should be ok ?

AFAICS, kmem_cache has the red zones and sanity checks.

> 
> Summing it up, I think that the proper fix should go to copy_page
> implementation on architectures that require it or make it clear what
> are the copy_page constraints.
> 

I guess anybody using copy_page() to copy something else than a page is 
on his/her own.

But following that (bad) experience, I propose a patch to at least 
detect it early, see https://patchwork.ozlabs.org/patch/1148033/

Christophe
