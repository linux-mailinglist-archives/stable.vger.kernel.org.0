Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90755A4436
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiH2Hw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2Hwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40524E86D
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB2B61159
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED73C433C1;
        Mon, 29 Aug 2022 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661759570;
        bh=Uuy7H6dbiaMGN4rCVm9wQIbo4o+g4rgl8+psGDWPpeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRi5SJ6oOqTzByfWDrBrMLUkyKr4PF3kvXh0oBjAVtSpE8KpD6AB07SX2AX76rslp
         DUFTWYBZc3z0X4jH0L62NuVwnb1IWTCxb8nLyDBznJd/I2Mx3BgjswyKFE3awaea67
         IoFkzRZB2JlwtFKAgRzGjSxS2gHQ717en2LYp8X0=
Date:   Mon, 29 Aug 2022 09:50:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Alexey Romanov <avromanov@sberdevices.ru>,
        Dmitry Rokosov <ddrokosov@sberdevices.ru>,
        Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.19] Revert "zram: remove double compression logic"
Message-ID: <Ywxvy8+it4vyIyHz@kroah.com>
References: <1661424215189156@kroah.com>
 <20220829073147.10716-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829073147.10716-1-jslaby@suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 09:31:47AM +0200, Jiri Slaby wrote:
> This reverts commit e7be8d1dd983156b ("zram: remove double compression
> logic") as it causes zram failures.  It does not revert cleanly, PTR_ERR
> handling was introduced in the meantime.  This is handled by appropriate
> IS_ERR.
> 
> When under memory pressure, zs_malloc() can fail.  Before the above
> commit, the allocation was retried with direct reclaim enabled (GFP_NOIO).
> After the commit, it is not -- only __GFP_KSWAPD_RECLAIM is tried.
> 
> So when the failure occurs under memory pressure, the overlaying
> filesystem such as ext2 (mounted by ext4 module in this case) can emit
> failures, making the (file)system unusable:
>   EXT4-fs warning (device zram0): ext4_end_bio:343: I/O error 10 writing to inode 16386 starting block 159744)
>   Buffer I/O error on device zram0, logical block 159744
> 
> With direct reclaim, memory is really reclaimed and allocation succeeds,
> eventually.  In the worst case, the oom killer is invoked, which is proper
> outcome if user sets up zram too large (in comparison to available RAM).
> 
> This very diff doesn't apply to 5.19 (stable) cleanly (see PTR_ERR note
> above). Use revert of e7be8d1dd983 directly.
> 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1202203
> Link: https://lkml.kernel.org/r/20220810070609.14402-1-jslaby@suse.cz
> Fixes: e7be8d1dd983 ("zram: remove double compression logic")
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Alexey Romanov <avromanov@sberdevices.ru>
> Cc: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Cc: <stable@vger.kernel.org>	[5.19]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/block/zram/zram_drv.c | 42 ++++++++++++++++++++++++++---------
>  drivers/block/zram/zram_drv.h |  1 +
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 

Now queued up, thanks.

greg k-h
