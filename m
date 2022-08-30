Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5A5A631E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiH3MTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiH3MTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:19:13 -0400
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAAEF7B06;
        Tue, 30 Aug 2022 05:19:08 -0700 (PDT)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: martin-eric.racine)
        by meesny.iki.fi (Postfix) with ESMTPSA id A30B2205A1;
        Tue, 30 Aug 2022 15:19:04 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1661861944; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1IU/Vmv+KZu7a/do/ie4ryReg1wzXp+x8m05MY3sN4=;
        b=T5c8amJbGhpf41aUBfRM5HBFG1FyJTLhr6Wv9mEJBwYuCOiIOorZer5oP5hDA126IyxSzK
        yffoD1fIO27107XLX9QVZa8KcNx9XVRnsSyRM3ftrjquGoZuYGfbfdzOdO89ioi2dkQQCT
        lZ2/GMAd7sou4zNR7/SFcB6jDdM1VHY=
Received: by mail-vk1-f177.google.com with SMTP id j11so3171280vkl.12;
        Tue, 30 Aug 2022 05:19:04 -0700 (PDT)
X-Gm-Message-State: ACgBeo0boMwaGo2+gmpujZSMMSDD/enYFLr6WMGF3tKRmWNP2q5ZX/uC
        4wTkRR3ScK78uYlTb8YEf8Dgn4pdQIMeTqtpPCU=
X-Google-Smtp-Source: AA6agR5rR1fVDlOBNX7yh43t51QfOGYtnAZYHCcN7/0XB9TOzAvuqMxXzIhZQAVtx7cQ2q4Z/gGHZLV9vDclvymdWSc=
X-Received: by 2002:a1f:9105:0:b0:388:353b:1b2d with SMTP id
 t5-20020a1f9105000000b00388353b1b2dmr4786178vkd.0.1661861943311; Tue, 30 Aug
 2022 05:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk> <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net> <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
 <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net> <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
 <Yw37wnE19bAIhhP2@hirez.programming.kicks-ass.net>
In-Reply-To: <Yw37wnE19bAIhhP2@hirez.programming.kicks-ass.net>
Reply-To: martin-eric.racine@iki.fi
From:   =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
Date:   Tue, 30 Aug 2022 15:18:51 +0300
X-Gmail-Original-Message-ID: <CAPZXPQfrCQi5y0yS0kXNYajb_YyRGBPj1hhJEYEWWUsJxa-EHw@mail.gmail.com>
Message-ID: <CAPZXPQfrCQi5y0yS0kXNYajb_YyRGBPj1hhJEYEWWUsJxa-EHw@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        1017425@bugs.debian.org, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1661861944;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1IU/Vmv+KZu7a/do/ie4ryReg1wzXp+x8m05MY3sN4=;
        b=szISCSm+ZyvjZfMveQ7tlIIc7sJnoVI9NOFu2fPo9lfwULv6qgFq5L+t8QcjqY/w0SXv93
        s9FcMqumaD/qTaTayyPtN7pFhfk7s9AOq5F8FhDeo/2yI3si4GIOu4QP5oz7WkFN6LxU7N
        Nu5RBjF0ZFEpR4jP0ZDE6rqmRC6/1Oo=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=martin-eric.racine smtp.mailfrom=martin-eric.racine@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1661861944; a=rsa-sha256; cv=none;
        b=ITTTng9ykl4+SWZHqEU45LlUbNO3+0rfnaAYRhd4ApUjGAVDA8B5FwRmETCyewjAraYj/G
        NgG0wFoiNl98Szq80Tu3uEefHYYryoh8WNz/sFTj43t8aU9NPDgCC6xD6iBIy0gTUSYiAl
        P+wtcNCWURO0SXZE5Gn0epXHYcnyvEM=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 3:00 PM Peter Zijlstra <peterz@infradead.org> wrote=
:
> On Tue, Aug 30, 2022 at 02:42:04PM +0300, Martin-=C3=89ric Racine wrote:
> > On Fri, Aug 19, 2022 at 3:15 PM Peter Zijlstra <peterz@infradead.org> w=
rote:
> > >
> > > On Fri, Aug 19, 2022 at 01:38:27PM +0200, Ben Hutchings wrote:
> > >
> > > > So that puts the whole __FILL_RETURN_BUFFER inside an alternative, =
and
> > > > we can't have nested alternatives.  That's unfortunate.
> > >
> > > Well, both alternatives end with the LFENCE instruction, so I could p=
ull
> > > it out and do two consequtive ALTs, but unrolling the loop for i386 i=
s
> > > a better solution in that the sequence, while larger, removes the nee=
d
> > > for the LFENCE.
> >
> > Have we reached a definitive conclusion on to how to fix this?
>
> https://git.kernel.org/tip/332924973725e8cdcc783c175f68cf7e162cb9e5

Thanks.

Ben: When can we expect an updated kernel to security-updates at Debian?

Martin-=C3=89ric
