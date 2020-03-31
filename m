Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4353F199968
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 17:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCaPQo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 31 Mar 2020 11:16:44 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:52868 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730589AbgCaPQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 11:16:44 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20753974-1500050 
        for multiple; Tue, 31 Mar 2020 16:16:38 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAM0jSHPOY4So442J1O0zW75cBwM4rCPm1CN0YVOMLMJhU=uhfw@mail.gmail.com>
References: <20200331124202.4497-1-chris@chris-wilson.co.uk> <CAM0jSHPOY4So442J1O0zW75cBwM4rCPm1CN0YVOMLMJhU=uhfw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Fill all the unused space in the GGTT
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
To:     Matthew Auld <matthew.william.auld@gmail.com>
Message-ID: <158566779807.5852.10085468544103922929@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 31 Mar 2020 16:16:38 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Matthew Auld (2020-03-31 16:07:21)
> On Tue, 31 Mar 2020 at 13:42, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > When we allocate space in the GGTT we may have to allocate a larger
> > region than will be populated by the object to accommodate fencing. Make
> > sure that this space beyond the end of the buffer points safely into
> > scratch space, in case the HW tries to access it anyway (e.g. fenced
> > access to the last tile row).
> >
> > Reported-by: Imre Deak <imre.deak@intel.com>
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/1554
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Matthew Auld <matthew.auld@intel.com>
> > Cc: Imre Deak <imre.deak@intel.com>
> > Cc: stable@vger.kernel.org
> 
> Do we not need similar treatment for gen6? It seems to also play
> tricks with the nop clear range, or did we disable gen7 ppgtt in the
> end?

Currently disabled. But yes, if we use nop_clear_range we will need
similar clearing. As this method turned out to be much easier than
expected, I guess we should just do it anyway.
-Chris
