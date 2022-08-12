Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61094590C8B
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbiHLH3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLH3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:29:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99119A5C71
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660289354; x=1691825354;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FhydQKfgAGhccxPnKjn4WIuYwJ8wNgp0VsrgavjJMZc=;
  b=b0uFGRfAVNfJRODwIIjJrCGQ/RjiDVchBmFaGsOt8N4BY2dKTRTn43Ep
   BsxdgugfSHW9usx3reIFI6PsiIhJ8+PAvkuaTIWygg0ZDcUwT6Kdfb0CM
   mONKcJRt0qwx7Q2Mj0C+lk8paUgEcaaZAnvQipJlSRarSg9A+lO8etMJ3
   zZv6nVaCnRIDu6jDGieKwaHU8OGHJdedpzTW1Jsbqt/cRJvY7gE03n2BI
   RUyJB++Zp+t+Uk3xMg86lZzLGdM39jTWF7oQ05CyhM21OEUe7fRLH4GF0
   u6IIZMcbtr3kr7L2mSkFTT/J15DagldoUA/rUcCfsCsOyb3l8tT1W/aV4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="355546896"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="355546896"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 00:29:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="605831179"
Received: from jsalvagx-mobl2.amr.corp.intel.com (HELO [10.212.98.52]) ([10.212.98.52])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 00:29:13 -0700
Message-ID: <bd3abbb2-f3e8-b143-a19d-2cbf9463f7b3@linux.intel.com>
Date:   Fri, 12 Aug 2022 08:29:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915/guc: clear stalled request after a
 reset
Content-Language: en-US
To:     Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20220811210812.3239621-1-daniele.ceraolospurio@intel.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <20220811210812.3239621-1-daniele.ceraolospurio@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/08/2022 22:08, Daniele Ceraolo Spurio wrote:
> If the GuC CTs are full and we need to stall the request submission
> while waiting for space, we save the stalled request and where the stall
> occurred; when the CTs have space again we pick up the request submission
> from where we left off.

How serious is it? Statement always was CT buffers can never get full 
outside the pathological IGT test cases. So I am wondering if this is in 
the category of fix for correctness or actually the CT buffers can get 
full in normal use so it is imperative to fix.

Regards,

Tvrtko

> If a full GT reset occurs, the state of all contexts is cleared and all
> non-guilty requests are unsubmitted, therefore we need to restart the
> stalled request submission from scratch. To make sure that we do so,
> clear the saved request after a reset.
> 
> Fixes note: the patch that introduced the bug is in 5.15, but no
> officially supported platform had GuC submission enabled by default
> in that kernel, so the backport to that particular version (and only
> that one) can potentially be skipped.
> 
> Fixes: 925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
> Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Harrison <john.c.harrison@intel.com>
> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>   drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
> index 0d17da77e787..0d56b615bf78 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
> @@ -4002,6 +4002,13 @@ static inline void guc_init_lrc_mapping(struct intel_guc *guc)
>   	/* make sure all descriptors are clean... */
>   	xa_destroy(&guc->context_lookup);
>   
> +	/*
> +	 * A reset might have occurred while we had a pending stalled request,
> +	 * so make sure we clean that up.
> +	 */
> +	guc->stalled_request = NULL;
> +	guc->submission_stall_reason = STALL_NONE;
> +
>   	/*
>   	 * Some contexts might have been pinned before we enabled GuC
>   	 * submission, so we need to add them to the GuC bookeeping.
