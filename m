Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E923DBA21
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhG3OMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 10:12:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:9264 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238962AbhG3OMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 10:12:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="235014994"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="235014994"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 07:12:39 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="518961685"
Received: from spichard-mobl1.amr.corp.intel.com (HELO [10.212.106.239]) ([10.212.106.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 07:12:39 -0700
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98357a: fix drv_name
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210730115906.144300-1-lma@semihalf.com>
 <58b46549-9b42-1832-b1e1-680d56c3f393@linux.intel.com>
 <c1fb1cd1-6d27-648a-ac9c-81e150505750@intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <6a0866a7-aec4-69d9-eb70-07931952b732@linux.intel.com>
Date:   Fri, 30 Jul 2021 09:12:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c1fb1cd1-6d27-648a-ac9c-81e150505750@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/30/21 9:05 AM, Cezary Rojewski wrote:
> On 2021-07-30 3:55 PM, Pierre-Louis Bossart wrote:
>> On 7/30/21 6:59 AM, Lukasz Majczak wrote:
> 
> ...
> 
>>> @@ -113,7 +113,7 @@ struct snd_soc_acpi_mach
>>> snd_soc_acpi_intel_kbl_machines[] = {
>>>       },
>>>       {
>>>           .id = "DLGS7219",
>>> -        .drv_name = "kbl_da7219_mx98373",
>>> +        .drv_name = "kbl_da7219_max98373",
>>
>> this one is wrong though? The correct name was already present, you're
>> reverting back to the wrong name.
>>
>> there's another one that I missed, do you mind changing this as well?
>>
>> soc-acpi-intel-cml-match.c:             .drv_name =
>> "cml_da7219_max98357a",
>>
>> Should be "cml_da7219_mx98357a"
>>
>>
> 
> Not saying 'nay' or 'yay' but why is configuration first available on
> KBL platforms being renamed to 'cml_XXX'?
The same bxt_da7219_max98357a.c machine driver is used for multiple devices.

static const struct platform_device_id bxt_board_ids[] = {
	{ .name = "bxt_da7219_mx98357a" },
	{ .name = "glk_da7219_mx98357a" },
	{ .name = "cml_da7219_mx98357a" },
	{ }
};
MODULE_DEVICE_TABLE(platform, bxt_board_ids);

Why there are different drivers for KBL and BXT is probably lost in history.
