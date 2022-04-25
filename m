Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA13750D7D2
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 05:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbiDYDtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 23:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240986AbiDYDs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 23:48:59 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7306519039
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 20:45:51 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z8so15811195oix.3
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 20:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=landley-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dCbuXnt8KI6vT4+iL+5GGDKwywcs08Pazm0PAaoYNFI=;
        b=ZvaDEohb8ZLj7cvPeWXG70F+Xmei4RkLyAyXVmfQrQwpmNzLUAwA3X85LIHV2dvy3B
         zdls0TLE9Bm0H7NsvkqqSigKYPQmL1fEIk5ubVzVX7gH77cDgy0gcYKaDwbqepEx+Z42
         beIuU3yYuC2nJ2JPlxGkDdPy5pfY6i9g6EviD4PM1Biie+s8LDe1rU1v7Chqf9+Of2DM
         hj/fz3cO/2reyFq0zD0PoG1gQgbBJr8wL+PmUB6jjTiewSYBc88jCiVWlYLS+ZIGuJG5
         9Lz/5+i0Ir9Lvrsf2fCg6oedgf2axiFm5gLfRx95D6fG5Ndv39Ybt7WM3UQW1//pXBzv
         tO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dCbuXnt8KI6vT4+iL+5GGDKwywcs08Pazm0PAaoYNFI=;
        b=lUBkPrVRjX3I8S1wl9r3bamAjeIojuBH2BZHVv+Q9qZquvGQcQ0jz4KRzcYn5JDXNU
         4ysnDAFtF1rr/b0Pap6o4XjvonQIwmi//wP8Zo4S4mpG7OLq13676Yjm0Ph2zgExigid
         lQFGPD0biIj7VDHRYewlwAbocJOHRMk+7SlOJhGRwWiQG3hYkm4L0XRXiRdovfOv1+Py
         1lb/rk0vGsmaV8Oshmc2LEf+LgITJuuEimjkR4lCDlz/skwRn4YpJNS1z2l7FC7Sghhp
         AXygpwF4HlpW1JDI1R3c4AH98tlAQ6fgAv8Ud973n57uSrdH78xdD8Cu2jo+nb5Oq76l
         mHtQ==
X-Gm-Message-State: AOAM533I/tNabMXXQgIeh8iNS/pYYEh4yhiNTdDrU4w7YhB+a1PTRENf
        nNOfTQ6UPgw1pcs9WtZQxMalZw==
X-Google-Smtp-Source: ABdhPJyjXv8VnX8iTAuwua0Imy62cyfWX3ohly9ACpWE55XVrjfJZYK8m6QF79M73snVG+oZVSSfmQ==
X-Received: by 2002:a05:6808:1381:b0:325:1ffe:af93 with SMTP id c1-20020a056808138100b003251ffeaf93mr2368429oiw.191.1650858350829;
        Sun, 24 Apr 2022 20:45:50 -0700 (PDT)
Received: from [192.168.208.243] ([172.56.88.231])
        by smtp.gmail.com with ESMTPSA id e16-20020a4a9b50000000b0035e5b5acc04sm1834959ook.24.2022.04.24.20.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 20:45:50 -0700 (PDT)
Message-ID: <24f1fd7f-7e1c-bb56-3a08-56ccfc686a61@landley.net>
Date:   Sun, 24 Apr 2022 22:50:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
Content-Language: en-US
To:     Rich Felker <dalias@libc.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
 <Yli8voX7hw3EZ7E/@x1-carbon>
 <81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org>
 <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <01b063d7-d5c2-8af0-ad90-ed6c069252c5@linux-m68k.org>
 <CAMuHMdXd94L=766usN4WG-hK2MpQLy50mJZ=9G9NGv03kx8V8Q@mail.gmail.com>
 <20220421124326.GG7074@brightrain.aerifal.cx>
From:   Rob Landley <rob@landley.net>
In-Reply-To: <20220421124326.GG7074@brightrain.aerifal.cx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/21/22 07:43, Rich Felker wrote:
> On Thu, Apr 21, 2022 at 08:52:59AM +0200, Geert Uytterhoeven wrote:
>> On Thu, Apr 21, 2022 at 1:53 AM Greg Ungerer <gerg@linux-m68k.org> wrote:
>> > On 21/4/22 00:58, Eric W. Biederman wrote:
>> > > In a recent discussion[1] it was reported that the binfmt_flat library
>> > > support was only ever used on m68k and even on m68k has not been used
>> > > in a very long time.
>> > >
>> > > The structure of binfmt_flat is different from all of the other binfmt
>> > > implementations becasue of this shared library support and it made
>> > > life and code review more effort when I refactored the code in fs/exec.c.
>> > >
>> > > Since in practice the code is dead remove the binfmt_flat shared libarary
>> > > support and make maintenance of the code easier.
>> > >
>> > > [1] https://lkml.kernel.org/r/81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org
>> > > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> > > ---
>> > >
>> > > Can the binfmt_flat folks please verify that the shared library support
>> > > really isn't used?
>> >
>> > I can definitely confirm I don't use it on m68k. And I don't know of
>> > anyone that has used it in many years.
>> >
>> >
>> > > Was binfmt_flat being enabled on arm and sh the mistake it looks like?
>> 
>> I think the question was intended to be
>> 
>>     Was *binfmt_flat_shared_flat* being enabled on arm and sh the
>>     mistake it looks like?
> 
> Early in my work on j2, I tried to research the history of shared flat
> support on sh, and it turned out the mainline tooling never even
> supported it, and the out-of-line tooling I eventually found was using
> all sorts of wrong conditionals for how it did the linking and elf2flt
> conversion, e.g. mere presence of any PIC-like relocation in any file
> made it assume the whole program was PIC-compatible. There's no way
> that stuf was ever used in any meaningful way. It just didn't work.
> 
> Quickly dropped that and got plain ELF (no shared text/xip, but no
> worse than the existing flat support) working, and soon after, FDPIC.
> 
> The whole binfmt_flat ecosystem is a mess with no good reason to
> exist.

FYI when I had to come up to speed on this in 2014 I did a writeup on my own
research:

https://landley.net/notes-2014.html#07-12-2014

The lack of a canonical "upstream" elf2flt repository was probably the biggest
problem at the time.

(There's a reason I grabbed fdpic hard and tried to make that work everywhere.)

> Rich

Rob
