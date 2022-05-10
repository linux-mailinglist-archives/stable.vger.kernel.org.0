Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607DD52142D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiEJLwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiEJLwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:52:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8E625D110
        for <stable@vger.kernel.org>; Tue, 10 May 2022 04:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D15D16194B
        for <stable@vger.kernel.org>; Tue, 10 May 2022 11:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC95C385C2;
        Tue, 10 May 2022 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652183282;
        bh=9vJ3yeAp7V3LSAzCls+2oNMLm6Y/NWRodhpIOOlPlYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UC/ifrmeDSAxdBjBVBEmcvNUyfT9DELqAggFnN+wE33640H2jH95xB/XH+uDtpVaO
         rOmS7HRNoLb/vIUbrVYxyZJWSOjA9BD8eZw/2XKHJJ037HVknmYbsA0M0QOeDV8FS2
         4gteUzIyQQ1101f7IC8gqtIdLY1q449am8jsNezE=
Date:   Tue, 10 May 2022 13:47:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4.9] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
Message-ID: <YnpQ7gcGt872LstM@kroah.com>
References: <alpine.LRH.2.02.2205031634520.11434@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2205031634520.11434@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 04:35:44PM -0400, Mikulas Patocka wrote:
> This is backport of the patch 9f6dc6337610 ("dm: interlock pending dm_io
> and dm_wait_for_bios_completion") for the kernel 4.9.
> 
> The bugs fixed by this patch can cause random crashing when reloading dm
> table, so it is eligible for stable backport.
> 
> Note that the kernel 4.9 uses md->pending to count the number of
> in-progress I/Os and md->pending is decremented after dm_stats_account_io,
> so the race condition doesn't really exist there (except for missing
> smp_rmb()).
> 
> The percpu variable md->pending_io is not needed in the stable kernels,
> because md->pending counts the same value, so it is not backported.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>
> 
> ---
>  drivers/md/dm.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-stable/drivers/md/dm.c
> ===================================================================
> --- linux-stable.orig/drivers/md/dm.c	2022-04-30 19:03:08.000000000 +0200
> +++ linux-stable/drivers/md/dm.c	2022-04-30 19:03:46.000000000 +0200
> @@ -2027,6 +2027,8 @@ static int dm_wait_for_completion(struct
>  	}
>  	finish_wait(&md->wait, &wait);
>  
> +	smp_rmb(); /* paired with atomic_dec_return in end_io_acct */
> +
>  	return r;
>  }
>  
> 

All now queued up, thanks.

gre gk-h
