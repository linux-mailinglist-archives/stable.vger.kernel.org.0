Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C127A61EE9A
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiKGJSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKGJSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:18:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FA615A23
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 01:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6037460F7C
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C64EC433D6;
        Mon,  7 Nov 2022 09:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667812665;
        bh=n6c4IktYspCdt9nKfSThCDwsNgJdRBiLbZ7KhgVsTY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OvU1+rsnihrRvwMQpCaVYZGK6/UlSXtuBJ6jUJt1a/8uc4Fu1pT7A9Wm0tO9Yhz9V
         0lGXo7EU9ulaTAO9YI2rLdSDZ05dYE/zNYyaOE8tznEwaHPIeOHDPTuAEkGrcO2z7x
         4+/PizdIAig6JDeTHC0dQPjkqw9ZgXBNCsXnLQWo=
Date:   Mon, 7 Nov 2022 10:17:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        kernel-team@android.com, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: [PATCH 5.10] binder: fix UAF of alloc->vma in race with munmap()
Message-ID: <Y2jNMfMRfQOxHOOg@kroah.com>
References: <20221104175450.306810-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104175450.306810-1-cmllamas@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 05:54:49PM +0000, Carlos Llamas wrote:
> In commit 720c24192404 ("ANDROID: binder: change down_write to
> down_read") binder assumed the mmap read lock is sufficient to protect
> alloc->vma inside binder_update_page_range(). This used to be accurate
> until commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
> munmap"), which now downgrades the mmap_lock after detaching the vma
> from the rbtree in munmap(). Then it proceeds to teardown and free the
> vma with only the read lock held.
> 
> This means that accesses to alloc->vma in binder_update_page_range() now
> will race with vm_area_free() in munmap() and can cause a UAF as shown
> in the following KASAN trace:
> 
>   ==================================================================
>   BUG: KASAN: use-after-free in vm_insert_page+0x7c/0x1f0
>   Read of size 8 at addr ffff16204ad00600 by task server/558
> 
>   CPU: 3 PID: 558 Comm: server Not tainted 5.10.150-00001-gdc8dcf942daa #1
>   Hardware name: linux,dummy-virt (DT)
>   Call trace:
>    dump_backtrace+0x0/0x2a0
>    show_stack+0x18/0x2c
>    dump_stack+0xf8/0x164
>    print_address_description.constprop.0+0x9c/0x538
>    kasan_report+0x120/0x200
>    __asan_load8+0xa0/0xc4
>    vm_insert_page+0x7c/0x1f0
>    binder_update_page_range+0x278/0x50c
>    binder_alloc_new_buf+0x3f0/0xba0
>    binder_transaction+0x64c/0x3040
>    binder_thread_write+0x924/0x2020
>    binder_ioctl+0x1610/0x2e5c
>    __arm64_sys_ioctl+0xd4/0x120
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
> 
>   Allocated by task 559:
>    kasan_save_stack+0x38/0x6c
>    __kasan_kmalloc.constprop.0+0xe4/0xf0
>    kasan_slab_alloc+0x18/0x2c
>    kmem_cache_alloc+0x1b0/0x2d0
>    vm_area_alloc+0x28/0x94
>    mmap_region+0x378/0x920
>    do_mmap+0x3f0/0x600
>    vm_mmap_pgoff+0x150/0x17c
>    ksys_mmap_pgoff+0x284/0x2dc
>    __arm64_sys_mmap+0x84/0xa4
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
> 
>   Freed by task 560:
>    kasan_save_stack+0x38/0x6c
>    kasan_set_track+0x28/0x40
>    kasan_set_free_info+0x24/0x4c
>    __kasan_slab_free+0x100/0x164
>    kasan_slab_free+0x14/0x20
>    kmem_cache_free+0xc4/0x34c
>    vm_area_free+0x1c/0x2c
>    remove_vma+0x7c/0x94
>    __do_munmap+0x358/0x710
>    __vm_munmap+0xbc/0x130
>    __arm64_sys_munmap+0x4c/0x64
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
> 
>   [...]
>   ==================================================================
> 
> To prevent the race above, revert back to taking the mmap write lock
> inside binder_update_page_range(). One might expect an increase of mmap
> lock contention. However, binder already serializes these calls via top
> level alloc->mutex. Also, there was no performance impact shown when
> running the binder benchmark tests.
> 
> Note this patch is specific to stable branches 5.4 and 5.10. Since in
> newer kernel releases binder no longer caches a pointer to the vma.
> Instead, it has been refactored to use vma_lookup() which avoids the
> issue described here. This switch was introduced in commit a43cfc87caaf
> ("android: binder: stop saving a pointer to the VMA").

Both commits now queued up, thanks.

greg k-h
