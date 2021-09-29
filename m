Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF2441C109
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244875AbhI2IzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:55:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:22073 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244920AbhI2IzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 04:55:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="247416974"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="247416974"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:53:27 -0700
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="554617859"
Received: from pathanas-mobl1.ger.corp.intel.com (HELO [10.252.38.52]) ([10.252.38.52])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:53:26 -0700
Subject: Re: [Intel-gfx] [PATCH 08/19] drm/i915: Fix runtime pm handling in
 i915_gem_shrink
To:     Matthew Auld <matthew.william.auld@gmail.com>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
References: <20210830121006.2978297-1-maarten.lankhorst@linux.intel.com>
 <20210830121006.2978297-9-maarten.lankhorst@linux.intel.com>
 <CAM0jSHP7GtkRoDV+avUKyOe6SOce0ZO_2Tzg9p8O7KR9nWk_VQ@mail.gmail.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <aec64c55-f44b-8dbb-eb28-de4c732410ae@linux.intel.com>
Date:   Wed, 29 Sep 2021 10:53:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAM0jSHP7GtkRoDV+avUKyOe6SOce0ZO_2Tzg9p8O7KR9nWk_VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 29-09-2021 om 10:37 schreef Matthew Auld:
> On Mon, 30 Aug 2021 at 13:10, Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com> wrote:
>> We forgot to call intel_runtime_pm_put on error, fix it!
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
>> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: <stable@vger.kernel.org> # v5.13+
> How does the err handling work? gem_shrink is meant to return the
> number of pages reclaimed which is an unsigned long, and yet we are
> also just returning the err here? Fortunately it looks like nothing is
> calling gem_shrinker with an actual ww context, so nothing will hit
> this yet? I think the interface needs to be reworked or something.

We should probably make it signed in the future when used.
It should never hit the LONG_MAX limit, since max value returned would be ULONG_MAX >> PAGE_SHIFT,
assuming the entire address space is filled with evictable buffers.

I've kept the ww lock, in case we want to evict in the future. Without ww context the buffers
are trylocked, with ww we can evict the entire address space as much as possible.
In most cases we only want to evict idle objects, in that case no ww is needed.

Pushed just this patch, thanks for feedback. :)

~Maarten

