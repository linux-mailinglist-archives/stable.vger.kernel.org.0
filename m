Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED635FFB0D
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJOPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 11:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJOPf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 11:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D10230F69;
        Sat, 15 Oct 2022 08:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F6560E2D;
        Sat, 15 Oct 2022 15:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93849C433C1;
        Sat, 15 Oct 2022 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665848115;
        bh=kodHl9TTu9t56McWQSFGYH03s9jx5pwxhnqq0rGzmJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXZXoCFh+PkM/zBnSieAFrMQ8LyjSlIZdou6GVRMfw4sbUKLcHW3dbGpvn7WXIqC2
         A0udzRmOIlyimhz5j1nYsjdPEG/OAtT8Dkg4LllURrh3hLBVKMtGMZBJclz7IEyqgc
         1f4fKBuONHzkBLTit0d8KJ8G78NvtQVeq8+rfpSA=
Date:   Sat, 15 Oct 2022 17:36:00 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Message-ID: <Y0rTYFHjqVWHIm98@kroah.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
 <YzmujBxtwUxHexem@kroah.com>
 <58294d242fc256a48abb31926232565830197f02.camel@amazon.com>
 <e35b7856-138c-a255-a32e-41f57ad6f76d@amazon.com>
 <0d923959-1b93-6133-6609-ac2c0c5711ee@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d923959-1b93-6133-6609-ac2c0c5711ee@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 12:00:31PM -0700, Bhatnagar, Rishabh wrote:
> 
> On 10/9/22 10:50 AM, Bhatnagar, Rishabh wrote:
> > 
> > On 10/6/22 8:07 PM, Herrenschmidt, Benjamin wrote:
> > > (putting my @amazon.com hat on)
> > > 
> > > On Sun, 2022-10-02 at 17:30 +0200, Greg KH wrote:
> > > 
> > > 
> > > > On Thu, Sep 29, 2022 at 09:06:45PM +0000, Rishabh Bhatnagar wrote:
> > > > > This patch series backports a bunch of patches related IRQ handling
> > > > > with respect to freeing the irq line while IRQ is in flight at CPU
> > > > > or at the hardware level.
> > > > > Recently we saw this issue in serial 8250 driver where the IRQ was
> > > > > being
> > > > > freed while the irq was in flight or not yet delivered to the CPU.
> > > > > As a
> > > > > result the irqchip was going into a wedged state and IRQ was not
> > > > > getting
> > > > > delivered to the cpu. These patches helped fixed the issue in 4.14
> > > > > kernel.
> > > > Why is the serial driver freeing an irq while the system is running?
> > > > Ah, this could happen on a tty hangup, right?
> > > Right. Rishabh answered that separately.
> > > 
> > > > > Let us know if more patches need backporting.
> > > > What hardware platform were these patches tested on to verify they
> > > > work properly?  And why can't they move to 4.19 or newer if they
> > > > really need this fix?  What's preventing that?
> > > > 
> > > > As Amazon doesn't seem to be testing 4.14.y -rc releases, I find it
> > > > odd that you all did this backport.  Is this a kernel that you all
> > > > care about?
> > > These were tested on a collection of EC2 instances, virtual and metal I
> > > believe (Rishabh, please confirm).
> > Yes these patches were tested on multiple virt/metal EC2 instances.
> > > 
> > > Amazon Linux 2 runs 4.14 or 5.10. Unfortunately we still have to
> > > support customers running the former.
> > > 
> > > We'll be including these patches in our releases, we thought it would
> > > be nice to have them in -stable as well for the sake of whoever else
> > > might be still using this kernel. No huge deal if they don't.
> > > 
> > > As for testing -rc's, yes, we need to get better at that (and publish
> > > what we test). Point taken :-)
> > > 
> > > Cheers,
> > > Ben.
> > > 
> Hi Greg
> 
> Let us know if you think it would be beneficial to take these backports for
> 4.14 stable.

Give me some time after -rc1 is out to review this then as we are
swamped right now.

> We can drop this patch set otherwise.

You can do whatever you want with your tree :)

thanks,

greg k-h
