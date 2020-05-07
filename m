Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189CE1C9ACB
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEGTTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgEGTTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:19:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35DEC05BD09
        for <stable@vger.kernel.org>; Thu,  7 May 2020 12:19:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t11so3252129pgg.2
        for <stable@vger.kernel.org>; Thu, 07 May 2020 12:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB3v+OVcFtBZ7ZxmBQPRfPvGnWMyHqtj7wSU+ZXJm/Y=;
        b=ot3OCpEta1bUGj7Eyn/O2BM3DsKQSlfuMJA0kfWjwta8wQItirdklq4ghFKJtmG5D+
         tqhEah0MMH9Y7EUmZlL0zvlUaAgXCc54VBnexdTL6xeTSjrMLEqZjLyesOtnn5M24XY5
         MMMaeJgNx4pIdqR58iZZK84+fVcbfbW6PVJCqvEP/s8Lm3Rbo6zb9Yh6Mbi1UjxsAa6I
         QKy5btjVyumIOTJs+2LESxx92KAaDF8ohkvVgrklotjnOoE1W8mm2CD5YP94A5vrn1Bw
         YVmmjLVNoGMNdY1mhSyfsRaFkHkLZvkA4l04C27gesBHsdKuMmfarNQqcQFAd82vY6Fu
         XTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB3v+OVcFtBZ7ZxmBQPRfPvGnWMyHqtj7wSU+ZXJm/Y=;
        b=tu/AL4e4900O9SZnnWQ5n3TQc7v6OIz5st7y6qA9WC3iz6OEs7p2JIjMTp8uwgU3tS
         8tAMZIkcO/R20qjl2iVvTCQLH89FgCNa4msvUGuwPubrf8DmcxWGx2cXSbOVyKKJWeEo
         cCP1K3xVtCOZeZQsq4tI4UygmYeCHSV1Kt0VRg7gJD48gHOMDEQItdGU5Y6SnEvAIFcr
         Q5eRTEpRItZjMxT3B+p/8sxxKoF+HvrDdAJVLrDEOqbM/VlC/yZNbXxOBPxuZTVaTeLa
         zLqWce0GiZeToHzTpJqoMeJE+fjOcU9DEEqwdQswDyEJMrFODkNAFW0dI5/Y5vPChVOQ
         UORA==
X-Gm-Message-State: AGi0Puborf/X8DS/LAoO9dpq6xk4gpGm6tGHAHPOUhI1q/UM+45n9J0T
        ix2fMaTS+P8nLIiFCViI/bwfhKh7L5zMlbg24qlC5g==
X-Google-Smtp-Source: APiQypJwDIl+NGSGeTeV9dzXBlAr5vo7snEgRhPkTUModDNer2LwguSt79l/UTDkVHvA/eFy0BCX/S1m9RhMme3bqlo=
X-Received: by 2002:a62:146:: with SMTP id 67mr15430634pfb.169.1588879180828;
 Thu, 07 May 2020 12:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
In-Reply-To: <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 May 2020 12:19:30 -0700
Message-ID: <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Brian Gerst <brgerst@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 7:00 AM Brian Gerst <brgerst@gmail.com> wrote:
>
> This change will make sparse happy and allow these cleanups:
> #define CONST_MASK(nr)                 ((u8)1 << ((nr) & 7))

yep, this is more elegant, IMO.  Will send a v3 later with this
change.  Looking at the uses of CONST_MASK, I noticed
arch_change_bit() currently has the (u8) cast from commit
838e8bb71dc0c ("x86: Implement change_bit with immediate operand as
"lock xorb""), so that instance can get cleaned up with the above
suggestion.

-- 
Thanks,
~Nick Desaulniers
