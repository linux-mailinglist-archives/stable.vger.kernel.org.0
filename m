Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E74A1B2CCF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 18:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDUQiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 12:38:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34636 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUQiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 12:38:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so2539399pfa.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 09:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0khUqx1YabhU1s0W9K0DTrddSLprVxUAWBvp6SKJZzA=;
        b=dVNpubVTr08HEB2PCZeJ7qiCq1sAuTBsdGNoxz0U8H9TsJrhitk3QWeENpayZz1zss
         W/mL6g44/CgP9fXLv+/+m61U92dkWjYjTxeSMF5BjieSSZh3WxO2gk/euE7zVRaZJE/+
         GqqjhY7NXE6y75bKB7mqwDjh1H/8yYy5oYOKf0pjrP52zBxGCcu3r8sE2EwvI2FikxLA
         zp2guXdadho2j3hBIu02IQqsqk+Hthaosp3cR9Zd5BmV12dnlXn8lFJmPeCYGjdoHGYJ
         qzfQs6u4U5LG2cl4NAmsy+vIo9EzV7HDzE6JG+iGp0YeFgF5CHbMa0iqgprXxruksdEI
         cYWg==
X-Gm-Message-State: AGi0PuYp9xpKUZ6NmSq4zBIVXxvJp1joQirDnmMdkidrpuT0KWk0gqYQ
        hDs0T/pfafTSIMpqFW5Y7dI=
X-Google-Smtp-Source: APiQypIdeRK0z8DisPDG03FsvjWjUvEF00MRu9daPCcTsgQeaqka3SIM0V+AHcd1+fC8V232iN/2wA==
X-Received: by 2002:a63:d3:: with SMTP id 202mr22001799pga.378.1587487092243;
        Tue, 21 Apr 2020 09:38:12 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id 128sm2781368pfx.187.2020.04.21.09.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 09:38:11 -0700 (PDT)
Date:   Tue, 21 Apr 2020 09:38:09 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in
 i915_active_wait()
Message-ID: <20200421163809.GB2289@sultan-box.localdomain>
References: <20200407065210.GA263852@kroah.com>
 <20200407071809.3148-1-sultan@kerneltoast.com>
 <20200410090838.GD1691838@kroah.com>
 <20200410141738.GB2025@sultan-box.localdomain>
 <20200411113957.GB2606747@kroah.com>
 <158685210730.16269.15932754047962572236@build.alporthouse.com>
 <20200414082344.GA10645@kroah.com>
 <158737335977.8380.15005528012712372014@jlahtine-desk.ger.corp.intel.com>
 <20200420154216.GA1963@sultan-box.localdomain>
 <158745625375.5265.15743487643543685929@jlahtine-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158745625375.5265.15743487643543685929@jlahtine-desk.ger.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 11:04:13AM +0300, Joonas Lahtinen wrote:
> Quoting Sultan Alsawaf (2020-04-20 18:42:16)
> > On Mon, Apr 20, 2020 at 12:02:39PM +0300, Joonas Lahtinen wrote:
> > > I think the the patch should be dropped for now before the issue is
> > > properly addressed. Either by backporting the mainline fixes or if
> > > those are too big and there indeed is a smaller alternative patch
> > > that is properly reviewed. But the above patch is not, at least yet.
> > 
> > Why should a fix for a bona-fide issue be dropped due to political reasons? This
> > doesn't make sense to me. This just hurts miserable i915 users even more. If my
> > patch is going to be dropped, it should be replaced by a different fix at the
> > same time.
> 
> There's no politics involved. It's all about doing the due diligence
> that we're fixing upstream bugs, and we're fixing them in a way that
> does not cause regressions to other users.

Due diligence is the furthest thing from what I'd associate with i915. My
cherryview laptop doesn't work anymore in 5.6 (it gets many GPU hangs; a RedHat
engineer is working on fixing it according to the gitlab issue), my colleagues'
laptops with 4k screens still suffer from GPU hangs (with fully documented
gitlab reports that have gone completely unanswered), and I still get occasional
FIFO underrun messages in dmesg accompanying graphical glitches on my own
laptops. On top of that, PSR doesn't work correctly on any of my laptops, and
it's enabled by default in i915. But when I reported the issue on gitlab, I got
claims that my laptops' panels were bad, and that my reports were "not enough
reason to disable PSR by default." [1]

[1] https://gitlab.freedesktop.org/drm/intel/-/issues/425#note_434182

> Without being able to reproduce a bug against vanilla kernel, there's
> too high of a risk that the patch that was developed will only work
> on the downstream kernel it was developed for. That happens for the
> best of the developers, and that is exactly why the process is in
> place, to avoid human error. So no politics, just due diligence.

You could have reviewed the patch in the same amount of time it took you to
write this email. It's very simple and obvious. That's why this sounds more like
politics to me than "due diligence."

