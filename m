Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044DD4924FD
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbiARLdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:33:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46388 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiARLdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:33:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 370E7B815D2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 11:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EC5C36AE3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 11:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642505589;
        bh=9S/8A/Iy+KaiUmvXLFXuRApVsJRDz/2g99eLjx6Wd/0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sYo9imNghGE46T+9p+wHPvk/vjnqVcwBZcYI9I1EfAlL95oo619Gj3QzkRZBxsVBL
         tbozDt5i2Nc1iXEwdz8lLdBpKitFqVADKYg/virhH3yq/iQXjvwrei3MTIbzP3lc2u
         LJHvzijN38/5R3iWdbjp/kyKzQtfsyqJUWUbDNDtUQsu4W/MUqkkOwh9mILNUX4j7E
         V3Rf4L/Q0/BUSxiHu/5luHFF6m0QLPUdt1/tLFHMsjuGkN4KXSipeiFdlkJl2Q1PWt
         T7hlKOw/FnKB2jAMHAlwPiUtn3W4bIbRZKymbUPjCGPaj8tZTzkQuDhEokxk2GNOLB
         0VqxWEdDYbeAA==
Received: by mail-wm1-f48.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso3556671wma.1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 03:33:08 -0800 (PST)
X-Gm-Message-State: AOAM530YJKAyuEmw3M+kprpFs8eiuQeBeDesXuQniMDvv/9Y5SOB34/r
        io8yIgyFm9pQZs9u13f9pGEyAuHpAbRZ7TCpZbY=
X-Google-Smtp-Source: ABdhPJyqmvvkEYOtV9hw1kReg78mNOc9h11VFekVsE5/9hLnEX7g+/G3rOjJ0A13ChHXpXm8YyGsk18CNIhFbjOQgjQ=
X-Received: by 2002:a5d:6d85:: with SMTP id l5mr9316186wrs.447.1642505587362;
 Tue, 18 Jan 2022 03:33:07 -0800 (PST)
MIME-Version: 1.0
References: <20220118102756.1259149-1-ardb@kernel.org> <YeaisFN1ru7suF1Y@shell.armlinux.org.uk>
In-Reply-To: <YeaisFN1ru7suF1Y@shell.armlinux.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Jan 2022 12:32:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHTXeLPWbnQpkEen2uy6ameVL27QfeN2MZpdBB21Wj14w@mail.gmail.com>
Message-ID: <CAMj1kXHTXeLPWbnQpkEen2uy6ameVL27QfeN2MZpdBB21Wj14w@mail.gmail.com>
Subject: Re: [PATCH] ARM: Thumb2: align ALT_UP() sections sufficiently
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 at 12:21, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jan 18, 2022 at 11:27:56AM +0100, Ard Biesheuvel wrote:
> > When building for Thumb2, the .alt.smp.init sections that are emitted by
> > the ALT_UP() patching code may not be 32-bit aligned, even though the
> > fixup_smp_on_up() routine expects that. This results in alignment faults
> > at module load time, which need to be fixed up by the fault handler.
> >
> > So let's align those sections explicitly, and avoid this from occurring.
>
> Are you seeing a problem that this patch fixes?
>
> This really should not matter. .alt.smp.init contents are always a whole
> number of 32-bit words. These are gathered by the linker into the
> .init.smpalt section, so the contents should always be a whole number
> of 32-bit words.
>
> This follows the .init.tagtable section, which is also a 32-bit word
> aligned structure built by the linker... which follows the
> .init.arch.info section and .init.proc.info sections which all have
> 32-bit alignment requirements.
>

This only affects modules, not the core kernel. The .alt.smp.init
section in a module is visible to the module loader, which means the
module loader will make no attempt to position it at a 32-bit aligned
address if the ELF alignment is only 16 bits, which appears to be the
default in my Thumb2 build [gcc version 10.3.1 20211117 (Debian
10.3.0-13)]

I only spotted this because do_fixup_smp_on_up() was shown as the most
recent in-kernel fixup location in /proc/cpu/alignment.
