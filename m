Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F30A65D63D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbjADOnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbjADOmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:42:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17267188;
        Wed,  4 Jan 2023 06:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A393D6176B;
        Wed,  4 Jan 2023 14:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3CEC433F2;
        Wed,  4 Jan 2023 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672843356;
        bh=2h6S36bZJ85jADuzLHYnhUt+Q2Kq22quMH8ZU54eN8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cjVd33us2AS+rA9ls3Z47M+j6oGpkMzpBLYCVej146IZ7dho6+IDlN2eVyCAzilwb
         Re7dfGegDBUc3CxEEfNsEbLj58NEu/8DIAWUAXR1A3TjHriVXFGd3Mi1EpaEGnSuli
         jwnGTH2m62ntlBchVJoWRykTOXlLov+xkcKk/Apz8xpEhxKi/seIfRVhd5dXByYndK
         KnTvWvDcEWwY+DCOyPkag504YwAjp8UnmzswlGQbUjjmvzTH03XPnaDFCAfpxCdiut
         MBiISMlJsw63dSfizcCVt1LwZYb030tZR9BFDEB2ErXmeKFye7LOSJF47IE0CKT3gz
         FAxHFm5pL70zw==
Date:   Wed, 4 Jan 2023 14:42:30 +0000
From:   Lee Jones <lee@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        catalin.marinas@arm.com, mark.rutland@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y7WQVreh3l9hYarK@google.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com>
 <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 Jan 2023, Ard Biesheuvel wrote:

> On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> >
> > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> >
> > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > to manage concurrent calls into firmware, but also that firmware calls
> > > may occur that are not marshalled via the workqueue mechanism, but
> > > originate directly from the caller context.
> > >
> > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > of stack space available as per the EFI spec, introduce a spinlock
> > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > runtime calls) and other callers of efi_call_virt_pointer().
> > >
> > > While at it, use the stack pivot to avoid reloading the shadow call
> > > stack pointer from the ordinary stack, as doing so could produce a
> > > gadget to defeat it.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/efi.h       |  3 +++
> > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > >  3 files changed, 40 insertions(+), 1 deletion(-)
> >
> > Could we have this in Stable please?
> >
> > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> >
> > Ard, do we need Patch 2 as well, or can this be applied on its own?
> >
> 
> Thanks for the reminder.
> 
> Only patch #1 is needed. It should be applied to v5.10 and later.

Perfect, thanks Ard.

-- 
Lee Jones [李琼斯]
