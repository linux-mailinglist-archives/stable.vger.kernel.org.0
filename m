Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818482CECC9
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 12:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgLDLLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 06:11:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:25373 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgLDLLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 06:11:32 -0500
IronPort-SDR: eR8rgQ/81vwoQ0XA+KaTYAnczb4bwgku8Eut23F0KTfY8aMwll5KGXEWB4L3H+0V0G914FNTrj
 epHjmr2O8Jcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="191604814"
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="191604814"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 03:09:52 -0800
IronPort-SDR: ZjwEm6o/J2uWVg/DZtrEwPqVKTtcOgQfWir1+idpURExU4w3jKruUMNfYqn+MffliTzbJ/oFnv
 KR9K3cHQpSFw==
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="550912246"
Received: from sgefen-mobl1.ger.corp.intel.com (HELO [10.214.200.164]) ([10.214.200.164])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2020 03:09:50 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Propagate error from cancelled
 submit due to context closure
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20201203103432.31526-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <eefe8e52-3d6e-6c91-5733-e9f3474aff9e@linux.intel.com>
Date:   Fri, 4 Dec 2020 11:09:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203103432.31526-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/12/2020 10:34, Chris Wilson wrote:
> In the course of discovering and closing many races with context closure
> and execbuf submission, since commit 61231f6bd056 ("drm/i915/gem: Check
> that the context wasn't closed during setup") we started checking that
> the context was not closed by another userspace thread during the execbuf
> ioctl. In doing so we cancelled the inflight request (by telling it to be
> skipped), but kept reporting success since we do submit a request, albeit
> one that doesn't execute. As the error is known before we return from the
> ioctl, we can report the error we detect immediately, rather than leave
> it on the fence status. With the immediate propagation of the error, it
> is easier for userspace to handle.
> 
> Fixes: 61231f6bd056 ("drm/i915/gem: Check that the context wasn't closed during setup")
> Testcase: igt/gem_ctx_exec/basic-close-race
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v5.7+
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> index 1904e6e5ea64..b07dc1156a0e 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -3097,7 +3097,7 @@ static void retire_requests(struct intel_timeline *tl, struct i915_request *end)
>   			break;
>   }
>   
> -static void eb_request_add(struct i915_execbuffer *eb)
> +static int eb_request_add(struct i915_execbuffer *eb, int err)
>   {
>   	struct i915_request *rq = eb->request;
>   	struct intel_timeline * const tl = i915_request_timeline(rq);
> @@ -3118,6 +3118,7 @@ static void eb_request_add(struct i915_execbuffer *eb)
>   		/* Serialise with context_close via the add_to_timeline */
>   		i915_request_set_error_once(rq, -ENOENT);
>   		__i915_request_skip(rq);
> +		err = -ENOENT; /* override any transient errors */
>   	}
>   
>   	__i915_request_queue(rq, &attr);
> @@ -3127,6 +3128,8 @@ static void eb_request_add(struct i915_execbuffer *eb)
>   		retire_requests(tl, prev);
>   
>   	mutex_unlock(&tl->mutex);
> +
> +	return err;
>   }
>   
>   static const i915_user_extension_fn execbuf_extensions[] = {
> @@ -3332,7 +3335,7 @@ i915_gem_do_execbuffer(struct drm_device *dev,
>   	err = eb_submit(&eb, batch);
>   err_request:
>   	i915_request_get(eb.request);
> -	eb_request_add(&eb);
> +	err = eb_request_add(&eb, err);
>   
>   	if (eb.fences)
>   		signal_fence_array(&eb);
> 

Simple enough and it explains why gem_busy assert in the IGT can fail 
after execbuf succeeded - skipped request executes before the check 
since the payload was zapped. Fast timing but obviously possible.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
