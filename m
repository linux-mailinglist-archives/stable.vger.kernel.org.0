Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0C36720E
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbhDURyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 13:54:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:49672 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243192AbhDURyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 13:54:40 -0400
IronPort-SDR: biYErnG+ZqwLBKfsSol0zKhvn7/FSjb/e8a33N69OP0GsEdjRPJU329knSyMXZZEdUR6Vr25+O
 wEOwSu8iDYrw==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="182875878"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="182875878"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 10:54:06 -0700
IronPort-SDR: ZXGipQWNSsHNUlpqwBwBGej/nZnWOLYdtDY1t3N8SXOBWiu0jLapikzNNHVMCzyI7Rbcit0HM4
 pGaVOPBt934A==
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="427609634"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.153.90]) ([10.249.153.90])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 10:54:05 -0700
Subject: Re: [PATCH 040/190] Revert "ACPI: CPPC: Fix reference count leak in
 acpi_cppc_processor_probe()"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, "4 . 10+" <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-41-gregkh@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <48ff1501-b0e2-4a86-ea27-9ef059eabf6b@intel.com>
Date:   Wed, 21 Apr 2021 19:54:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421130105.1226686-41-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/21/2021 2:58 PM, Greg Kroah-Hartman wrote:
> This reverts commit 4d8be4bc94f74bb7d096e1c2e44457b530d5a170.
>
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
>
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
>
> Cc: Qiushi Wu <wu000273@umn.edu>
> Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


> ---
>   drivers/acpi/cppc_acpi.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> index 69057fcd2c04..42650b34e45e 100644
> --- a/drivers/acpi/cppc_acpi.c
> +++ b/drivers/acpi/cppc_acpi.c
> @@ -830,7 +830,6 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
>   			"acpi_cppc");
>   	if (ret) {
>   		per_cpu(cpc_desc_ptr, pr->id) = NULL;
> -		kobject_put(&cpc_ptr->kobj);
>   		goto out_free;
>   	}
>   


