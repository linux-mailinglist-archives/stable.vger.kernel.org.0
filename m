Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934C551A32E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351869AbiEDPK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 11:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351885AbiEDPK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 11:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2126E2228E
        for <stable@vger.kernel.org>; Wed,  4 May 2022 08:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE14B8263C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 15:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D335C385A4;
        Wed,  4 May 2022 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651676838;
        bh=FNwGFZSSghL9KJyuzsHgp8CpQhQa/0a0SraBBTLra4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDVvxDUIhbbvKmGH5qGnShIF1ZmFCdyILLdSTu5IRtMrPoUPUnDmdmWAQ2i951dTy
         sFe7kaYhdE6HyCKFVpsv5Y+USd8z20/mJ3U+O1CMigypiOVKZVoTMINI0BTLJOHXU+
         OuWb26ahdNvM79PpbePCO8CNFmu/34V01YSJLxYw=
Date:   Wed, 4 May 2022 17:07:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: Re: Apply d799769188529abc6cbf035a10087a51f7832b6b to 5.17 and 5.15?
Message-ID: <YnKWpUVITMjaUUkt@kroah.com>
References: <Yl8pNxSGUgeHZ1FT@dev-arch.thelio-3990X>
 <877d7ig9oz.fsf@mpe.ellerman.id.au>
 <YmF0iajmlAg6Kj9I@dev-fedora.thelio-3990X>
 <YnGfyLAkB3NG+Ms2@dev-arch.thelio-3990X>
 <87o80eugqj.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o80eugqj.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 01:19:32PM +1000, Michael Ellerman wrote:
> Nathan Chancellor <nathan@kernel.org> writes:
> > On Thu, Apr 21, 2022 at 08:13:13AM -0700, Nathan Chancellor wrote:
> >> On Thu, Apr 21, 2022 at 05:46:52PM +1000, Michael Ellerman wrote:
> >> > Nathan Chancellor <nathan@kernel.org> writes:
> >> > > Hi Greg, Sasha, and Michael,
> >> > >
> >> > > Commit d79976918852 ("powerpc/64: Add UADDR64 relocation support") fixes
> >> > > a boot failure with CONFIG_RELOCATABLE=y kernels linked with recent
> >> > > versions of ld.lld [1]. Additionally, it resolves a separate boot
> >> > > failure that Paul Menzel reported [2] with ld.lld 13.0.0. Is this a
> >> > > reasonable backport for 5.17 and 5.15? It applies cleanly, resolves both
> >> > > problems, and does not appear to cause any other issues in my testing
> >> > > for both trees but I was curious what Michael's opinion was, as I am far
> >> > > from a PowerPC expert.
> >> > >
> >> > > This change does apply cleanly to 5.10 (I did not try earlier branches)
> >> > > but there are other changes needed for ld.lld to link CONFIG_RELOCATABLE
> >> > > kernels in that branch so to avoid any regressions, I think it is safe
> >> > > to just focus on 5.15 and 5.17.
> >> > 
> >> > I considered tagging it for stable, but I wanted it to get a bit of
> >> > testing first, it's a reasonably big patch.
> >> > 
> >> > I think we're reasonably confident it doesn't introduce any new bugs,
> >> > but more testing time is always good.
> >> > 
> >> > So I guess I'd be inclined to wait another week or so before requesting
> >> > a stable backport?
> >> 
> >> Sure, thanks for the response! I'll ping this thread on Monday, May 2nd,
> >> so that we have two more RC releases to try and flush out any lingering
> >> issues. If you do receive any reports of regressions, please let me
> >> know.
> >
> > I decided to wait an extra day just to give people the opportunity to
> > install -rc5 and run it through their tests. I have not heard of any
> > reports yet, are there any further objections?
> 
> No objection.

Now queued up!
