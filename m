Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EF1AF4ED
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgDRUaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgDRUaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 16:30:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81FC061A0C
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 13:30:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d1so2940101pfh.1
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:date:subject:message-id
         :cc:to;
        bh=jJqY9/SR/ad4P7H9qcJcsY9QD5wxC36npZ2vqT03CEs=;
        b=svfRl6JAzcnVOj/h2FflauvL4dvBhAOealAKFUZRMj0RxUVjkwmdFr0X1PPek2F6kR
         s2J+GFL4YWwoEDdJsWo99CwCtjStNv4D6mrX4DbsLVaRMcwndMkV8Z1mTqDCpkF3lfjc
         maBOzwRRO41B/IkGA1GnOfIdJ3HgQumUcPogYxuvu1MkWytQl33wsHglpXd9WFrdSv++
         Ev+4YGBX2TJqHki59IW1oNt8Lk8Wodn3R+ZZUoUfTzJUnRVPWWk3AmS48/17pagt9YWK
         3OQmgs8k/lc66S3BzA6ZRDVnBGxQ3QclKCMEi4wfeO/kSdkZVM9kxtsbc4TzmKqwFYKU
         IrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version:date
         :subject:message-id:cc:to;
        bh=jJqY9/SR/ad4P7H9qcJcsY9QD5wxC36npZ2vqT03CEs=;
        b=OxKcM6BJk7hCiiiqZ1KR9i8mm8/kWRyD/QIZgMsnIgPXHIDLjL95LT8DQJABfkZHac
         oHjK2u6sptF4JvcHNhoMfRK3LY5DSphNInBxi2qO2idgZLSCwdBdj4fKPEitdnFkrdKX
         p3imrP4MpgRgq2mXNHQbcuF4So6Jah53CkBk1PleDrZD70bPaf7A9ZBTDPpeKzMaFoS9
         NnSsr4HopiNX8xO7yrkNc7BwI0rcmOkuGiJ2qr7AY5/Fys9gbrQkN5WmHrZT/36+/Q30
         cdOXxZFjZJ0uav0+BSQd+1bt5y31Fc11OeFbD724ZGpebzJjeeYL3mv/0QHcgO7Tr+cg
         23VQ==
X-Gm-Message-State: AGi0Puaj2GGZimhOAg3luldtCvt3N36YTuNXRF2i/j8EAWbeZXlJGI3+
        wmrcOzS2ckv89kz3C0EeZlQl3g==
X-Google-Smtp-Source: APiQypLcRDF82+gi/uSEl48kZIhOa8/wjmaGeADbXMRVmijfIA5J9MXMJACYqsUjj+dOd+RNBeOpDA==
X-Received: by 2002:a62:62c3:: with SMTP id w186mr9256533pfb.238.1587241808920;
        Sat, 18 Apr 2020 13:30:08 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:e558:74e9:c7af:3ac7? ([2601:646:c200:1ef2:e558:74e9:c7af:3ac7])
        by smtp.gmail.com with ESMTPSA id o15sm8899098pjp.41.2020.04.18.13.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 13:30:07 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Date:   Sat, 18 Apr 2020 13:30:05 -0700
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Message-Id: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17E255)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



--Andy

> On Apr 18, 2020, at 12:42 PM, Linus Torvalds <torvalds@linux-foundation.or=
g> wrote:
>=20
>>> On Fri, Apr 17, 2020 at 5:12 PM Dan Williams <dan.j.williams@intel.com> w=
rote:
>>>=20
>>> @@ -106,12 +108,10 @@ static __always_inline __must_check unsigned long
>>> memcpy_mcsafe(void *dst, const void *src, size_t cnt)
>>> {
>>> #ifdef CONFIG_X86_MCE
>>> -       i(static_branch_unlikely(&mcsafe_key))
>>> -               return __memcpy_mcsafe(dst, src, cnt);
>>> -       else
>>> +       if (static_branch_unlikely(&mcsafe_slow_key))
>>> +               return memcpy_mcsafe_slow(dst, src, cnt);
>>> #endif
>>> -               memcpy(dst, src, cnt);
>>> -       return 0;
>>> +       return memcpy_mcsafe_fast(dst, src, cnt);
>>> }
>=20
> It strikes me that I see no advantages to making this an inline function a=
t all.
>=20
> Even for the good case - where it turns into just a memcpy because MCE
> is entirely disabled - it doesn't seem to matter.
>=20
> The only case that really helps is when the memcpy can be turned into
> a single access. Which - and I checked - does exist, with people doing
>=20
>        r =3D memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint6=
4_t));
>=20
> to read a single 64-bit field which looks aligned to me.
>=20
> But that code is incredible garbage anyway, since even on a broken
> machine, there's no actual reason to use the slow variant for that
> whole access that I can tell. The macs-safe copy routines do not do
> anything worthwhile for a single access.

Maybe I=E2=80=99m missing something obvious, but what=E2=80=99s the alternat=
ive?  The _mcsafe variants don=E2=80=99t just avoid the REP mess =E2=80=94 t=
hey also tell the kernel that this particular access is recoverable via exta=
ble. With a regular memory access, the CPU may not explode, but do_machine_c=
heck() will, at very best, OOPS, and even that requires a certain degree of o=
ptimism.  A panic is more likely.
