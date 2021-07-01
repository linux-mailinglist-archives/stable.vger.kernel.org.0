Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027523B8E08
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhGAHKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 03:10:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:25662 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234529AbhGAHKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 03:10:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="188867514"
X-IronPort-AV: E=Sophos;i="5.83,313,1616482800"; 
   d="scan'208";a="188867514"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 00:07:31 -0700
X-IronPort-AV: E=Sophos;i="5.83,313,1616482800"; 
   d="scan'208";a="447778411"
Received: from bjvanakk-mobl.ger.corp.intel.com (HELO [10.252.61.209]) ([10.252.61.209])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 00:07:29 -0700
Subject: Re: [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas.hellstrom@intel.com>
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
Date:   Thu, 1 Jul 2021 09:07:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 30-06-2021 om 18:44 schreef Ville Syrjala:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> The conversion to ww mutexes failed to address the fence code which
> already returns -EDEADLK when we run out of fences. Ww mutexes on
> the other hand treat -EDEADLK as an internal errno value indicating
> a need to restart the operation due to a deadlock. So now when the
> fence code returns -EDEADLK the higher level code erroneously
> restarts everything instead of returning the error to userspace
> as is expected.
>
> To remedy this let's switch the fence code to use a different errno
> value for this. -ENOBUFS seems like a semi-reasonable unique choice.
> Apart from igt the only user of this I could find is sna, and even
> there all we do is dump the current fence registers from debugfs
> into the X server log. So no user visible functionality is affected.
> If we really cared about preserving this we could of course convert
> back to -EDEADLK higher up, but doesn't seem like that's worth
> the hassle here.
>
> Not quite sure which commit specifically broke this, but I'll
> just attribute it to the general gem ww mutex work.
>
> Cc: stable@vger.kernel.org
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@intel.com>
> Testcase: igt/gem_pread/exhaustion
> Testcase: igt/gem_pwrite/basic-exhaustion
> Testcase: igt/gem_fenced_exec_thrash/too-many-fences
> Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww_ctx locking, v2.")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> index cac7f3f44642..f8948de72036 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> @@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i915_ggtt *ggtt)
>  	if (intel_has_pending_fb_unpin(ggtt->vm.i915))
>  		return ERR_PTR(-EAGAIN);
>  
> -	return ERR_PTR(-EDEADLK);
> +	return ERR_PTR(-ENOBUFS);
>  }
>  
>  int __i915_vma_pin_fence(struct i915_vma *vma)

Makes sense..

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

Is it a slightly more reent commit? Might probably be the part that converts execbuffer to use ww locks.

