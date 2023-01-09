Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EF3662A34
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjAIPj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbjAIPiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:38:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C03A60CF1;
        Mon,  9 Jan 2023 07:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F62D6119E;
        Mon,  9 Jan 2023 15:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AE4C433EF;
        Mon,  9 Jan 2023 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673278477;
        bh=WmKtUssUUKemnbA+tR6zwPKSfUAvCj2jLE4fMoIwAFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtouydVp5xhN24JtyRtIg8BJ5XW5fbu1rNn5cCswFTxTVMTG2xWEkOJrJTZ+AT6Rm
         +sU9pp0bsTa5/JdJoCZfvdAtapxceEuGG/DDqsGU6TtMUSZIrUGyq1u0aVok0q3+z6
         nmxJOX8l937vLPxHn16O95d+NKBRVxNAqbYaFTzsHGljJ35jrYNJRP+w3thH1uFLrS
         XmYoZUc2rE3x2A2/FoXmoV80u1xXbnzn5Kd8CaAh1+xCoU3FYsmslWpcvbwRimrxII
         NUCiLo5kGMdpdUhS5N9Do6ZNo/LikrttAhV1p0XbBmun+6i4e06l2ygq78HmHuIzkE
         2CNMECIQOUEvQ==
Date:   Mon, 9 Jan 2023 15:34:32 +0000
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
Message-ID: <20230109153431.GB7817@willie-the-truck>
References: <20230109095948.2471205-1-ardb@kernel.org>
 <20230109151054.GA7817@willie-the-truck>
 <CAMj1kXEUhdBgHUe9yuShaSw0WNV3=V0L4-x1DOTi-hmtn0L96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEUhdBgHUe9yuShaSw0WNV3=V0L4-x1DOTi-hmtn0L96w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 04:20:34PM +0100, Ard Biesheuvel wrote:
> On Mon, 9 Jan 2023 at 16:11, Will Deacon <will@kernel.org> wrote:
> >
> > On Mon, Jan 09, 2023 at 10:59:48AM +0100, Ard Biesheuvel wrote:
> > > Nathan reports that recent kernels built with LTO will crash when doing
> > > EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
> > > misaligned load from the TPM event log, which is annotated with
> > > READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
> > > which does not tolerate misaligned accesses.
> >
> > Interesting, that's a funny change in behaviour. READ_ONCE() of an unaligned
> > address is pretty sketchy, but if this ends up tripping lots of folks up
> > then I suppose we could use a plain load and a DMB LD as an alternative.
> > It's likely to be more expensive in the LDAPR case, though.
> >
> 
> Yeah, I am not suggesting that we change READ_ONCE(), but this case
> was definitely not taken into account at the time.

Indeed, and it looks like the architecture added SCTLR_ELx.nAA to toggle
this behaviour, although it was only added in 8.4 with FEAT_LSE2.

> > > Interestingly, this does not happen when booting the same kernel
> > > straight from the UEFI shell, and so the fact that the event log may
> > > appear misaligned in memory may be caused by a bug in GRUB or SHIM.
> > >
> > > However, using READ_ONCE() to access firmware tables is slightly unusual
> > > in any case, and here, we only need to ensure that 'event' is not
> > > dereferenced again after it gets unmapped, so a compiler barrier should
> > > be sufficient, and works around the reported issue.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Peter Jones <pjones@redhat.com>
> > > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1782
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  include/linux/tpm_eventlog.h | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
> > > index 20c0ff54b7a0d313..0abcc85904cba874 100644
> > > --- a/include/linux/tpm_eventlog.h
> > > +++ b/include/linux/tpm_eventlog.h
> > > @@ -198,8 +198,10 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
> > >        * The loop below will unmap these fields if the log is larger than
> > >        * one page, so save them here for reference:
> > >        */
> > > -     count = READ_ONCE(event->count);
> > > -     event_type = READ_ONCE(event->event_type);
> > > +     count = event->count;
> > > +     event_type = event->event_type;
> > > +
> > > +     barrier();
> >
> > It would be handy to have a comment here, but when I started thinking about
> > what that would say, it occurred to me that the unmap operation should
> > already have a barrier inside it due to the TLB invalidation, so I'm not
> > sure why this is needed at all.
> >
> 
> This is purely to prevent the compiler from accessing count or
> event_type by reloading it from the event pointer, in case it runs out
> of registers.

But that reload would only be a problem if the event has been unmapped, no?
Given that the unmapping code has a barrier() and the unmapped page is not
explicitly referenced, then I don't see the issue.

Will
