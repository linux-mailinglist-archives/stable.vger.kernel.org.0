Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196D563D5C2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiK3MlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiK3MlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:41:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF54442983;
        Wed, 30 Nov 2022 04:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8392BB81B30;
        Wed, 30 Nov 2022 12:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68FFC433C1;
        Wed, 30 Nov 2022 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669812061;
        bh=bxsZp9sx/SJS953ooVDRz4ylsW4KoL2wq/Zm3PqCvBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POsuHHroFNVze1BGqR/4ZoNSyee4FqY5ISz18vUYCgA9Mean4tgnm1aoqs1590uv/
         PEbOzWWK5n0FKaRRFs6qiuIooHXmaRyEhN/N+XlS5PlBUZzyjxHzLQ4uDIbK38H51s
         ozgnpaQBAtV59Ccodjy6UcbBVeU4g0PaI5+bMDqk=
Date:   Wed, 30 Nov 2022 13:40:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH 5.15] binder: validate alloc->mm in ->mmap() handler
Message-ID: <Y4dPWkfBkDzCq71A@kroah.com>
References: <20221123180922.1502550-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123180922.1502550-1-cmllamas@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 06:09:21PM +0000, Carlos Llamas wrote:
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
> 

This too is already in the 5.15 queue, is this a different version?

thanks,

greg k-h
