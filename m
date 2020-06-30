Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C8520FA99
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbgF3RaK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 30 Jun 2020 13:30:10 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:55512 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgF3RaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:30:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21666423-1500050 
        for multiple; Tue, 30 Jun 2020 18:29:55 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87imf84jh0.fsf@gaia.fi.intel.com>
References: <20200630152724.3734-1-chris@chris-wilson.co.uk> <87imf84jh0.fsf@gaia.fi.intel.com>
Subject: Re: [PATCH] drm/i915: Skip stale object handle for debugfs per-file-stats
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Tue, 30 Jun 2020 18:29:55 +0100
Message-ID: <159353819588.22902.3876380735847727824@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-06-30 17:16:43)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > As we close a handle GEM object, we update the drm_file's idr with an
> > error pointer to indicate the in-progress closure, and finally set it to
> 
> The error pointer part stage seems to be missing.

Yeah, the ERR_PTR stage seems to be my faulty memory, we just set it to
NULL to indicate in-progress. Ok, I'm not going totally mad:

commit f6cd7daecff558fab2c45d15283d3e52f688342d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Apr 15 12:55:08 2016 +0100

    drm: Release driver references to handle before making it available again

    ...

    v2: Use NULL rather than an ERR_PTR to avoid having to adjust callers.
    idr_alloc() tracks existing handles using an internal bitmap, so we are
    free to use the NULL object as our stale identifier.
-Chris
