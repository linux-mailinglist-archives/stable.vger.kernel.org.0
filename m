Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABE26B3D9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIOXLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgIOXLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 19:11:08 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECB1C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:11:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so2785449pgl.10
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ejKAlDLK9UWIbMwInXUY/PDlDWa5qsu2LYQ6i/9HXFM=;
        b=KHG2vbOWJxMxjnsh+S1sWXh95shYieMHEsjz4iKp3x9QfRdSwjtkT6btpPUbozst14
         23Uawwh/4BXHMg1qMvi6HIlSl5DGfMed8SZprNwn/GWstVP5ROvbjRgvMDnav5g4p+yf
         EkuthYVj4yWExMdR4u46ODhjcpfKSnQfoNcSt4B+R7AYAD+5C37bQkHbUJSIXQ4FsPLT
         zabUTZpZjAt+jm+gSdhKyqpffbV/oT2mkwMOgwTqkmWV7imb1NGv7w6WxKQqJLSDO+4G
         2dc3azJOMxqMZauZKEoHwXzYBZU1G3KkGxjveqMOorgaFTM24xr5l/XH1FvcW8tNpKwf
         B01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ejKAlDLK9UWIbMwInXUY/PDlDWa5qsu2LYQ6i/9HXFM=;
        b=pscpkGONSfabGw8bEHCVWcXFcp4Pnqd0T+h8J9Lz5bQk1dB/FaP/J3qcIbsXy/uBEQ
         EuJdRHkLXi5RxHmvlRykNGWGOGpGwQ4e/vse6xapExYKa2SsYhjF0Jb/iwp6uOefe/eb
         Vgce5HJP7XJJGFHGEDUvoVhDYMSjaiF/n2kDShSBGAt3tJFeKG9JcktcTIKcsB39mOp4
         qJIuJmEWiCYDLX/7KRM1Ks5I65CsU6J9j3FT2/EuQ1NTOpbK+vF32YneVszYJOtHjNEr
         Jk2fiz/dQ5GGIiPAPs5LU7xvfeLZr3UDBh/1ayEmX6/BkRbq8Nb6/TxOUGxJgd0e8Ifa
         HfEw==
X-Gm-Message-State: AOAM532tfIoWMOn87xLBFzFjBwstl1rKSznLfvbLLwcddpG3/vsyEePe
        psCot8BtPwYKzwkdyH/E7WV6oQ==
X-Google-Smtp-Source: ABdhPJwY+B6vjUUrVrR2gqGPeTejtBjJScxtUWVPmWxiI2qktO4A8qsjyaZAmUSKHMAXoLM1sA4/Vw==
X-Received: by 2002:a63:4a0a:: with SMTP id x10mr11653517pga.21.1600211466725;
        Tue, 15 Sep 2020 16:11:06 -0700 (PDT)
Received: from ?IPv6:2600:1010:b025:1a05:79dc:fef9:f308:6141? ([2600:1010:b025:1a05:79dc:fef9:f308:6141])
        by smtp.gmail.com with ESMTPSA id bb6sm498350pjb.15.2020.09.15.16.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 16:11:05 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
Date:   Tue, 15 Sep 2020 16:11:03 -0700
Message-Id: <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net>
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Bill Wendling <morbo@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
In-Reply-To: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
X-Mailer: iPhone Mail (17H35)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Sep 15, 2020, at 2:24 PM, Nick Desaulniers <ndesaulniers@google.com> wr=
ote:
>=20
> =EF=BB=BFOn Tue, Sep 15, 2020 at 1:56 PM Andy Lutomirski <luto@kernel.org>=
 wrote:
>>=20
>> The old smap_save() code was:
>>=20
>>  pushf
>>  pop %0
>>=20
>> with %0 defined by an "=3Drm" constraint.  This is fine if the
>> compiler picked the register option, but it was incorrect with an
>> %rsp-relative memory operand.
>=20
> It is incorrect because ... (I think mentioning the point about the
> red zone would be good, unless there were additional concerns?)

This isn=E2=80=99t a red zone issue =E2=80=94 it=E2=80=99s a just-plain-wron=
g issue.  The popf is storing the result in the wrong place in memory =E2=80=
=94 it=E2=80=99s RSP-relative, but RSP is whatever the compiler thinks it sh=
ould be minus 8, because the compiler doesn=E2=80=99t know that pushfq chang=
ed RSP.

>=20
> This is something we should fix.  Bill, James, and I are discussing
> this internally.  Thank you for filing a bug; I owe you a beer just
> for that.

I=E2=80=99m looking forward to the day that beers can be exchanged in person=
 again :)

>=20
>>=20
>> Fixes: e74deb11931f ("x86/uaccess: Introduce user_access_{save,restore}()=
")
>> Cc: stable@vger.kernel.org
>> Reported-by: Bill Wendling <morbo@google.com> # I think
>=20
> LOL, yes, the comment can be dropped...though I guess someone else may
> have reported the problem to Bill?

The =E2=80=9CI think=E2=80=9D is because I=E2=80=99m not sure whether Bill r=
eported this particular issue. But I=E2=80=99m fine with dropping it.=
