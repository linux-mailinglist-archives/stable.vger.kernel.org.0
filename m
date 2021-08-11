Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944E73E921B
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 15:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhHKNDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 09:03:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:4753 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhHKNDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 09:03:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="276152296"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="276152296"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 06:03:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="676090153"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2021 06:03:08 -0700
Received: from [10.209.20.238] (kliang2-MOBL.ccr.corp.intel.com [10.209.20.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 36CAB580815;
        Wed, 11 Aug 2021 06:03:07 -0700 (PDT)
Subject: Re: [RESEND PATCH] perf/x86/intel/uncore: Fix invalid unit check
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, eranian@google.com,
        namhyung@kernel.org, ak@linux.intel.com, stable@vger.kernel.org
References: <1626699297-32793-1-git-send-email-kan.liang@linux.intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <09cacddf-2b85-edfa-3788-8b315514b99a@linux.intel.com>
Date:   Wed, 11 Aug 2021 09:03:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1626699297-32793-1-git-send-email-kan.liang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

Could you please pick up the fix?
Please let me know if you have any comments/concerns.

Thanks,
Kan

On 7/19/2021 8:54 AM, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The uncore unit with the type ID 0 and the unit ID 0 is missed.
> 
> The table3 of the uncore unit maybe 0. The
> uncore_discovery_invalid_unit() mistakenly treated it as an invalid
> value.
> 
> Remove the !unit.table3 check.
> 
> Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
> 
> The patch was posted as a part of the "perf: Add Sapphire Rapids server
> uncore support" patch set. But it doesn't depend on the other patches in
> the patch set. The bugfix can be accepted and merged separately.
> 
> https://lore.kernel.org/lkml/cb0d2d43-102a-994c-f777-e11d61c77bf5@linux.intel.com/
> 
>   arch/x86/events/intel/uncore_discovery.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/uncore_discovery.h b/arch/x86/events/intel/uncore_discovery.h
> index 1d65293..abfb1e8 100644
> --- a/arch/x86/events/intel/uncore_discovery.h
> +++ b/arch/x86/events/intel/uncore_discovery.h
> @@ -30,7 +30,7 @@
>   
>   
>   #define uncore_discovery_invalid_unit(unit)			\
> -	(!unit.table1 || !unit.ctl || !unit.table3 ||	\
> +	(!unit.table1 || !unit.ctl || \
>   	 unit.table1 == -1ULL || unit.ctl == -1ULL ||	\
>   	 unit.table3 == -1ULL)
>   
> 
