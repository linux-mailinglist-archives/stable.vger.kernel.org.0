Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29CC1FDF
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 13:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfI3LRt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Sep 2019 07:17:49 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:52709 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729415AbfI3LRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 07:17:48 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 18665724-1500050 
        for multiple; Mon, 30 Sep 2019 12:17:46 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <51720124-9c90-04c4-2bff-4e067fba7ebb@linux.intel.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
References: <20190927163400.22767-1-chris@chris-wilson.co.uk>
 <20190928082546.3473-1-chris@chris-wilson.co.uk>
 <51720124-9c90-04c4-2bff-4e067fba7ebb@linux.intel.com>
Message-ID: <156984225982.1880.15060055639771073589@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915/userptr: Never allow userptr into the
 mappable GGTT
Date:   Mon, 30 Sep 2019 12:17:39 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2019-09-30 11:33:22)
> 
> On 28/09/2019 09:25, Chris Wilson wrote:
> > Daniel Vetter uncovered a nasty cycle in using the mmu-notifiers to
> > invalidate userptr objects which also happen to be pulled into GGTT
> > mmaps. That is when we unbind the userptr object (on mmu invalidation),
> > we revoke all CPU mmaps, which may then recurse into mmu invalidation.
> 
> On the same object? Invalidate on userptr built from some mmap_gtt area, 
> or standard userptr object mmapped via gtt? Or one userptr object built 
> from a mmap_gtt of another userptr object?

Yup, think of the multiple partial mmaps we have on the same object. If
we invalidate the mmap_offset, we may hit the same object again in
mmu-invalidate. As far as my understanding goes, there is nothing in
the munmap/invalidate that prevents this. Although, having the same
pages mapped into different process is not unusual, so you would think
we are not alone in having device pages in multiple mappings? There
might be something more at play here, but Daniel's lockdep patch is
straightforward: no recursion allowed in mmu-invalidate.

> Will anything change here after the struct mutex removal series? AFAIR 
> you remove struct mutex from userptr invalidation there.

No. This, aiui, is purely an issue where we trigger an mmu-invalidate
from inside the mmu_invalidate_range_start.
 
[snip]

> I remember in the distant past we discussed whether or not to allow 
> this. It is indeed a quite perverse setup so I am okay with disallowing it.
> 
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> Regards,
> 
> Tvrtko
> 
> P.S. I expect there will be some IGTs to be adjusted as well.

Yup. This was to start the ball rolling as come rc1 we will have some
fire-fighting to do.
-Chris
