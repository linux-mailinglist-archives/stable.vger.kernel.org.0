Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEA22C4B8
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 14:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXMGb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 Jul 2020 08:06:31 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:61333 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726258AbgGXMG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 08:06:29 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21918512-1500050 
        for multiple; Fri, 24 Jul 2020 13:06:16 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87tuxx1610.fsf@gaia.fi.intel.com>
References: <20200723183348.4037-1-chris@chris-wilson.co.uk> <159552931718.21069.13813749151778428706@build.alporthouse.com> <87tuxx1610.fsf@gaia.fi.intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Delay tracking the GEM context until it is registered
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Fri, 24 Jul 2020 13:06:15 +0100
Message-ID: <159559237550.21069.11909922893997723896@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-07-24 12:55:39)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > Quoting Chris Wilson (2020-07-23 19:33:48)
> >> Avoid exposing a partially constructed context by deferring the
> >> list_add() from the initial construction to the end of registration.
> >> Otherwise, if we peek into the list of contexts from inside debugfs, we
> >> may see the partially constructed context and change down some dangling
> >
> > s/change/chase/
> 
> that.
> 
> Are you sure about the fixes as it is not the commit that
> actually introduces the registration into context.list?
> 
> For me it looks like it is a4e7ccdac38e.

The one I picked was where we started adding more context setup after
the final step of list_add in __create_context(). More apropos would be
3aa9945a528e ("drm/i915: Separate GEM context construction and registration to userspace")
in the same kernel.

In the other direction, we have
f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
where we start using the contexts.list in debugfs.

In a4e7ccdac38e we are only moving the list_add(&ctx->link) around in
__create_context().
-Chris
