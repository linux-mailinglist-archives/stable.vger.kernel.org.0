Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42B6BD19
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 15:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfGQNfk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 17 Jul 2019 09:35:40 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50889 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726063AbfGQNfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 09:35:40 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17371553-1500050 
        for multiple; Wed, 17 Jul 2019 14:35:37 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <6038b21f-c052-36c5-2d56-72ddeb069097@linux.intel.com>
Cc:     stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
 <bb43c2b5-3513-ef4f-1bc9-887fc2b2e523@linux.intel.com>
 <156329142200.9436.8651620549785965913@skylake-alporthouse-com>
 <d76bdb93-b90b-afe3-841b-95a8de27902d@linux.intel.com>
 <156336944635.4375.7269371478914847980@skylake-alporthouse-com>
 <6038b21f-c052-36c5-2d56-72ddeb069097@linux.intel.com>
Message-ID: <156337053617.4375.13675276970408492219@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915/userptr: Beware recursive lock_page()
Date:   Wed, 17 Jul 2019 14:35:36 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2019-07-17 14:23:55)
> 
> On 17/07/2019 14:17, Chris Wilson wrote:
> > Quoting Tvrtko Ursulin (2019-07-17 14:09:00)
> >>
> >> On 16/07/2019 16:37, Chris Wilson wrote:
> >>> Quoting Tvrtko Ursulin (2019-07-16 16:25:22)
> >>>>
> >>>> On 16/07/2019 13:49, Chris Wilson wrote:
> >>>>> Following a try_to_unmap() we may want to remove the userptr and so call
> >>>>> put_pages(). However, try_to_unmap() acquires the page lock and so we
> >>>>> must avoid recursively locking the pages ourselves -- which means that
> >>>>> we cannot safely acquire the lock around set_page_dirty(). Since we
> >>>>> can't be sure of the lock, we have to risk skip dirtying the page, or
> >>>>> else risk calling set_page_dirty() without a lock and so risk fs
> >>>>> corruption.
> >>>>
> >>>> So if trylock randomly fail we get data corruption in whatever data set
> >>>> application is working on, which is what the original patch was trying
> >>>> to avoid? Are we able to detect the backing store type so at least we
> >>>> don't risk skipping set_page_dirty with anonymous/shmemfs?
> >>>
> >>> page->mapping???
> >>
> >> Would page->mapping work? What is it telling us?
> > 
> > It basically tells us if there is a fs around; anything that is the most
> > basic of malloc (even tmpfs/shmemfs has page->mapping).
> 
> Normal malloc so anonymous pages? Or you meant everything _apart_ from 
> the most basic malloc?

Aye missed the not.

> >>> We still have the issue that if there is a mapping we should be taking
> >>> the lock, and we may have both a mapping and be inside try_to_unmap().
> >>
> >> Is this a problem? On a path with mappings we trylock and so solve the
> >> set_dirty_locked and recursive deadlock issues, and with no mappings
> >> with always dirty the page and avoid data corruption.
> > 
> > The problem as I see it is !page->mapping are likely an insignificant
> > minority of userptr; as I think even memfd are essentially shmemfs (or
> > hugetlbfs) and so have mappings.
> 
> Better then nothing, no? If easy to do..

Actually, I erring on the opposite side. Peeking at mm/ internals does
not bode confidence and feels indefensible. I'd much rather throw my
hands up and say "this is the best we can do with the API provided,
please tell us what we should have done." To which the answer is
probably to not have used gup in the first place :|
-Chris
