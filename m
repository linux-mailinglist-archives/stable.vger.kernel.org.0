Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44566B7FCA
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 18:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjCMRxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCMRxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 13:53:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D21BDFA
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678730024; x=1710266024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8dJ21apbI0tMORrFDkphDRyhVjW51yImDrMyP7bKoHw=;
  b=Cz5/dqjLAQC4k47sjvCE5aUS2vSj/9XXM9XmitUytQ14lDdHztcPvHhK
   JNgdNGXqWkW72qIhQQZGMorH/bSrzJ9rfyA1+e56fAbqP0EfE6f1fngrG
   +6psXHatLec9aZZnR/P1iZ+xqtVsDiuX9kmwJSVZit0D8X46t524kZmOw
   3QIF2t4UtAC9Wb0Ki7xyHcCjUvFHpcxKHk8B5Et0ZZwritXFqPEtl7tNd
   +WzFVrfWv9g9Bgo0YrBQlyNMBw5YJRc253b9vzLYRcOczEEyz1T+JWwU8
   SdpRK/KapDIlngT4bDyYQC1xVd8fdT5EFkzC1ZjQTxoyV2rzjMS95Qyur
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="325582386"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="325582386"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 10:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="924595702"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="924595702"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.0.29]) ([10.213.0.29])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 10:53:15 -0700
Message-ID: <977d29de-ca0b-7398-803a-6aa5a87d898d@intel.com>
Date:   Mon, 13 Mar 2023 18:53:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915/active: Fix missing debug object
 activation
Content-Language: en-US
To:     Nirmoy Das <nirmoy.das@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas.hellstrom@intel.com>
References: <20230313103045.8906-1-nirmoy.das@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230313103045.8906-1-nirmoy.das@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.03.2023 11:30, Nirmoy Das wrote:
> debug_active_activate() expected ref->count to be zero
> which is not true anymore as __i915_active_activate() calls
> debug_active_activate() after incrementing the count.
> 
> v2: No need to check for "ref->count == 1" as __i915_active_activate()
> already make sure of that.
> 
> Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->active callback")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Thomas Hellström <thomas.hellstrom@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej
> ---
>   drivers/gpu/drm/i915/i915_active.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
> index a9fea115f2d2..8ef93889061a 100644
> --- a/drivers/gpu/drm/i915/i915_active.c
> +++ b/drivers/gpu/drm/i915/i915_active.c
> @@ -92,8 +92,7 @@ static void debug_active_init(struct i915_active *ref)
>   static void debug_active_activate(struct i915_active *ref)
>   {
>   	lockdep_assert_held(&ref->tree_lock);
> -	if (!atomic_read(&ref->count)) /* before the first inc */
> -		debug_object_activate(ref, &active_debug_desc);
> +	debug_object_activate(ref, &active_debug_desc);
>   }
>   
>   static void debug_active_deactivate(struct i915_active *ref)

