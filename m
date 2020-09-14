Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D511626920E
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINQsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 12:48:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:17647 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgINQsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 12:48:23 -0400
IronPort-SDR: TYx6cwZNcYc9WEbcWLhn7WYsXNGfHg03fCn3wfwSKXC5LcrBBqVKVyMowsZs3NOxS0GcAbGFq1
 aKqDFh6W06Bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158396039"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="158396039"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:45:15 -0700
IronPort-SDR: Q1puHls1IccRwMKDmUtPGqXO9BU+sBJUwBdtnEPqyHMVSgXoGdyM5FGTZMGcMwNb8Q5FNOFXqE
 aYjUIcI43dVw==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="306240559"
Received: from matancoh-mobl2.ger.corp.intel.com (HELO [10.255.198.45]) ([10.255.198.45])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:45:13 -0700
Subject: Re: [Intel-gfx] [PATCH 3/3] drm/i915/gem: Serialise debugfs
 i915_gem_objects with ctx->mutex
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Daniel Vetter <daniel.vetter@intel.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "Nikunj A. Dadhania" <nikunj.dadhania@linux.intel.com>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
 <20200723172119.17649-3-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <5e7f2c00-c72e-46ff-defe-404b5a847a02@linux.intel.com>
Date:   Mon, 14 Sep 2020 17:45:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723172119.17649-3-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/07/2020 18:21, Chris Wilson wrote:
> Since the debugfs may peek into the GEM contexts as the corresponding
> client/fd is being closed, we may try and follow a dangling pointer.
> However, the context closure itself is serialised with the ctx->mutex,
> so if we hold that mutex as we inspect the state coupled in the context,
> we know the pointers within the context are stable and will remain valid
> as we inspect their tables.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: CQ Tang <cq.tang@intel.com>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/i915_debugfs.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 784219962193..ea469168cd44 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -326,6 +326,7 @@ static void print_context_stats(struct seq_file *m,
>   		}
>   		i915_gem_context_unlock_engines(ctx);
>   
> +		mutex_lock(&ctx->mutex);
>   		if (!IS_ERR_OR_NULL(ctx->file_priv)) {
>   			struct file_stats stats = {
>   				.vm = rcu_access_pointer(ctx->vm),
> @@ -346,6 +347,7 @@ static void print_context_stats(struct seq_file *m,
>   
>   			print_file_stats(m, name, stats);
>   		}
> +		mutex_unlock(&ctx->mutex);
>   
>   		spin_lock(&i915->gem.contexts.lock);
>   		list_safe_reset_next(ctx, cn, link);
> 

Hm this apparently never got it's r-b and so got re-discovered in the 
field. +Nikunj

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
