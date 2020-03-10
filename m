Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7153617EE24
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 02:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgCJBou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 21:44:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:46957 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgCJBou (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 21:44:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 18:44:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,535,1574150400"; 
   d="scan'208";a="235774698"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.55]) ([10.254.215.55])
  by fmsmga008.fm.intel.com with ESMTP; 09 Mar 2020 18:44:47 -0700
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux-foundation.org,
        Barret Rhoden <brho@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT
 with pr_warn + add_taint
To:     Hans de Goede <hdegoede@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>
References: <20200309140138.3753-1-hdegoede@redhat.com>
 <20200309140138.3753-3-hdegoede@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5eeb3332-0f6a-4d5c-f895-ca92931e5f48@linux.intel.com>
Date:   Tue, 10 Mar 2020 09:44:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309140138.3753-3-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/3/9 22:01, Hans de Goede wrote:
> Quoting from the comment describing the WARN functions in
> include/asm-generic/bug.h:
> 
>   * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>   * significant kernel issues that need prompt attention if they should ever
>   * appear at runtime.
>   *
>   * Do not use these macros when checking for invalid external inputs
> 
> The (buggy) firmware tables which the dmar code was calling WARN_TAINT
> for really are invalid external inputs. They are not under the kernel's
> control and the issues in them cannot be fixed by a kernel update.
> So logging a backtrace, which invites bug reports to be filed about this,
> is not helpful.
> 
> Some distros, e.g. Fedora, have tools watching for the kernel backtraces
> logged by the WARN macros and offer the user an option to file a bug for
> this when these are encountered. The WARN_TAINT in dmar_parse_one_rmrr
> + another iommu WARN_TAINT, addressed in another patch, have lead to over
> a 100 bugs being filed this way.
> 
> This commit replaces the WARN_TAINT("...") call, with a
> pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) call
> avoiding the backtrace and thus also avoiding bug-reports being filed
> about this against the kernel.
> 
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1808874
> Fixes: f5a68bb0752e ("iommu/vt-d: Mark firmware tainted if RMRR fails sanity check")
> Cc: Barret Rhoden <brho@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> ---
>   drivers/iommu/intel-iommu.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 6fa6de2b6ad5..3857a5cd1a75 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4460,14 +4460,16 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
>   	struct dmar_rmrr_unit *rmrru;
>   
>   	rmrr = (struct acpi_dmar_reserved_memory *)header;
> -	if (rmrr_sanity_check(rmrr))
> -		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> +	if (rmrr_sanity_check(rmrr)) {
> +		pr_warn(FW_BUG
>   			   "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
>   			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
>   			   rmrr->base_address, rmrr->end_address,
>   			   dmi_get_system_info(DMI_BIOS_VENDOR),
>   			   dmi_get_system_info(DMI_BIOS_VERSION),
>   			   dmi_get_system_info(DMI_PRODUCT_VERSION));
> +		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
> +	}
>   
>   	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
>   	if (!rmrru)
> 
