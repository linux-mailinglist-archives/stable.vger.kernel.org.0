Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB15B159B
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 22:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfILUvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 16:51:37 -0400
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:50294 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfILUvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 16:51:37 -0400
Subject: Re: [PATCH AUTOSEL 5.2 13/23] drm/i915/userptr: Acquire the page lock
 around set_page_dirty()
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Jani Nikula <jani.nikula@intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
References: <20190903162424.6877-1-sashal@kernel.org>
 <20190903162424.6877-13-sashal@kernel.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <36993214-6ce7-260f-68c7-6fbb0630143f@mageia.org>
Date:   Thu, 12 Sep 2019 23:51:33 +0300
MIME-Version: 1.0
In-Reply-To: <20190903162424.6877-13-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C020F.5D7AAFD8.0051,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 03-09-2019 kl. 19:24, skrev Sasha Levin:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> [ Upstream commit aa56a292ce623734ddd30f52d73f527d1f3529b5 ]
> 
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
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
> Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
> References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
> (cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/i915/i915_gem_userptr.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
> index 8079ea3af1039..b1fc15c7f5997 100644
> --- a/drivers/gpu/drm/i915/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
> @@ -678,7 +678,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
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


Please drop this one from all 5.2 and 4.19 stable queues

It has now been reverted in Linus tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=505a8ec7e11ae5236c4a154a1e24ef49a8349600

--
Thomas
