Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A0394BF7
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 19:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfHSRph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 13:45:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:42508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbfHSRph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 13:45:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9441AE78;
        Mon, 19 Aug 2019 17:45:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 22F1EDA7DA; Mon, 19 Aug 2019 19:46:01 +0200 (CEST)
Date:   Mon, 19 Aug 2019 19:46:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix allocation of bitmap pages.
Message-ID: <20190819174600.GN24086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Christophe Leroy <christophe.leroy@c-s.fr>, erhard_f@mailbox.org,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20190817074439.84C6C1056A3@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817074439.84C6C1056A3@localhost.localdomain>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 07:44:39AM +0000, Christophe Leroy wrote:
> Various notifications of type "BUG kmalloc-4096 () : Redzone
> overwritten" have been observed recently in various parts of
> the kernel. After some time, it has been made a relation with
> the use of BTRFS filesystem.
> 
> [   22.809700] BUG kmalloc-4096 (Tainted: G        W        ): Redzone overwritten
> [   22.809971] -----------------------------------------------------------------------------
> 
> [   22.810286] INFO: 0xbe1a5921-0xfbfc06cd. First byte 0x0 instead of 0xcc
> [   22.810866] INFO: Allocated in __load_free_space_cache+0x588/0x780 [btrfs] age=22 cpu=0 pid=224
> [   22.811193] 	__slab_alloc.constprop.26+0x44/0x70
> [   22.811345] 	kmem_cache_alloc_trace+0xf0/0x2ec
> [   22.811588] 	__load_free_space_cache+0x588/0x780 [btrfs]
> [   22.811848] 	load_free_space_cache+0xf4/0x1b0 [btrfs]
> [   22.812090] 	cache_block_group+0x1d0/0x3d0 [btrfs]
> [   22.812321] 	find_free_extent+0x680/0x12a4 [btrfs]
> [   22.812549] 	btrfs_reserve_extent+0xec/0x220 [btrfs]
> [   22.812785] 	btrfs_alloc_tree_block+0x178/0x5f4 [btrfs]
> [   22.813032] 	__btrfs_cow_block+0x150/0x5d4 [btrfs]
> [   22.813262] 	btrfs_cow_block+0x194/0x298 [btrfs]
> [   22.813484] 	commit_cowonly_roots+0x44/0x294 [btrfs]
> [   22.813718] 	btrfs_commit_transaction+0x63c/0xc0c [btrfs]
> [   22.813973] 	close_ctree+0xf8/0x2a4 [btrfs]
> [   22.814107] 	generic_shutdown_super+0x80/0x110
> [   22.814250] 	kill_anon_super+0x18/0x30
> [   22.814437] 	btrfs_kill_super+0x18/0x90 [btrfs]
> [   22.814590] INFO: Freed in proc_cgroup_show+0xc0/0x248 age=41 cpu=0 pid=83
> [   22.814841] 	proc_cgroup_show+0xc0/0x248
> [   22.814967] 	proc_single_show+0x54/0x98
> [   22.815086] 	seq_read+0x278/0x45c
> [   22.815190] 	__vfs_read+0x28/0x17c
> [   22.815289] 	vfs_read+0xa8/0x14c
> [   22.815381] 	ksys_read+0x50/0x94
> [   22.815475] 	ret_from_syscall+0x0/0x38
> 
> Commit 69d2480456d1 ("btrfs: use copy_page for copying pages instead
> of memcpy") changed the way bitmap blocks are copied. But allthough
> bitmaps have the size of a page, they were allocated with kzalloc().
> 
> Most of the time, kzalloc() allocates aligned blocks of memory, so
> copy_page() can be used. But when some debug options like SLAB_DEBUG
> are activated, kzalloc() may return unaligned pointer.
> 
> On powerpc, memcpy(), copy_page() and other copying functions use
> 'dcbz' instruction which provides an entire zeroed cacheline to avoid
> memory read when the intention is to overwrite a full line. Functions
> like memcpy() are writen to care about partial cachelines at the start
> and end of the destination, but copy_page() assumes it gets pages.

This assumption is not documented nor any pitfalls mentioned in
include/asm-generic/page.h that provides the generic implementation. I
as an API user cannot check each arch implementation for additional
constraints or I would expect that it deals with the boundary cases the
same way as arch-specific memcpy implementations.

Another thing that is lost is the slub debugging support for all
architectures, because get_zeroed_pages lacking the red zones and sanity
checks.

I find working with raw pages in this code a bit inconsistent with the
rest of btrfs code, but that's rather minor compared to the above.

Summing it up, I think that the proper fix should go to copy_page
implementation on architectures that require it or make it clear what
are the copy_page constraints.
