Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A8D53F767
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 09:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiFGHkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 03:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbiFGHkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 03:40:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F16DB7DCE;
        Tue,  7 Jun 2022 00:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654587639; x=1686123639;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W8olvD6jsW8G7sUBGciwGYzzYT1FeeRZhqthVitPYz4=;
  b=OSD37cNJTW87mTNIxYlVgdYuNCHvTWnlFew8QOcq7RxK5BbgGGP4bxWw
   RoLJGalbu9OrYcDy+115RsM5IzcIvI9E4xHAYq7vqu7iOf4r67dL/sdZl
   BxB1nhZ+r/luGI/AcuGtXR6Z7Vi14IrJq4HzEt9dtZLRm9FbSL+sLnP84
   UarH8T5C//SDl9n3eMSuUrtCJKef/rrKTF5oyWOvyNk3XInrQa2gV1Sj9
   iMSMkSApLNclVLOE15gToMtGjxCgPdw6BMDU0ge6XFSRci+P0w9ooDOor
   V4k9uHzThYjBshYTWQzG9Qm2Yf8hQDHIMQ1OSHSvCikTuykNc9EniZgPv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="340348105"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="340348105"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:40:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="906930360"
Received: from mrasiewx-mobl.ger.corp.intel.com (HELO [10.99.241.39]) ([10.99.241.39])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:40:17 -0700
Message-ID: <238510b7-fc5f-4f1b-9e25-6e38b49c2535@linux.intel.com>
Date:   Tue, 7 Jun 2022 09:40:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] ASoC: topology: Avoid card NULL deref in
 snd_soc_tplg_component_remove()
Content-Language: en-US
To:     Dean Gehnert <deang@tpi.com>, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.com>,
        stable@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <20220603201425.2590-1-deang@tpi.com>
From:   =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <20220603201425.2590-1-deang@tpi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/2022 10:14 PM, Dean Gehnert wrote:
> Don't deference card in comp->card->snd_card before checking for NULL card.
> 
> During the unloading of ASoC kernel modules, there is a kernel oops in
> snd_soc_tplg_component_remove() that happens because comp->card is set to
> NULL in soc_cleanup_component().
> 
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: alsa-devel@alsa-project.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 7e567b5ae063 ("ASoC: topology: Add missing rwsem around snd_ctl_remove() calls")
> Signed-off-by: Dean Gehnert <deang@tpi.com>
> ---
>   sound/soc/soc-topology.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
> index 3f9d314fba16..cf0efe1147c2 100644
> --- a/sound/soc/soc-topology.c
> +++ b/sound/soc/soc-topology.c
> @@ -2613,15 +2613,18 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_component_load);
>   /* remove dynamic controls from the component driver */
>   int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
>   {
> -	struct snd_card *card = comp->card->snd_card;
> +	struct snd_card *card;
>   	struct snd_soc_dobj *dobj, *next_dobj;
>   	int pass;
>   
>   	/* process the header types from end to start */
>   	for (pass = SOC_TPLG_PASS_END; pass >= SOC_TPLG_PASS_START; pass--) {
>   
> +		card = (comp->card) ? comp->card->snd_card : NULL;
> +
>   		/* remove mixer controls */
> -		down_write(&card->controls_rwsem);
> +		if (card)
> +			down_write(&card->controls_rwsem);
>   		list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
>   			list) {

I'm pretty sure that quite a lot of operations in this 
list_for_each_entry_safe() loop require existing card...

And trying to investigate more closely, there is no 
soc_cleanup_component() mentioned in commit message, for quite a few 
kernel versions - seems to have been removed during v5.5-rc1.

I would say to not merge this, unless problem can be reproduced with 
latest kernel and even then would consider if it is a correct fix.

>   
> @@ -2660,7 +2663,8 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
>   				break;
>   			}
>   		}
> -		up_write(&card->controls_rwsem);
> +		if (card)
> +			up_write(&card->controls_rwsem);
>   	}
>   
>   	/* let caller know if FW can be freed when no objects are left */

