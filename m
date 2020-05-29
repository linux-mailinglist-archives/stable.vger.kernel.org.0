Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E09F1E836C
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 18:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgE2QRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 12:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2QRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 12:17:53 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3670CC03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 09:17:52 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c14so1662757qka.11
        for <stable@vger.kernel.org>; Fri, 29 May 2020 09:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXTV+TTsF92ztx+5DK/JVYDETlfO/g4OhWYxReRxajM=;
        b=LBwBsmiTipPGKv83Lwc1wO/o5okKYKCM8Qwn+aPYZGtMmELM2EfGJj0o54LB5dBszv
         UqXlxADnAsOgAkEp5o8cH3CzAROx0BcmO/RMzYqvy0NvLKyox1a705B2c2/ShuZO5Rb1
         RU+V2akyMtgIDb0WzSJlXp3hBGDff5At4Sr/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXTV+TTsF92ztx+5DK/JVYDETlfO/g4OhWYxReRxajM=;
        b=nzsZPW6gkGO4H3rw08EkRZZSB4mG1qltXtUENqL0FD0WeJ5UeD/Zd75JSIR/QXgA57
         WpMKDUWm8b5riQNYDlISI1huasf8I8M/Bo0d/JxJhD941gve+PXX3uLTUuuFkn94szaS
         4hcPMqDLPlyT3m8WYb8H2T79VzygYNh71RvK27vI1wcRMSkwKK9Ue79W8HMsBMSeay31
         JSLHncFta867rdJk6bncYY4mc3R95i7GfYjTyjN34B/3zbwL7FP3FeEWZ5Dyiv0zsjbr
         cfCKf0WlvHdJQXw4XflS36NWBaeOMqGSCLIh0gwSMG8z1s0mfC9A2i+CURYNVVdcnc04
         hQBw==
X-Gm-Message-State: AOAM532lm+YdVK4W3QXPODrbSnxyqjZ241YvYRSshdelxMRNDstkydG6
        CCPciapTxJSPF/VBHs1vsY6JuQ==
X-Google-Smtp-Source: ABdhPJxKEIUUHpXlIgFmAKpfph9pSR/7GKXbUtKzBf2eKyfwxM6ieBIpQSJ9XFwP+ISntLnX3hjjCw==
X-Received: by 2002:a05:620a:64f:: with SMTP id a15mr8487717qka.10.1590769071261;
        Fri, 29 May 2020 09:17:51 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id n123sm7677240qkf.23.2020.05.29.09.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:17:50 -0700 (PDT)
Date:   Fri, 29 May 2020 12:17:50 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        vpillai <vpillai@digitalocean.com>, vineethrp@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/headers: Fix sched_setattr userspace compilation
 breakage
Message-ID: <20200529161750.GA196085@google.com>
References: <20200528135552.GA87103@google.com>
 <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
 <20200528230859.GB225299@google.com>
 <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
 <20200529014524.GA38759@google.com>
 <CAHk-=wgO86MS-=G2D=aDpOvZVYARD2kBZ43sofX6WwK0OAzmwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgO86MS-=G2D=aDpOvZVYARD2kBZ43sofX6WwK0OAzmwg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On Thu, May 28, 2020 at 07:17:38PM -0700, Linus Torvalds wrote:
> On Thu, May 28, 2020 at 6:45 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> >  glibc's <sched.h> already defines struct sched_param (which is a POSIX
> >  struct), so my inclusion of <linux/sched/types.h> above which is a UAPI
> >  header exported by the kernel, breaks because the following commit moved
> >  sched_param into the UAPI:
> >  e2d1e2aec572a ("sched/headers: Move various ABI definitions to <uapi/linux/sched/types.h>")
> >
> >  Simply reverting that part of the patch also fixes it, like below. Would
> >  that be an acceptable fix? Then I can go patch glibc to get struct
> >  sched_attr by including the UAPI's <linux/sched/types.h>. Otherwise, I
> >  suspect glibc will also break if it tried to include the UAPI header.
> 
> Hmm.
> 
> Reverting that commit makes some sense as a "it broke things", and
> yes, if this was some recent change that caused problems with user
> headers, that would be what we should do (at least to then think about
> it a bit more).
> 
> But that commit was done three years ago and you're the first person
> to report breakage.
> 
> So for all I know, modern glibc source bases have already fixed
> themselves up, and take advantage of the new UAPI location. Or they
> just did that kernel header sync many years ago, and will fix it up
> the next time they do a header sync.
> 
> So then reverting things (or adding the __KERNEL__ guard) would only
> break _those_ cases instead and make for only more problems.
> 
> Basically, I think you should treat this as a glibc header bug, not a
> kernel header bug.

Got it, thanks.

> And when you say

> > The reason is, since <sched.h> did not provide struct sched_attr as the
> > manpage said, so I did the include of uapi's linux/sched/types.h myself:
> 
> instead of starting to include the kernel uapi header files - that
> interact at a deep level with those system header files - you should
> just treat it as a glibc bug.
> 
> And then you can either work around it locally, or make a glibc
> bug-report and hope it gets fixed that way.
> 
> The "work around it locally" might be something like a
> "glibc-sched-h-fixup.h" header file that does
> 
>   #ifndef SCHED_FIXUP_H
>   #define SCHED_FIXUP_H
>   #include <sched.h>
> 
>   /* This is documented to come from <sched.h>, but doesn't */
>   struct sched_attr {
>         __u32 size;
> 
>         __u32 sched_policy;
>         __u64 sched_flags;
> 
>         /* SCHED_NORMAL, SCHED_BATCH */
>         __s32 sched_nice;
> 
>         /* SCHED_FIFO, SCHED_RR */
>         __u32 sched_priority;
> 
>         /* SCHED_DEADLINE */
>         __u64 sched_runtime;
>         __u64 sched_deadline;
>         __u64 sched_period;
> 
>         /* Utilization hints */
>         __u32 sched_util_min;
>         __u32 sched_util_max;
> 
>   };
>   #end /* SCHED_FIXUP_H */
> 
> in your build environment (possibly with configure magic etc to find
> the need for this fixup, depending on how fancy you want to be).

Got it, I will look into these options. Thanks.

Turns out I hit the same/similar issue in 2018 but for a different reason. At
the time I was working on Android and needed this struct. The bionic C
library folks refused to add it because no other libc exposed it either (that
was their reason to not have it, anyway). I suspect everyone was just doing
their own fixups to use it and that was what I was asked to do.

I think it would be better to just do the fixup you suggested above for now.

> Because when we have a change that is three+ years old, we can't
> reasonably change the kernel back again without then likely just
> breaking some other case that depends on that uapi file that has been
> there for the last few years.
> 
> glibc and the kernel aren't developed in sync, so glibc generally
> takes a snapshot of the kernel headers and then works with that. That
> allows glibc developers to work around any issues they have with our
> uapi headers (we've had lots of namespace issues, for example), but it
> also means that the system headers aren't using some "generic kernel
> UAPI headers". They are using a very _particular_ set of kernel uapi
> headers from (likely) several years ago, and quite possibly then
> further edited too.
> 
> Which is why you can't then mix glibc system headers that are years
> old with kernel headers that are modern (or vice versa).
> 
> Well, with extreme luck and/or care you can. But not in general.

Got it, thank you Linus !!!

 - Joel

