Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D1D2D6EBC
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 04:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393948AbgLKDho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 22:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405283AbgLKDhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 22:37:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AC9C061793;
        Thu, 10 Dec 2020 19:37:01 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 131so6131535pfb.9;
        Thu, 10 Dec 2020 19:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=R12bHnWBmJ0j0CINJvbpAaTQaDqQwRyP5m4ckzxJ3/g=;
        b=pYfcgNE5kDvbZdEUj4L6w4HrvfKS+EyxYf8j27B2Z/WB5OGaGZ92OR5Oh4UMjHWhiX
         wzX+xPxHtBevQX5OMegd2yfqVyhhuRnJBUSUeoYTPaCgsb8zMnTz1VsPRlYUC1XS3KML
         tRod2w7KvokY4lzfpWhuaShAdKut2cOOFg1RqUBTrDK2f0i83hXzHJGGi7rav2vTz+wl
         PFJHqMvC8Jd5nJFMsuAJLtnzSmx2MUmD+KSp4RLmDgUVWgVYwYe6bwv1PU6dA9GQ6lIO
         8s8xEVAIbCfBYEXSrLj9qUoojf5V9GevZpaaZ1Lpa9phNu58paS0Bb5AvMQK31sSq9YD
         7SGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=R12bHnWBmJ0j0CINJvbpAaTQaDqQwRyP5m4ckzxJ3/g=;
        b=MoZT+5d8ROAG/cq7FmKNl7DjkC4JxQoqL5XDtCj878SOs5+yFu75ez4gBqAFnj++Bm
         BaRmwdx6DaNLclnMtZcI6iu04lml0OH4xzsAVoyiipU5twnWd0VvQgCmoakLF4Gav7Ok
         Iq8TtMdC+UeOYbPj4gFwP7SpMi2KExzFb3mBqzIinvurItotktWdRagNgUSY8NWeiHaH
         10jLomqk/Ysm7DoqCW/AmBN01Nt56sQn9VqOZE0JNpl+H8s1mmQ173a6yiIb8cm8Em8d
         ldFe8ELXa0MNsFcoJnRxh3sHEMGjqBpJs9aRkfKeeWkRkLVkLvzsQuVWLYgA59KQdVnF
         ixNg==
X-Gm-Message-State: AOAM530yVbJOWGDOIeLwF99jJN+XLYlRKVq8euiOuvO9KiisYt8dMTRL
        NhcOqJDIiAqUezE/WgIy6h8=
X-Google-Smtp-Source: ABdhPJxf6xOx4SKKMI1X4XnhhMpe1jPJRTzRyvOlzqLdbV5NlMgFodIGmC66awa3RWcuP3vaOagWww==
X-Received: by 2002:a63:5466:: with SMTP id e38mr9521389pgm.242.1607657821196;
        Thu, 10 Dec 2020 19:37:01 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:a6ae:11ff:fe11:4b46])
        by smtp.gmail.com with ESMTPSA id q23sm8257112pfg.18.2020.12.10.19.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 19:37:00 -0800 (PST)
Date:   Fri, 11 Dec 2020 12:36:57 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [stable] ext4 fscrypt_get_encryption_info() circular locking
 dependency
Message-ID: <20201211033657.GE1667627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I got the following lockdep splat the other day, while running some
tests on 4.19. I didn't test other stable kernels, but it seems that
5.4 should also have similar problem.

As far as I can tell, ext4_dir_open() has been removed quite recently:
https://www.mail-archive.com/linux-f2fs-devel@lists.sourceforge.net/msg18727.html

Eric, Ted, Jaegeuk, how difficult would it be to remove ext4_dir_open()
from the stable kernels? (I'm interested in ext4 in particular, I
understand that other filesystems may also need similar patches)



[  133.454721] kswapd0/79 is trying to acquire lock:
[  133.454724] 00000000a815a55f (jbd2_handle){++++}, at: start_this_handle+0x1f9/0x859
[  133.454730]                     
               but task is already holding lock:
[  133.454731] 00000000106bd5a3 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x2f
[  133.454736]                         
               which lock already depends on the new lock.

[  133.454739] 
               the existing dependency chain (in reverse order) is:
[  133.454740] 
               -> #2 (fs_reclaim){+.+.}:
[  133.454745]        kmem_cache_alloc_trace+0x44/0x28b
[  133.454748]        mempool_create_node+0x46/0x92
[  133.454750]        fscrypt_initialize+0xa0/0xbf
[  133.454752]        fscrypt_get_encryption_info+0xa4/0x774
[  133.454754]        ext4_dir_open+0x1b/0x2d
[  133.454757]        do_dentry_open+0x144/0x36d
[  133.454759]        path_openat+0x2d7/0x156d
[  133.454762]        do_filp_open+0x97/0x13e
[  133.454764]        do_sys_open+0x128/0x3a3
[  133.454766]        do_syscall_64+0x6f/0x22a
[  133.454769]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  133.454771] 
               -> #1 (fscrypt_init_mutex){+.+.}:
