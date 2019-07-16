Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C086ABAA
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 17:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbfGPPZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 11:25:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:1675 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfGPPZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 11:25:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 08:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="158167369"
Received: from esulliva-mobl.ger.corp.intel.com (HELO [10.251.94.109]) ([10.251.94.109])
  by orsmga007.jf.intel.com with ESMTP; 16 Jul 2019 08:25:22 -0700
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915/userptr: Beware recursive
 lock_page()
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20190716124931.5870-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <bb43c2b5-3513-ef4f-1bc9-887fc2b2e523@linux.intel.com>
Date:   Tue, 16 Jul 2019 16:25:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190716124931.5870-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/07/2019 13:49, Chris Wilson wrote:
> Following a try_to_unmap() we may want to remove the userptr and so call
> put_pages(). However, try_to_unmap() acquires the page lock and so we
> must avoid recursively locking the pages ourselves -- which means that
> we cannot safely acquire the lock around set_page_dirty(). Since we
> can't be sure of the lock, we have to risk skip dirtying the page, or
> else risk calling set_page_dirty() without a lock and so risk fs
> corruption.

So if trylock randomly fail we get data corruption in whatever data set 
application is working on, which is what the original patch was trying 
to avoid? Are we able to detect the backing store type so at least we 
don't risk skipping set_page_dirty with anonymous/shmemfs?

Regards,

Tvrtko

> Reported-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Fixes: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> index b9d2bb15e4a6..1ad2047a6dbd 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> @@ -672,7 +672,7 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>   		obj->mm.dirty = false;
>   
>   	for_each_sgt_page(page, sgt_iter, pages) {
> -		if (obj->mm.dirty)
> +		if (obj->mm.dirty && trylock_page(page)) {
>   			/*
>   			 * As this may not be anonymous memory (e.g. shmem)
>   			 * but exist on a real mapping, we have to lock
> @@ -680,8 +680,20 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>   			 * the page reference is not sufficient to
>   			 * prevent the inode from being truncated.
>   			 * Play safe and take the lock.
> +			 *
> +			 * However...!
> +			 *
> +			 * The mmu-notifier can be invalidated for a
> +			 * migrate_page, that is alreadying holding the lock
> +			 * on the page. Such a try_to_unmap() will result
> +			 * in us calling put_pages() and so recursively try
> +			 * to lock the page. We avoid that deadlock with
> +			 * a trylock_page() and in exchange we risk missing
> +			 * some page dirtying.
>   			 */
> -			set_page_dirty_lock(page);
> +			set_page_dirty(page);
> +			unlock_page(page);
> +		}
>   
>   		mark_page_accessed(page);
>   		put_page(page);
> 
