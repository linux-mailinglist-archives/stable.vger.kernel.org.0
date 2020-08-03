Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DB223ABD2
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHCRux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:50:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:3376 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgHCRuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 13:50:52 -0400
IronPort-SDR: fbB8YZ7KrLlxDGmQTj9R4hsPKG4sFLmsYhjgxtLAj9qL44JrZr1Ftb7g4UK83cxHyS1EFX2sir
 sGEKNtzZrQLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="139750947"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="139750947"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:50:51 -0700
IronPort-SDR: hOdiJNidcPOOLZB0eOpfj5YDCPJczoyfoxkmQ9QJDOxdUHqqG2P5tttzc8QDdWR4Csmg3vBe80
 h09bg/p36dSQ==
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="330152837"
Received: from dravoori-mobl.amr.corp.intel.com (HELO [10.212.46.95]) ([10.212.46.95])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:50:51 -0700
Subject: Re: [PATCH] Revert "ALSA: hda: call runtime_allow() for all hda
 controllers"
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Hui Wang <hui.wang@canonical.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
References: <20200803064638.6139-1-hui.wang@canonical.com>
 <0db4f5fe-7895-2d00-8ce3-96f1245000ab@linux.intel.com>
 <s5hwo2f3cux.wl-tiwai@suse.de>
 <6f583ccc-2251-384d-bc20-aa17c83a45b4@linux.intel.com>
 <s5hk0yf39wj.wl-tiwai@suse.de>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <f6a66bc4-9f1a-0425-6f00-4ddce3a2b6cc@linux.intel.com>
Date:   Mon, 3 Aug 2020 12:50:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <s5hk0yf39wj.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>> Do I get this right that this permanently disables pm_runtime on all
>>>> Intel HDaudio controllers?
>>>
>>> It just drops the unconditional enablement of runtime PM.
>>> It can be enabled via sysfs, and that's the old default (let admin
>>> enabling it via udev or whatever).
>>
>> Sorry I am confused now.
>> Kai seemed to suggest in the Bugzilla comments that this would be
>> temporary, until these problems with i915 and ALC662 get fixed?
> 
> Right, that's the plan.  This patch revert to the old state before the
> forced-all-enable call we've taken in 5.7.  On 5.7 and onwards, all
> HD-audio controllers are enforced to use the runtime PM.  Before that
> version, the runtime PM was enabled *as default* only for limited
> devices (typically the ones bound with GPU); for other devices, the
> runtime PM is manually enabled from user-space via sysfs (and many
> distros enable them in anyway).
> 
> The forced enablement was merged with a hope that now all HD-audio
> controllers behave nicely, but it turned out to cause a regression, so
> it was reverted.  Once when we find out the real cause, we can flip
> the flag again.

ok, sounds good. I was concerned mainly because on the SOF driver side 
we enable pm_runtime by default, so that's a difference in configuration 
we need to be aware of when dealing with 'my speaker is silent' support 
questions.
