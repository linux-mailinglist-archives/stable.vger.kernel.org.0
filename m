Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E317F6ABF6
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbfGPPhI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 16 Jul 2019 11:37:08 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:51346 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387966AbfGPPhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 11:37:08 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17346045-1500050 
        for multiple; Tue, 16 Jul 2019 16:37:04 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <bb43c2b5-3513-ef4f-1bc9-887fc2b2e523@linux.intel.com>
Cc:     stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
 <bb43c2b5-3513-ef4f-1bc9-887fc2b2e523@linux.intel.com>
Message-ID: <156329142200.9436.8651620549785965913@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915/userptr: Beware recursive lock_page()
Date:   Tue, 16 Jul 2019 16:37:02 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2019-07-16 16:25:22)
> 
> On 16/07/2019 13:49, Chris Wilson wrote:
> > Following a try_to_unmap() we may want to remove the userptr and so call
> > put_pages(). However, try_to_unmap() acquires the page lock and so we
> > must avoid recursively locking the pages ourselves -- which means that
> > we cannot safely acquire the lock around set_page_dirty(). Since we
> > can't be sure of the lock, we have to risk skip dirtying the page, or
> > else risk calling set_page_dirty() without a lock and so risk fs
> > corruption.
> 
> So if trylock randomly fail we get data corruption in whatever data set 
> application is working on, which is what the original patch was trying 
> to avoid? Are we able to detect the backing store type so at least we 
> don't risk skipping set_page_dirty with anonymous/shmemfs?

page->mapping???

We still have the issue that if there is a mapping we should be taking
the lock, and we may have both a mapping and be inside try_to_unmap().

I think it's lose-lose. The only way to win is not to userptr :)
-Chris
