Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49651403213
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhIHBNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:13:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:65467 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230162AbhIHBNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 21:13:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10100"; a="284060215"
X-IronPort-AV: E=Sophos;i="5.85,276,1624345200"; 
   d="scan'208";a="284060215"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 18:11:59 -0700
X-IronPort-AV: E=Sophos;i="5.85,276,1624345200"; 
   d="scan'208";a="547298868"
Received: from nvishwa1-desk.sc.intel.com (HELO nvishwa1-DESK) ([172.25.29.76])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 18:11:58 -0700
Date:   Tue, 7 Sep 2021 18:12:24 -0700
From:   Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Thomas =?iso-8859-1?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 08/19] drm/i915: Fix runtime pm handling in
 i915_gem_shrink
Message-ID: <20210908011224.GN11424@nvishwa1-DESK>
References: <20210830121006.2978297-1-maarten.lankhorst@linux.intel.com>
 <20210830121006.2978297-9-maarten.lankhorst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830121006.2978297-9-maarten.lankhorst@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 02:09:55PM +0200, Maarten Lankhorst wrote:
>We forgot to call intel_runtime_pm_put on error, fix it!
>

Looks good to me.
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

>Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
>Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>Cc: <stable@vger.kernel.org> # v5.13+
>---
> drivers/gpu/drm/i915/gem/i915_gem_shrinker.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
>index e382b7f2353b..5ab136ffdeb2 100644
>--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
>+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
>@@ -118,7 +118,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
> 	intel_wakeref_t wakeref = 0;
> 	unsigned long count = 0;
> 	unsigned long scanned = 0;
>-	int err;
>+	int err = 0;
>
> 	/* CHV + VTD workaround use stop_machine(); need to trylock vm->mutex */
> 	bool trylock_vm = !ww && intel_vm_no_concurrent_access_wa(i915);
>@@ -242,12 +242,15 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
> 		list_splice_tail(&still_in_list, phase->list);
> 		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
> 		if (err)
>-			return err;
>+			break;
> 	}
>
> 	if (shrink & I915_SHRINK_BOUND)
> 		intel_runtime_pm_put(&i915->runtime_pm, wakeref);
>
>+	if (err)
>+		return err;
>+
> 	if (nr_scanned)
> 		*nr_scanned += scanned;
> 	return count;
>-- 
>2.32.0
>
