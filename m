Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB125BEC2B
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiITRmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiITRmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 13:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835F61D58
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 10:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12AFC62262
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 17:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F8CC433D6;
        Tue, 20 Sep 2022 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663695760;
        bh=jESE6e3evHJyKiGEdIrqaZ0//aX6PDcZAsAYSDBwTjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FwW0jcmJx0g3j/CRD9VhVJQdOwkrO9PfdDcDxn1s8YjPoq1Oivv0fza0HONjR8E6b
         nIybbBsBfw6qNch5uJi7InCPioNXnVwcq/11R5yggIanHQe1t+j+jTXrp/oelhR7ao
         lxuMMhGQNMS+Tye3WlYleccmvbVeEDoUWeDx9nZc=
Date:   Tue, 20 Sep 2022 19:42:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        kernel-team@android.com, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH 5.15] binder: remove inaccurate mmap_assert_locked()
Message-ID: <Yyn7jrFvk7pRj1SH@kroah.com>
References: <20220920052444.2148424-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920052444.2148424-1-cmllamas@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 05:24:43AM +0000, Carlos Llamas wrote:
> Acquiring the mmap_lock during exit_mmap() was only added recently in
> v5.17 by commit 64591e8605d6 ("mm: protect free_pgtables with mmap_lock
> write lock in exit_mmap"). Soon after, asserts for holding this lock
> were added to the binder_alloc_set_vma() callback by the following two
> fix commits in mainline: commit b0cab80ecd54 ("android: binder: fix
> lockdep check on clearing vma") and commit a43cfc87caaf ("android:
> binder: stop saving a pointer to the VMA").
> 
> These two fix commits were picked for stable trees including v5.15 were
> unfortunately the mmap_lock is not held during exit_mmap() yet and this
> unmet dependency leads to the following BUG report:
> 
>   ------------[ cut here ]------------
>   kernel BUG at include/linux/mmap_lock.h:156!
>   Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>   Modules linked in:
>   CPU: 3 PID: 437 Comm: binder Not tainted 5.15.68 #5
>   Hardware name: linux,dummy-virt (DT)
>   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : binder_alloc_vma_close+0x6c/0x70
>   lr : binder_alloc_vma_close+0x6c/0x70
>   sp : ffff800008687a70
>   x29: ffff800008687a70 x28: ffff02a7ccf89d00 x27: ffff02a7c92f99e8
>   x26: 000000000000012a x25: ffff02a7c6284740 x24: ffff02a7ccf8a360
>   x23: ffff02a7c92f9980 x22: 1ffff000010d0f6c x21: ffff02a7c92f99e8
>   x20: ffff02a7c92f9980 x19: ffff02a7d16b79a8 x18: 0000ffffe1702d20
>   x17: 3334373239343932 x16: 34206e6163735f74 x15: 78656e5f616d756e
>   x14: 0a30303030303030 x13: 7366666f5f6e6163 x12: ffff60550564a12b
>   x11: 1fffe0550564a12a x10: ffff60550564a12a x9 : dfff800000000000
>   x8 : ffff02a82b250957 x7 : 0000000000000001 x6 : ffff60550564a12a
>   x5 : ffff02a82b250950 x4 : dfff800000000000 x3 : 0000000000000000
>   x2 : 0000000000000000 x1 : ffff02a7ccf89d00 x0 : 0000000000000374
>   Call trace:
>    binder_alloc_vma_close+0x6c/0x70
>    binder_vma_close+0x38/0xf4
>    remove_vma+0x4c/0x94
>    exit_mmap+0x14c/0x2bc
>    __mmput+0x70/0x19c
>    mmput+0x68/0x80
>    do_exit+0x484/0xeb0
>    do_group_exit+0x5c/0x100
>    [...]
> 
> This patch removes the inaccurate assert specifically from v5.15 since
> it's the only release with such issue. Note the mmap_lock is technically
> not needed here as the mm->mm_users has dropped to zero at this point.
> More context: https://lore.kernel.org/all/YxpQaio7xm3z9TUw@google.com/.
> 
> Fixes: b0cab80ecd54 ("android: binder: fix lockdep check on clearing vma")
> Fixes: a43cfc87caaf ("android: binder: stop saving a pointer to the VMA")
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org> # v5.15
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---
>  drivers/android/binder_alloc.c | 7 -------
>  1 file changed, 7 deletions(-)

Now queued up, thanks.

greg k-h
