Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD24A7875
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 20:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346843AbiBBTDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346841AbiBBTDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 14:03:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ACFC06173D
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 11:03:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so7746738pju.2
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 11:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aukpW1iZ03y9P5Ftl5wjItYFQL/CIJ9WL1xn7dY1lMc=;
        b=d5CHA/ArAtV/xPhLL2/JhkAe37YFSe43ehxtmA5SCeVDr410kShpQ5JnPBswiRQVcy
         RmIrCXJZy1n4FE4WROjypPuHYpeubia5+50oO3H4OlzDzlKappn+UlQ9qzPQBMnsVTOP
         Quueb5szhF/BxSK2uR+7g0OBW6XEC6M1Ihvr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aukpW1iZ03y9P5Ftl5wjItYFQL/CIJ9WL1xn7dY1lMc=;
        b=5vks/u22WaviKsjcyPRUMjdNc30Wvo597FexnQOYco8L4SbYcKdJitRylVLfKm29tq
         3QkWPxfM3N+IMjKFsWVl4L31+TslJPvQ2W73oGEAANYk8aWLIWOXll9X5Kc1qyOlU4ZH
         Xl2s4Hdl7Czbpbsb8f8KhRF1ZQmpYhhlQp6z5K6QgT59Z42CQTC/fii85DrsuU3o89BJ
         e38WSltgC53fdRLGfOu4mBUYn/W0tZHBYtbhO0z4DHwpSXsUOKbQwpWMdD4Zg2cHp3lp
         6UBJageZqGymuD3jDo7xrQOIKlY6iYN7TPOibN6hDGhiJRAkttk3/0k2EHIrNjY/+s08
         l6og==
X-Gm-Message-State: AOAM5305Z8Tbsm7eEhJoexNcYbqx/9NGi9Y4RPtUysUTWQntDsJ8TYiR
        IMvcW4CzTM/cLMC3OqxBIUsVUw==
X-Google-Smtp-Source: ABdhPJw+8PJv/OS8Dx0VVQ7xKm/3S+7zS+33PFyICT8EO3OvjoYaQYPH3Qiq87/Okt1OkXuL/rp2pw==
X-Received: by 2002:a17:90a:be15:: with SMTP id a21mr9663038pjs.36.1643828631016;
        Wed, 02 Feb 2022 11:03:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y191sm25813825pfb.114.2022.02.02.11.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 11:03:50 -0800 (PST)
Date:   Wed, 2 Feb 2022 11:03:49 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Rich Felker <dalias@libc.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
Message-ID: <202202021056.ED125C0346@keescook>
References: <20220201000947.2453721-1-keescook@chromium.org>
 <20220201145324.GA29634@brightrain.aerifal.cx>
 <1A24DA4E-2B15-4A95-B2A1-F5F963E0CD6F@chromium.org>
 <20220202171218.GQ7074@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202171218.GQ7074@brightrain.aerifal.cx>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 12:12:19PM -0500, Rich Felker wrote:
> On Wed, Feb 02, 2022 at 07:50:42AM -0800, Kees Cook wrote:
> > On February 1, 2022 6:53:25 AM PST, Rich Felker <dalias@libc.org> wrote:
> > >From #musl:
> > >
> > ><mixi> kees: shouldn't the min(bprm->argc, 1) be max(...) in your patch?
> > 
> > Fix has already been sent, yup.
> > 
> > >I'm pretty sure without fixing that, you're introducing a giant vuln
> > >here.
> > 
> > I wouldn't say "giant", but yes, it weakened a defense in depth for
> > avoiding high stack utilization.
> 
> I thought it was deciding the amount of memory to allocate/reserve for
> the arg slots, but based on the comment it looks like it's just a way
> to fail early rather than making the new process image fault later if
> they don't fit.

Right.

> > > I believe this is the second time a patch attempting to fix this
> > >non-vuln has proposed adding a new vuln...
> > 
> > Mistakes happen, and that's why there is review and testing. Thank
> > you for being part of the review process! :)
> 
> I know, and I'm sorry for being a bit hostile over it, and for jumping
> the gun about the severity. I just get frustrated when I see a rush to
> make changes over an incidental part of a popularized vuln, with
> disproportionate weight on "doing something" and not enough on being
> careful.

Sure, I can see it looks that way. My sense of urgency on this in
particular is that we're early in the development cycle, and it's an
ABI-breaking change, so I want to maximize how much time it has to get
tested out in real workloads. (i.e. we've now seen that just rejecting
NULL argv is likely too painful, etc.)

All that said, I regularly bemoan the lack of sufficient regression
tests for execve() and the binfmt_*.c loaders. I've written a couple,
and so have others, but what I really want is a library of "binary that
got broken by exec change" for doing regression testing against. That
gets hampered by both size, redistribution issues, etc, so I've wanted
to have minimal reproducers for each, but creating those take time, etc,
etc.

(And you'll note I wrote[1] a test for this particular behavior, because
I'm trying to avoid falling further behind in test coverage.)

I would _love_ it if someone had the time and attention to go through
all the past binaries and make a regression test series. :)

-Kees

[1] https://lore.kernel.org/linux-hardening/20220201011637.2457646-1-keescook@chromium.org/

-- 
Kees Cook
