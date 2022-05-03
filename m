Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4678251903A
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbiECVhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 17:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiECVhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 17:37:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A5F2F03B
        for <stable@vger.kernel.org>; Tue,  3 May 2022 14:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 476F0B82176
        for <stable@vger.kernel.org>; Tue,  3 May 2022 21:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6D8C385A9;
        Tue,  3 May 2022 21:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651613643;
        bh=sN5FuOKqNd0XV4Nh0Le7UJ1EWbfgNf8PwkVQcOXZWhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UthkOEc1attrGYiLizI9QSas2cCXLo7yZKned3biguUWuJRbxF1UJAb1M0AB/oB96
         oOqiC2gU3Z1QbmwaCryFRRu+N75sf8rXMHZwpX4ERf8BzySnhmAqT0H1T3Q4+bdHHd
         BYnUTfRZo4AmkynYUPOoQKhVkKcbKzpNuqYY22oUi5se3h5vjdVVuP5H9mUw+tlJ4Y
         /lGjw4U6k3pkZbiyjpWGpJer+YqLEytyPVVVGsOoYsaxXAvVCBgbgTAEFuHPEJkRZT
         b90rgGc4M27RTavZC2c7gX9XQoAIhMDQrJd7MkzCX17xUM0i6ReFiigo4MWSe11BKu
         XGY9sw/PZHEJA==
Date:   Tue, 3 May 2022 14:34:00 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: Re: Apply d799769188529abc6cbf035a10087a51f7832b6b to 5.17 and 5.15?
Message-ID: <YnGfyLAkB3NG+Ms2@dev-arch.thelio-3990X>
References: <Yl8pNxSGUgeHZ1FT@dev-arch.thelio-3990X>
 <877d7ig9oz.fsf@mpe.ellerman.id.au>
 <YmF0iajmlAg6Kj9I@dev-fedora.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmF0iajmlAg6Kj9I@dev-fedora.thelio-3990X>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 08:13:13AM -0700, Nathan Chancellor wrote:
> On Thu, Apr 21, 2022 at 05:46:52PM +1000, Michael Ellerman wrote:
> > Nathan Chancellor <nathan@kernel.org> writes:
> > > Hi Greg, Sasha, and Michael,
> > >
> > > Commit d79976918852 ("powerpc/64: Add UADDR64 relocation support") fixes
> > > a boot failure with CONFIG_RELOCATABLE=y kernels linked with recent
> > > versions of ld.lld [1]. Additionally, it resolves a separate boot
> > > failure that Paul Menzel reported [2] with ld.lld 13.0.0. Is this a
> > > reasonable backport for 5.17 and 5.15? It applies cleanly, resolves both
> > > problems, and does not appear to cause any other issues in my testing
> > > for both trees but I was curious what Michael's opinion was, as I am far
> > > from a PowerPC expert.
> > >
> > > This change does apply cleanly to 5.10 (I did not try earlier branches)
> > > but there are other changes needed for ld.lld to link CONFIG_RELOCATABLE
> > > kernels in that branch so to avoid any regressions, I think it is safe
> > > to just focus on 5.15 and 5.17.
> > 
> > I considered tagging it for stable, but I wanted it to get a bit of
> > testing first, it's a reasonably big patch.
> > 
> > I think we're reasonably confident it doesn't introduce any new bugs,
> > but more testing time is always good.
> > 
> > So I guess I'd be inclined to wait another week or so before requesting
> > a stable backport?
> 
> Sure, thanks for the response! I'll ping this thread on Monday, May 2nd,
> so that we have two more RC releases to try and flush out any lingering
> issues. If you do receive any reports of regressions, please let me
> know.

I decided to wait an extra day just to give people the opportunity to
install -rc5 and run it through their tests. I have not heard of any
reports yet, are there any further objections?

Cheers,
Nathan
