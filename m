Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E906F453B21
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKPUoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhKPUoL (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:44:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7673E615E2;
        Tue, 16 Nov 2021 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637095273;
        bh=HJXh7d45EkOa81W0yYy22f31pSuK5EYCpmnPfOH9bV0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=lzMniruqAN7FIccrEqhN47qqJzeE7l1cHj/1rgGKbZObRkVdUoQbTmBnGezQpNi8E
         TFbpkVKPVaaRWTkwQLPjGO7LYYvdJPM2H29BHKkCdqNhEzoeQKz5jiJ/0qLMIeY1Fv
         +NY4C659CRa5QsZeFR0icQGOTjdSmiYf6Sbem01xmHvC3S91FaIYXpcBz1i7zI4g/E
         AyFDdC+oYSm4HXcdOFacA4Xbqp7bG6OZh8ZvCovCJlvWYjhsh/jz/Rkj8wkVMFSPZI
         5qKpZKo3SLA2pR+7N8CRic3wzmdAgOixqkWRFiymK+AbYWh7HgBJChNQlghLLDtjJR
         gG1Qb69VzO37A==
Date:   Tue, 16 Nov 2021 12:41:12 -0800 (PST)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@ubuntu-linux-20-04-desktop
To:     Jan Beulich <jbeulich@suse.com>
cc:     Stefano Stabellini <sstabellini@kernel.org>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org, jgross@suse.com
Subject: Re: [PATCH v2] xen: don't continue xenstore initialization in case
 of errors
In-Reply-To: <29e1ea87-c2e3-f8b1-b843-a390ad280984@suse.com>
Message-ID: <alpine.DEB.2.22.394.2111161239180.1412361@ubuntu-linux-20-04-desktop>
References: <20211115222719.2558207-1-sstabellini@kernel.org> <29e1ea87-c2e3-f8b1-b843-a390ad280984@suse.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021, Jan Beulich wrote:
> On 15.11.2021 23:27, Stefano Stabellini wrote:
> > From: Stefano Stabellini <stefano.stabellini@xilinx.com>
> > 
> > In case of errors in xenbus_init (e.g. missing xen_store_gfn parameter),
> > we goto out_error but we forget to reset xen_store_domain_type to
> > XS_UNKNOWN. As a consequence xenbus_probe_initcall and other initcalls
> > will still try to initialize xenstore resulting into a crash at boot.
> > 
> > [    2.479830] Call trace:
> > [    2.482314]  xb_init_comms+0x18/0x150
> > [    2.486354]  xs_init+0x34/0x138
> > [    2.489786]  xenbus_probe+0x4c/0x70
> > [    2.498432]  xenbus_probe_initcall+0x2c/0x7c
> > [    2.503944]  do_one_initcall+0x54/0x1b8
> > [    2.507358]  kernel_init_freeable+0x1ac/0x210
> > [    2.511617]  kernel_init+0x28/0x130
> > [    2.516112]  ret_from_fork+0x10/0x20
> > 
> > Cc: <Stable@vger.kernel.org>
> > Cc: jbeulich@suse.com
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
> 
> For the immediate purpose as described this looks okay, so
> Reviewed-by: Jan Beulich <jbeulich@suse.com>

Thank you!


> However, aren't there further pieces missing on this error patch:
> - clearing of xenstored_ready in case it got set,
> - rolling back xenstored_local_init() (XS_LOCAL) and xen_remap()
>   (XS_HVM).
> And shouldn't xs_init() failure when called from xenbus_probe()
> also result in the driver not giving the appearance of being usable?

I prioritized this patch because I have a direct test case for this
issue and I can see that this patch solves it. But what you wrote is
true, and I can have a look in the following weeks.


> > --- a/drivers/xen/xenbus/xenbus_probe.c
> > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > @@ -909,7 +909,7 @@ static struct notifier_block xenbus_resume_nb = {
> >  
> >  static int __init xenbus_init(void)
> >  {
> > -	int err = 0;
> > +	int err;
> >  	uint64_t v = 0;
> >  	xen_store_domain_type = XS_UNKNOWN;
> >  
> 
> Minor remark: You may want to take the opportunity and add the
> missing blank line here to visually separate the assignment from
> the declarations.
> 
> Jan
> 
