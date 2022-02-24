Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40594C3551
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 20:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiBXTFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 14:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiBXTFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 14:05:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19C81E3767;
        Thu, 24 Feb 2022 11:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B066B828CA;
        Thu, 24 Feb 2022 19:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB17C340E9;
        Thu, 24 Feb 2022 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645729486;
        bh=jDuI5h8fYq6fb6tCbrdAIXZK+ehpxE2FmsQTFDRp0+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPP1y1NsGmd9F/iS/Pfgftz+6LR0TB0C30eStDClgzYqZQCM1mhnkhINwqXeWidLx
         /7uqXIdUk0W9gaIgTdSlK45OLmEBz1AMeVxyrDn/fpMphvwLja6O7vbrgHpJUuE5tl
         EvO5PNVPZhJVVoxbGl+cMzNa3dmuAoR1YgcPCedjNCuM740yv2blIT3rnDvf7zZIhB
         7NmlrP06G0RgOChbwWoREmAqIzpeEziQJQfcyqISs1nlKlAZ2n4Ptq1k9o/ofl9o78
         MUBJNxt5KOLkSH3xVlk/uqsKdJmcU2fS60+XT0jNElGenOGGJ1rrnUxemxTChZ3Ouk
         0kcKnCEa9Uxjg==
Date:   Thu, 24 Feb 2022 11:04:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
Message-ID: <YhfWzLBq2A2nr5Ey@sol.localdomain>
References: <20220223080400.139367-1-gilad@benyossef.com>
 <Yhbjq3cVsMVUQLio@sol.localdomain>
 <YhblA1qQ9XLb2nmO@sol.localdomain>
 <CAOtvUMfFhQABmmZe7EH-o=ULEChm_t=KY7ORBRgm94O=1MiuFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMfFhQABmmZe7EH-o=ULEChm_t=KY7ORBRgm94O=1MiuFw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 09:07:47AM +0200, Gilad Ben-Yossef wrote:
> Hi Eric,
> 
> On Thu, Feb 24, 2022 at 3:53 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Feb 23, 2022 at 05:47:25PM -0800, Eric Biggers wrote:
> > > On Wed, Feb 23, 2022 at 10:04:00AM +0200, Gilad Ben-Yossef wrote:
> > > > the drbg code was binding the same buffer to two different
> > > > scatter gather lists and submitting those as source and
> > > > destination to a crypto api operation, thus potentially
> > > > causing HW crypto drivers to perform overlapping DMA
> > > > mappings which are not aware it is the same buffer.
> > > >
> > > > This can have serious consequences of data corruption of
> > > > internal DRBG buffers and wrong RNG output.
> > > >
> > > > Fix this by reusing the same scatter gatther list for both
> > > > src and dst.
> > > >
> > > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > > > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > > Tested-on: r8a7795-salvator-x
> > > > Tested-on: xilinx-zc706
> > > > Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation for CTR")
> > > > Cc: stable@vger.kernel.org
> > >
> > > Where is it documented and tested that the API doesn't allow this?
> > > I wasn't aware of this case; it sounds perfectly allowed to me.
> > > There might be a lot of other users who do this, not just drbg.c.
> > >
> >
> > Just quickly looking through the code I maintain, there is another place that
> > uses scatterlists like this: in fscrypt_crypt_block() in fs/crypto/crypto.c, the
> > source and destination can be the same.  That's just the code I maintain; I'm
> > sure if you looked through the whole kernel you'd find a lot more.
> >
> > This sounds more like a driver bug, and a case we need to add self-tests for.
> 
> Thank you for the feedback. That is a very good question. Indeed, I
> agree with you that in an ideal world the internal implementation details of DMA
> mapping would not pop up and interfere with higher level layer logic.
> 
> Let me describe my point of view and I would be very happy to hear
> where I am wrong:
> 
> The root cause underlying this is that, of course,  hardware crypto
> drivers map the sglists passed to them for DMA . Indeed, we require
> input to crypto
> API as sglists of DMAable buffers (and not, say stack allocated buffers) because
> of this. So far I am just stating the obvious...
> 
> Now, it looks like the DMA api, accessed via dma_map_sg(), does not
> like overlapping mappings. The bug report that triggered this patch (see:
> https://lkml.org/lkml/2022/2/20/240) was an oops message including this
> warning: "DMA-API: ccree e6601000.crypto: cacheline tracking EEXIST,
> overlapping mappings aren't supported".
> 
> The messages comes from add_dma_entry() in kernel.dma/debug.c,
> because, as stated in the commit message that added this check in May 2021:
> 
> "Since, overlapping mappings are not supported by the DMA API we
> should report an error if active_cacheline_insert returns -EEXIST."
> (https://lkml.org/lkml/2021/5/18/572)
> 
> For now, I will take it at a given that this is proper and you do not
> consider this
> an issue in the DMA API.
> 
> Now, driver writers are of course aware of this DMA API limitation and thus we
> check if the src sglist is the same as the dst sglist and if so only map once.
> However, the underlying assumption is that the buffers pointed by different
> sglists do not overlap. We do not iterate over all the sglist trying
> to find overlaps.
> 
> When I see "we", it is because this behavior is not unique to the ccree driver:
> 
> Here is the same logic from a marvell cesa driver:
> https://elixir.bootlin.com/linux/latest/source/drivers/crypto/marvell/cesa/cipher.c#L326
> 
> Here it is again in the camm driver:
> https://elixir.bootlin.com/linux/latest/source/drivers/crypto/caam/caamalg.c#L1619
> 
> I do believe that at least all crypto HW drivers apply the same logic.
> 
> Of course, we can ask that every HW crypto driver (and possibly any other
> sglist using HW driver) will add logic that scans each sglist for
> overlapping buffers
> and if found use a more sophisticated mapping (easy for a simple
> sglist that has one buffer
> identical to some other sglist, maybe more complicated if the overlap
> is not identity).
> The storage drivers sort of already do on some level, although I think
> on a higher abstraction
> layer than the drivers themselves if I'm not mistaken, though for
> performance reasons.
> This is certainly DOABLE in the sense that it can be achieved.
> 
> However, I don't think this is desirable. This will add non trivial
> code with non trivial runtime
> costs just to spot these cases. And we will need to fix ALL the hw
> drivers, because, to the best
> of my knowledge, none of them do this right now.
> 
> The remaining option is to enforce the rule of no overlap between
> different sglists passed to the
> crypto API. This seems much easier to me. Indeed, the fix I sent is a
> one liner. I suspect all
> other fixes are similar and I assume (but did not check) that there
> are not many of those.
> Indeed, I think it is much easier to impose the required limitation at
> the API caller level.
> It is not pretty, nor "just", but easier, I think.
> 
> I hope I've managed to explain my logic here.
> 
> I will note that even if we decide to follow the other route, we do
> need to document and fix
> probably every hw crypto (and possibly others) driver out there,
> because AFAIK, no one is taking
> into account this possibility right now.

Decryption in dm-crypt is another example where different scatterlists are used
for in-place data.  (This is because like the fscrypt case, it has a helper
function which handles both in-place and out-of-place data.)

I don't think it is reasonable to "fix" all these users who are using the crypto
API in a perfectly reasonable way.

Are you saying that dm-crypt, fscrypt, drbg, etc. never worked with any hardware
crypto driver?  How could that possibly be the case?  Perhaps something changed
in the DMA API recently that is causing this.  Or maybe it is specific to the
implementation of the DMA API on the platform you are testing.

- Eric
