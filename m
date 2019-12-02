Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9FB10E777
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLBJN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:13:26 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58340 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLBJN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:13:26 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 76EC8283CA2;
        Mon,  2 Dec 2019 09:13:24 +0000 (GMT)
Date:   Mon, 2 Dec 2019 10:13:21 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 7/8] drm/panfrost: Add the panfrost_gem_mapping concept
Message-ID: <20191202101321.5a053f32@collabora.com>
In-Reply-To: <20191202085532.GY624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-8-boris.brezillon@collabora.com>
        <20191129201459.GS624164@phenom.ffwll.local>
        <20191129223629.3aaab761@collabora.com>
        <20191202085532.GY624164@phenom.ffwll.local>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Dec 2019 09:55:32 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Fri, Nov 29, 2019 at 10:36:29PM +0100, Boris Brezillon wrote:
> > On Fri, 29 Nov 2019 21:14:59 +0100
> > Daniel Vetter <daniel@ffwll.ch> wrote:
> >   
> > > On Fri, Nov 29, 2019 at 02:59:07PM +0100, Boris Brezillon wrote:  
> > > > With the introduction of per-FD address space, the same BO can be mapped
> > > > in different address space if the BO is globally visible (GEM_FLINK)    
> > > 
> > > Also dma-buf self-imports for wayland/dri3 ...  
> > 
> > Indeed, I'll extend the commit message to mention that case.
> >   
> > >   
> > > > and opened in different context. The current implementation does not
> > > > take case into account, and attaches the mapping directly to the
> > > > panfrost_gem_object.
> > > > 
> > > > Let's create a panfrost_gem_mapping struct and allow multiple mappings
> > > > per BO.
> > > > 
> > > > The mappings are refcounted, which helps solve another problem where
> > > > mappings were teared down (GEM handle closed by userspace) while GPU
> > > > jobs accessing those BOs were still in-flight. Jobs now keep a
> > > > reference on the mappings they use.    
> > > 
> > > uh what.
> > > 
> > > tbh this sounds bad enough (as in how did a desktop on panfrost ever work)  
> > 
> > Well, we didn't discover this problem until recently because:
> > 
> > 1/ We have a BO cache in mesa, and until recently, this cache could
> > only grow (no entry eviction and no MADVISE support), meaning that BOs
> > were staying around forever until the app was killed.  
> 
> Uh, so where was the userspace when we merged this?

Well, userspace was there, it's just that we probably didn't stress
the implementation as it should have been when doing the changes
described in #1, #2 and 3. 

> 
> > 2/ Mappings were teared down at BO destruction time before commit
> > a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation"), and
> > jobs are retaining references to all the BO they access.
> > 
> > 3/ The mesa driver was serializing GPU jobs, and only releasing the BO
> > reference when the job was done (wait on the completion fence). This
> > has recently been changed, and now BOs are returned to the cache as
> > soon as the job has been submitted to the kernel. When that
> > happens,those BOs are marked purgeable which means the kernel can
> > reclaim them when it's under memory pressure.
> > 
> > So yes, kernel 5.4 with a recent mesa version is currently subject to
> > GPU page-fault storms when the system starts reclaiming memory.
> >   
> > > that I think you really want a few igts to test this stuff.  
> > 
> > I'll see what I can come up with (not sure how to easily detect
> > pagefaults from userspace).  
> 
> The dumb approach we do is just thrash memory and check nothing has blown
> up (which the runner does by looking at the dmesg and a few proc files).
> If you run that on a kernel with all debugging enabled, it's pretty good
> at catching issues.

We could also check the fence state (assuming it's signaled with an
error, which I'm not sure is the case right now).

> 
> For added nastiness lots of interrupts to check error paths/syscall
> restarting, and at the end of the testcase, some sanity check that all the
> bo still contain what you think they should contain.

Okay, but that requires a GPU job (vertex or fragment shader) touching
a BO. Apparently we haven't done that for panfrost IGT tests yet, and
I'm not sure how to approach that. Should we manually forge a cmdstream
and submit it?
