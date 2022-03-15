Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65674D9B6A
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiCOMmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiCOMms (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323EC31207;
        Tue, 15 Mar 2022 05:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC96DB8122D;
        Tue, 15 Mar 2022 12:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE235C340E8;
        Tue, 15 Mar 2022 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647348094;
        bh=zAhNw43eKx/s14dsMwTsXrVFhTIKJTj9xC310UWpx30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eh/3Y7XfzsMWfqrWEhkY8RvxH8YHSETrBx1+6StYSccdCZ5bne2u5X71gHWYJb8ke
         LBPRfbHBoDnO+noqw77wlYMdqHO87vx8XbcXcPZTPokV9ZTua3tkQ/SwE5gQcnfPJJ
         RttRv8qLngJ3CV7JU7dXz2Hu6Zgk156mwlRYJR9E=
Date:   Tue, 15 Mar 2022 13:41:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.10 38/58] KVM: arm64: Allow indirect vectors to be used
 without SPECTRE_V3A
Message-ID: <YjCJejmCTOYZkVj5@kroah.com>
References: <20220310140812.869208747@linuxfoundation.org>
 <20220310140813.956533242@linuxfoundation.org>
 <20220310234858.GB16308@amd>
 <YirvObKn0ADrEOk+@kroah.com>
 <ef538a31-5f73-dfc5-12a9-f5222514035c@arm.com>
 <dcce2353-d20b-eed3-fac1-420b4cad7152@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcce2353-d20b-eed3-fac1-420b4cad7152@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 12:27:29PM +0000, James Morse wrote:
> On 3/15/22 12:20 PM, James Morse wrote:
> > On 3/11/22 6:42 AM, Greg Kroah-Hartman wrote:
> > > On Fri, Mar 11, 2022 at 12:48:59AM +0100, Pavel Machek wrote:
> > > > What is going on here?
> > > > 
> > > > > commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.
> > > > 
> > > > Upstream commit 5bdf is very different from this. In particular,
> > > > 
> > > > >   arch/arm64/kvm/hyp/smccc_wa.S    |   66 +++++++++++++++++++++++++++++++++++++++
> > > > 
> > > > I can't find smccc_wa.S, neither in mainline, nor in -next. And it
> > > > looks buggy. I suspect loop_k24 should loop 24 times, but it does 8
> > > > loops AFAICT. Same problem with loop_k32.
> > 
> > Yup, that's a bug. Thanks for spotting it!
> > I'll post a replacement for this patch.
> 
> Looking more closely at this: when I originally did this the 'new' code for stable was
> in a separate patch to make it clear it was new code. Here it looks like Greg has merged
> it into this patch.

I did?  I don't recall doing that at all, sorry.  But getting the 5.10
arm64 tree into the stable queue was not easy from what I recall.

> I'm not sure what the 'rules' are for this sort of thing, obviously Greg gets the last say.
> 
> I'll try and restructure the other backports to look like this, it is certainly simpler
> than trrying to pull all the prerequisites for all the upstream patches in.

I tried to also take a lot of prerequisite patches for the cpu id stuff,
to make those merges easier, so I have no problem with taking what is in
Linus's tree to make backports simpler.  But it's a balencing act,
especially for tougher stuff like this :(

thanks,

greg k-h
