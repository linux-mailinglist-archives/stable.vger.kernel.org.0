Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7350883E
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345052AbiDTMgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244098AbiDTMgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:36:41 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843D424A2
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:33:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g20so2091339edw.6
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YK1gwQHfzWNPMKl1EIpM7XtIAL3qDFBevpSSKsKoNRY=;
        b=nPa8hfPZywMg937IwHbiNMiNe8EsqyiDAnCYtzJBpjQaHy1d4TpWnr2834Me5gYmy6
         qTW2rv5tNUcbKvQgNCcpb7eEm7/s0Pg6OtLyEXP2aL8WySIbMfxMX/Cc9L+LqMsCMvYJ
         bjgQaQ25ApPqwrTi0/ibvD/VIeeh6l3EQ5Jd1NTSscsl8uaVbtXR6ekbs9Lpnori+E50
         2ah6ROt2CtGASMwpjB3xM1pNorO2ZOpzRd5sEsXlmPay6hjuSlTelSxM3gUyxMmJzU9e
         6T29Qsgm2Q9D5xKR0YMR4TKrumrG7NXHLcHv3ufx+hwDy1gq66fKoJ7AtqK6OORx8kRO
         Tpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YK1gwQHfzWNPMKl1EIpM7XtIAL3qDFBevpSSKsKoNRY=;
        b=VZsPUOeM+aUpb3u2b4krs8CFVYe/4GSASzbJAVOMnnu5ccos4GpTqFpet9yWVdJhu2
         wWK/uj8KnW+5Rdy6lX7EphyuAeCmY5CbNEr0ukv9LeDeHpcd0fnEw0dGJZdqnsJNK7vw
         xWP8uYQRDso7YU844kLeLasr2KeXz/nd0SobkWLCTapeT4rrlfqgOOd1Wtf/4HxsHanJ
         25A7DYemYvZ6MDl8R9GAKWPfHhaKLnerlBodmae5x61ioneF6byVlg1RO2/POU4sF1y4
         Ad04Rh8UDucmmexNpRcCBOwPNJihLq+J4zkTXCEFBd+R/kdU0fxeC/EomhD0SN9/lNPm
         R8+g==
X-Gm-Message-State: AOAM53186K2BY7QXdhuYYP9+xZyeS/6oTkhj23Vfq7dKR5GKfqYjnKV0
        7cSwi52Bz/Xm3vVSLamiKPABKSYylmQGP4TmVh4t2QdF6l73kA==
X-Google-Smtp-Source: ABdhPJxQh4qATIg7fh2d/Rn6HYLS5+wfjP3gtV1tUSHmAmwfdypDh6a+tcEIkZGaV0XlelDf1q6MHbymQ5w2b/7dafg=
X-Received: by 2002:a05:651c:1546:b0:24c:7e0c:38b1 with SMTP id
 y6-20020a05651c154600b0024c7e0c38b1mr13233370ljp.375.1650458022985; Wed, 20
 Apr 2022 05:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220419041742.4117026-1-keescook@chromium.org> <Yl+8K++wZUJCthMj@hovoldconsulting.com>
In-Reply-To: <Yl+8K++wZUJCthMj@hovoldconsulting.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 20 Apr 2022 14:33:06 +0200
Message-ID: <CAG48ez2Pikm5g2RfJxae=jz1C7KSCWc99sCa7fXFBKvDOPJubA@mail.gmail.com>
Subject: Re: [PATCH] USB: serial: Fix heap overflow in WHITEHEAT_GET_DTR_RTS
To:     Kees Cook <keescook@chromium.org>
Cc:     Johan Hovold <johan@kernel.org>, kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 10:14 AM Johan Hovold <johan@kernel.org> wrote:
> On Mon, Apr 18, 2022 at 09:17:42PM -0700, Kees Cook wrote:
> > This looks like it's harmless, as both the source and the destinations are
> > currently the same allocation size (4 bytes) and don't use their padding,
> > but if anything were to ever be added after the "mcr" member in "struct
> > whiteheat_private", it would be overwritten. The structs both have a
> > single u8 "mcr" member, but are 4 bytes in padded size. The memcpy()
> > destination was explicitly targeting the u8 member (size 1) with the
> > length of the whole structure (size 4), triggering the memcpy buffer
> > overflow warning:
>
> Ehh... No. The size of a structure with a single u8 is 1, not 4. There's
> nothing wrong with the current code even if the use of memcpy for this
> is a bit odd.
>
> > In file included from include/linux/string.h:253,
> >                  from include/linux/bitmap.h:11,
> >                  from include/linux/cpumask.h:12,
> >                  from include/linux/smp.h:13,
> >                  from include/linux/lockdep.h:14,
> >                  from include/linux/spinlock.h:62,
> >                  from include/linux/mmzone.h:8,
> >                  from include/linux/gfp.h:6,
> >                  from include/linux/slab.h:15,
> >                  from drivers/usb/serial/whiteheat.c:17:
> > In function 'fortify_memcpy_chk',
> >     inlined from 'firm_send_command' at drivers/usb/serial/whiteheat.c:587:4:
> > include/linux/fortify-string.h:328:25: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> >   328 |                         __write_overflow_field(p_size_field, size);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> So something is confused here.

So something's going wrong in fortify_memcpy_chk()? It looks like it
is called with constant "size" equal to 1, and the condition
"p_size_field < size" (with an unsigned comparison) is either true
(meaning p_size_field would have to be 0) or not known at compile
time?

The original report says it happened when compiling with
CONFIG_CC_OPTIMIZE_FOR_SIZE=y, maybe that matters?
