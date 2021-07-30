Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2213DB9D2
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 15:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhG3Nzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 09:55:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:64512 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231173AbhG3Nzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 09:55:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="276877236"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="276877236"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 06:55:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="518953369"
Received: from spichard-mobl1.amr.corp.intel.com (HELO [10.212.106.239]) ([10.212.106.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 06:55:43 -0700
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98357a: fix drv_name
To:     Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210730115906.144300-1-lma@semihalf.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <58b46549-9b42-1832-b1e1-680d56c3f393@linux.intel.com>
Date:   Fri, 30 Jul 2021 08:55:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730115906.144300-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/30/21 6:59 AM, Lukasz Majczak wrote:
> platform_id for kbl_da7219_max98357a was shrunk for kbl_da7219_mx98357a,
> but the drv_name was changed for kbl_da7219_max98373. Tested on a
> Pixelbook (Atlas).
> 
> Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
> Cc: <stable@vger.kernel.org> # 5.4+
> Reported-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Tested-by: Lukasz Majczak <lma@semihalf.com>
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> ---
>  sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> index ba5ff468c265..8cab91a00b1a 100644
> --- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> +++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
> @@ -87,7 +87,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
>  	},
>  	{
>  		.id = "DLGS7219",
> -		.drv_name = "kbl_da7219_max98357a",
> +		.drv_name = "kbl_da7219_mx98357a",

that one is correct, that was a miss

>  		.fw_filename = "intel/dsp_fw_kbl.bin",
>  		.machine_quirk = snd_soc_acpi_codec_list,
>  		.quirk_data = &kbl_7219_98357_codecs,
> @@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
>  	},
>  	{
>  		.id = "DLGS7219",
> -		.drv_name = "kbl_da7219_mx98373",
> +		.drv_name = "kbl_da7219_max98373",

this one is wrong though? The correct name was already present, you're
reverting back to the wrong name.

there's another one that I missed, do you mind changing this as well?

soc-acpi-intel-cml-match.c:             .drv_name = "cml_da7219_max98357a",

Should be "cml_da7219_mx98357a"


>  		.fw_filename = "intel/dsp_fw_kbl.bin",
>  		.machine_quirk = snd_soc_acpi_codec_list,
>  		.quirk_data = &kbl_7219_98373_codecs,
> 
