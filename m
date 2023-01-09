Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDAF6629C4
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjAIPWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjAIPWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE539FB4;
        Mon,  9 Jan 2023 07:20:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A2C361198;
        Mon,  9 Jan 2023 15:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737DDC433F2;
        Mon,  9 Jan 2023 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673277647;
        bh=G0amHNOGJLDgrMPLnSeZ5P04E28PJ5OyQkUalUdxOXU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ME3etlcLpvuGq111zuhTkXJMrNEtWmvCWg7kl2xDgHOx0TuwyXdk+zYq9ppaH/xUe
         F8mE5dUbfdh5jEEK18zlPyP4E9r72tAMiJWQi5qLC8qLfzqpyZH4a4qzuwMR6AHbzZ
         0So8Zs+h1424nD/ys1u1o99qY4tjUod/dNQR/REzt+THP8kENYC/uTrCLxjGh2c/PJ
         auQxBQtPAtKE9pi0RuJV0KcZ584b6m7N59MSBnoizAYhCKD805rvKSB3P57LdffTpl
         82YUis2/Z0XKMOYy2o5m+ZLPR4eemEe2X0onzT7DyTzJ9/pn3ma+M0xhKYtcWOCmlP
         1eqiTPX1gNtPw==
Received: by mail-lj1-f172.google.com with SMTP id g14so9163119ljh.10;
        Mon, 09 Jan 2023 07:20:47 -0800 (PST)
X-Gm-Message-State: AFqh2kohyWKkHGaeOFuMuW0PJaZ4b3oqX0wX3N/o+ZYq5+GxAnZBPISA
        tHBbsOe8VfxmbA6smMl3NF43yhQlDY9WKv88Vl4=
X-Google-Smtp-Source: AMrXdXvJ7YptjTwPvk0wYPENOEpPQkGZG/qbn1mPYqHdw4HQxlULT7U4oO4iKeP5ob0pa8hrswTpjMjy73bxZGGcJEU=
X-Received: by 2002:a2e:a99b:0:b0:27f:b833:cf6d with SMTP id
 x27-20020a2ea99b000000b0027fb833cf6dmr4298948ljq.291.1673277645408; Mon, 09
 Jan 2023 07:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20230109095948.2471205-1-ardb@kernel.org> <20230109151054.GA7817@willie-the-truck>
In-Reply-To: <20230109151054.GA7817@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 9 Jan 2023 16:20:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEUhdBgHUe9yuShaSw0WNV3=V0L4-x1DOTi-hmtn0L96w@mail.gmail.com>
Message-ID: <CAMj1kXEUhdBgHUe9yuShaSw0WNV3=V0L4-x1DOTi-hmtn0L96w@mail.gmail.com>
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

On Mon, 9 Jan 2023 at 16:11, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jan 09, 2023 at 10:59:48AM +0100, Ard Biesheuvel wrote:
> > Nathan reports that recent kernels built with LTO will crash when doing
> > EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
> > misaligned load from the TPM event log, which is annotated with
> > READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
> > which does not tolerate misaligned accesses.
>
> Interesting, that's a funny change in behaviour. READ_ONCE() of an unaligned
> address is pretty sketchy, but if this ends up tripping lots of folks up
> then I suppose we could use a plain load and a DMB LD as an alternative.
> It's likely to be more expensive in the LDAPR case, though.
>

Yeah, I am not suggesting that we change READ_ONCE(), but this case
was definitely not taken into account at the time.

> > Interestingly, this does not happen when booting the same kernel
> > straight from the UEFI shell, and so the fact that the event log may
> > appear misaligned in memory may be caused by a bug in GRUB or SHIM.
> >
> > However, using READ_ONCE() to access firmware tables is slightly unusual
> > in any case, and here, we only need to ensure that 'event' is not
> > dereferenced again after it gets unmapped, so a compiler barrier should
> > be sufficient, and works around the reported issue.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: Peter Jones <pjones@redhat.com>
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1782
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  include/linux/tpm_eventlog.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
> > index 20c0ff54b7a0d313..0abcc85904cba874 100644
> > --- a/include/linux/tpm_eventlog.h
> > +++ b/include/linux/tpm_eventlog.h
> > @@ -198,8 +198,10 @@ static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *ev
> >        * The loop below will unmap these fields if the log is larger than
> >        * one page, so save them here for reference:
> >        */
> > -     count = READ_ONCE(event->count);
> > -     event_type = READ_ONCE(event->event_type);
> > +     count = event->count;
> > +     event_type = event->event_type;
> > +
> > +     barrier();
>
> It would be handy to have a comment here, but when I started thinking about
> what that would say, it occurred to me that the unmap operation should
> already have a barrier inside it due to the TLB invalidation, so I'm not
> sure why this is needed at all.
>

This is purely to prevent the compiler from accessing count or
event_type by reloading it from the event pointer, in case it runs out
of registers.

Perhaps this is unlikely to occur, given that the kernel uses
-fno-strict-aliasing, and so any store occurring after this
READ_ONCE() could potentially affect the result of accessing
event->count or event->event_type.
