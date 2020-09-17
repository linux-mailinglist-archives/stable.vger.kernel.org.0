Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B826D362
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 08:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIQGEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 02:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQGEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 02:04:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB98C06174A;
        Wed, 16 Sep 2020 23:04:42 -0700 (PDT)
Received: from zn.tnic (p200300ec2f1053004ecb76e63d7beff7.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:5300:4ecb:76e6:3d7b:eff7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8BC11EC03A0;
        Thu, 17 Sep 2020 08:04:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600322679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/a3iXaOCnVbs+tv2C+NH3qhihwfg99V7VZvy9ZISaA=;
        b=ZTyBFJpgiiWtsEmEhJ8BylR7v9Rb+F3a8TqZ5M1H45KNCBLZ3LDpmKQEOA7/bBj5c/OxZJ
        D8NNyIMj619IwVvw7eulJwNtVbVkPXNbLhUnfGYAXXKfiT8KeXzo0EVvsHP6wSEXha8KnS
        XNZQarfqGe4GRUdnWaPiTyP5uqQGmO4=
Date:   Thu, 17 Sep 2020 08:04:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Bill Wendling <morbo@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
Message-ID: <20200917060432.GA31960@zn.tnic>
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net>
 <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
 <20200916082621.GB2643@zn.tnic>
 <be498e49-b467-e04c-d833-372f7d83cb1f@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be498e49-b467-e04c-d833-372f7d83cb1f@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 11:48:42PM +0100, Andrew Cooper wrote:
> Every day is a school day.

Tell me about it...

> This is very definitely one to be filed in obscure x86 corner cases.
> 
> The code snippet above is actually wrong for the kernel, as it uses one
> slot of the red-zone.  Recompiling with -mno-red-zone makes something
> which looks safe stack-wise, give or take this behaviour.

Right, we recently disabled red zone in the early decompression stage,
for SEV-ES:

https://git.kernel.org/tip/6ba0efa46047936afa81460489cfd24bc95dd863

I probably should go audit that for similar funnies:

$ objdump -d arch/x86/boot/compressed/vmlinux | grep -E "pop.*\(%[er]?sp"
$

Nope, nothing. Because building your snippet with:

$ gcc -Wall -O2 -mno-red-zone -o flags{,.c}

still does use that one slot:

0000000000001050 <main>:
    1050:       48 83 ec 18             sub    $0x18,%rsp
    1054:       48 8d 3d a9 0f 00 00    lea    0xfa9(%rip),%rdi        # 2004 <_IO_stdin_used+0x4>
    105b:       31 c0                   xor    %eax,%eax
    105d:       9c                      pushfq
    105e:       8f 44 24 08             popq   0x8(%rsp)
    1062:       48 8b 74 24 08          mov    0x8(%rsp),%rsi

Wonder if that flag -mno-red-zone even does anything...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
