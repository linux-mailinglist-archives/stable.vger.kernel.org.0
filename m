Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1526DD2C9
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 08:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDKGaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 02:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjDKGaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 02:30:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB171BDD
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 23:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681194609; x=1712730609;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hJXyQc8Ux6zE5uWjzHqikCNDXfD9NvEam2DDgAfzuP4=;
  b=CYO8UQmJQ0bbp4S3wAwS+OuI+yO0U3HEyKpTCv5cRlXS7kJRH7DtTQGO
   xytEZkAozMkdk/QdTem4r/wEPFjOSLSQh1kFrqjBlBFBOH7IiFpyC7A46
   qZXoU8t1zRrx2o8wh1UOk7KLH5NUuaXqlDxsG2MbJsrqMd8SqnZHzAeBW
   xp5A0ikFPPq52Vb1XQYiKUXn+RDN/ErKajyXFaSgcrL6yJqp+Zu0ULV0o
   wriYW60WNXzaVj6LgPJfU/RLolVAGXTgHJ0qEDMVhtF9xeKnZa5owzg4x
   EQR+oKVFtCMs8KzzloEecH/FhM0mVVi/PSrLHR1WxiuvEKmAnNvBXucdN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="429826001"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="429826001"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 23:30:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="757701732"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="757701732"
Received: from nirmoyda-mobl.ger.corp.intel.com (HELO [10.252.55.106]) ([10.252.55.106])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 23:30:07 -0700
Message-ID: <7fc53d8f-a406-5bed-837c-f8023ed9dedb@linux.intel.com>
Date:   Tue, 11 Apr 2023 08:30:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v4 2/5] drm/i915/gt: Add intel_context_timeline_is_locked
 helper
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Andi Shyti <andi.shyti@kernel.org>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-3-andi.shyti@linux.intel.com>
From:   "Das, Nirmoy" <nirmoy.das@linux.intel.com>
In-Reply-To: <20230308094106.203686-3-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/8/2023 10:41 AM, Andi Shyti wrote:
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

Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>


> ---
>   drivers/gpu/drm/i915/gt/intel_context.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
> index f919a66cebf5b..87d5e2d60b6db 100644
> --- a/drivers/gpu/drm/i915/gt/intel_context.h
> +++ b/drivers/gpu/drm/i915/gt/intel_context.h
> @@ -265,6 +265,12 @@ static inline void intel_context_timeline_unlock(struct intel_timeline *tl)
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
