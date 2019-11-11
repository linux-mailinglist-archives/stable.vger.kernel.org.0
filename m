Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD48F7616
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKKOMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:12:39 -0500
Received: from mga07.intel.com ([134.134.136.100]:60176 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfKKOMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:12:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 06:12:37 -0800
X-IronPort-AV: E=Sophos;i="5.68,293,1569308400"; 
   d="scan'208";a="197679382"
Received: from mpotanix-mobl2.ccr.corp.intel.com (HELO [10.252.20.183]) ([10.252.20.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 11 Nov 2019 06:12:35 -0800
Subject: Re: [FIXES 1/3] drm/i915/userptr: Try to acquire the page lock around
 set_page_dirty()
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     joonas.lahtinen@linux.intel.com,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
References: <20191111133205.11590-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <bff35e14-331b-1912-afe4-2989fd22695e@linux.intel.com>
Date:   Mon, 11 Nov 2019 14:12:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111133205.11590-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/11/2019 13:32, Chris Wilson wrote:
> set_page_dirty says:
> 
> 	For pages with a mapping this should be done under the page lock
> 	for the benefit of asynchronous memory errors who prefer a
> 	consistent dirty state. This rule can be broken in some special
> 	cases, but should be better not to.
> 
> Under those rules, it is only safe for us to use the plain set_page_dirty
> calls for shmemfs/anonymous memory. Userptr may be used with real
> mappings and so needs to use the locked version (set_page_dirty_lock).
> 
> However, following a try_to_unmap() we may want to remove the userptr and
> so call put_pages(). However, try_to_unmap() acquires the page lock and
> so we must avoid recursively locking the pages ourselves -- which means
> that we cannot safely acquire the lock around set_page_dirty(). Since we
> can't be sure of the lock, we have to risk skip dirtying the page, or
> else risk calling set_page_dirty() without a lock and so risk fs
> corruption.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112012
> Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video m
> References: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
> References: 505a8ec7e11a ("Revert "drm/i915/userptr: Acquire the page lock around set_page_dirty()"")
> References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 22 ++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> index ee65c6acf0e2..dd104b0e2071 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> @@ -646,8 +646,28 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>   		obj->mm.dirty = false;
>   
>   	for_each_sgt_page(page, sgt_iter, pages) {
> -		if (obj->mm.dirty)
> +		if (obj->mm.dirty && trylock_page(page)) {
> +			/*
> +			 * As this may not be anonymous memory (e.g. shmem)
> +			 * but exist on a real mapping, we have to lock
> +			 * the page in order to dirty it -- holding
> +			 * the page reference is not sufficient to
> +			 * prevent the inode from being truncated.
> +			 * Play safe and take the lock.
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
> +			 */
>   			set_page_dirty(page);
> +			unlock_page(page);
> +		}
>   
>   		mark_page_accessed(page);
>   		put_page(page);
> 

It looks that the bug report could be about BUG_ON(PageWriteback(page)) 
in ext4/mpage_prepare_extent_to_map which would be somewhat consistent 
with not being allowed to call set_page_dirty on an unlocked page. So on 
the basis of that:

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
