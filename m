Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3209951445C
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355769AbiD2IlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 04:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351551AbiD2IlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:41:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F8CA777E
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53464B83290
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 08:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16FC385A4;
        Fri, 29 Apr 2022 08:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651221459;
        bh=CZbc3NLs5UB/GOr1yq0DL6qsy6DPtAYbsTSdagd5TL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RxkaXikUryp72tRGdncSYWs4pZ9/cLPFVM7DnwCkAcQ1zvo7DNGZVc7KdJnRaxp1C
         VP9anXOcF+EavPIAugFQ94eUF+i14SrQiOQDfIcbcsZZOone2Tddb5jNf13nCfzGah
         +bz7qk7oRpJ/xpqjUa7Y69bmvQsrXpNYgrnPsa4k=
Date:   Fri, 29 Apr 2022 10:37:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5.10] dm: fix mempool NULL pointer race when
 completing IO
Message-ID: <Ymuj0Y2A6WHOi05c@kroah.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
 <YmeUXC3DZGLPJlWw@kroah.com>
 <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 12:22:26PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:
> 
> > On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > > Hi
> > 
> > Not really needed in a changelog text :)
> > 
> > > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > > and dm_wait_for_bios_completion") for the kernel 5.10.
> > 
> > Can you just make these 2 different patches?
> > 
> > > 
> > > The bugs fixed by these patches can cause random crashing when reloading
> > > dm table, so it is eligible for stable backport.
> > > 
> > > This patch is different from the upstream patches because the code
> > > diverged significantly.
> > > 
> > 
> > This change is _VERY_ different.  I would need acks from the maintainers
> > of this code before I could accept this, along with a much more detailed
> > description of why the original commits will not work here as well.
> > 
> > Same for the other backports.
> 
> Regarding backporting of 9f6dc633:
> 
> My reasoning was that introducing "md->pending_io" in the backported 
> stable kernels is useless - it will just degrade performance by consuming 
> one more cache line per I/O without providing any gain.
> 
> In the upstream kernels, Mike needs that "md->pending_io" variable for 
> other reasons (the I/O accounting was reworked there in order to avoid 
> some spikes with dm-crypt), but there is no need for it in the stable 
> kernels.
> 
> In order to fix that race condition, all we need to do is to make sure 
> that dm_stats_account_io is called before bio_end_io_acct - and the patch 
> does that - it swaps them.
> 
> Do you still insist that this useless percpu variable must be added to the 
> stable kernels? If you do, I can make it, but I think it's better to just 
> swap those two functions.

I am no insisting on anything, I want the dm maintainers to agree that
this change is acceptable to take as it is not what is in Linus's tree.
Every time we take a "not upstream" commit, the odds are 90% that it
ends up being wrong, so I need extra review and assurances that it is
acceptable before I can apply it.

thanks,

greg k-h
