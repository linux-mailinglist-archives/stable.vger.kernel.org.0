Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD0810E7DE
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfLBJor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:44:47 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36355 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfLBJor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:44:47 -0500
Received: by mail-oi1-f195.google.com with SMTP id c16so9684735oic.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmkx1k4uj/Q9GM7+22Ue6MGN5g2PJXYszTB2VXqmJUo=;
        b=JqBjF9pGrkS8V+l1DFesKcTmKK/NwuoRU27k/DQgAujntrpwFuP+YDCJDm1XjTWxRH
         FtkMzD8zp086SO7UjM4nqBcbfoAmyndRH4AO8kxlE7+sEIFFSGZrx2zvQZt5b+rtsWWz
         t0B5W+x5srPEvri87dOLFzzT+MQL4VoS8jYy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmkx1k4uj/Q9GM7+22Ue6MGN5g2PJXYszTB2VXqmJUo=;
        b=fn+eTznfBzQXVqo9XmRTA2UEP46WwbCOm6wJRFViUtwg568+QLiT5UQLi21MqmrKLm
         eIBfCA8myisKjoa0p2DOQXcRnUfdvEIWpKSCIr/zvfUgiviZk1iux7ueAXq1oF8Y0wkf
         q30OGRuuwV4oPJwGz/JDOJdkn0K5l91WhYRrNN9aojrCpGINP4tyebNIkPG9pTPQhnpg
         9w+LvfDuHCMeO7PKR+fMr6S9rm47gXLF7lZkUx6J2PX3WzW1DjKjm3Jq4uz4UwpcSM80
         FWK7zcib2PO+5vgB2C6w+9nWx007b3cwVcGml1uURUfOMXwOZKNBEN6UEeuQJNwBNChO
         eWww==
X-Gm-Message-State: APjAAAWpiIUlZ9JhRwyvJMV+d/7YYbEhexb7lWP9c5BmyHMqWEqGuAhW
        cyjuw6/Jo+QeUjsDVpkATP3Ct2EHTnU6TBP9W1XGOQ==
X-Google-Smtp-Source: APXvYqyqPTprRFOejeLvnxpSYYBu1O+VETKirCazf4D/SLAOu62tapItcXmlX1kbzUVi9E6o3rQKvmU6iCzbsq5Z68Y=
X-Received: by 2002:aca:39d7:: with SMTP id g206mr1476302oia.101.1575279885601;
 Mon, 02 Dec 2019 01:44:45 -0800 (PST)
MIME-Version: 1.0
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-8-boris.brezillon@collabora.com> <20191129201459.GS624164@phenom.ffwll.local>
 <20191129223629.3aaab761@collabora.com> <20191202085532.GY624164@phenom.ffwll.local>
 <20191202101321.5a053f32@collabora.com>
In-Reply-To: <20191202101321.5a053f32@collabora.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Mon, 2 Dec 2019 10:44:34 +0100
Message-ID: <CAKMK7uG2Zwm5zCud1CZHvAgxgtpg+LopSFM4uB1KO4=yJhYq+Q@mail.gmail.com>
Subject: Re: [PATCH 7/8] drm/panfrost: Add the panfrost_gem_mapping concept
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 2, 2019 at 10:13 AM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> On Mon, 2 Dec 2019 09:55:32 +0100
> Daniel Vetter <daniel@ffwll.ch> wrote:
>
> > On Fri, Nov 29, 2019 at 10:36:29PM +0100, Boris Brezillon wrote:
> > > On Fri, 29 Nov 2019 21:14:59 +0100
> > > Daniel Vetter <daniel@ffwll.ch> wrote:
> > >
> > > > On Fri, Nov 29, 2019 at 02:59:07PM +0100, Boris Brezillon wrote:
> > > > > With the introduction of per-FD address space, the same BO can be mapped
> > > > > in different address space if the BO is globally visible (GEM_FLINK)
> > > >
> > > > Also dma-buf self-imports for wayland/dri3 ...
> > >
> > > Indeed, I'll extend the commit message to mention that case.
> > >
> > > >
> > > > > and opened in different context. The current implementation does not
> > > > > take case into account, and attaches the mapping directly to the
> > > > > panfrost_gem_object.
> > > > >
> > > > > Let's create a panfrost_gem_mapping struct and allow multiple mappings
> > > > > per BO.
> > > > >
> > > > > The mappings are refcounted, which helps solve another problem where
> > > > > mappings were teared down (GEM handle closed by userspace) while GPU
> > > > > jobs accessing those BOs were still in-flight. Jobs now keep a
> > > > > reference on the mappings they use.
> > > >
> > > > uh what.
> > > >
> > > > tbh this sounds bad enough (as in how did a desktop on panfrost ever work)
> > >
> > > Well, we didn't discover this problem until recently because:
> > >
> > > 1/ We have a BO cache in mesa, and until recently, this cache could
> > > only grow (no entry eviction and no MADVISE support), meaning that BOs
> > > were staying around forever until the app was killed.
> >
> > Uh, so where was the userspace when we merged this?
>
> Well, userspace was there, it's just that we probably didn't stress
> the implementation as it should have been when doing the changes
> described in #1, #2 and 3.
>
> >
> > > 2/ Mappings were teared down at BO destruction time before commit
> > > a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation"), and
> > > jobs are retaining references to all the BO they access.
> > >
> > > 3/ The mesa driver was serializing GPU jobs, and only releasing the BO
> > > reference when the job was done (wait on the completion fence). This
> > > has recently been changed, and now BOs are returned to the cache as
> > > soon as the job has been submitted to the kernel. When that
> > > happens,those BOs are marked purgeable which means the kernel can
> > > reclaim them when it's under memory pressure.
> > >
> > > So yes, kernel 5.4 with a recent mesa version is currently subject to
> > > GPU page-fault storms when the system starts reclaiming memory.
> > >
> > > > that I think you really want a few igts to test this stuff.
> > >
> > > I'll see what I can come up with (not sure how to easily detect
> > > pagefaults from userspace).
> >
> > The dumb approach we do is just thrash memory and check nothing has blown
> > up (which the runner does by looking at the dmesg and a few proc files).
> > If you run that on a kernel with all debugging enabled, it's pretty good
> > at catching issues.
>
> We could also check the fence state (assuming it's signaled with an
> error, which I'm not sure is the case right now).
>
> >
> > For added nastiness lots of interrupts to check error paths/syscall
> > restarting, and at the end of the testcase, some sanity check that all the
> > bo still contain what you think they should contain.
>
> Okay, but that requires a GPU job (vertex or fragment shader) touching
> a BO. Apparently we haven't done that for panfrost IGT tests yet, and
> I'm not sure how to approach that. Should we manually forge a cmdstream
> and submit it?

Yeah that's what we do all the time in i915 igts. Usually a simple
commandstream dword write (if you have that somewhere) is good enough
for tests. We also have a 2d blitter engine, plus a library for
issuing copies using the rendercopy.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
