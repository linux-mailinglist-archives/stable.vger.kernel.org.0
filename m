Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5B10E71D
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 09:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLBIzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 03:55:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34989 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfLBIzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 03:55:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id u8so6642769wmu.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 00:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c8TtAQLPKuN1WcQJrqPrwS1JTgSMHdpZhxAvN9ThAMU=;
        b=I9UNuYxrlcBjCIkvdieElnyRrwi05HIV3hy43x8E8cIPtA2yT6HG1AIYQ21EEnKHTx
         GZRI1HgkGeaQQ68MluzkqfSRGBGsXTrnwJi4BnK+0IjGG7cHViRO1Np+qydWJRv14QnV
         bDV9wxUnHkaB8XIPjQCHaIoxEK6lanq3tkROo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c8TtAQLPKuN1WcQJrqPrwS1JTgSMHdpZhxAvN9ThAMU=;
        b=Hvm6KXAxHUbTCH/GJEQvemh159GaNQUnl9JuHuypmjqhfwrFDBLt4cs7PthVMeWgtp
         PMX8eljwV16Rg+v6/nsYSQXJQ8ZpoAA73lJG510vcH6L2/4h9FP8dPhNk+hLjrSQdsXs
         ZnJWWwazdl2tzocWcu6b6EJRvhDJ63Mlwm+VnAJWu46RSPY+lzB+msLVURzJ6NsAnR/d
         F0DEWK32KmbOLI2+DttPXTjLeSI7ZzynYCjkN2zl+dHQ2iJdnD/4EPTJ/t59PHSxvEH3
         LilnIkQis1ro/GizNDRXPFpm9YcgI2sfkCuiNrULKkA/G/P2rg3bRXr2da7a5Tx5Fxgq
         dc2Q==
X-Gm-Message-State: APjAAAXe/ultB6sf1yvISvKfTmoop2Lxg7NMaErtohuC5ssYBVxqU4uE
        TcaUTnq9Dt3czBsqvB21J4AByg==
X-Google-Smtp-Source: APXvYqxmtdTk6LMaQnkuKbMTq39fhimr3bvLAUgIcn0/zSZMPoPCAxRyLnZB0ESW7ei0+XMZBXb1Og==
X-Received: by 2002:a1c:98d8:: with SMTP id a207mr25895748wme.73.1575276934927;
        Mon, 02 Dec 2019 00:55:34 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id r15sm40418208wrc.5.2019.12.02.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 00:55:34 -0800 (PST)
Date:   Mon, 2 Dec 2019 09:55:32 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 7/8] drm/panfrost: Add the panfrost_gem_mapping concept
Message-ID: <20191202085532.GY624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-8-boris.brezillon@collabora.com>
 <20191129201459.GS624164@phenom.ffwll.local>
 <20191129223629.3aaab761@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129223629.3aaab761@collabora.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 10:36:29PM +0100, Boris Brezillon wrote:
> On Fri, 29 Nov 2019 21:14:59 +0100
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Fri, Nov 29, 2019 at 02:59:07PM +0100, Boris Brezillon wrote:
> > > With the introduction of per-FD address space, the same BO can be mapped
> > > in different address space if the BO is globally visible (GEM_FLINK)  
> > 
> > Also dma-buf self-imports for wayland/dri3 ...
> 
> Indeed, I'll extend the commit message to mention that case.
> 
> > 
> > > and opened in different context. The current implementation does not
> > > take case into account, and attaches the mapping directly to the
> > > panfrost_gem_object.
> > > 
> > > Let's create a panfrost_gem_mapping struct and allow multiple mappings
> > > per BO.
> > > 
> > > The mappings are refcounted, which helps solve another problem where
> > > mappings were teared down (GEM handle closed by userspace) while GPU
> > > jobs accessing those BOs were still in-flight. Jobs now keep a
> > > reference on the mappings they use.  
> > 
> > uh what.
> > 
> > tbh this sounds bad enough (as in how did a desktop on panfrost ever work)
> 
> Well, we didn't discover this problem until recently because:
> 
> 1/ We have a BO cache in mesa, and until recently, this cache could
> only grow (no entry eviction and no MADVISE support), meaning that BOs
> were staying around forever until the app was killed.

Uh, so where was the userspace when we merged this?

> 2/ Mappings were teared down at BO destruction time before commit
> a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation"), and
> jobs are retaining references to all the BO they access.
> 
> 3/ The mesa driver was serializing GPU jobs, and only releasing the BO
> reference when the job was done (wait on the completion fence). This
> has recently been changed, and now BOs are returned to the cache as
> soon as the job has been submitted to the kernel. When that
> happens,those BOs are marked purgeable which means the kernel can
> reclaim them when it's under memory pressure.
> 
> So yes, kernel 5.4 with a recent mesa version is currently subject to
> GPU page-fault storms when the system starts reclaiming memory.
> 
> > that I think you really want a few igts to test this stuff.
> 
> I'll see what I can come up with (not sure how to easily detect
> pagefaults from userspace).

The dumb approach we do is just thrash memory and check nothing has blown
up (which the runner does by looking at the dmesg and a few proc files).
If you run that on a kernel with all debugging enabled, it's pretty good
at catching issues.

For added nastiness lots of interrupts to check error paths/syscall
restarting, and at the end of the testcase, some sanity check that all the
bo still contain what you think they should contain.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
