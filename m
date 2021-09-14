Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463EE40B71F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhINSqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhINSqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:46:21 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8323C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:45:03 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id l18so357512lji.12
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdIzjS6IYbczmviRsXg0INdcvtOzKAQJX4hM5LHMeSs=;
        b=B3Z5J5BIG0I3311xEFGaman00V0Rf3NaRlcsKNT/YSeHCKd4WEtd/+O10/OfuFMwEr
         oVn830o6q5cSmBs+q2yhSJ7VhXzGxLXJqdSjGWR6+mOCx0N4KEQDzXSdDTE9XubyuvUW
         wKl2wdKaoXMH8aant/KGXrrFIBUW1iGd4fI6k7I+MdyYhmyvlV9BH9Z44l6E19Z8pyzD
         NPL9UhvGIx5BLBxz20fLrz9frYc9NFtsqecGiQj5nkN2aueDEqdgzwRgbCxItzGPzyXp
         vbRXSctftFDwPIFVKN6GkP8PecggzEDhMCRFTT+3WncuOy82zeNNZlNUxgg0dBHMbhQd
         /zsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdIzjS6IYbczmviRsXg0INdcvtOzKAQJX4hM5LHMeSs=;
        b=3zbY/DQxS6AG8WX8oCUtw8/IzPkjpDUn/4kOHpb/8+Z+pskM+jioDnkXjV2rxoZgG2
         vgs3XGY6g2nO/XiTEHYZaI0UQ0tp6G28Ns1heTbjLFs4BQwl+abZIE9Z+Rtlts4PEzY7
         xU4Yu7SP+o5HP/Fa+n9AZ23xzFwvYmmkLHcugSk9XXYt8Plu4DTKAylRu8nVJF6VCNTA
         s+J78oxN8U21DxAigBdx+0B4fOM5Zfgtr3MwUPUacp+7TSm9lLBlDN5OuEYJaP4J2tYO
         BTTU4K0Gev0cFuT5dlkLQVH9KKI8NXMWoLV0mCi2jDBOF2Rc55BybaMaXkjW4zT3MXWF
         CKTA==
X-Gm-Message-State: AOAM532arMnw7s95TQE6mR+CAo/gAfboFSJSpI2LGo5A6aXB1j20bZBX
        HNJVGtuSvBcnit6hSucbo90UscmBEyY9IEQ4TdujRLa4KEc=
X-Google-Smtp-Source: ABdhPJzbrzG3BCqo4kAzv47y1+XDJdc1ct/sAehFe+rweN9ucsNxGIsXat+PIVGve93EZr+wbPlsi0xnjkRlIIQYtNg=
X-Received: by 2002:a2e:750e:: with SMTP id q14mr16512912ljc.338.1631645101892;
 Tue, 14 Sep 2021 11:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com> <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
In-Reply-To: <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 14 Sep 2021 11:44:50 -0700
Message-ID: <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:30 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Sep 14, 2021 at 11:14 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > All this pain could have been trivially avoided with just people
> > writing better code, knowing that multiplies and divides are
> > expensive, and that shift counts are small and cheap.
>
> IOW, maybe the fix is just this attached trivial patch.
>
> I didn't bother to change the order of the 'struct ndb_config'
> structure. It would pack better if you put the (now 32-bit)
> blksize_bits field next to the 'atomic_t' field, I think. But I wanted
> to just see how a minimal patch looks.
>
> I did make the debugfs interface reflect the change to blocksize_bits,
> so this is visible in user space. But it's debugfs.
>
> If people care, it could be made to use a DEFINE_SHOW_ATTRIBUTE()
> function the way it already does for 'flags', so that's not a
> fundamental issue, I just didn't bother.
>
> Hmm?
>
> Btw, I really think more of the block layer should perhaps think about
> use bit shifts more, not expanded values.  Can things like the queue
> 'discard_alignment' really be non-powers-of-two?
>
>           Linus

Any issues passing an loff_t (aka long long) to __ffs which expects an
unsigned long for ilp32 targets? (I hate the whole family of
ffs()...why did ffs() ever accept just an int?!)

Any issues modifying the sysfs interface? Perhaps something in
userspace relies on parsing those strings?

Other than that LGTM, and I like your new overflow check. :)
-- 
Thanks,
~Nick Desaulniers
