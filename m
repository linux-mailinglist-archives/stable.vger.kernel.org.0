Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21F33185A2
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 08:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBKHY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 02:24:28 -0500
Received: from condef-02.nifty.com ([202.248.20.67]:42116 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBKHY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 02:24:27 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2021 02:24:25 EST
Received: from conssluserg-04.nifty.com ([10.126.8.83])by condef-02.nifty.com with ESMTP id 11B7DDjQ021497
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:13:13 +0900
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 11B7CFW4026666;
        Thu, 11 Feb 2021 16:12:15 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 11B7CFW4026666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1613027536;
        bh=3uTsFhncO9j2uWw71VszMc/8qXJiR1mM5uIIs5ZLtB8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=01HDiUMX03JxXxYd/PEn4GPkhJr2L9K2yL7ymdkLj1VFK6sPziZE5qsnkbJ2wd1Q6
         Y3TiSDWj7CRUY3kGVD1FM1mm5dmtUvr7yI1nPSScyR4yD+MQ0EyC998ICGbxHcZxMM
         7jbPj8uR8f9ingq2da2jG8WHbXqQDPGSK44KGuKso/Uk5okv0dVL+eCUgik7vEpPOE
         nRV/DBfL+c4xUHn5InB3ursaQWj1QZH5lVlG4KK9uvU/tA0rE6TjdMdHjsWbtBhnh/
         s3/ns/Ge4SqNnbPAjBVfxKiaV1LS2AcrMFvE9MIumyuZcvhWXaFOLCDEW/kUWF46Z+
         7Wn47FaX8VWxg==
X-Nifty-SrcIP: [209.85.216.43]
Received: by mail-pj1-f43.google.com with SMTP id nm1so2894904pjb.3;
        Wed, 10 Feb 2021 23:12:15 -0800 (PST)
X-Gm-Message-State: AOAM530tRHove1WUsntue7ZIs1e8Yw/H7vVckF55TGyNnjGrCoi7d/iK
        nRV/3S/0deYzVZU7RpdwvUc46hidWhV5jC//2vo=
X-Google-Smtp-Source: ABdhPJx02/hZAwunL54hiS/7i6cptJtBKT67YhWi0l70bying22Iln3/zhLUQdgo6XXG1NNawwVHTsVyb+uL2V8/Ers=
X-Received: by 2002:a17:90b:1b50:: with SMTP id nv16mr2567307pjb.153.1613027534692;
 Wed, 10 Feb 2021 23:12:14 -0800 (PST)
MIME-Version: 1.0
References: <20210209050047.1958473-1-daniel.diaz@linaro.org>
In-Reply-To: <20210209050047.1958473-1-daniel.diaz@linaro.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 11 Feb 2021 16:11:37 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR-OFSYERwX45gy=WyVkBBaUEVY_UBS0ZNj5T+B0a6+Xw@mail.gmail.com>
Message-ID: <CAK7LNAR-OFSYERwX45gy=WyVkBBaUEVY_UBS0ZNj5T+B0a6+Xw@mail.gmail.com>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Rolf Eike Beer <eb@emlix.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 9, 2021 at 2:01 PM Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
>
> When compiling under OpenEmbedded, the following error is seen
> as of recently:
>
>   /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
>   /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a i=
nside /
>   /srv/oe/build/tmp/hosttools/ld: cannot find /lib/ld-linux-x86-64.so.2 i=
nside /
>   collect2: error: ld returned 1 exit status
>   make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1
>
> This is because 2cea4a7a1885 ("scripts: use pkg-config to
> locate libcrypto") now calls for `pkg-config --libs libcrypto`
> and inserts that into the Makefile rules as LDLIBS when
> building extract-cert.c.
>
> The problem is that --libs will include both -l and -L, which
> will be out of order when compiling/linking.
>
> This (very ugly) command is what's produced with OpenEmbedded:
>
>   gcc -Wp,-MMD,scripts/.extract-cert.d -Wall -Wmissing-prototypes -Wstric=
t-prototypes \
>     -O2 -fomit-frame-pointer -std=3Dgnu89 \
>     -isystem/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r=
0/recipe-sysroot-native/usr/include \
>     -O2 -pipe -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d=
83-r0/recipe-sysroot-native/usr/lib \
>     -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/reci=
pe-sysroot-native/lib \
>     -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f=
250d83-r0/recipe-sysroot-native/usr/lib \
>     -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f=
250d83-r0/recipe-sysroot-native/lib \
>     -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d8=
3-r0/recipe-sysroot-native/usr/lib \
>     -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d8=
3-r0/recipe-sysroot-native/lib \
>     -Wl,-O1 -I/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83=
-r0/recipe-sysroot-native/usr/include \
>     -I ./scripts -o scripts/extract-cert \
>     /oe/build/tmp/work-shared/intel-corei7-64/kernel-source/scripts/extra=
ct-cert.c \
>     -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/reci=
pe-sysroot/usr//lib \
>     -lcrypto
>
> As per `make`'s documentation:
>
>   LDFLAGS
>     Extra flags to give to compilers when they are supposed to
>     invoke the linker, =E2=80=98ld=E2=80=99, such as -L. Libraries (-lfoo=
)
>     should be added to the LDLIBS variable instead.
>
>   LDLIBS
>     Library flags or names given to compilers when they are
>     supposed to invoke the linker, =E2=80=98ld=E2=80=99. LOADLIBES is a
>     deprecated (but still supported) alternative to LDLIBS.
>     Non-library linker flags, such as -L, should go in the
>     LDFLAGS variable.
>
> Fixes: 2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto")
> Cc: stable@vger.kernel.org # 5.6.x
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
> ---
>  scripts/Makefile | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 9de3c03b94aa..4b4e938b4ba7 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -3,7 +3,8 @@
>  # scripts contains sources for various helper programs used throughout
>  # the kernel for the build process.
>
> -CRYPTO_LIBS =3D $(shell pkg-config --libs libcrypto 2> /dev/null || echo=
 -lcrypto)
> +CRYPTO_LDFLAGS =3D $(shell pkg-config --libs-only-L libcrypto 2> /dev/nu=
ll)
> +CRYPTO_LDLIBS =3D $(shell pkg-config --libs-only-l libcrypto 2> /dev/nul=
l || echo -lcrypto)
>  CRYPTO_CFLAGS =3D $(shell pkg-config --cflags libcrypto 2> /dev/null)
>
>  hostprogs-always-$(CONFIG_BUILD_BIN2C)                 +=3D bin2c
> @@ -17,9 +18,11 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)  +=
=3D insert-sys-cert
>
>  HOSTCFLAGS_sorttable.o =3D -I$(srctree)/tools/include
>  HOSTCFLAGS_asn1_compiler.o =3D -I$(srctree)/include
> -HOSTLDLIBS_sign-file =3D $(CRYPTO_LIBS)
> +HOSTLDFLAGS_sign-file =3D $(CRYPTO_LDFLAGS)
> +HOSTLDLIBS_sign-file =3D $(CRYPTO_LDLIBS)
>  HOSTCFLAGS_extract-cert.o =3D $(CRYPTO_CFLAGS)
> -HOSTLDLIBS_extract-cert =3D $(CRYPTO_LIBS)
> +HOSTLDFLAGS_extract-cert =3D $(CRYPTO_LDFLAGS)
> +HOSTLDLIBS_extract-cert =3D $(CRYPTO_LDLIBS)
>
>  ifdef CONFIG_UNWINDER_ORC
>  ifeq ($(ARCH),x86_64)
> --
> 2.25.1
>


I am wondering how "HOSTLDFLAGS_sign-file" and
"HOSTLDFLAGS_extract-cert" worked for you.


Kbuild supports HOSTLDLIBS_<target> syntax,
but not HOSTLDFLAGS_<target>.


I see $(HOSTLDLIBS_$(target-stem) in scripts/Makefile.host
but failed to find $(HOSTLDFLAGS_$(target-stem)).

So, presumably you will get the same result
(OE build error will be fixed)
even without HOSTLDFLAGS_sign-file
or HOSTLDFLAGS_extract-cert.



But, I am still wondering what the correct approach is.



Basically, there are two ways to link libraries
in non-standard paths.



[1] Give linker flags via HOSTLDFLAGS

   This is documented in Documentation/kbuild/kbuild.rst

   HOSTLDFLAGS
   -----------
   Additional flags to be passed when linking host programs.




[2] Use pkg-config






OE already adopted [1].

I think the following long lines came from HOSTLDFLAGS.

    -isystem/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/=
recipe-sysroot-native/usr/include
\
    -O2 -pipe -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83=
-r0/recipe-sysroot-native/usr/lib
\
    -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/recipe=
-sysroot-native/lib
\
    -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f25=
0d83-r0/recipe-sysroot-native/usr/lib
\
    -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f25=
0d83-r0/recipe-sysroot-native/lib
\
    -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-=
r0/recipe-sysroot-native/usr/lib
\
    -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-=
r0/recipe-sysroot-native/lib
\
    -Wl,-O1 -I/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r=
0/recipe-sysroot-native/usr/include
\
    -I ./scripts -o scripts/extract-cert \




But, some people are not satisfied with [1] (or do not notice it)?


Then, 2cea4a7a1885 introduced the second one [2].

Mixing [1] and [2] perhaps confuses the build system somehow?




So, 2cea4a7a1885 was a problem, but
I do not think this patch is the right one either.

(At least, HOSTLDFLAGS_* additions are pointless)




--=20
Best Regards
Masahiro Yamada
