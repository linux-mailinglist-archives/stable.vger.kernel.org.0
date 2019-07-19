Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D8B6E4F5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 13:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfGSLTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 07:19:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:9604 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfGSLTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 07:19:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 04:19:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,282,1559545200"; 
   d="scan'208";a="195918306"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.251.81.172]) ([10.251.81.172])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jul 2019 04:19:33 -0700
Subject: Re: [PATCH v6 2/6] ASoC: sgtl5000: Improve VAG power and mute control
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
References: <20190719100524.23300-1-oleksandr.suvorov@toradex.com>
 <20190719100524.23300-3-oleksandr.suvorov@toradex.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <a4bcf146-4e5a-09be-599e-0ba12113d128@intel.com>
Date:   Fri, 19 Jul 2019 13:19:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719100524.23300-3-oleksandr.suvorov@toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019-07-19 12:05, Oleksandr Suvorov wrote:
> VAG power control is improved to fit the manual [1]. This patch fixes as
> minimum one bug: if customer muxes Headphone to Line-In right after boot,
> the VAG power remains off that leads to poor sound quality from line-in.
> 
> I.e. after boot:
>    - Connect sound source to Line-In jack;
>    - Connect headphone to HP jack;
>    - Run following commands:
>    $ amixer set 'Headphone' 80%
>    $ amixer set 'Headphone Mux' LINE_IN
> 
> Change VAG power on/off control according to the following algorithm:
>    - turn VAG power ON on the 1st incoming event.
>    - keep it ON if there is any active VAG consumer (ADC/DAC/HP/Line-In).
>    - turn VAG power OFF when there is the latest consumer's pre-down event
>      come.
>    - always delay after VAG power OFF to avoid pop.
>    - delay after VAG power ON if the initiative consumer is Line-In, this
>      prevents pop during line-in muxing.
> 
> According to the data sheet [1], to avoid any pops/clicks,
> the outputs should be muted during input/output
> routing changes.
> 
> [1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf
> 
> Cc: stable@vger.kernel.org
> Fixes: 9b34e6cc3bc2 ("ASoC: Add Freescale SGTL5000 codec support")
> Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> 
> ---
> 
> Changes in v6:
> - Code optimization

You went crazy with that description (u16 mute_mask[]) :)

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
