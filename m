Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB81B1C5D
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 05:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgDUDCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 23:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgDUDCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 23:02:41 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C81C061A0E
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 20:02:41 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o139so6582708ybc.11
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 20:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Xg0ucvJ0a4x795cVc9Dbnu3XcqL9TQ6pJuuArFyuuuk=;
        b=iAt3qsTApeIRBR+tkdloRs+/PdItY/G9W2VdQ0Fl0rlJR0rkE1Gg9/6l2CFfa8CP+8
         /nP8xJ9wctmEUEc4nRlI6cEHsuIPUuNhTsUthC2hxM1Jw/3LRiMom4LtIghN+NnwGDgR
         Gm2O4FSsmvwpOHt1KYYRBu6EHoB27ElM3iYEJHrT8jz60/fW+bfpfKZQVINd00zx5iNR
         SGvfqTmWFntfHi31btgxdsFE3lbyYr2nws+mFyjIsVK4FXTphG4hBWSJH1XJkJe+JEb5
         8gOBkARSRtJWM6/nR0KkmGCJQyrO/fiboByhK6S1H0exU3BymgcUGZIrLHreUsTi2a8o
         I5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Xg0ucvJ0a4x795cVc9Dbnu3XcqL9TQ6pJuuArFyuuuk=;
        b=VakF+p0p64smc3DKMuTEbfQjikBWwOfyzroElXjLN8TJhsKysOrleUHuAOeI+sys1w
         TesqaJuTPgF7vkixQS7k/FSFQ2VIaSEyRry/v7Uo9sWYifGer/MSyrofXoyuxZZW6xko
         j0PXOXS07B9al5jeaoNJJS9r5QbTc+8QpNtwWVOT60WeT8Npf5Bm7xeDFQvN/qZwk8mL
         7Vu05K1Kt2jmyVl3bX2whIoQK/QSv/00EoZSqZajOGyvlEjRS8nq1kPGFmgMkKbs7UL/
         rm/+S/Lrof6iprrDp5MR84+O0S/CPe06GhOjkPAFZkMXtYc3uuIEPsxiGj7+tYArQzx5
         FXWg==
X-Gm-Message-State: AGi0PuaiI/+EmX0wcgy48t45+SJwGTETwfgYUf4VtJ66rYHMsSghUWry
        1OGG1lLMULsrcaYffXf+NdQ3gkayCUAhHRqHdxPuzgC7
X-Google-Smtp-Source: APiQypJmbCvynbd3Q0T2VqpQc3gpw3sauzrGnsfmRiAhT3xukFQsf/SO7QwTo1i8DuoTQaXqW8U8EmmSbisG2ERCAzs=
X-Received: by 2002:a25:2454:: with SMTP id k81mr23726745ybk.470.1587438160774;
 Mon, 20 Apr 2020 20:02:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a25:3615:0:0:0:0:0 with HTTP; Mon, 20 Apr 2020 20:02:39
 -0700 (PDT)
From:   =?UTF-8?B?5p2O5LmJ?= <yilikernel@gmail.com>
Date:   Tue, 21 Apr 2020 11:02:39 +0800
Message-ID: <CAJfdMYCeexsnxk3C1bZNgSubf91wHGPbO6DGWAZq-fERfaPk4A@mail.gmail.com>
Subject: Re: [PATCH] uapi: fix userspace breakage, use __BITS_PER_LONG for swap
To:     Yi Li <yili@winhong.com>
Cc:     stable <stable@vger.kernel.org>, borntraeger@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> QEMU has a funny new build error message when I use the upstream kernel h=
eaders:
>
>   CC      block/file-posix.o
> In file included from /home/cborntra/REPOS/qemu/include/qemu/timer.h:4,
>                  from /home/cborntra/REPOS/qemu/include/qemu/timed-averag=
e.h:29,
>                  from /home/cborntra/REPOS/qemu/include/block/accounting.=
h:28,
>                  from /home/cborntra/REPOS/qemu/include/block/block_int.h=
:27,
>                  from /home/cborntra/REPOS/qemu/block/file-posix.c:30:
> /usr/include/linux/swab.h: In function =E2=80=98__swab=E2=80=99:
> /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:34: error: "sizeof" is=
 not defined, evaluates to 0 [-Werror=3Dundef]
>    20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PE=
R_BYTE)
>       |                                  ^~~~~~
> /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:41: error: missing bin=
ary operator before token "("
>    20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PE=
R_BYTE)
>       |                                         ^
> cc1: all warnings being treated as errors
> make: *** [/home/cborntra/REPOS/qemu/rules.mak:69: block/file-posix.o] Er=
ror 1
> rm tests/qemu-iotests/socket_scm_helper.o
>
> This was triggered by commit d5767057c9a ("uapi: rename ext2_swab() to sw=
ab() and share globally in swab.h")
> This patch is doing
> +#include <asm/bitsperlong.h>
> but it uses BITS_PER_LONG.
>
> The kernel file asm/bitsperlong.h provide only __BITS_PER_LONG.
>
> Let us use the __ variant in swap.h
> Fixes: d5767057c9a ("uapi: rename ext2_swab() to swab() and share globall=
y in swab.h")
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: Allison Randal <allison@lohutok.net>
> Cc: Joe Perches <joe@perches.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  include/uapi/linux/swab.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
> index fa7f97da5b76..7272f85d6d6a 100644
> --- a/include/uapi/linux/swab.h
> +++ b/include/uapi/linux/swab.h
> @@ -135,9 +135,9 @@ static inline __attribute_const__ __u32 __fswahb32(__=
u32 val)
>
>  static __always_inline unsigned long __swab(const unsigned long y)
>  {
> -#if BITS_PER_LONG =3D=3D 64
> +#if __BITS_PER_LONG =3D=3D 64
>  	return __swab64(y);
> -#else /* BITS_PER_LONG =3D=3D 32 */
> +#else /* __BITS_PER_LONG =3D=3D 32 */
>  	return __swab32(y);
>  #endif
>  }

Cc: <stable@vger.kernel.org> # 4.19.x: 467d12f5:
include/uapi/linux/swab.h: fix userspace breakage
