Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFEE5F9A60
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiJJHsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiJJHro (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:47:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA0A2635
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 00:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665387892; x=1696923892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+xYBzkJJbEswt3Udi7rw2jLreR3Vwbfut7+yRDH0aa4=;
  b=Gq59wpPGrMxHibtq5esatsTq1quQZEljkowOa4oOXo1WwcBPrd6PpwLd
   XCCtY2pX3iDbtUgl+FJeZpFQR8vrzifQnd2nGUzAykHr1FPoHlbg5hFlj
   3iuj5Bbx4SxM3rFd1502S4pn3ksCjrTC/NnSnC1OraNKhjuqWpO/4DxwS
   wv+CQULHbLV8Ot9HNQfd8WjbaivONaJRk0ljh3dKg/4m9OtNowF4pVty4
   UrF99ZrrKedNTLRHcdF0tnR2UWpR4+vWhrJYGPLDMPmRD1k/Y4Zfa++wQ
   +oMabebpiyDU1q7NTXM/v39JnjQ7/UGWJpHQmUKDrKofAzR/x65A/CAK2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="284545131"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="284545131"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 00:44:30 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="603628611"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="603628611"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.10.52]) ([10.213.10.52])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 00:44:23 -0700
Message-ID: <10268aa0-6d76-2635-79f8-f450f11e01d0@intel.com>
Date:   Mon, 10 Oct 2022 09:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.1
Subject: Re: [Intel-gfx] [PATCH RESEND] drm/i915: Fix display problems after
 resume
Content-Language: en-US
To:     =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>, intel-gfx@lists.freedesktop.org
Cc:     Kevin Boulain <kevinboulain@gmail.com>,
        David de Sousa <davidesousa@gmail.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Matthew Auld <matthew.auld@intel.com>
References: <20221005121159.340245-1-thomas.hellstrom@linux.intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20221005121159.340245-1-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.10.2022 14:11, Thomas Hellström wrote:
> Commit 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt
> binding / unbinding") introduced a regression that due to the vma resource
> tracking of the binding state, dpt ptes were not correctly repopulated.
> Fix this by clearing the vma resource state before repopulating.
> The state will subsequently be restored by the bind_vma operation.
> 
> Fixes: 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt binding / unbinding")
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220912121957.31310-1-thomas.hellstrom@linux.intel.com
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.18+
> Reported-and-tested-by: Kevin Boulain <kevinboulain@gmail.com>
> Tested-by: David de Sousa <davidesousa@gmail.com>
> ---
>   drivers/gpu/drm/i915/gt/intel_ggtt.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt.c b/drivers/gpu/drm/i915/gt/intel_ggtt.c
> index b31fe0fb013f..5c67e49aacf6 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
> @@ -1275,10 +1275,16 @@ bool i915_ggtt_resume_vm(struct i915_address_space *vm)
>   			atomic_read(&vma->flags) & I915_VMA_BIND_MASK;
>   
>   		GEM_BUG_ON(!was_bound);
> -		if (!retained_ptes)
> +		if (!retained_ptes) {
> +			/*
> +			 * Clear the bound flags of the vma resource to allow
> +			 * ptes to be repopulated.
> +			 */
> +			vma->resource->bound_flags = 0;

Personally I would put this at suspend path, if possible.
Anyway:
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej


>   			vma->ops->bind_vma(vm, NULL, vma->resource,
>   					   obj ? obj->cache_level : 0,
>   					   was_bound);
> +		}
>   		if (obj) { /* only used during resume => exclusive access */
>   			write_domain_objs |= fetch_and_zero(&obj->write_domain);
>   			obj->read_domains |= I915_GEM_DOMAIN_GTT;

