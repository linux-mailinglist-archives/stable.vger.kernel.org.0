Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD710DB47
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfK2Vpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 16:45:42 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41816 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfK2Vpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 16:45:41 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:b93f:9fae:b276:a89a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id DC910292998;
        Fri, 29 Nov 2019 21:45:39 +0000 (GMT)
Date:   Fri, 29 Nov 2019 22:45:36 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Steven Price <steven.price@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: Re: [PATCH 2/8] drm/panfrost: Fix a race in
 panfrost_ioctl_madvise()
Message-ID: <20191129224536.6ba79df0@collabora.com>
In-Reply-To: <20191129200733.GQ624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-3-boris.brezillon@collabora.com>
        <dd8a946c-5666-a7b8-f7bc-06647e0d0bbc@arm.com>
        <20191129153310.2f9c80e1@collabora.com>
        <b159591d-1dd4-1ac7-e924-c02be1d8b1f3@arm.com>
        <20191129200733.GQ624164@phenom.ffwll.local>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Nov 2019 21:07:33 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Fri, Nov 29, 2019 at 02:40:34PM +0000, Steven Price wrote:
> > On 29/11/2019 14:33, Boris Brezillon wrote:  
> > > On Fri, 29 Nov 2019 14:24:48 +0000
> > > Steven Price <steven.price@arm.com> wrote:
> > >   
> > >> On 29/11/2019 13:59, Boris Brezillon wrote:  
> > >>> If 2 threads change the MADVISE property of the same BO in parallel we
> > >>> might end up with an shmem->madv value that's inconsistent with the
> > >>> presence of the BO in the shrinker list.    
> > >>
> > >> I'm a bit worried from the point of view of user space sanity that you
> > >> observed this - but clearly the kernel should be robust!  
> > > 
> > > It's not something I observed, just found the race by inspecting the
> > > code, and I thought it was worth fixing it.  
> > 
> > Good! ;) Your cover letter referring to a "debug session" made me think
> > you'd actually hit all these.  
> 
> Time for some igt to make sure this is actually correct?

That's not something I can easily trigger without instrumenting the
code: I need 2 threads doing MADVISE with 2 different values,
and there has to be a context switch between the
drm_gem_shmem_madvise() call and the mutex_lock(shrinker_lock) one. And
last but not least, I'll need a way to report such inconsistencies to
userspace (trace?).
