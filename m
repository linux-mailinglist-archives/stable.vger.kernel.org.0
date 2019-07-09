Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0353C63064
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 08:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfGIGYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 02:24:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:11628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfGIGYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 02:24:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 23:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,469,1557212400"; 
   d="scan'208";a="170503316"
Received: from dawalker-mobl.ger.corp.intel.com (HELO [10.251.80.131]) ([10.251.80.131])
  by orsmga006.jf.intel.com with ESMTP; 08 Jul 2019 23:24:47 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915/userptr: Acquire the page lock
 around set_page_dirty()
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20190708140327.26825-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <c3040a9e-a9de-904b-52ea-7d5ff4f3ae5c@linux.intel.com>
Date:   Tue, 9 Jul 2019 07:24:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190708140327.26825-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/07/2019 15:03, Chris Wilson wrote:
> set_page_dirty says:
> 
> 	For pages with a mapping this should be done under the page lock
> 	for the benefit of asynchronous memory errors who prefer a
> 	consistent dirty state. This rule can be broken in some special
> 	cases, but should be better not to.
> 
> 	If the mapping doesn't provide a set_page_dirty a_op, then
> 	just fall through and assume that it wants buffer_heads.
> 
> Under those rules, it only safe for us to use the plain set_page_dirty()
> calls for shmemfs/anonymous memory. Userptr may be used with real
> mappings and so needs to use the locked version (set_page_dirty_lock).
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
> Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> index 16ccec7fb7da..32d208ede343 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> @@ -665,7 +665,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>   
>   	for_each_sgt_page(page, sgt_iter, pages) {
>   		if (obj->mm.dirty)
> -			set_page_dirty(page);
> +			/*
> +			 * As this may not be anonymous memory (e.g. shmem)
> +			 * but exist on a real mapping, we have to lock
> +			 * the page in order to dirty it -- holding
> +			 * the page reference is not sufficient to
> +			 * prevent the inode from being truncated.
> +			 * Play safe and take the lock.
> +			 */
> +			set_page_dirty_lock(page);
>   
>   		mark_page_accessed(page);
>   		put_page(page);
> 

Not an expert but sounds plausible.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
