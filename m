Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1CF1024
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 08:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfKFHWc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 6 Nov 2019 02:22:32 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:62944 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726772AbfKFHWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 02:22:31 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19097373-1500050 
        for multiple; Wed, 06 Nov 2019 07:22:26 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190716124931.5870-1-chris@chris-wilson.co.uk>
Cc:     tvrtko.ursulin@intel.com,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
Message-ID: <157302494441.18566.9645099809866368384@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH 1/5] drm/i915/userptr: Beware recursive lock_page()
Date:   Wed, 06 Nov 2019 07:22:24 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2019-07-16 13:49:27)
> Following a try_to_unmap() we may want to remove the userptr and so call
> put_pages(). However, try_to_unmap() acquires the page lock and so we
> must avoid recursively locking the pages ourselves -- which means that
> we cannot safely acquire the lock around set_page_dirty(). Since we
> can't be sure of the lock, we have to risk skip dirtying the page, or
> else risk calling set_page_dirty() without a lock and so risk fs
> corruption.
> 
> Reported-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Fixes: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> index b9d2bb15e4a6..1ad2047a6dbd 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> @@ -672,7 +672,7 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>                 obj->mm.dirty = false;
>  
>         for_each_sgt_page(page, sgt_iter, pages) {
> -               if (obj->mm.dirty)
> +               if (obj->mm.dirty && trylock_page(page)) {
>                         /*
>                          * As this may not be anonymous memory (e.g. shmem)
>                          * but exist on a real mapping, we have to lock
> @@ -680,8 +680,20 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>                          * the page reference is not sufficient to
>                          * prevent the inode from being truncated.
>                          * Play safe and take the lock.
> +                        *
> +                        * However...!
> +                        *
> +                        * The mmu-notifier can be invalidated for a
> +                        * migrate_page, that is alreadying holding the lock
> +                        * on the page. Such a try_to_unmap() will result
> +                        * in us calling put_pages() and so recursively try
> +                        * to lock the page. We avoid that deadlock with
> +                        * a trylock_page() and in exchange we risk missing
> +                        * some page dirtying.
>                          */
> -                       set_page_dirty_lock(page);
> +                       set_page_dirty(page);
> +                       unlock_page(page);
> +               }

It really seems like we have no choice but to only call set_page_dirty()
while under the page lock, and the only way we can guarantee that
without recursion is with a trylock...

https://bugs.freedesktop.org/show_bug.cgi?id=112012
-Chris
