Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C4145CC2
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 20:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVT4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 14:56:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:52025 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVT4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 14:56:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2020 11:56:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,350,1574150400"; 
   d="scan'208";a="250734872"
Received: from jovercas-mobl1.amr.corp.intel.com (HELO [10.254.105.26]) ([10.254.105.26])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jan 2020 11:56:31 -0800
Subject: Re: [alsa-devel] [PATCH] ASoC: topology: fix
 soc_tplg_fe_link_create() - link->dobj initialization order
To:     Jaroslav Kysela <perex@perex.cz>,
        ALSA development <alsa-devel@alsa-project.org>
Cc:     Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
References: <20200122190752.3081016-1-perex@perex.cz>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
Date:   Wed, 22 Jan 2020 13:28:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122190752.3081016-1-perex@perex.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/20 1:07 PM, Jaroslav Kysela wrote:
> The code which checks the return value for snd_soc_add_dai_link() call
> in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
> link->dobj members initialization.
> 
> While it does not affect the latest kernels, the old soc-core.c code
> in the stable kernels is affected. The snd_soc_add_dai_link() function uses
> the link->dobj.type member to check, if the link structure is valid.
> 
> Reorder the link->dobj initialization to make things work again.
> It's harmless for the recent code (and the structure should be properly
> initialized before other calls anyway).
> 
> The problem is in stable linux-5.4.y since version 5.4.11 when the
> upstream commit 76d270364932 was applied.

I am not following. Is this a fix for linux-5.4-y only, or is it needed 
on Mark's tree? In the latter case, what is broken? We've been using 
Mark's tree without issues, wondering what we missed?

> 
> Fixes: 76d270364932 ("ASoC: topology: Check return value for snd_soc_add_dai_link()")
> Cc: Dragos Tarcatu <dragos_tarcatu@mentor.com>
> Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jaroslav Kysela <perex@perex.cz>
> ---
>   sound/soc/soc-topology.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
> index 92e4f4d08bfa..4e1fe623c390 100644
> --- a/sound/soc/soc-topology.c
> +++ b/sound/soc/soc-topology.c
> @@ -1906,6 +1906,10 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
>   	link->num_codecs = 1;
>   	link->num_platforms = 1;
>   
> +	link->dobj.index = tplg->index;
> +	link->dobj.ops = tplg->ops;
> +	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
> +
>   	if (strlen(pcm->pcm_name)) {
>   		link->name = kstrdup(pcm->pcm_name, GFP_KERNEL);
>   		link->stream_name = kstrdup(pcm->pcm_name, GFP_KERNEL);
> @@ -1942,9 +1946,6 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
>   		goto err;
>   	}
>   
> -	link->dobj.index = tplg->index;
> -	link->dobj.ops = tplg->ops;
> -	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
>   	list_add(&link->dobj.list, &tplg->comp->dobj_list);
>   
>   	return 0;
> 
