Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7336492161
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbiARIiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:38:50 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:50239 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240240AbiARIiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:38:50 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MWSJJ-1mpXff3NgB-00XuU5 for <stable@vger.kernel.org>; Tue, 18 Jan 2022
 09:38:49 +0100
Received: by mail-ot1-f49.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso9655215otb.11
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:38:48 -0800 (PST)
X-Gm-Message-State: AOAM533IG2fBkxa1is7CsbDXAERhJBRWEHwmu7hZWoMMv1Op0/hJV+AK
        kv5AL2cOnb3G1qkgqtwCrzKYwRHbUQvmIjFZeI8=
X-Google-Smtp-Source: ABdhPJx6fg697PgpU7sBmOy6sXrWE/A6JLoZclR8yjHZeOBESVtcWrEXO7ZT0ds9xGKOm06yGNp5kO7XwZ8+N4LdPVo=
X-Received: by 2002:a05:6830:791:: with SMTP id w17mr19876040ots.72.1642495127563;
 Tue, 18 Jan 2022 00:38:47 -0800 (PST)
MIME-Version: 1.0
References: <20220118082808.931129-1-ardb@kernel.org>
In-Reply-To: <20220118082808.931129-1-ardb@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jan 2022 09:38:31 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0XGEZSTWy=24fEckPxtLoOt7sF7SYzF+QZEMooiW4BsA@mail.gmail.com>
Message-ID: <CAK8P3a0XGEZSTWy=24fEckPxtLoOt7sF7SYzF+QZEMooiW4BsA@mail.gmail.com>
Subject: Re: [PATCH] ARM: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rsK4HXta1ojJUGCivix4GEwApQvbhoiVg+b7pELI7iw6kbLA+rp
 E9BIGzfhtSQxRSGNEjDVD/s5Mv6kczyIbBNMxXP7R0J8ZoY9U8uwe22/Yy1/gdbVjRPtSXg
 7mhYZ5C82yNx68eyHbwISz0oVDYHzqRS/crHnK9gkarTzlCNiUsvmqpB/5gys2cOrkxi9pU
 Pq6u3qbkOXcVtsJWUnyUg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Le0iD6IR/xw=:7jefV9LKIlOH3i5qNnsAv3
 cRmC+wnF7n9HKXe0i9+MFk66K/Tyh3N7qczDTA3eYd3W7LAmNITAiMdHq1TPg3IXz3sLaf8F5
 NeHspHX15N26+8eWaO0CUJlNmB3ZSmhzkOpxw0tlhpghC7ZaSjFB00JyDW/Qsx6PuQH6wdW/H
 2gFtNhTUvTi3xcBWCM3RqSNYiIRknFj5YVAluNb28J4WLxg7WSNjgAaBZg03dcK4IC3/oI0XO
 X26AOuRxdaVAyGHxCUv0Ociv2Eqkyo/szxfOwWvyQcrSJX1ZfnVYY8+0qT2KwsQxXj0oeWMhf
 Ksm6NojrqFwoyxqbDvv1oaHh7VQtrcRWT9Wu5pk3ScIVPtGrPnfVl3my5O3vNSk09pMm/VAsr
 GXwKuS38s75iYwrK+TMjDn4+/SAnEFjv5Ev5dw1r55TlmOYmZyUpm2U/mQVnwbhHIRwjsJUH3
 LZDx0Fwcc1subhYnInOL7c/ia/m4CkQ602l+6WS91q51YKVQaeOPOAJR+ONXH+6as4rMamTju
 chfoQtRphVcQ30et74FWwmSqI3WD9x/yGeEzFtXitSN/nCtGCZvN7Hyn5PrySg4i46Wswxm4n
 ZzSl5e6ApxTUN9WtnklTc26Lk5NqKDBlRQmFRwzDbg6wRPaY59ygwfLRH9JTEHr2ycJdnzoPI
 OK2ngeVQwh3YcbE9JDsxCY1cLPX/zDnooFSayVsltTTeDlPgv/2OY3VL+Ng1Xe5rzUy4haoQu
 mvHXZDwzBgsfW+z4k7jsPV3pXCWv9f3zyfz+GEqffJofsK+G3Dzfg+anaDF5Ft71Ubfg/nBdF
 oKT+fCeHit3EJ6f+osfogUxxZZp6/Cn4lXFMulT5SfoYkitvBk=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 9:28 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The helpers that are used to implement copy_from_kernel_nofault() and
> copy_to_kernel_nofault() cast a void* to a pointer to a wider type,
> which may result in alignment faults on ARM if the compiler decides to
> use double-word or multiple-word load/store instructions.
>
> So use the unaligned accessors where needed: when the type's size > 1
> and the input was not aligned already by the caller.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 2df4c9a741a0 ("ARM: 9112/1: uaccess: add __{get,put}_kernel_nofault")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

It took me a bit to see whythis works, maybe mention commit 2423de2e6f4d
("ARM: 9115/1: mm/maccess: fix unaligned copy_{from,to}_kernel_nofault")
in the description for clarification.

Did you run into actual faults, or did you find this problem by
reading the code?

         Arnd
