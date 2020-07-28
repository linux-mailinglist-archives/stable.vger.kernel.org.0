Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E128230F33
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgG1Q1x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 28 Jul 2020 12:27:53 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:61112 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731118AbgG1Q1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 12:27:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21960187-1500050 
        for multiple; Tue, 28 Jul 2020 17:27:33 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAKMK7uFt5ViekqBPqdBbJWN4FhfxvF57K58VW8hAZGZwjRDz0w@mail.gmail.com>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk> <CAKMK7uFt5ViekqBPqdBbJWN4FhfxvF57K58VW8hAZGZwjRDz0w@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm: Restore driver.preclose() for all to use
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        CQ Tang <cq.tang@intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>
Date:   Tue, 28 Jul 2020 17:27:33 +0100
Message-ID: <159595365380.28639.1774414370144556112@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Daniel Vetter (2020-07-27 20:32:45)
> On Thu, Jul 23, 2020 at 7:21 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > An unfortunate sequence of events, but it turns out there is a valid
> > usecase for being able to free/decouple the driver objects before they
> > are freed by the DRM core. In particular, if we have a pointer into a
> > drm core object from inside a driver object, that pointer needs to be
> > nerfed *before* it is freed so that concurrent access (e.g. debugfs)
> > does not following the dangling pointer.
> >
> > The legacy marker was adding in the code movement from drp_fops.c to
> > drm_file.c
> 
> I might fumble a lot, but not this one:
> 
> commit 45c3d213a400c952ab7119f394c5293bb6877e6b
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Mon May 8 10:26:33 2017 +0200
> 
>     drm: Nerf the preclose callback for modern drivers

Gah, when I going through the history it looked like it appeared out of
nowhere.

> Also looking at the debugfs hook that has some rather adventurous
> stuff going on I think, feels a bit like a kitchensink with batteries
> included. If that's really all needed I'd say iterate the contexts by
> first going over files, then the ctx (which arent shared anyway) and
> the problem should also be gone.

Or we could cut out the middlelayer and put the release under the driver
control with a call to the drm_release() when the driver is ready.
-Chris
