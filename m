Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A50563D5BF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiK3Mkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiK3Mko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:40:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7E929801;
        Wed, 30 Nov 2022 04:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D1B61BA3;
        Wed, 30 Nov 2022 12:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87419C433D6;
        Wed, 30 Nov 2022 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669812043;
        bh=GlkpgJ1w1hGdnqLs36PrTT1mYKX1ZJWOrDUYgdlxAh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRlQ0bzrKC6ACEYnbzLH1rkyXoAMvdqblPg9NlIedJZjD0e9+l379mFVqyL7OOf2n
         flkRnKX/t2J5mmvh/tKN3VxyGASq3m5UUSc045KMIlXlKbizQ6ckz0i+8zq6t17bpt
         KmTKhbGz85XWV0jH6sNx7NbB6A4WgMmCXzJ56Pjc=
Date:   Wed, 30 Nov 2022 13:40:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH 6.0] binder: validate alloc->mm in ->mmap() handler
Message-ID: <Y4dPSFygaaPGKBdK@kroah.com>
References: <20221123180809.1501779-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123180809.1501779-1-cmllamas@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 06:08:09PM +0000, Carlos Llamas wrote:
> commit 3ce00bb7e91cf57d723905371507af57182c37ef upstream.
> 
> Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
> dereference") binder caches a pointer to the current->mm during open().
> This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
> it also opens the door for a process to update its mm after the open(),
> (e.g. via execve) making the cached alloc->mm pointer invalid.
> 
> Things get worse when the process continues to mmap() a vma. From this
> point forward, binder will attempt to find this vma using an obsolete
> alloc->mm reference. Such as in binder_update_page_range(), where the
> wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
> insert new pages into it.
> 
> To avoid this issue fail the ->mmap() callback if we detect a mismatch
> between the vma->vm_mm and the original alloc->mm pointer. This prevents
> alloc->vm_addr from getting set, so that any subsequent vma_lookup()
> calls fail as expected.
> 
> Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
> Reported-by: Jann Horn <jannh@google.com>
> Cc: <stable@vger.kernel.org> # 5.15+
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> Acked-by: Todd Kjos <tkjos@google.com>
> Link: https://lore.kernel.org/r/20221104231235.348958-1-cmllamas@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [cmllamas: renamed alloc->mm since missing e66b77e50522]
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---
>  drivers/android/binder_alloc.c | 7 +++++++
>  1 file changed, 7 insertions(+)

This is already in the 6.0 queue, is this a different version?

thanks,

greg k-h
