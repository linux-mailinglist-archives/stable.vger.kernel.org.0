Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97CE6CCBEB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 23:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjC1VIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 17:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjC1VIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 17:08:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF63210C;
        Tue, 28 Mar 2023 14:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680037718; x=1711573718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6GLo3d35oVtHdFhb6UNpuguyDFJRdNOuxUvgwUhlmnY=;
  b=LglhwN39RVgEo5FLlQyQGAK7E30JKuG6QDcXLAacgGymVQqdiPyM9BsR
   PktPGUQtOjjF+E9K7+bhDXyds1N41adi2+hJ+URoTDczRt1nyf2HfXu9c
   VKXxaTb6EWB3IoGbaTMokBgLTqN2h3QtU2NZGHGsSWlQCc8ciB5r4OP8w
   ovFBAEz9OkSGFT24L602Kk3rloMh1zso3/DQcrU/Ce8AgNKUHgXLyZLWB
   DV9L2v1qD9FpjwpnrJNLFjoBkmNbM2S9P1JR3Mcfl5gX0DD7vHum0dfVl
   xnEZd8Qm1wxv/atGHEvT9cggufuivuepzgqofbUPRr4oC+NU1Hw5O+e4J
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="338193556"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="338193556"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:08:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="827628736"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="827628736"
Received: from fhannebi-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.50.224])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:08:36 -0700
Date:   Tue, 28 Mar 2023 23:08:11 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Min Li <lm0963hack@gmail.com>
Cc:     jani.nikula@linux.intel.com, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch, rodrigo.vivi@intel.com, airlied@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/1] drm/i915: fix race condition UAF in
 i915_perf_add_config_ioctl
Message-ID: <ZCNXO/NJecxaGwep@ashyti-mobl2.lan>
References: <20230328093627.5067-1-lm0963hack@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328093627.5067-1-lm0963hack@gmail.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 05:36:27PM +0800, Min Li wrote:
> Userspace can guess the id value and try to race oa_config object creation
> with config remove, resulting in a use-after-free if we dereference the
> object after unlocking the metrics_lock.  For that reason, unlocking the
> metrics_lock must be done after we are done dereferencing the object.
> 
> Signed-off-by: Min Li <lm0963hack@gmail.com>

I think we should also add

Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
Cc: <stable@vger.kernel.org> # v4.14+

Andi

> ---
>  drivers/gpu/drm/i915/i915_perf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 824a34ec0b83..93748ca2c5da 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4634,13 +4634,13 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
>  		err = oa_config->id;
>  		goto sysfs_err;
>  	}
> -
> -	mutex_unlock(&perf->metrics_lock);
> +	id = oa_config->id;
>  
>  	drm_dbg(&perf->i915->drm,
>  		"Added config %s id=%i\n", oa_config->uuid, oa_config->id);
> +	mutex_unlock(&perf->metrics_lock);
>  
> -	return oa_config->id;
> +	return id;
>  
>  sysfs_err:
>  	mutex_unlock(&perf->metrics_lock);
> -- 
> 2.25.1
