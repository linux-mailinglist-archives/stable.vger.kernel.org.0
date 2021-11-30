Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856CA463106
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhK3KgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbhK3KgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255A5C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 02:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB81B817FF
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6542FC53FC1;
        Tue, 30 Nov 2021 10:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638268365;
        bh=+pnDCim3rKnKbFD8o0g0mTSUmj2WFSAOC/vKgJ7vzQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eIak7vrGxh9qfXjr3C0RY7ZwzogqHbKbIpNY4GJUbcIkUMYYHf1HvO0X0FjpdLVtv
         RocE6DQyZBFfm/DDhi39zNHbGMrHecN9LU/5nyVArhaGQGgCdGLl5ydqGXIioTgFi/
         ivSKSJrOSqrlgxDQp3ZJjKipJe05BRaFJOznXwxM=
Date:   Tue, 30 Nov 2021 11:32:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Message-ID: <YaX9y1/eBkgON3NM@kroah.com>
References: <163758370314212@kroah.com>
 <20211129194737.827232-1-alexander.mikhalitsyn@virtuozzo.com>
 <439aa09f-96e7-1bc6-1a4e-da5390d2aa8e@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439aa09f-96e7-1bc6-1a4e-da5390d2aa8e@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 10:56:07AM +0100, Manfred Spraul wrote:
> Hi,
> 
> On 11/29/21 20:47, Alexander Mikhalitsyn wrote:
> > For 4.14.y:
> > 
> > Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")
> > 
> > Currently, the exit_shm() function not designed to work properly when
> > task->sysvshm.shm_clist holds shm objects from different IPC namespaces.
> > 
> > This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
> > leads to use-after-free (reproducer exists).
> > 
> > This is an attempt to fix the problem by extending exit_shm mechanism to
> > handle shm's destroy from several IPC ns'es.
> > 
> > To achieve that we do several things:
> > 
> > 1. add a namespace (non-refcounted) pointer to the struct shmid_kernel
> > 
> > 2. during new shm object creation (newseg()/shmget syscall) we
> >     initialize this pointer by current task IPC ns
> > 
> > 3. exit_shm() fully reworked such that it traverses over all shp's in
> >     task->sysvshm.shm_clist and gets IPC namespace not from current task
> >     as it was before but from shp's object itself, then call
> >     shm_destroy(shp, ns).
> > 
> > Note: We need to be really careful here, because as it was said before
> > (1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we
> > using special helper get_ipc_ns_not_zero() which allows to get IPC ns
> > refcounter only if IPC ns not in the "state of destruction".
> > 
> > Q/A
> > 
> > Q: Why can we access shp->ns memory using non-refcounted pointer?
> > A: Because shp object lifetime is always shorther than IPC namespace
> >     lifetime, so, if we get shp object from the task->sysvshm.shm_clist
> >     while holding task_lock(task) nobody can steal our namespace.
> > 
> > Q: Does this patch change semantics of unshare/setns/clone syscalls?
> > A: No. It's just fixes non-covered case when process may leave IPC
> >     namespace without getting task->sysvshm.shm_clist list cleaned up.
> > 
> > Link: https://lkml.kernel.org/r/67bb03e5-f79c-1815-e2bf-949c67047418@colorfullife.com
> > Link: https://lkml.kernel.org/r/20211109151501.4921-1-manfred@colorfullife.com
> > Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
> > Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
> > Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Davidlohr Bueso <dave@stgolabs.net>
> > Cc: Greg KH <gregkh@linuxfoundation.org>
> > Cc: Andrei Vagin <avagin@gmail.com>
> > Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> > Cc: Vasily Averin <vvs@virtuozzo.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >   include/linux/ipc_namespace.h |  15 +++
> >   include/linux/sched/task.h    |   2 +-
> >   include/linux/shm.h           |  13 ++-
> >   ipc/shm.c                     | 176 +++++++++++++++++++++++++---------
> >   4 files changed, 159 insertions(+), 47 deletions(-)
> 
> Tested ok: The crash is resolved, no observed degradations.

Now queued up, thanks.

greg k-h
