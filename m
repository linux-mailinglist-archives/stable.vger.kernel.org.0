Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092A16E0978
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjDMI4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDMIzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:55:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F6AA5E5
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 01:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681376086; x=1712912086;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tfAoIKfWayM4xmxfJpBuzkgkVCUcE32N1uH+iLjpzFk=;
  b=iUSU3l13E23Oum0gc8qc8XnZS6jCgI3CBZW7r/PYnwO9B/Ce1nURp6Ay
   p00ijzp68PLLzLNFNoVFCJoxuYPV/0qjBnJviTges42PZoIL8zzGCioL5
   WS7U224+ic+j/0vguFcRVAyT0UTw3Wlnyw5j4JyokMFgWejKCH3/KlzD2
   MnF1OyrhbGTf0dxy1uLfuiS3BEdX3R7zFpXDGPXE8Cd30dItv1imPCLRm
   hCJ399obf/n5lZuiPUc4MTzoNACWQ65jTxq7pNrMzoXWoHkFkHbVeq+Pl
   hCzN5YXmrTxJRGi6tGyiHg3nwoCrH4bV0VHLP/xauqinDAvubdgYMt8oN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="342874522"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="342874522"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 01:54:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="758617012"
X-IronPort-AV: E=Sophos;i="5.98,341,1673942400"; 
   d="scan'208";a="758617012"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 01:54:19 -0700
Date:   Thu, 13 Apr 2023 10:53:51 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: Re: [PATCH v5 2/5] drm/i915: Create the locked version of the
 request create
Message-ID: <ZDfDHwrNEsaiCQ7T@ashyti-mobl2.lan>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
 <20230412113308.812468-3-andi.shyti@linux.intel.com>
 <04f9e2ac-0967-1e26-fbfc-da7ff54c9a62@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04f9e2ac-0967-1e26-fbfc-da7ff54c9a62@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrzej,

> > Make version of the request creation that doesn't hold any
> > lock.
> > 
> > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
> > ---
> >   drivers/gpu/drm/i915/i915_request.c | 38 +++++++++++++++++++++--------
> >   drivers/gpu/drm/i915/i915_request.h |  2 ++
> >   2 files changed, 30 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > index 630a732aaecca..58662360ac34e 100644
> > --- a/drivers/gpu/drm/i915/i915_request.c
> > +++ b/drivers/gpu/drm/i915/i915_request.c
> > @@ -1028,15 +1028,11 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
> >   	return ERR_PTR(ret);
> >   }
> > -struct i915_request *
> > -i915_request_create(struct intel_context *ce)
> > +static struct i915_request *
> > +__i915_request_create_locked(struct intel_context *ce)
> >   {
> > +	struct intel_timeline *tl = ce->timeline;
> >   	struct i915_request *rq;
> > -	struct intel_timeline *tl;
> > -
> > -	tl = intel_context_timeline_lock(ce);
> > -	if (IS_ERR(tl))
> > -		return ERR_CAST(tl);
> >   	/* Move our oldest request to the slab-cache (if not in use!) */
> >   	rq = list_first_entry(&tl->requests, typeof(*rq), link);
> > @@ -1046,16 +1042,38 @@ i915_request_create(struct intel_context *ce)
> >   	intel_context_enter(ce);
> >   	rq = __i915_request_create(ce, GFP_KERNEL);
> >   	intel_context_exit(ce); /* active reference transferred to request */
> > +
> >   	if (IS_ERR(rq))
> > -		goto err_unlock;
> > +		return rq;
> >   	/* Check that we do not interrupt ourselves with a new request */
> >   	rq->cookie = lockdep_pin_lock(&tl->mutex);
> >   	return rq;
> > +}
> > +
> > +struct i915_request *
> > +i915_request_create_locked(struct intel_context *ce)
> > +{
> > +	intel_context_assert_timeline_is_locked(ce->timeline);
> > +
> > +	return __i915_request_create_locked(ce);
> > +}
> 
> I wonder if we really need to have such granularity? Leaving only
> i915_request_create_locked and removing __i915_request_create_locked would
> simplify little bit the code,
> I guess the cost of calling intel_context_assert_timeline_is_locked twice
> sometimes is not big, or maybe it can be re-arranged, up to you.

There is some usage of such granularity in patch 4. I am adding
here the throttle on the timeline. I am adding it in the
"_locked" version to avoid potential deadlocks coming from
selftests (and from realworld?).

Here I'd love to have some comments from Chris and Matt.

I might still add this in the commit message:

"i915_request_create_locked() is now empty but will be used in
later commits where a throttle on the ringspace will be executed
to ensure exclusive ownership of the timeline."

> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Thanks!

Andi
