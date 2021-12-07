Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F7A46B36C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhLGHNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:13:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:32529 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhLGHNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 02:13:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="236252251"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="236252251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 23:10:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="542705381"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2021 23:10:03 -0800
Received: from [10.252.51.133] (marialya-MOBL1.ccr.corp.intel.com [10.252.51.133])
        by linux.intel.com (Postfix) with ESMTP id 90EB4580B54;
        Mon,  6 Dec 2021 23:10:02 -0800 (PST)
Message-ID: <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
Date:   Tue, 7 Dec 2021 09:10:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
Content-Language: en-US
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     david1.zhou@amd.com, christian.koenig@amd.com,
        stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/12/2021 03:32, Bas Nieuwenhuizen wrote:
> See the comments in the code. Basically if the seqno is already
> signalled then we get a NULL fence. If we then put the NULL fence
> in a binary syncobj it counts as unsignalled, making that syncobj
> pretty much useless for all expected uses.
>
> Not 100% sure about the transfer to a timeline syncobj but I
> believe it is needed there too, as AFAICT the add_point function
> assumes the fence isn't NULL.
>
> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> ---
>   drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> index fdd2ec87cdd1..eb28a40400d2 100644
> --- a/drivers/gpu/drm/drm_syncobj.c
> +++ b/drivers/gpu/drm/drm_syncobj.c
> @@ -861,6 +861,19 @@ static int drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>   				     &fence);
>   	if (ret)
>   		goto err;
> +
> +	/* If the requested seqno is already signaled drm_syncobj_find_fence may
> +	 * return a NULL fence. To make sure the recipient gets signalled, use
> +	 * a new fence instead.
> +	 */
> +	if (!fence) {
> +		fence = dma_fence_allocate_private_stub();
> +		if (!fence) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +


Shouldn't we fix drm_syncobj_find_fence() instead?

By returning a stub fence for the timeline case if there isn't one.


Because the same NULL fence check appears missing in amdgpu (and 
probably other drivers).


Also we should have tests for this in IGT.

AMD contributed some tests when this code was written but they never got 
reviewed :(


-Lionel


>   	chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>   	if (!chain) {
>   		ret = -ENOMEM;
> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file *file_private,
>   				     args->src_point, args->flags, &fence);
>   	if (ret)
>   		goto err;
> +
> +	/* If the requested seqno is already signaled drm_syncobj_find_fence may
> +	 * return a NULL fence. To make sure the recipient gets signalled, use
> +	 * a new fence instead.
> +	 */
> +	if (!fence) {
> +		fence = dma_fence_allocate_private_stub();
> +		if (!fence) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +
>   	drm_syncobj_replace_fence(binary_syncobj, fence);
>   	dma_fence_put(fence);
>   err:


