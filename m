Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D329698DFF
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBPHqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBPHqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:46:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0AC3B0C8;
        Wed, 15 Feb 2023 23:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EDBAB825D5;
        Thu, 16 Feb 2023 07:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E71C4339B;
        Thu, 16 Feb 2023 07:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676533607;
        bh=1fHVCAebbHEEGzBBOAxpM2zLnFRsw1EJNwYcko4owRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VHpQrgDeKRE19/jG0RzUwrvEKA0SZw+/lG7AQ/Kd5qEjSZqkXr8EXuuK2l0qArdIZ
         qgHKFj9DRz0+A3JT+oeVigYFCF+1UrXArfuB9yFsPEzt0ne8zqdpX88hewzQwuXdXQ
         xONNtHK/5GsRN4HR6ij65t2H5dHF+Qg3iYZYAHkY=
Date:   Thu, 16 Feb 2023 08:46:44 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Yonggil Song <yonggil.song@samsung.com>
Cc:     Chao Yu <chao@kernel.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daehojeong@google.com" <daehojeong@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] f2fs: fix uninitialized skipped_gc_rwsem
Message-ID: <Y+3fZM/5g1RO+mR1@kroah.com>
References: <CGME20230215024850epcms2p22be2cc864d82b44f31c19a7ef28770b6@epcms2p4>
 <20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366@epcms2p4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216074427epcms2p49a3d71b08d356530b40e34e750cc2366@epcms2p4>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 16, 2023 at 04:44:27PM +0900, Yonggil Song wrote:
> When f2fs skipped a gc round during victim migration, there was a bug which
> would skip all upcoming gc rounds unconditionally because skipped_gc_rwsem
> was not initialized. It fixes the bug by correctly initializing the
> skipped_gc_rwsem inside the gc loop.
> 
> Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
> 
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index b22f49a6f128..81d326abaac1 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -1786,8 +1786,8 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
>  				prefree_segments(sbi));
>  
>  	cpc.reason = __get_cp_reason(sbi);
> -	sbi->skipped_gc_rwsem = 0;
>  gc_more:
> +	sbi->skipped_gc_rwsem = 0;
>  	if (unlikely(!(sbi->sb->s_flags & SB_ACTIVE))) {
>  		ret = -EINVAL;
>  		goto stop;
> -- 
> 2.34.1

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
