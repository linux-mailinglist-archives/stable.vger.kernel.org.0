Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FE35B4C3B
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 07:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIKFrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 01:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIKFrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 01:47:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74CD3C8DA
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 22:47:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F260B80B0E
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 05:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CE0C433C1;
        Sun, 11 Sep 2022 05:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662875222;
        bh=UIiOIiBNcb1dcuaCt1qfyM0Q9OdtI+87tazUBz48PE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HAbpi5ib3ooxLdhxQSirIRfUjb/sNTJZtErEuN28wtbtAtqdza0v/aL4KQKheW/wz
         lYcZ7BrnSxg6Jo4585VwjcC2uh/BRFm9/n9E4gMPLqZ/5f7nk4GYkvM0D+IWeJim8/
         ZpH1uQzceNOtuxyJTsCE8X1zAuzM7QPLUCDCHZDM=
Date:   Sun, 11 Sep 2022 07:47:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        peterz@infradead.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <Yx12bQVdycfVQkp0@kroah.com>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
 <Yxc4CeyDS2tWLXfo@kroah.com>
 <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
 <20220906212010.rfvxzkt25nwakfad@desk>
 <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
 <20220908060949.dcybz74j3wm7pzrg@desk>
 <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 02:44:33PM +0200, Ben Hutchings wrote:
> On Wed, 2022-09-07 at 23:09 -0700, Pawan Gupta wrote:
> > On Wed, Sep 07, 2022 at 02:23:58AM +0200, Ben Hutchings wrote:
> > > > > - The added mitigation, for PBRSB, requires removing any RET
> > > > > instructions executed between VM exit and the RSB filling.  In these
> > > > > older branches that hasn't been done, so the mitigation doesn't work.
> > > > 
> > > > I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> > > > filling. Could you please point me to any specific instance you are
> > > > seeing?
> > > 
> > > Yes, you're right.  The backported versions avoid this problem.  They
> > > are quite different from the upstream commit - and I would have
> > > appreciated some explanation of this in their commit messages.
> > 
> > Ahh right, I will keep in mind next time.
> > 
> > > So, let's try again to move forward.  I've attached a backport for 4.19
> > > and 5.4 (only tested with the latter so far).
> > 
> > I am not understanding why lfence in single-entry-fill sequence is okay
> > on 32-bit kernels?
> > 
> > #define __FILL_ONE_RETURN                               \
> >         __FILL_RETURN_SLOT                              \
> >         add     $(BITS_PER_LONG/8), %_ASM_SP;           \
> >         lfence;
> 
> This isn't exactly about whether the kernel is 32-bit vs 64-bit, it's
> about whether the code may run on a processor that lacks support for
> LFENCE (part of SSE2).
> 
> - SSE2 is architectural on x86_64, so 64-bit kernels can use LFENCE
> unconditionally.
> - PBRSB doesn't affect any of those old processors, so its mitigation
> can use LFENCE unconditionally.  (Those procesors don't support VMX
> either.)

Ok, it seems that I need to take Ben's patch to resolve this.  Pawan, if
you object, please let us know.

thanks,

greg k-h
