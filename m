Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1F3F1B9E
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbhHSObm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 10:31:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:44277 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238595AbhHSObl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 10:31:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="216562207"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="216562207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 07:31:03 -0700
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="489687511"
Received: from mmdandap-mobl.amr.corp.intel.com (HELO [10.213.172.210]) ([10.213.172.210])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 07:31:02 -0700
Subject: Re: [PATCH v2] ASoC: Intel: Fix platform ID matching for
 kbl_da7219_max98373
To:     Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        stable@vger.kernel.org
References: <20210819082414.39497-1-lma@semihalf.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <87736cce-a96f-064e-6d60-71645ba46f13@linux.intel.com>
Date:   Thu, 19 Aug 2021 09:30:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210819082414.39497-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/21 3:24 AM, Lukasz Majczak wrote:
> Sparse warnings triggered truncating the IDs of some platform device
> tables. Unfortunately kbl_da7219_max98373 was also truncated.
> This patch is reverting the original ID.
> Tested on Atlas chromebook.

Instead of reverting, how about changing the remaining occurrences of
the old name in the machine driver?

sound/soc/intel/boards/kbl_da7219_max98927.c:   if (!strcmp(pdev->name,
"kbl_da7219_max98373") ||
sound/soc/intel/boards/kbl_da7219_max98927.c:           .name =
"kbl_da7219_max98373",


> 
> Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
> Cc: <stable@vger.kernel.org> # 5.4+
> Tested-by: Lukasz Majczak <lma@semihalf.com>
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Suggested-by: Cezary Rojewski <cezary.rojewski@intel.com>
> ---
>  sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> index 741bf2f9e081..8cab91a00b1a 100644
> --- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> +++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> @@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
>  	},
>  	{
>  		.id = "DLGS7219",
> -		.drv_name = "kbl_da7219_mx98373",
> +		.drv_name = "kbl_da7219_max98373",
>  		.fw_filename = "intel/dsp_fw_kbl.bin",
>  		.machine_quirk = snd_soc_acpi_codec_list,
>  		.quirk_data = &kbl_7219_98373_codecs,
> 
