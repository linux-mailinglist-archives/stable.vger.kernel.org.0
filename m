Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220F0D2FC9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfJJRvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 13:51:17 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36660 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJJRvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 13:51:17 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so5684977oih.3
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 10:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DKe45SUxB6hYFAJK4Hzzx9HwPC758qhlQpHJI3tZEIo=;
        b=VWVqLMShkk5AFXL8NAEgE0bqeZexDXkca5zP9VsCIHpGJGP655Ahj59j6PofdbF8yy
         zkXGLQUiQVY2NUUON+mXcdZoaZ16AEqOJUqMfJGAQSARITAkutR4PupxVfwgjhvHFnbd
         oWv1EFdvgCKVUXqmDGsUwNcxvGMa/a/TZNyHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DKe45SUxB6hYFAJK4Hzzx9HwPC758qhlQpHJI3tZEIo=;
        b=ABt2UVNZh1SoxEPGgDCiL3Gf3ZRmNO8v1YN7ZtrRyg0SUqjfoqDLonQqBd4n6lDEKk
         DLJlgACjf0u69QGEfBspenuLdW5e8zzObHOPYQihZC9XWg6QFUDsnWVqyCYs+eers7fF
         kePRZqrUgvNrvhomK99Ruiu0vi/eMoPV5MH6cgJ0HN3uD68Ll/brJh1LabWCeWu7UH2X
         PPLgvs/FegmBRqAxUewv+aBLh3jM4Dx/qZWKgHNrUm4CMR4MeOTJ6PHbIFccWwIYS7Gs
         9/FA2LiWCDJSvK+2UmR1asFv3zGSp1UX2HsISYnUwc+pG/fInEBGfS1MpxiqsYJYzcxx
         STKw==
X-Gm-Message-State: APjAAAXVxUs7+70m1QpQh30srE7PeAmsCPUpRRYBSEZVP6dpMl85XZsv
        E1hvoog6M61oMNVJwf3aExFS1VUY25c=
X-Google-Smtp-Source: APXvYqyTLOIPwAirqBl7uNcaIk1IHPq1RAIFfLcxjq4eo5unRmtw50Qjputx8isRq00CQKjxhEzxGA==
X-Received: by 2002:a05:6808:4c3:: with SMTP id a3mr8889515oie.63.1570729876326;
        Thu, 10 Oct 2019 10:51:16 -0700 (PDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com. [209.85.166.49])
        by smtp.gmail.com with ESMTPSA id z14sm1746149oic.13.2019.10.10.10.51.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 10:51:16 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id b19so15701652iob.4
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 10:51:16 -0700 (PDT)
X-Received: by 2002:a5d:8991:: with SMTP id m17mr12301165iol.52.1570729464667;
 Thu, 10 Oct 2019 10:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190906060115.9460-1-mark-pk.tsai@mediatek.com>
In-Reply-To: <20190906060115.9460-1-mark-pk.tsai@mediatek.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 10 Oct 2019 10:44:13 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vxdnecw2SnUeFpa8Rqq0DSTTeoD_bE1GXk4q37usZ9-w@mail.gmail.com>
Message-ID: <CAD=FV=Vxdnecw2SnUeFpa8Rqq0DSTTeoD_bE1GXk4q37usZ9-w@mail.gmail.com>
Subject: Re: [PATCH] perf/hw_breakpoint: Fix arch_hw_breakpoint use-before-initialization
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, namhyung@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alix Wu <alix.wu@mediatek.com>,
        YJ Chiang <yj.chiang@mediatek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Sep 5, 2019 at 11:01 PM Mark-PK Tsai <mark-pk.tsai@mediatek.com> wrote:
>
> If we disable the compiler's auto-initialization feature
> (-fplugin-arg-structleak_plugin-byref or -ftrivial-auto-var-init=pattern)
> is disabled, arch_hw_breakpoint may be used before initialization after
> the change 9a4903dde2c86.
> (perf/hw_breakpoint: Split attribute parse and commit)
>
> On our arm platform, the struct step_ctrl in arch_hw_breakpoint, which
> used to be zero-initialized by kzalloc, may be used in
> arch_install_hw_breakpoint without initialization.
>
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Cc: YJ Chiang <yj.chiang@mediatek.com>
> Cc: Alix Wu <alix.wu@mediatek.com>
> ---
>  kernel/events/hw_breakpoint.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Stable should pick this up, please.  It landed in mainline as commit
310aa0a25b33 ("perf/hw_breakpoint: Fix arch_hw_breakpoint
use-before-initialization").

* I have confirmed that it cleanly applies to and fixes a kernel based
on v4.19.75, so picking it back to kernels 4.19+ is the easiest.

* I have confirmed that my test shows that hardware breakpoints fail
on my arm32 test machine on v4.18.20 and on v4.17.0.  They last worked
on 4.16.  Picking this patch alone is not sufficient to make 4.17 and
4.18 work again.  Bisecting shows that the first breakage was the
merge resolution that happened in commit 2d074918fb15 ("Merge branch
'perf/urgent' into perf/core").  Specifically both parents of that
merge passed my test but the result of the merge didn't pass my test.
If anyone cares about 4.17 and 4.18 at this point, I will leave it as
an exercise to them to try to get them working again.

-Doug
