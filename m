Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DF63F1C7F
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 17:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhHSPT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 11:19:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:14350 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhHSPT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 11:19:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="203777064"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="203777064"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 08:18:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="489703501"
Received: from mmdandap-mobl.amr.corp.intel.com (HELO [10.213.172.210]) ([10.213.172.210])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 08:18:46 -0700
Subject: Re: [PATCH v2] ASoC: Intel: Fix platform ID matching for
 kbl_da7219_max98373
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        stable@vger.kernel.org
References: <20210819082414.39497-1-lma@semihalf.com>
 <87736cce-a96f-064e-6d60-71645ba46f13@linux.intel.com>
 <aeb40985-140f-b013-f368-778ad33fc7d0@intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <50eb6c88-5f1a-7a42-adaf-da16f711e5c5@linux.intel.com>
Date:   Thu, 19 Aug 2021 10:18:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <aeb40985-140f-b013-f368-778ad33fc7d0@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/21 10:06 AM, Cezary Rojewski wrote:
> On 2021-08-19 4:30 PM, Pierre-Louis Bossart wrote:
>> On 8/19/21 3:24 AM, Lukasz Majczak wrote:
>>> Sparse warnings triggered truncating the IDs of some platform device
>>> tables. Unfortunately kbl_da7219_max98373 was also truncated.
>>> This patch is reverting the original ID.
>>> Tested on Atlas chromebook.
>>
>> Instead of reverting, how about changing the remaining occurrences of
>> the old name in the machine driver?
>>
>> sound/soc/intel/boards/kbl_da7219_max98927.c:   if (!strcmp(pdev->name,
>> "kbl_da7219_max98373") ||
>> sound/soc/intel/boards/kbl_da7219_max98927.c:           .name =
>> "kbl_da7219_max98373",
> 
> Mentioned by 'Fixes' tag patch clearly introduced regression. If we are
> to update any name-fields, it's better to have a fresh start and update
> all the boards in one-go than doing so separately.
> 
> Apart from that, Maxim codecs go by the name of 'max' in
> sound/soc/codecs/. It's more intuitive to have equivalent shortcut used
> in board's name.

the ACPI HID start with MX and there's not much consistency in naming,
is there?

		.drv_name = "kbl_r5514_5663_max",
		.drv_name = "kbl_rt5663_m98927",
		.drv_name = "kbl_da7219_mx98357a",
		.drv_name = "kbl_da7219_max98927",
		.drv_name = "kbl_max98373",

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
