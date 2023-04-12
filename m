Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665176DF4C7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDLMMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDLMMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:12:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D7AB4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 05:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681301561; x=1712837561;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YelRvsKvfkMkqEWwM4QldxTKUD8aZ0/aa0ca/gJmI5g=;
  b=aI7fovsZGv220l6YD0TbPy6ultHkazwbdJx31z1M+VskmYSplb1WaJKr
   +wgMqVXAj7ahd/nYE0Ol705jb/zR0S7UY4nEth91SzhpgeR64M1pTqp/b
   2Rbs9aZI7E6aIGutZrNEuT19CT8qjyYjsxyx60VWVHlg26XLCyh+EKXSO
   5ZPHs/ASzDZFFmnKKun3WB5zHROzrFVaE0Rv6C+XiAQQB+SDfahGtu4YY
   0eY/te6oFBJZstrF3QLymlDGJm8K/1ztlkZlfrV5FqMO+bQBU6x1yUyHy
   xrAF8gzP2F7X+1kYcm+gLj4UiWzQAyWxQ/QIekgggKzDtRhWe+GgOgVmm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346550814"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="346550814"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 05:12:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="688934295"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="688934295"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.31.124]) ([10.213.31.124])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 05:12:36 -0700
Message-ID: <fc171027-0bfc-db92-d2c9-dafb322a0041@intel.com>
Date:   Wed, 12 Apr 2023 14:12:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH v5 1/5] drm/i915/gt: Add intel_context_timeline_is_locked
 helper
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
 <20230412113308.812468-2-andi.shyti@linux.intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230412113308.812468-2-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12.04.2023 13:33, Andi Shyti wrote:
> We have:
>
>   - intel_context_timeline_lock()
>   - intel_context_timeline_unlock()
>
> In the next patches we will also need:
>
>   - intel_context_timeline_is_locked()
>
> Add it.
>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

> ---
>   drivers/gpu/drm/i915/gt/intel_context.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
> index 48f888c3da083..f2f79ff0dfd1d 100644
> --- a/drivers/gpu/drm/i915/gt/intel_context.h
> +++ b/drivers/gpu/drm/i915/gt/intel_context.h
> @@ -270,6 +270,12 @@ static inline void intel_context_timeline_unlock(struct intel_timeline *tl)
>   	mutex_unlock(&tl->mutex);
>   }
>   
> +static inline void intel_context_assert_timeline_is_locked(struct intel_timeline *tl)
> +	__must_hold(&tl->mutex)
> +{
> +	lockdep_assert_held(&tl->mutex);
> +}
> +
>   int intel_context_prepare_remote_request(struct intel_context *ce,
>   					 struct i915_request *rq);
>   

