Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155994C69E6
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 12:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiB1LKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 06:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiB1LJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 06:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2486CA48;
        Mon, 28 Feb 2022 03:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5256B80FE7;
        Mon, 28 Feb 2022 11:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA9C340E7;
        Mon, 28 Feb 2022 11:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646046541;
        bh=ZWAjzUfZYuJT/DEBzqsIadiIJ6sqa7zdYVhrMqhf4hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWlOxSY0YS8+oSTONiP6uipPZHROYfrgZEsYxTVTaaYUY4VEpXl5mSNWDCgbXMqLG
         Rz48F9rm99BdCLJ/1CBzTfWWIDYKMWD49+emsw1MBiLYF32wVBxrZXsCef7hjUeRKO
         /DAhBKDih8SJiRnIt2VH8OgtqTAzKHPXF2z7VBQQ=
Date:   Mon, 28 Feb 2022 12:08:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        oliver.sang@intel.com, beibei.si@intel.com, jannh@google.com,
        mszeredi@redhat.com, torvalds@linux-foundation.org,
        yukuai3@huawei.com
Subject: Re: [PATCH 5.4] fget: clarify and improve __fget_files()
 implementation
Message-ID: <YhytSkOJ7caNbTDj@kroah.com>
References: <20220226063201.167183-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226063201.167183-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 26, 2022 at 02:32:01PM +0800, Baokun Li wrote:
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
>  fs/file.c | 73 +++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 57 insertions(+), 16 deletions(-)

All now queued up, thanks for the backports!

greg k-h
