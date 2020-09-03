Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D6725BA36
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 07:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgICFkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 01:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgICFku (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Sep 2020 01:40:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208EDC061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 22:40:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so1750798wrt.3
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 22:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gY3MI41vEU1NMjzHm+Y/kv/+1eo4t7vouQCNTLaH8tw=;
        b=P9O9ojK9SN4DainuCnqGEkkLw7c5IFDodPBOdOgzK+Qxwb3dd2JbPa5pie0pU6EWGY
         6aqd8Tvnb0DaCmCfOHc0j+eVU3LQWj9I/WdXj/xiz+oB8SZ0pDSsikXx6claCGG1F6OH
         NMtN9sCXIml8rgVj6vW6eAF2d8ai35zOWun29dkU8xvq6zxmmxC0CPFuDCWUeEbTelCh
         WKqTIZXomFbb623MncUfm6CSk4h6Si/AR9JjpHIo49Vg2Z87BnnPzb7FTG0fHKpzOly5
         uKMab0vlcNvYC06NKzcx0k9UGMSdi8tOeNttQCEb1tamPTt8s2da+L6xBV01VzpnBBP7
         +6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gY3MI41vEU1NMjzHm+Y/kv/+1eo4t7vouQCNTLaH8tw=;
        b=JsL3DJiH6xwe2KRmzEmTMkEF5aJSdVI77NNxM0XSKlz6yIep6ldVjD8zWZj1UNazsW
         az2bSrq4VWqhaKg0ojf8Px0xMDE68yJGs51p9SstXWUPOvGyJxp3vPqGgsnbU30lGIry
         9WlMQFKkFj8CH8wCgjlcHNuiAd2DwS3ImOOAok/aW/sK2Fz1bWmNUV5mrpWUdvFD2bMS
         bCHwupwd2IAHObHcabVVGh/sLEOiA8cC9m9i/5r8jkf3LOuUc6z6wwcXudJ8Z9m6sk9P
         pO/koD4HQU49dD8xFWO14KTcKXBXdJY1uVO2RpjWYCmB72kC2Cq7XYMrhZFMe6WxTHXz
         hnBA==
X-Gm-Message-State: AOAM5330nxD1dwE2S0+sH50vkuozsjeAbE/MYb1MRa8lw9eP5gIPT2zr
        k4/HaVGvhqRYlVdFzIuDsSnKMnTkb+UZNDipJiBQdA==
X-Google-Smtp-Source: ABdhPJx57OEmu3nFJ6L+W1wyfPe96PkYaQ4mvT6GUNK8/UGkwQBG35cuXucn+daqE40Lw5jNPPgSOrxCQsHPLLVxJho=
X-Received: by 2002:adf:fb01:: with SMTP id c1mr369410wrr.119.1599111647233;
 Wed, 02 Sep 2020 22:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200901220944.277505-1-kim.phillips@amd.com>
In-Reply-To: <20200901220944.277505-1-kim.phillips@amd.com>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 2 Sep 2020 22:40:35 -0700
Message-ID: <CAP-5=fXE3SC8Lj1K30ooA1kJJqFyAA0AzSyMRh4VG+480tupZQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf vendor events amd: Add L2 Prefetch events for zen1
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vijay Thakkar <vijaythakkar@me.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        =?UTF-8?Q?Martin_Li=C5=A1ka?= <mliska@suse.cz>,
        Borislav Petkov <bp@suse.de>, Jon Grimm <jon.grimm@amd.com>,
        Martin Jambor <mjambor@suse.cz>,
        Michael Petlan <mpetlan@redhat.com>,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 1, 2020 at 3:10 PM Kim Phillips <kim.phillips@amd.com> wrote:
>
> Later revisions of PPRs that post-date the original Family 17h events
> submission patch add these events.
>
> Specifically, they were not in this 2017 revision of the F17h PPR:
>
> Processor Programming Reference (PPR) for AMD Family 17h Model 01h, Revis=
ion B1 Processors Rev 1.14 - April 15, 2017
>
> But e.g., are included in this 2019 version of the PPR:
>
> Processor Programming Reference (PPR) for AMD Family 17h Model 18h, Revis=
ion B1 Processors Rev. 3.14 - Sep 26, 2019
>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Sanity checked manual and ran tests. Thanks,
Ian

> Fixes: 98c07a8f74f8 ("perf vendor events amd: perf PMU events for AMD Fam=
ily 17h")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Vijay Thakkar <vijaythakkar@me.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Yunfeng Ye <yeyunfeng@huawei.com>
> Cc: Jin Yao <yao.jin@linux.intel.com>
> Cc: "Martin Li=C5=A1ka" <mliska@suse.cz>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jon Grimm <jon.grimm@amd.com>
> Cc: Martin Jambor <mjambor@suse.cz>
> Cc: Michael Petlan <mpetlan@redhat.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  .../pmu-events/arch/x86/amdzen1/cache.json     | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json b/tools/pe=
rf/pmu-events/arch/x86/amdzen1/cache.json
> index 404d4c569c01..695ed3ffa3a6 100644
> --- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
> +++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
> @@ -249,6 +249,24 @@
>      "BriefDescription": "Cycles with fill pending from L2. Total cycles =
spent with one or more fill requests in flight from L2.",
>      "UMask": "0x1"
>    },
> +  {
> +    "EventName": "l2_pf_hit_l2",
> +    "EventCode": "0x70",
> +    "BriefDescription": "L2 prefetch hit in L2.",
> +    "UMask": "0xff"
> +  },
> +  {
> +    "EventName": "l2_pf_miss_l2_hit_l3",
> +    "EventCode": "0x71",
> +    "BriefDescription": "L2 prefetcher hits in L3. Counts all L2 prefetc=
hes accepted by the L2 pipeline which miss the L2 cache and hit the L3.",
> +    "UMask": "0xff"
> +  },
> +  {
> +    "EventName": "l2_pf_miss_l2_l3",
> +    "EventCode": "0x72",
> +    "BriefDescription": "L2 prefetcher misses in L3. All L2 prefetches a=
ccepted by the L2 pipeline which miss the L2 and the L3 caches.",
> +    "UMask": "0xff"
> +  },
>    {
>      "EventName": "l3_request_g1.caching_l3_cache_accesses",
>      "EventCode": "0x01",
> --
> 2.27.0
>
