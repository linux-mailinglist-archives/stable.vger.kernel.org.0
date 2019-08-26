Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4C9D321
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfHZPk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:40:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:52854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730499AbfHZPk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 11:40:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6E3DAFFE;
        Mon, 26 Aug 2019 15:40:26 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: fix allocation of bitmap pages.
To:     dsterba@suse.cz, Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <c3157c8e8e0e7588312b40c853f65c02fe6c957a.1566399731.git.christophe.leroy@c-s.fr>
 <20190826153757.GW2752@twin.jikos.cz>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a096d653-8b64-be15-3e81-581536a88e8a@suse.com>
Date:   Mon, 26 Aug 2019 18:40:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826153757.GW2752@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 26.08.19 г. 18:37 ч., David Sterba wrote:
> On Wed, Aug 21, 2019 at 03:05:55PM +0000, Christophe Leroy wrote:
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
>> and end of the destination, but copy_page() assumes it gets pages. As
>> pages are naturally cache aligned, copy_page() doesn't care about
>> partial lines. This means that when copy_page() is called with a
>> misaligned pointer, a few leading bytes are zeroed.
>>
>> To fix it, allocate bitmaps through kmem_cache instead of using kzalloc()
>> The cache pool is created with PAGE_SIZE alignment constraint.
>>
>> Reported-by: Erhard F. <erhard_f@mailbox.org>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=204371
>> Fixes: 69d2480456d1 ("btrfs: use copy_page for copying pages instead of memcpy")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> ---
>> v2: Using kmem_cache instead of get_zeroed_page() in order to benefit from SLAB debugging features like redzone.
> 
> I'll take this version, thanks. Though I'm not happy about the allocator
> behaviour. The kmem cache based fix can be backported independently to
> 4.19 regardless of the SL*B fixes.
> 
>> +extern struct kmem_cache *btrfs_bitmap_cachep;
> 
> I've renamed the cache to btrfs_free_space_bitmap_cachep
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Isn't this obsoleted by

'[PATCH v2 0/2] guarantee natural alignment for kmalloc()' ?

> 
