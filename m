Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1227300075
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 11:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhAVKfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 05:35:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:24443 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbhAVK2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 05:28:08 -0500
IronPort-SDR: la40UqFJOR8HLXIZZiLDu6bQe4N8XLBPVSi4sf3L3w4+hyEpGf/OlUEl63wEpBZljk91Jpid7x
 1BiLDvLJzbuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="198181324"
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="198181324"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 02:27:25 -0800
IronPort-SDR: 6+8wOWlJjWzNUVVhTOUYuI38TGBXhAas0+Za4mtWanSQzB1g0m67iO7llQHlIS0kl0o2Mv+T4B
 aytBJxwYsLwQ==
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="385711041"
Received: from lcfenner-mobl1.ger.corp.intel.com (HELO [10.252.20.148]) ([10.252.20.148])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 02:27:23 -0800
Subject: Re: [PATCH] drm/i915: Always flush the active worker before returning
 from the wait
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>, stable@vger.kernel.org
References: <20210121232807.16618-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.auld@intel.com>
Message-ID: <5b188fea-2417-fa6a-7a8c-c2d240b359f7@intel.com>
Date:   Fri, 22 Jan 2021 10:27:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121232807.16618-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/01/2021 23:28, Chris Wilson wrote:
> The first thing the active retirement worker does is decrement the
> i915_active count.
> 
> The first thing we do during i915_active_wait is try to increment the
> i915_active count, but only if already active [non-zero].
> 
> The wait may see that the retirement is already started and so marked the
> i915_active as idle, and skip waiting for the retirement handler.
> However, the caller of i915_active_wait may immediately free the
> i915_active upon returning (e.g. i915_vma_destroy) so we must not return
> before the concurrent access from the worker are completed. We must
> always flush the worker.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2473
> Fixes: 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
