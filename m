Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EFD6D1A87
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 10:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjCaIjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 04:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjCaIjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 04:39:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D0AFF12
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 01:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680251820; x=1711787820;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=je0I5iROlVyoByNGogpREttITQp0mzNKe/6HkPr7EJg=;
  b=Bf3rWiHUK/wnWimf+vJDvSYLSTJXH1fCE4VzZ4koJpMVzM3+NX95bmTD
   TyylBg6qWPHCUh2kv2t264Gj5CNgec5AXfFGdUtFvRHDk4u1fXZk69MeG
   uykQJSLRnlhQmG2i6QRlw4Fivc2DQCGDotfULWooZRu/nEKQyxPaw2upx
   rOejc+R9lG+T5LcV94rcKmqL7saF9s2/S2DpGgqwMmps+/zvPp77ckS83
   bbfe6v0vzMsDZKyQD6lST8BIQYeyoizGOgWXkio1X2g0k6OIvOpu5+jAo
   VoptgfzJmD0sOkvQIaJDMp+s7ugip5Dp4xCEsX31AxTiInR1NHiuEKldZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="321051726"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="321051726"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 01:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="1014743077"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="1014743077"
Received: from bpower-mobl3.ger.corp.intel.com (HELO [10.213.225.27]) ([10.213.225.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 01:35:09 -0700
Message-ID: <ef0b3c48-799e-70fb-ecbc-4d62c75058a9@linux.intel.com>
Date:   Fri, 31 Mar 2023 09:35:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] drm/i915: Fix context runtime accounting
Content-Language: en-US
To:     Matthew Auld <matthew.william.auld@gmail.com>
Cc:     Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
References: <20230320151423.1708436-1-tvrtko.ursulin@linux.intel.com>
 <CAM0jSHMFF7VeRFMqRwfbvVtRdc6-6RXipe3nvLijrCtTNdKweQ@mail.gmail.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <CAM0jSHMFF7VeRFMqRwfbvVtRdc6-6RXipe3nvLijrCtTNdKweQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 31/03/2023 07:25, Matthew Auld wrote:
> On Mon, 20 Mar 2023 at 15:14, Tvrtko Ursulin
> <tvrtko.ursulin@linux.intel.com> wrote:
>>
>> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>
>> When considering whether to mark one context as stopped and another as
>> started we need to look at whether the previous and new _contexts_ are
>> different and not just requests. Otherwise the software tracked context
>> start time was incorrectly updated to the most recent lite-restore time-
>> stamp, which was in some cases resulting in active time going backward,
>> until the context switch (typically the hearbeat pulse) would synchronise
>> with the hardware tracked context runtime. Easiest use case to observe
>> this behaviour was with a full screen clients with close to 100% engine
>> load.
>>
>> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>> Fixes: bb6287cb1886 ("drm/i915: Track context current active time")
>> Cc: <stable@vger.kernel.org> # v5.19+
> 
> Seems reasonable to me, fwiw,
> Reviewed-by: Matthew Auld <matthew.auld@intel.com>

Thanks, pushed!

Regards,

Tvrtko
