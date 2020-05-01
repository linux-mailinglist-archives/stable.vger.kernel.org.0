Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D131C0B9E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 03:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEABUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 21:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727124AbgEABUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 21:20:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CEBC035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 18:20:43 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x77so915238pfc.0
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 18:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=+ob/X0QXFpxvmr3EWB8fQOJcF1u/V0cTtMVpIs2p45o=;
        b=JWz/HNe9QVe3KpMe6Fx9Bq2GqkBQAoBVa8iqrJqTOXH9HIZzwUCDZU8rE102fg1z7o
         0kalZERJUV6gw/xA8MPaoOfaHwYAbAANimUog9Hm676+TIjcO+dBY89FjUJ4wcMs975/
         SKm9CbmjdES6fxlHT0h2/dzk9hxGqC1/y06ZPZMjk0uNY0N5EoJ6K6sn0qt6pUf2eCuJ
         jgwqP5f32gdTlY0FX3Gs1FAz+ZOhcRu86YggMsjZ1RdG5yNctLB6+vmapn45gRamTYGp
         fRbPwUxOjDOzHfI5AUlpxdC9aNAaFqoSCkIZ/PKmcj6qIrFM96yFQKqxFpwDUaMHMKf7
         yvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=+ob/X0QXFpxvmr3EWB8fQOJcF1u/V0cTtMVpIs2p45o=;
        b=Twn75Lu/SEza7OO3drBPSdYCJnN1gQPdHxH7vlR8arg8PYh8tNsX4i5FTK5fnUjG7h
         C1yvbHm+g/X1sfzOFoJKscPo/soSwUx/mIWdguoyBgbZQoOd3pvuNO2205he1Jndn5yX
         9ZuliARPhX5vSQoiihV68qBe9QFIWPwNtgOanbUQGktaxBg3EdWzRP8Ln0wK7jVdwCsr
         RdcPWAb4eMN9Wf2E8P69qydKkVkoP5MD9NhKvo09VAacIoSGaDJmS51VGvSiePl9wnjj
         0UkTja8K3lQpWNltzy+Grwi4P1rm1Q8mcn6/RJF8iJufQkS41jlu8XEr5ECA9BAsgHnI
         fkCw==
X-Gm-Message-State: AGi0PuZ7syLmNnHQsmDl6BodpQyalhU7lJayce8oHPJis10aHcBugrDp
        C6b7zU9w+YaIZT05pkkbrh3CPw==
X-Google-Smtp-Source: APiQypJVdLbyXVtAGU4O61QE9USzd9aHvhWz43HYF+zei+FPbOx+DYcTAVOeS9XOsayG60rqSExmJg==
X-Received: by 2002:aa7:819a:: with SMTP id g26mr1723584pfi.193.1588296042609;
        Thu, 30 Apr 2020 18:20:42 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d495:581b:d692:e814? ([2601:646:c200:1ef2:d495:581b:d692:e814])
        by smtp.gmail.com with ESMTPSA id h31sm784779pjb.33.2020.04.30.18.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 18:20:41 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Date:   Thu, 30 Apr 2020 18:20:39 -0700
Message-Id: <D47C71D3-349B-49C4-9945-330C9F42A3E0@amacapital.net>
References: <CAHk-=wh1SPyuGkTkQESsacwKTpjWd=_-KwoCK5o=SuC3yMdf7A@mail.gmail.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
In-Reply-To: <CAHk-=wh1SPyuGkTkQESsacwKTpjWd=_-KwoCK5o=SuC3yMdf7A@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17E262)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 30, 2020, at 5:25 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
>=20
> It wasn't clear how "copy_to_mc()" could ever fault. Poisoning
> after-the-fact? Why would that be preferable to just mapping a dummy
> page?

If the kernel gets an async memory error and maps a dummy page, then subsequ=
ent reads will subsequently succeed and return garbage when they should fail=
.  If x86 had write-only pages, we could map a dummy write-only page. But we=
 don=E2=80=99t, so I think we=E2=80=99re stuck.

As for naming the kind of memory we=E2=80=99re taking about, ISTM there are t=
wo classes: DAX and monstrous memory-mapped non-persistent cache devices.  B=
oth could be Optane, I suppose.

But I also think it=E2=80=99s legitimate to use these accessors to increase t=
he chance of surviving a failure of normal memory. If a normal page happens t=
o be page cache when it fails and if page cache access use these fancy acces=
sors, then we might actually survive a failure.

We could be ambitious: declare that all page cache and all get_user_page=E2=80=
=99d memory should use the new accessors.  I doubt we=E2=80=99ll ever really=
 succeed due to magical things like rseq and anything that thinks that users=
 can set up their own memory as a kernel-accessed ring buffer, but I suppose=
 we could try.

