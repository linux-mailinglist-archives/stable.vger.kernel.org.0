Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDCF1CC11C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgEIMCr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 9 May 2020 08:02:47 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57621 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726600AbgEIMCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 08:02:47 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21147788-1500050 
        for multiple; Sat, 09 May 2020 13:02:38 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200509115217.26853-1-chris@chris-wilson.co.uk>
References: <20200509115217.26853-1-chris@chris-wilson.co.uk>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>, stable@vger.kernel.org
To:     intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Watch out for idling during i915_gem_evict_something
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158902575439.20071.16532097686934470584@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Sat, 09 May 2020 13:02:34 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-05-09 12:52:17)
> i915_gem_evict_something() is charged with finding a slot within the GTT
> that we may reuse. Since our goal is not to stall, we first look for a
> slot that only overlaps idle vma. To this end, on the first pass we move
> any active vma to the end of the search list. However, we only stopped
> moving active vma after we see the first active vma twice. If during the
> search, that first active vma completed, we would not notice and keep on
> extending the search list.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1746

Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Fixes: b1e3177bd1d8 ("drm/i915: Coordinate i915_active with its own mutex")

> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