> > Also, the mainline fixes just *happen* to fix this deadlock by removing the
> > mutex lock from the path in question and creating multiple other bugs in the
> > process that had to be addressed with "Fixes:" commits. The regression potential
> > was too high to include those patches for a "stable" kernel, so I made this
> > patch which fixes the issue in the simplest way possible.
> 
> The thing is that it may be that the patch fixes the exact issue you
> have at hand in the downstream kernel you are testing against. But
> in doing so it may as well break other usecases for other users of
> vanilla kernel. That is what we're trying to avoid.

I don't know of any usecase that needs a double mutex lock (except for drm code
that uses mutex_trylock_recursive of course), but alright.

> A patch that claims to fix a deadlock in upstream kernel should
> include that splat from upstream kernel, not a speculated chain.
> Again, this is just the regular due diligence, because we have
> made errors in the past. It is for those self-made errors we
> know not to merge fixes too quickly before we are able to
> reproduce the error and make sure it is gone.

I sent the splat in a previous email. And you lot are all making many errors in
the present, far more so than in the past because i915 used to work at some
point. The sheer number of Chris' commits with subsequent "Fixes:" for his
changes is mind numbing. For Ubuntu, we've had to backport a massive amount of
i915 fixes to our 5.4 kernel thus far, and the major bugs still aren't all
fixed (probably since those bugs still exist in Linus' tree). And we can't
backport all of the relevant fixes we find because they're either contained in
massive refactor commits or they only apply to i915 code that's been massively
refactored since the last kernel release.

> > We put this patch into
> > Ubuntu now as well, because praying for a response from i915 maintainers while
> > the 20.04 release was on the horizon was not an option.
> > 
> > > There is an another similar thread where there's jumping into
> > > conclusions and doing ad-hoc patches for already fixed issues:
> > > 
> > > https://lore.kernel.org/dri-devel/20200414144309.GB2082@sultan-box.localdomain/
> > 
> > Maybe this wouldn't have happened if I had received a proper response for that
> > issue on gitlab from the get-go... Instead I got the run-around from Chris
> > claiming that it wasn't an i915 bug:
> > 
> > https://gitlab.freedesktop.org/drm/intel/issues/1599
> > 
> > > I appreciate enthusiasm to provide fixes to i915 but we should
> > > continue do the regular due diligence to make sure we're properly
> > > fixing bugs in upstream kernels. And when fixing them, to make
> > > sure we're not simply papering over them for a single use case.
> > > 
> > > It would be preferred to file a bug for the seen issues,
> > > describing how to reproduce them with vanilla upstream kernels:
> > > 
> > > https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs
> > 
> > gitlab.freedesktop.org/drm/intel is where bugs go to be neglected, as noted
> > above. I really see no reason to send anything there anymore, when the vast
> > majority of community-sourced bug reports go ignored.
> 
> In the above bug, you claim to be booting vanilla kernel but the splat
> clearly says "5.4.28-00007-g64bb42e80256-dirty", so the developer correctly
> requested to bisect the error between 5.4.27 and 5.4.28 vanilla kernels, which
> you seem to have ignored and simply jumped to provide a patch.

Telling me to bisect between 5.4.27 and 5.4.28 after claiming it's not an i915
bug is a total waste of time. There weren't even any i915 changes in 5.4.28, and
the assumption that it's "not i915" is a load of crap too because the bug in
question had a very sane crash: `ring->vaddr` was clearly zero, like I said in
my description. I "jumped to provide a patch" because we have customers to
answer to when i915 doesn't work, and I wasn't going to waste time running in
circles to appease the maintainer when I could fix the problem myself.

> Apologies if it feels like the bugs do not get enough attention, but we
> do our best to act on the reported bugs. You can best guarantee that
> your bug is getting the attention by providing all the details requested
> in the above link.

Why hasn't this bug got any attention:
https://gitlab.freedesktop.org/drm/intel/issues/1412

That seems like a showstopper.

What about this bug?
https://gitlab.freedesktop.org/drm/intel/issues/1605

That's the bug that makes my cherryview machine unusable. A RedHat engineer is
working on fixing that instead of an i915 maintainer... that doesn't seem right.

Someone else reported that bug here:
https://gitlab.freedesktop.org/drm/intel/issues/1585

And Chris gave a very helpful, "Despite all that it is still probably userspace
fouling the memory" in response. Even though the problem doesn't occur in older
kernels.

> Without that information, it'll be hard to assess the severity of the
> bug. Above bug is missing critical pieces of information which help us
> in assessing the severity: 1. Is the bug reproducible on drm-tip?
> 2. How to reproduce? 3. How often does it reproduce? 4. Which hardware?
> 
> If that information is missing, it means that that some of our
> developers needs to find out all those bits of information before
> we can even assess the severity of the bug. And as we also have
> bugs where the information is present, those are often acted on
> first.

Why not ask for that? I was never asked for that information. A splat should've
been enough to identify the problem anyway.

> Again, no politics involved and no praying needed.

I don't think I'll stop praying for i915 to work based on the current state of
affairs, thanks.

Sultan
