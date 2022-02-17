Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0A4BA8E2
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbiBQS4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:56:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbiBQS4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:56:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A080758E6F;
        Thu, 17 Feb 2022 10:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C5B361B8A;
        Thu, 17 Feb 2022 18:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E7CC340E8;
        Thu, 17 Feb 2022 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124144;
        bh=Rh0qZRyhLF/JeJYDSRhXWN0tLJc2VU+e0gkrEgt5rFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LwvbAGf9J25gZA48/mDNJ6DibV8IANCyxD6WtW/RFemLIbgE+LJaLy+EvhGcPjEtr
         am4y3jvh3KGJSTMf1HHFIkrJqKq3qIlyxIM0EIVidMjVV6kJqK+9XaNbK+ciyyKSNz
         0/lNivsSwhVFSMMidaIdtSJS4o5en5LR8Tsd7YVM=
Date:   Thu, 17 Feb 2022 19:55:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        oliver.sang@intel.com, beibei.si@intel.com, jannh@google.com,
        mszeredi@redhat.com, torvalds@linux-foundation.org,
        yukuai3@huawei.com
Subject: Re: [PATCH 5.10] fget: clarify and improve __fget_files()
 implementation
Message-ID: <Yg6aLQCR3zxn5XoW@kroah.com>
References: <20220215065107.3045023-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215065107.3045023-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 02:51:07PM +0800, Baokun Li wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit e386dfc56f837da66d00a078e5314bc8382fab83 upstream.
> 
> Commit 054aa8d439b9 ("fget: check that the fd still exists after getting
> a ref to it") fixed a race with getting a reference to a file just as it
> was being closed.  It was a fairly minimal patch, and I didn't think
> re-checking the file pointer lookup would be a measurable overhead,
> since it was all right there and cached.
> 
> But I was wrong, as pointed out by the kernel test robot.
> 
> The 'poll2' case of the will-it-scale.per_thread_ops benchmark regressed
> quite noticeably.  Admittedly it seems to be a very artificial test:
> doing "poll()" system calls on regular files in a very tight loop in
> multiple threads.
> 
> That means that basically all the time is spent just looking up file
> descriptors without ever doing anything useful with them (not that doing
> 'poll()' on a regular file is useful to begin with).  And as a result it
> shows the extra "re-check fd" cost as a sore thumb.
> 
> Happily, the regression is fixable by just writing the code to loook up
> the fd to be better and clearer.  There's still a cost to verify the
> file pointer, but now it's basically in the noise even for that
> benchmark that does nothing else - and the code is more understandable
> and has better comments too.
> 
> [ Side note: this patch is also a classic case of one that looks very
>   messy with the default greedy Myers diff - it's much more legible with
>   either the patience of histogram diff algorithm ]
> 
> Link: https://lore.kernel.org/lkml/20211210053743.GA36420@xsang-OptiPlex-9020/
> Link: https://lore.kernel.org/lkml/20211213083154.GA20853@linux.intel.com/
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Tested-by: Carel Si <beibei.si@intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/file.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 56 insertions(+), 16 deletions(-)

Now queued up, thanks.

Any chance you can do this for 5.4 and older kernels too?

greg k-h
