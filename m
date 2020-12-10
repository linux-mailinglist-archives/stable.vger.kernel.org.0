Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4170B2D60AA
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392131AbgLJP5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:57:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:40076 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392075AbgLJP5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 10:57:34 -0500
IronPort-SDR: DndN5pqvbd3zG+lfduwegh4JSuiBKEGDEHxe2HcAIoYnEpXvf9C4x7hHQ31v0QHh7jbPAyFyhE
 R5iyHKpnlsZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="192599474"
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="192599474"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 07:55:45 -0800
IronPort-SDR: 3nkhWLCpQ6dAgMT9lORwAd8Jj7LQTaOWfcJOil6sKfSm0P33XjP5LeJlZlfS624xA3+aUm+ZjR
 b2qpEZaQKnEQ==
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="319653427"
Received: from mgorski-mobl.ger.corp.intel.com (HELO [10.213.11.242]) ([10.213.11.242])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 07:55:43 -0800
Subject: Re: [PATCH] ASoC: Intel: Skylake: Check the kcontrol against NULL
To:     Lukasz Majczak <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201210121438.7718-1-lma@semihalf.com>
From:   "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>
Message-ID: <43ecc9e6-3a86-6e7c-bb88-f87fbce0f51d@linux.intel.com>
Date:   Thu, 10 Dec 2020 16:55:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210121438.7718-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> There is no check for the kcontrol against NULL and in some cases
> it causes kernel to crash.
>
> Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT")
> Cc: <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> ---
>   sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
> index ae466cd592922..c9abbe4ff0ba3 100644
> --- a/sound/soc/intel/skylake/skl-topology.c
> +++ b/sound/soc/intel/skylake/skl-topology.c
> @@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_component *component)
>   	int i;
>   
>   	list_for_each_entry(dobj, &component->dobj_list, list) {
> -		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
> -		struct soc_enum *se =
> -			(struct soc_enum *)kcontrol->private_value;
> -		char **texts = dobj->control.dtexts;
> +		struct snd_kcontrol *kcontrol;
> +		struct soc_enum *se;
> +		char **texts;
>   		char chan_text[4];
>   
> +		kcontrol = dobj->control.kcontrol;
> +		if(!kcontrol)
> +			continue;
> +
> +		se = (struct soc_enum *)kcontrol->private_value;
> +		texts = dobj->control.dtexts;
> +
>   		if (dobj->type != SND_SOC_DOBJ_ENUM ||
>   		    dobj->control.kcontrol->put !=
>   		    skl_tplg_multi_config_set_dmic)
>
> base-commit: 69fe63aa100220c8fd1f451dd54dd0895df1441d


Thanks for pointing out and fixing this. This check was obviously 
missing there. I did a quick verification on few of our platforms, 
encountered no issues, so:

     Reviewed-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>


Also, could you please:

- describe the affected configuration (used machine driver or audio card 
name, device name),
- share full dmesg logs from one of said crashes,
- copy the output of "amixer -c0 controls" command executed on affected 
device.

These would be useful information for us to further improve our 
validation and help us with debugging.


Thanks,

Mateusz


