Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEFD1A759C
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407062AbgDNIO7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 Apr 2020 04:14:59 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60245 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407053AbgDNIO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:14:57 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20891787-1500050 
        for multiple; Tue, 14 Apr 2020 09:13:30 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200407062622.6443-2-sultan@kerneltoast.com>
References: <20200407062622.6443-1-sultan@kerneltoast.com> <20200407062622.6443-2-sultan@kerneltoast.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>
Message-ID: <158685200854.16269.9481176231557533815@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 14 Apr 2020 09:13:28 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sultan Alsawaf (2020-04-07 07:26:22)
> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> The following deadlock exists in i915_active_wait() due to a double lock
> on ref->mutex (call chain listed in order from top to bottom):
>  i915_active_wait();
>  mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
>  i915_active_request_retire();
>  node_retire();
>  active_retire();
>  mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK
> 
> Fix the deadlock by skipping the second ref->mutex lock when
> active_retire() is called through i915_active_request_retire().
> 
> Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>

Incorrect. 

You missed that it cannot retire from inside the wait due to the active
reference held on the i915_active for the wait.

The only point it can enter retire from inside i915_active_wait() is via
the terminal __active_retire() which releases the mutex in doing so.
-Chris
