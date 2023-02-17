Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DF369AD46
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBQOD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBQOD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:03:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287C6656B2
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:03:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A411761B97
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FD1C433D2;
        Fri, 17 Feb 2023 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642605;
        bh=fkNheiNNtSCLOz5dLboXu6U03BXc78i/gAgypCwBn9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZcirM4vZfD3S/pVWi9RAqXGcst9GJ5INRH1XZuYPSUHUkXJTufYerDB3Z5pVWNYlz
         iOd/JnwEJGLby0JXOnXKE+JACz+P49Sau9VWVOeRgRiaHj4DXk+iSvdYIl2qGXTXsi
         D4IvGL9xOUQUokUOlcRfFgBOdoCFTk1bCaDGzWbA=
Date:   Fri, 17 Feb 2023 15:03:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     "Xu, Shaoying" <shaoyi@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "longman@redhat.com" <longman@redhat.com>
Subject: Re: [PATCH stable 5.10 0/7] Remove reader optimistic spinning
Message-ID: <Y++JKvzMzMJPqid7@kroah.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
 <Y+TMvcaArE0M/TnS@kroah.com>
 <8E6E1FCA-620A-4556-87A5-1ABB4A936A33@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E6E1FCA-620A-4556-87A5-1ABB4A936A33@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 12:11:55PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> > This is great that you did this work and found this out, but really,
> > shouldn't you have done the less work and just moved to 5.15.y instead?
> > You're going to have to do that anyway, what's preventing that from
> > happening now, with the HUGE justification that you get a big workload
> > increase and power savings (i.e. real money)?
> 
> 
> 
> 
> 
> 
> 
> 
> Hey Greg,
> 
> 
> 
> 
> 
> 
> 
> 

Hi,

Odd whitespace, you should fix your email client :)

> We are actually shipping kernel 5.15 as part of Amazon Linux kernel releases so theoretically moving to 5.15 should be the way to go however usually the relevant teams take some time for workload specific testing and benchmark before they do a major upgrade like moving from 5.10 to 5.15. We usually ask whoever is reporting a regression/bug/kernel enhancement to run with the latest kernel as you said while sometimes we backport fixes if the production migration to the latest kernel is something that will take time for the reasons I mentioned above. We thought that this performance improvement will also be beneficial for Linux 5.10 users hence we preferred these patches to be merged to the stable 5.10 rather than us just consume them as downstream patches. We are currently working with the relevant team on a plan for the possible 5.15 migration as a long term solution.

And use some \n characters :)

But this isn't a regression, it's a speedup.  And a good reason to use a
newer kernel version.  What type of guarantees that these changes work
properly and have all needed future bugfixes applied to them?  How were
they tested?

I am loath to want to replace something as core as this without a lot of
testing and verification and agreement from the subsystem
authors/maintainers that this is ok to make.

Seriously, just move to 5.15.y or 6.1.y, that will be easier for you in
the long run, the amount of testing and validation should have been the
same for this small patchset as it would be for a kernel update, so
there shouldn't be any issues here.

thanks,

greg k-h
