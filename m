Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC86662A5F
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjAIPql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbjAIPqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:46:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A717542E3C;
        Mon,  9 Jan 2023 07:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020616116D;
        Mon,  9 Jan 2023 15:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3E2C4339B;
        Mon,  9 Jan 2023 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673279021;
        bh=jX2M91ZsBIkNRo7LR0kkDmoHShH5AA5eueGeGJMC9cM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dzcdouQkpyqXmSpSV+a2dlDkMEev7E4BylaZCs/cng//bEMjwY94FVRgZORjDeoLN
         s6diXIKp1WYNppJ9byBvkwOoIBU9ju+BW4cUFSOi31E8Ij6pHnPQebM2P/1GZfHcwz
         lzlhz96c29tAP89AxFH4Ya0mJ+xpM4Mpf1LXA7ImtdpLOIwO4QpdSXtRX2EFbxWQa3
         Ge4R3lX9qK8FyGBV6XxRmpJw+fELC0t96cKQ3GiCGQTYpAB9u9uupPsZqoSmyiIzja
         CbV/hEouzkg83dyKLj6P7XTcxdmzLCkf3+ujvkJ5akW8neFVhUIG7ltRyKg2I1gE01
         OVwKe04I9I9bg==
Received: by mail-lj1-f178.google.com with SMTP id y18so5716525ljk.11;
        Mon, 09 Jan 2023 07:43:41 -0800 (PST)
X-Gm-Message-State: AFqh2kpOss6c8u0FXyWjUnb5Ms9qvWrbiozcaa9v9XIBs7VeDzELO6UD
        xhZBL3Vlb27meITzIMyXrymd0/7Kt65rzIYZ/d4=
X-Google-Smtp-Source: AMrXdXswStzPhGQjQyC+bAaCpJ3LPCHsucq9q4I2JZ0y5uOS8Oub6nkLa+AcKdaeVJog0Ym/n4nasnVo/t5CuPJPiE0=
X-Received: by 2002:a2e:96ce:0:b0:283:33fa:ee22 with SMTP id
 d14-20020a2e96ce000000b0028333faee22mr308757ljj.415.1673279019250; Mon, 09
 Jan 2023 07:43:39 -0800 (PST)
MIME-Version: 1.0
References: <20230109095948.2471205-1-ardb@kernel.org> <20230109151054.GA7817@willie-the-truck>
 <CAMj1kXEUhdBgHUe9yuShaSw0WNV3=V0L4-x1DOTi-hmtn0L96w@mail.gmail.com> <20230109153431.GB7817@willie-the-truck>
In-Reply-To: <20230109153431.GB7817@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 9 Jan 2023 16:43:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFLvR1PWc1vC11Cm1iVUf7MS_ivYxt_hd6W5KDs1w3tHA@mail.gmail.com>
Message-ID: <CAMj1kXFLvR1PWc1vC11Cm1iVUf7MS_ivYxt_hd6W5KDs1w3tHA@mail.gmail.com>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Jan 2023 at 16:34, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jan 09, 2023 at 04:20:34PM +0100, Ard Biesheuvel wrote:
> > On Mon, 9 Jan 2023 at 16:11, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Mon, Jan 09, 2023 at 10:59:48AM +0100, Ard Biesheuvel wrote:
> > > > Nathan reports that recent kernels built with LTO will crash when doing
> > > > EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
> > > > misaligned load from the TPM event log, which is annotated with
> > > > READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
> > > > which does not tolerate misaligned accesses.
> > >
> > > Interesting, that's a funny change in behaviour. READ_ONCE() of an unaligned
> > > address is pretty sketchy, but if this ends up tripping lots of folks up
> > > then I suppose we could use a plain load and a DMB LD as an alternative.
> > > It's likely to be more expensive in the LDAPR case, though.
> > >
> >
> > Yeah, I am not suggesting that we change READ_ONCE(), but this case
> > was definitely not taken into account at the time.
>
> Indeed, and it looks like the architecture added SCTLR_ELx.nAA to toggle
> this behaviour, although it was only added in 8.4 with FEAT_LSE2.
>
> > > > Interestingly, this does not happen when booting the same kernel
> > > > straight from the UEFI shell, and so the fact that the event log may
> > > > appear misaligned in memory may be caused by a bug in GRUB or SHIM.
> > > >
> > > > However, using READ_ONCE() to access firmware tables is slightly unusual
> > > > in any case, and here, we only need to ensure that 'event' is not
> > > > dereferenced again after it gets unmapped, so a compiler barrier should
> > > > be sufficient, and works around the reported issue.
> > > >
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: Peter Jones <pjones@redhat.com>
> > > > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > > > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > > > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > > Link: https://github.com/ClangBuiltLinux/linux/issues/1782
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > ---
> > > >  include/linux/tpm_eventlog.h | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
> > > > index 20c0ff54b7a0d313..0abcc85904cba874 100644
> > > > --- a/include/linux/tpm_eventlog.h
> > > > +++ b/include/linux/tpm_eventlog.h
> > > > @@ -198,8 +198,10 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
> > > >        * The loop below will unmap these fields if the log is larger than
> > > >        * one page, so save them here for reference:
> > > >        */
> > > > -     count = READ_ONCE(event->count);
> > > > -     event_type = READ_ONCE(event->event_type);
> > > > +     count = event->count;
> > > > +     event_type = event->event_type;
> > > > +
> > > > +     barrier();
> > >
> > > It would be handy to have a comment here, but when I started thinking about
> > > what that would say, it occurred to me that the unmap operation should
> > > already have a barrier inside it due to the TLB invalidation, so I'm not
> > > sure why this is needed at all.
> > >
> >
> > This is purely to prevent the compiler from accessing count or
> > event_type by reloading it from the event pointer, in case it runs out
> > of registers.
>
> But that reload would only be a problem if the event has been unmapped, no?
> Given that the unmapping code has a barrier() and the unmapped page is not
> explicitly referenced, then I don't see the issue.
>

Fair point. Looking at the history, it was I who suggested the
READ_ONCE() here in addition to the changes to lift the explicit event
dereferences out of the loop, but it indeed seems unlikely that there
is any way the compiler could decide that it can dereference event
again to grab these quantities.

https://lore.kernel.org/all/20190826153028.32639-1-pjones@redhat.com/T/#u

So i'll drop the barrier() from this patch.

Thanks,
Ard.
