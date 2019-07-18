Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59B16D41D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 20:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfGRSmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 14:42:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:37496 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfGRSmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 14:42:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 11:42:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="195708519"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.251.81.172]) ([10.251.81.172])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jul 2019 11:42:11 -0700
Subject: Re: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute control
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
References: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
 <20190718090240.18432-3-oleksandr.suvorov@toradex.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <9c9ee47c-48bd-7109-9870-8f73be1f1cfa@intel.com>
Date:   Thu, 18 Jul 2019 20:42:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718090240.18432-3-oleksandr.suvorov@toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-07-18 11:02, Oleksandr Suvorov wrote:
>   
> +enum {
> +	HP_POWER_EVENT,
> +	DAC_POWER_EVENT,
> +	ADC_POWER_EVENT,
> +	LAST_POWER_EVENT
> +};
> +
> +static u16 mute_mask[] = {
> +	SGTL5000_HP_MUTE,
> +	SGTL5000_OUTPUTS_MUTE,
> +	SGTL5000_OUTPUTS_MUTE
> +};

If mute_mask[] is only used within common handler, you may consider 
declaring const array within said handler instead (did not check that 
myself).
Otherwise, simple comment for the second _OUTPUTS_MUTE should suffice - 
its not self explanatory why you doubled that mask.

> +
>   /* sgtl5000 private structure in codec */
>   struct sgtl5000_priv {
>   	int sysclk;	/* sysclk rate */
> @@ -137,8 +157,109 @@ struct sgtl5000_priv {
>   	u8 micbias_voltage;
>   	u8 lrclk_strength;
>   	u8 sclk_strength;
> +	u16 mute_state[LAST_POWER_EVENT];
>   };
>   

When I spoke of LAST enum constant, I did not really had this specific 
usage in mind.

 From design perspective, _LAST_ does not exist and should never be 
referred to as "the next option" i.e.: new enum constant.
That is way preferred usage is:
u16 mute_state[ADC_POWER_EVENT+1;
-or-
u16 mute_state[LAST_POWER_EVENT+1];

Maybe I'm just being radical here :)

Czarek
