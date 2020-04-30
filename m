Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5451C0767
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3UHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 16:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgD3UHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 16:07:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B11BC035495
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 13:07:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ms17so1349691pjb.0
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 13:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=p3wUvEbSn9f+WPyEEsvBQpBZL7x1SSk0c7XRYZKC7go=;
        b=vLKm85XeGVLBINOi+MNK7f63J8VzDtOC7kEqYCvUpC4YvbvTEJAYkMiBSGQX6J70Ha
         maCBbN6Occzx6JzwsTyizH4bV5bF82J1N3xXZLGRQ6aVP1XmfstafoB5WPCGqRGsQwEK
         fvEkC4NCRYQ5xnMtYPB0OAq8dlOZa9n33vdEJ0pRlrc7xXYyA+cVJn2gpcBJJoPdOSQ9
         DH0j5fkW9bao+gLWoFUenYN07TOxS19vea2YvvDccg5FxBmAxAbHWtKy+i35RAaIsqGc
         YYpb6EHY6WGpF1QO657rmcKInIALsnUwu7XXWfMHA4jWEOxpOTV9p4srfx3ugdTOALk1
         Bn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=p3wUvEbSn9f+WPyEEsvBQpBZL7x1SSk0c7XRYZKC7go=;
        b=hEFBgsQEQqMFl/3QV2PNugJKjuTtHFngPI6OBTf6GjdpVueO/ppmxDi+293tx5MTmc
         pnZRnivIyZi4OkceVABiwVoUxHTrwe/aZvAMfCer6nWrXT0bW3qWB4CPz3Tes6FRw29p
         Ozlcw7ONIfBZ/3YM4m8bTCzxbZKLnBvEJjhbyTVsGCe+hYnlQtT1NCq+3vgIVwbmJZKR
         0aVDdVHWfhw5UrcitLPa5kb3x1Lz88c2A3IdyVizgrI1P4HaEroI8rRJCwO6evVOp3Ix
         OGR0ywipJ6JKJkbFb8vEzawmr550ofJvybF8uW69taOZJPk2+e2jqrmMyDzl2jq1VO7x
         84Wg==
X-Gm-Message-State: AGi0PuaR4IXuLy8PobnsHBeria5dNh9v4j1P82xXYBKY3GuesxNDLGYE
        gfrbRhgIT0wS7ZJPGWgAe2s/3oFWClc=
X-Google-Smtp-Source: APiQypIYAXUg7Biw0D2TBRkbkjLKeZ1YlBGAyuI6df4rKF0UYwZavIIpzVrPwSNRWmjAPJ3maXqqbw==
X-Received: by 2002:a17:90a:1b26:: with SMTP id q35mr571681pjq.149.1588277232615;
        Thu, 30 Apr 2020 13:07:12 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:fd86:293b:2791:eb06? ([2601:646:c200:1ef2:fd86:293b:2791:eb06])
        by smtp.gmail.com with ESMTPSA id d203sm523177pfd.79.2020.04.30.13.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:07:11 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Date:   Thu, 30 Apr 2020 13:07:09 -0700
Message-Id: <4819995F-4EAE-46EE-8311-9CF65CB8D08A@amacapital.net>
References: <CAPcyv4g8rA2TRvoFHqEjs5Xn74gdZx8uF0PXFYCjTcx56yA=Jw@mail.gmail.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAPcyv4g8rA2TRvoFHqEjs5Xn74gdZx8uF0PXFYCjTcx56yA=Jw@mail.gmail.com>
To:     Dan Williams <dan.j.williams@intel.com>
X-Mailer: iPhone Mail (17E262)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Apr 30, 2020, at 12:51 PM, Dan Williams <dan.j.williams@intel.com> wrot=
e:
>=20
> =EF=BB=BFOn Thu, Apr 30, 2020 at 12:23 PM Luck, Tony <tony.luck@intel.com>=
 wrote:
>>=20
>>> On Thu, Apr 30, 2020 at 11:42:20AM -0700, Andy Lutomirski wrote:
>>> I suppose there could be a consistent naming like this:
>>>=20
>>> copy_from_user()
>>> copy_to_user()
>>>=20
>>> copy_from_unchecked_kernel_address() [what probe_kernel_read() is]
>>> copy_to_unchecked_kernel_address() [what probe_kernel_write() is]
>>>=20
>>> copy_from_fallible() [from a kernel address that can fail to a kernel
>>> address that can't fail]
>>> copy_to_fallible() [the opposite, but hopefully identical to memcpy() on=
 x86]
>>>=20
>>> copy_from_fallible_to_user()
>>> copy_from_user_to_fallible()
>>>=20
>>> These names are fairly verbose and could probably be improved.
>>=20
>> How about
>>=20
>>        try_copy_catch(void *dst, void *src, size_t count, int *fault)
>>=20
>> returns number of bytes not-copied (like copy_to_user etc).
>>=20
>> if return is not zero, "fault" tells you what type of fault
>> cause the early stop (#PF, #MC).
>=20
> I do like try_copy_catch() for the case when neither of the buffers
> are __user (like in the pmem driver) and _copy_to_iter_fallible()
> (plus all the helpers it implies) for the other cases.
>=20
> copy_to_user_fallible
> copy_fallible_to_page
> copy_pipe_to_iter_fallible
>=20
> ...because the mmu-fault handling is an aspect of "_user" and fallible
> implies other source fault reasons. It does leave a gap if an
> architecture has a concept of a fallible write, but that seems like
> something that will be handled asynchronously and not subject to this
> interface.


I=E2=80=99m suspicious that, as a practical matter, x86 does have a fallible=
 write. In particular, if a page fails and the memory failure code is notifi=
ed, the page will be unmapped. At that point, an attempt to write to the fai=
led fallible page will get #PF, and code that writes to it needs to be prepa=
red to handle #PF.  Perhaps copy_to_fallible(), etc can still return void, b=
ut I=E2=80=99m unconvinced
the implementation can be the same as memcpy.=