[  133.454774]        mutex_lock_nested+0x20/0x26
[  133.454776]        fscrypt_initialize+0x20/0xbf
[  133.454778]        fscrypt_get_encryption_info+0xa4/0x774
[  133.454780]        fscrypt_inherit_context+0xbe/0xe6
[  133.454782]        __ext4_new_inode+0x11ee/0x1631
[  133.454785]        ext4_mkdir+0x112/0x416
[  133.454787]        vfs_mkdir2+0x135/0x1c6
[  133.454789]        do_mkdirat+0xc3/0x138
[  133.454791]        do_syscall_64+0x6f/0x22a
[  133.454793]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  133.454795] 
               -> #0 (jbd2_handle){++++}:
[  133.454798]        start_this_handle+0x21c/0x859
[  133.454800]        jbd2__journal_start+0xa2/0x282
[  133.454802]        ext4_release_dquot+0x58/0x93
[  133.454804]        dqput+0x196/0x1ec
[  133.454806]        __dquot_drop+0x8d/0xb2
[  133.454809]        ext4_clear_inode+0x22/0x8c
[  133.454811]        ext4_evict_inode+0x127/0x662
[  133.454813]        evict+0xc0/0x241
[  133.454816]        dispose_list+0x36/0x54
[  133.454818]        prune_icache_sb+0x56/0x76
[  133.454820]        super_cache_scan+0x13a/0x19c
[  133.454822]        shrink_slab+0x39a/0x572
[  133.454824]        shrink_node+0x3f8/0x63b
[  133.454826]        balance_pgdat+0x1bd/0x326
[  133.454828]        kswapd+0x2ad/0x510
[  133.454831]        kthread+0x14d/0x155
[  133.454833]        ret_from_fork+0x24/0x50
[  133.454834] 
               other info that might help us debug this:

[  133.454836] Chain exists of:
                 jbd2_handle --> fscrypt_init_mutex --> fs_reclaim

[  133.454840]  Possible unsafe locking scenario:

[  133.454841]        CPU0                    CPU1
[  133.454843]        ----                    ----
[  133.454844]   lock(fs_reclaim);
[  133.454846]                                lock(fscrypt_init_mutex);
[  133.454848]                                lock(fs_reclaim);
[  133.454850]   lock(jbd2_handle);
[  133.454851] 
                *** DEADLOCK ***

[  133.454854] 3 locks held by kswapd0/79:
[  133.454855]  #0: 00000000106bd5a3 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x2f
[  133.454859]  #1: 00000000c230047b (shrinker_rwsem){++++}, at: shrink_slab+0x3b/0x572
[  133.454862]  #2: 00000000ce797452 (&type->s_umount_key#45){++++}, at: trylock_super+0x1b/0x47
[  133.454866] 
               stack backtrace:
[  133.454869] CPU: 6 PID: 79 Comm: kswapd0 Not tainted 4.19.161 #43
[  133.454872] Call Trace:
[  133.454877]  dump_stack+0xbd/0x11d
[  133.454880]  ? print_circular_bug+0x2c1/0x2d4
[  133.454883]  __lock_acquire+0x1977/0x1981
[  133.454886]  ? start_this_handle+0x1f9/0x859
[  133.454888]  lock_acquire+0x1b7/0x202
[  133.454890]  ? start_this_handle+0x1f9/0x859
[  133.454893]  start_this_handle+0x21c/0x859
[  133.454895]  ? start_this_handle+0x1f9/0x859
[  133.454897]  ? kmem_cache_alloc+0x1d1/0x27d
[  133.454900]  jbd2__journal_start+0xa2/0x282
[  133.454902]  ? __ext4_journal_start_sb+0x10b/0x208
[  133.454905]  ext4_release_dquot+0x58/0x93
[  133.454907]  dqput+0x196/0x1ec
[  133.454909]  __dquot_drop+0x8d/0xb2
[  133.454912]  ? dquot_drop+0x27/0x43
[  133.454914]  ext4_clear_inode+0x22/0x8c
[  133.454917]  ext4_evict_inode+0x127/0x662
[  133.454920]  evict+0xc0/0x241
[  133.454923]  dispose_list+0x36/0x54
[  133.454926]  prune_icache_sb+0x56/0x76
[  133.454928]  super_cache_scan+0x13a/0x19c
[  133.454931]  shrink_slab+0x39a/0x572
[  133.454934]  shrink_node+0x3f8/0x63b
[  133.454938]  balance_pgdat+0x1bd/0x326
[  133.454941]  kswapd+0x2ad/0x510
[  133.454946]  ? init_wait_entry+0x2e/0x2e
[  133.454949]  kthread+0x14d/0x155
[  133.454951]  ? wakeup_kswapd+0x20d/0x20d
[  133.454953]  ? kthread_destroy_worker+0x62/0x62
[  133.454956]  ret_from_fork+0x24/0x50

	-ss
