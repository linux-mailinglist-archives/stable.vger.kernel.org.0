Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7532C57BD4B
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiGTR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 13:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGTR5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 13:57:31 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E42626123
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 10:57:29 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id j70so11768677oih.10
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 10:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sgTGIjyBI1Xr5kae9NtvGuvQ751HmdoxY8E4y+04bcM=;
        b=VuHxsoUeYLJU3NL2MX0RU5EKmY7niw3Gwan0qSjKNQ+yHnuScPtLYptfI3fKI++uAI
         ZeZ8nICnyQhmL1BpX4XQNXKRt39zlzUQWbx08LgEuCZ1tvXne53ZQf6SRKJVlIm3SYkA
         mL9xo1GRlnkK1+eByxB1hXq6hJ+8ib0Bj6Vz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sgTGIjyBI1Xr5kae9NtvGuvQ751HmdoxY8E4y+04bcM=;
        b=PWLSBPmv6DE2qr0yE/gznlTvrAiyvcyBhCasv0Qi37mlYXNpJcNspJ43Y2gMacwXfc
         +1Hv05kKta6BOHbkuOIriJGLZ4XBp+IHXeTDbYwRBS3X1/6/hKFIHGbnvk0TgzXt7/dX
         0kO+UEq53IC8MOhxIJnOZtuWYtHw9uHk5GFuC7IROJNq7ZWIPIOiZ+WRYo7qwI6F0JQM
         dNNNEDe2g8luWz4XmxY8aqJ7gKak7y172o5dINyPpDJAqQPIjT0E5WwtvOipTfS4TgXF
         76FWBYn7uaUoTNtaPeVxzB3cz6cdo4U73k481va5bc6wJPrDVkzaR2O1jkUC2xaA1Rmn
         +2lQ==
X-Gm-Message-State: AJIora/ocZl6lT2tnZYx0olFmRnfR+k4abVM1xgUHix2I1JufazTV5yc
        BoeJAFIQW+mkgkkMz7KPqhJL+A==
X-Google-Smtp-Source: AGRyM1vYLqC/RqZeHtVvHjmMhC0sp3QLz3G9l0Bz1+cMerVnWbXkdjUx5gjtpb0zt3sMy6gYkJFMPg==
X-Received: by 2002:a05:6808:302:b0:33a:78cc:2fa7 with SMTP id i2-20020a056808030200b0033a78cc2fa7mr2939761oie.50.1658339848625;
        Wed, 20 Jul 2022 10:57:28 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id y7-20020a544d87000000b0032f7605d1a3sm6795335oix.31.2022.07.20.10.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:57:27 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 20 Jul 2022 12:57:26 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jslaby@suse.cz>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <YthCBl4SORA2BfDv@fedora64.linuxtx.org>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,PDS_BTC_ID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 10:28:33AM -0700, Linus Torvalds wrote:
> [ Adding PeterZ and Jiri to the participants. ]
> 
> Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
> Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
> ANNOTATE_UNRET_SAFE use on 32-bit") in that list.

It should be noted that the build doesn't fail, it just warns.
I am guessing the 32bit failure is what promoted someone to look at
the logs to begin with and notice the warn initially. I just verified
that it exists in our builds of 5.18.13-rc1, but not on mainline builds.
I am gueesing it is because commit 9bb2ec608a20 ("objtool: Update Retpoline
validation") should be followed up with at least commit f43b9876e857c
("x86/retbleed: Add fine grained Kconfig knobs")

Justin

> That said, 3131ef39fb03 should have fixed a completely different issue
> on 32-bit, not the "naked ret" thing.
> 
> PeterZ, Jiri, any ideas? Limited quoting below, see thread at
> 
>   https://lore.kernel.org/all/CA+G9fYsJBBbEXowA-3kxDNqcfbtcqmxBrEnJSkCnLUsMzNfJZw@mail.gmail.com/
> 
> for more details.
> 
>               Linus
> 
> On Wed, Jul 20, 2022 at 9:37 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
> >
> > On Tue, Jul 19, 2022 at 12:32:48PM -0700, Linus Torvalds wrote:
> > > On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
> > > <naresh.kamboju@linaro.org> wrote:
> > > >
> > > >
> > > > 2. Large number of build warnings on x86 with gcc-11,
> > > > I do not see these build warnings on mainline,
> > > ..
> > > > 'naked' return found in RETPOLINE build
> > >
> > > Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?
> > >
> > > Your build does magic things with 'scripts/kconfig/merge_config.sh',
> > > and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
> > > compiler that doesn't actually support it, or something like that?
> >
> > I am seeing these 'naked' return found in RETPOLINE build on the
> > standard fedora 36 toolchain as well. No cross compiling, nothing fancy.
> > These were not seen with mainline, or with the 5.18.12-rc1 retbleed
> > patches.
> >
> > Justin
