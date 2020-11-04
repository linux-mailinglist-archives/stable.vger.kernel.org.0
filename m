Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07462A6393
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgKDLsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:48:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:16204 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKDLqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 06:46:42 -0500
IronPort-SDR: 5fG76cl0jgyzmP1HqGfK3+GtAxHz/K5oFQ/geJH1RG8R/cr8M5tbcch+evbRlHkwayYKa8pOcz
 Nz0bFjF1mIZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="233366377"
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="233366377"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:46:41 -0800
IronPort-SDR: 68kskoXqxwYBFqWbszWyaEQkCGG5qeIkJGC5hc6NY2wJMZcLz88Qhstzoozgc0QQfFt7j092xm
 MWHOjYSRFquA==
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="471197594"
Received: from mgorski-mobl.ger.corp.intel.com (HELO [10.249.147.98]) ([10.249.147.98])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:46:39 -0800
Subject: Re: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, cezary.rojewski@intel.com,
        Mark Brown <broonie@kernel.org>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
 <20201103153541.GC3267686@kroah.com>
From:   "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>
Message-ID: <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
Date:   Wed, 4 Nov 2020 12:46:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103153541.GC3267686@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: pl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
>>
>> Add alternative topology binary file name based on used machine driver
>> and fallback to use this name after failed attempt to load topology file
>> with name based on NHLT.
>> This change addresses multiple issues with current mechanism, for
>> example - there are devices without NHLT table, and that currently
>> results in tplg_name being empty.
>>
>> Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
>> Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
>> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>> Link: https://lore.kernel.org/r/20200427132727.24942-2-mateusz.gorski@linux.intel.com
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> ---
>>
>> This functionality is merged on upstream kernel and widely used. Merging
>> it to LTS kernel would improve the user experience and resolve some of the
>> problems regarding topology naming that the users are facing.
> What problems are people facing, and what kernel(s) are you asking for
> this to be ported to, and why can't people just use 5.8 or newer if they
> have this new hardware?
>
> thanks,
>
> greg k-h

I forgot to add - I wanted this change to be merged to stable 5.4 
kernel. Please let me know if I should resend this patch with this 
information included.

As for the user issues - topology binary file name is currently created 
according to information from NHLT. The problem is, that some laptops 
(for example Dell XPS 13) do not have NHLT at all. This results in 
topology binary name being empty (" ").
This patch adds alternative name based on loaded machine driver.

It applies not only to new hardware, please note that the mentioned Dell 
XPS 13 is based on Kabylake. This issue existed on upstream from the 
beginning of Skylake driver and was only recently addressed.

