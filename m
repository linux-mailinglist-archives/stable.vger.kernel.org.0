Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302BC599ADC
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348258AbiHSLVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348250AbiHSLVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6F201B9;
        Fri, 19 Aug 2022 04:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557E161714;
        Fri, 19 Aug 2022 11:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA9FC433C1;
        Fri, 19 Aug 2022 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660908077;
        bh=yT8EDrgNbjdWjlNQBG9B6Fy9zmyFIdtm8/pk4zRpl4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pdXlDFbjQV65ThLVxRLIaQQ4LPW4zNjMxWy2U0mztyH8qxKnq/VBxkakd4cBVyxJX
         R0S5HvcWT1jhjnl8SvSuhDXzyUo9M9y7f7oE1CC7n5BPPYCD1M6A78QiJzB6ZSXkbq
         CsMK0WfvGOzRiAjOdnolJwafwmf6J6MidcDYP+u8=
Date:   Fri, 19 Aug 2022 13:21:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.15 0/2] btrfs: raid56: backports to reduce
 corruption
Message-ID: <Yv9yKtRffK6tX8K5@kroah.com>
References: <cover.1660898037.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660898037.git.wqu@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 04:39:48PM +0800, Qu Wenruo wrote:
> This is the backport for v5.15.x stable branch.
> 
> The full explananation can be found here:
> https://lore.kernel.org/linux-btrfs/Yv85PTBsDhrQITZp@kroah.com/T/#t
> 
> Difference between v5.15.x and v5.18.x backports:
> 
> - btrfs_io_contrl::fs_info and btrfs_raid_bio::fs_info refactor
>   In v5.15 and older kernel, btrfs_raid_bio and btrfs_io_control both
>   have fs_info member, and the new rbio_add_bio() function utilizes
>   btrfs_io_ctrl::fs_info.
> 
>   Unfortunately that rbio->bioc->fs_info is not always initialized in
>   v5.15 and older kernels.
>   Thus has to use rbio->fs_info instead.
> 
>   If not properly handled, can lead to btrfs/158 crash.
> 
> Qu Wenruo (2):
>   btrfs: only write the sectors in the vertical stripe which has data
>     stripes
>   btrfs: raid56: don't trust any cached sector in
>     __raid56_parity_recover()
> 
>  fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 17 deletions(-)
> 
> -- 
> 2.37.1
> 

All now queued up, thanks.

greg k-h
