Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4564A2D6EE3
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 04:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395204AbgLKDt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 22:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392246AbgLKDtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 22:49:11 -0500
Date:   Thu, 10 Dec 2020 19:48:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607658510;
        bh=Br3yuvlVdobQPxlXHKs4wQB/cIvXf86koFgZ9Pt0j/I=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=CeGmuBGmrNQ0UgfHF4HrDRwl+Z2xompa+zzA01sr1fHrJH6pXEjy0OcNodFXvaQDs
         nBAsfbqsvdSysp5a5L1nXGMxK0fowJ2oWqCF0VPlXFUKYHwDijXED02ekeHFhFwsHM
         japuICgQFbL95/FOmfFkpu6OJyKASc35G1hpzX9X8gIXUsNBuY9+7oH+WMltQMh4Jy
         wJsMHwVAb3Wl3bWR0abtoXa8Wn1xltBwUxS6qVvDbDj3JoRynjZ5BvWVVZzgQjH4pt
         /ePYcokVHvuGgWTsVOBXIZAL9emokM26HL7LVZU9gTbqm96ngwbLmxpG5LdS6eo/1w
         dcGcOYcSnctKQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] ext4 fscrypt_get_encryption_info() circular locking
 dependency
Message-ID: <X9LsDPsXdLNv0+va@sol.localdomain>
References: <20201211033657.GE1667627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211033657.GE1667627@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 12:36:57PM +0900, Sergey Senozhatsky wrote:
> Hi,
> 
> I got the following lockdep splat the other day, while running some
> tests on 4.19. I didn't test other stable kernels, but it seems that
> 5.4 should also have similar problem.
> 
> As far as I can tell, ext4_dir_open() has been removed quite recently:
> https://www.mail-archive.com/linux-f2fs-devel@lists.sourceforge.net/msg18727.html
> 
> Eric, Ted, Jaegeuk, how difficult would it be to remove ext4_dir_open()
> from the stable kernels? (I'm interested in ext4 in particular, I
> understand that other filesystems may also need similar patches)
> 
> 
> 
> [  133.454721] kswapd0/79 is trying to acquire lock:
> [  133.454724] 00000000a815a55f (jbd2_handle){++++}, at: start_this_handle+0x1f9/0x859
> [  133.454730]                     
>                but task is already holding lock:
> [  133.454731] 00000000106bd5a3 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x2f
> [  133.454736]                         
>                which lock already depends on the new lock.
> 
> [  133.454739] 
>                the existing dependency chain (in reverse order) is:
> [  133.454740] 
>                -> #2 (fs_reclaim){+.+.}:
> [  133.454745]        kmem_cache_alloc_trace+0x44/0x28b
> [  133.454748]        mempool_create_node+0x46/0x92
> [  133.454750]        fscrypt_initialize+0xa0/0xbf
> [  133.454752]        fscrypt_get_encryption_info+0xa4/0x774
> [  133.454754]        ext4_dir_open+0x1b/0x2d
> [  133.454757]        do_dentry_open+0x144/0x36d
> [  133.454759]        path_openat+0x2d7/0x156d
> [  133.454762]        do_filp_open+0x97/0x13e
> [  133.454764]        do_sys_open+0x128/0x3a3
> [  133.454766]        do_syscall_64+0x6f/0x22a
> [  133.454769]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  133.454771] 
>                -> #1 (fscrypt_init_mutex){+.+.}:
> [  133.454774]        mutex_lock_nested+0x20/0x26
> [  133.454776]        fscrypt_initialize+0x20/0xbf
> [  133.454778]        fscrypt_get_encryption_info+0xa4/0x774
> [  133.454780]        fscrypt_inherit_context+0xbe/0xe6
> [  133.454782]        __ext4_new_inode+0x11ee/0x1631
> [  133.454785]        ext4_mkdir+0x112/0x416
> [  133.454787]        vfs_mkdir2+0x135/0x1c6
> [  133.454789]        do_mkdirat+0xc3/0x138
> [  133.454791]        do_syscall_64+0x6f/0x22a
> [  133.454793]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  133.454795] 
>                -> #0 (jbd2_handle){++++}:
> [  133.454798]        start_this_handle+0x21c/0x859
> [  133.454800]        jbd2__journal_start+0xa2/0x282
> [  133.454802]        ext4_release_dquot+0x58/0x93
> [  133.454804]        dqput+0x196/0x1ec
> [  133.454806]        __dquot_drop+0x8d/0xb2
> [  133.454809]        ext4_clear_inode+0x22/0x8c
> [  133.454811]        ext4_evict_inode+0x127/0x662
> [  133.454813]        evict+0xc0/0x241
> [  133.454816]        dispose_list+0x36/0x54
> [  133.454818]        prune_icache_sb+0x56/0x76
> [  133.454820]        super_cache_scan+0x13a/0x19c
> [  133.454822]        shrink_slab+0x39a/0x572
> [  133.454824]        shrink_node+0x3f8/0x63b
> [  133.454826]        balance_pgdat+0x1bd/0x326
> [  133.454828]        kswapd+0x2ad/0x510
> [  133.454831]        kthread+0x14d/0x155
> [  133.454833]        ret_from_fork+0x24/0x50
> [  133.454834] 
>                other info that might help us debug this:
> 
> [  133.454836] Chain exists of:
>                  jbd2_handle --> fscrypt_init_mutex --> fs_reclaim
> 
> [  133.454840]  Possible unsafe locking scenario:
> 
> [  133.454841]        CPU0                    CPU1
> [  133.454843]        ----                    ----
> [  133.454844]   lock(fs_reclaim);
> [  133.454846]                                lock(fscrypt_init_mutex);
> [  133.454848]                                lock(fs_reclaim);
> [  133.454850]   lock(jbd2_handle);
> [  133.454851] 

This actually got fixed by the patch series
https://lkml.kernel.org/linux-fscrypt/20200913083620.170627-1-ebiggers@kernel.org/
which went into 5.10.  The more recent patch to remove ext4_dir_open() isn't
related.

It's a hard patch series to backport.  Backporting it to 5.4 would be somewhat
feasible, while 4.19 would be very difficult as there have been a lot of other
fscrypt commits which would heavily conflict with cherry-picks.

How interested are you in having this fixed?  Did you encounter an actual
deadlock or just the lockdep report?

- Eric
