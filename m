Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D021D773C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgERLfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 07:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgERLfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 07:35:21 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF26C061A0C;
        Mon, 18 May 2020 04:35:21 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so4812221pfb.10;
        Mon, 18 May 2020 04:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eWsNrn4B6fq2XaSi/s70lNeZTSbVK7YGuNLIy+mTVdw=;
        b=BreqznuTyETLvo3JMHC0tzVCFjIyoNoJcIeStI8ie9K5FKkPeAXbwhvpOGY5IEEvDp
         zaXS7vSb8el2Ql/G7CVkH7ssnxs9sqzbV7UilaMrik09ENRE9U45pSqH+/IuxTWzFWrR
         Pkea0RvFr6IQKNzdOg3t7EO/7kW+WaakOXAgcEg6kMiiKU45liWVPNH1dGI5I6oxhcqR
         IPb3Mx7j+i5dTcTsR3Ip10TmeYk+q8OgDg2mxEER46jKjqRrEFanrhdMJY3h8jUrKtnA
         LtjL6jiorcF+nx22cFdsOcIP02EuC8W54e6A3Apy3fbXhrp8AQxY4Z8wfcBgbZBXqc0t
         3a2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eWsNrn4B6fq2XaSi/s70lNeZTSbVK7YGuNLIy+mTVdw=;
        b=p1DBVRc34aqjk5Qn+fV4X54t/rFtnTCto6cxyRZFlfv9JlHgl+vJQQntqpJlbfjUfC
         8RZXAx1slfh9fYAdMGWfpJ0d/FihJ1mGj/msi0To7g0Srrc5EcQCnnKfgvYUSVdld6GF
         DM8dprq1S+GGejN/BPsepDbZk1ZeWO+8P1CHyWO6641iA0vTQX5M6DCpoq9ff0YyIGpL
         2+aPCLY3wzWKTNtdhOivhqKofLQHdGU0mXNL8ytMRYbu0u+4NDNnFKTPpvmxW9JPXawv
         mE8qkdWSsvWUnKJS7iu6bAlRwNXK3PveWv3Cz7keqcEXFbyAOazWu3SuqpVzjicnVRjH
         2Qyw==
X-Gm-Message-State: AOAM530lvai1zwPHWlMc8nr6mR26edI5/SogmJPbBtBqreEwbW01o0Gx
        u+M40AsX3nhW6ktD1kV5lOt83KmHFSWFnGzH82Q=
X-Google-Smtp-Source: ABdhPJz368/fiWFGZQ05YiuM8Iv1Itf8wvpcKktScZj0tkIymGnYsiEn6dMUf7feFO/0PDdZ8A3xrqu4w1b0QC9/zjA=
X-Received: by 2002:a63:1c1:: with SMTP id 184mr14953999pgb.203.1589801720834;
 Mon, 18 May 2020 04:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com> <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
In-Reply-To: <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 18 May 2020 14:35:09 +0300
Message-ID: <CAHp75VcLu738ktasiUsgbKNyW-5vENpK2n9_OD5oFmhOzfCG6Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] lib: fix bitmap_parse() on 64-bit big endian archs
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 2:33 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Mon, May 18, 2020 at 1:40 PM Alexander Gordeev
> <agordeev@linux.ibm.com> wrote:
> >
> > Commit 2d6261583be0 ("lib: rework bitmap_parse()") does
> > not take into account order of halfwords on 64-bit big
> > endian architectures.
>
> Thanks for report and the patch!
>
> Did it work before? Can we have a test case for that that we will see
> the failure?

Sorry, I wasn't clear enough. I meant a test case that is
arch-independent for this very issue (so, that I can run it on LE 64
machine and see a problem).

-- 
With Best Regards,
Andy Shevchenko
