Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43A160CEFA
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJYO2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiJYO2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:28:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E58FC3568;
        Tue, 25 Oct 2022 07:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666708128; x=1698244128;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5lf9HXnuZmAIrUwqX/AP3lotJnWhdB2O4yFZG3cNmME=;
  b=FfPo3qIWki8M/KRCoYtYxJR9EU1t0aO0hWyS4yf+XsvGLUwZMTUaoHdJ
   A6aZzzMdepHN5ti4aEvEI5nSTOWr2VxSbVjy3DvBoA7GVE/3v8XRttDSU
   UZXh3jvMmO/Wua73xPPb6OIBmzmCLsR6T/wnAWoYLz+srsdioirwLVdpm
   OzyMEqdGG/+s2hBi+FHBJkgcGQM5ntCwnescCtsn3Ri3XO5QdH/I4EE4o
   ZmGlTtkY8Ny6EcNXwG8v/XjamwJtIf/eI0Sk6WoJHYAgxD2KmVuiF6jID
   /FHjHNpkmISFoPXOcIsyMPHPEoh0yfMkntQx9PTiZ7a9DUVFe6l71uyHs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="309376320"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="309376320"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 07:27:34 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="634116437"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="634116437"
Received: from pperezji-mobl.amr.corp.intel.com (HELO [10.212.98.192]) ([10.212.98.192])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 07:27:32 -0700
Message-ID: <24d084e1-700d-da77-d93e-2d330aac2f63@linux.intel.com>
Date:   Tue, 25 Oct 2022 09:27:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH AUTOSEL 6.0 07/44] ALSA: hda: Fix page fault in
 snd_hda_codec_shutdown()
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, tiwai@suse.com,
        alsa-devel@alsa-project.org, peter.ujfalusi@linux.intel.com,
        mkumard@nvidia.com
References: <20221009234932.1230196-1-sashal@kernel.org>
 <20221009234932.1230196-7-sashal@kernel.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20221009234932.1230196-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/9/22 18:48, Sasha Levin wrote:
> From: Cezary Rojewski <cezary.rojewski@intel.com>
> 
> [ Upstream commit f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 ]

This commit on linux-stable seems to have broken a number of platforms.

6.0.2 worked fine.
6.0.3 does not

reverting this commit solves the problem, see
https://github.com/thesofproject/linux/issues/3960 for details.

Are we missing a prerequisite patch for this commit?


> If early probe of HDAudio bus driver fails e.g.: due to missing
> firmware file, snd_hda_codec_shutdown() ends in manipulating
> uninitialized codec->pcm_list_head causing page fault.
> 
> Initialization of HDAudio codec in ASoC is split in two:
> - snd_hda_codec_device_init()
> - snd_hda_codec_device_new()
> 
> snd_hda_codec_device_init() is called during probe_codecs() by HDAudio
> bus driver while snd_hda_codec_device_new() is called by
> codec-component's ->probe(). The second call will not happen until all
> components required by related sound card are present within the ASoC
> framework. With firmware failing to load during the PCI's deferred
> initialization i.e.: probe_work(), no platform components are ever
> registered. HDAudio codec enumeration is done at that point though, so
> the codec components became registered to ASoC framework, calling
> snd_hda_codec_device_init() in the process.
> 
> Now, during platform reboot snd_hda_codec_shutdown() is called for every
> codec found on the HDAudio bus causing oops if any of them has not
> completed both of their initialization steps. Relocating field
> initialization fixes the issue.
> 
> Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Link: https://lore.kernel.org/r/20220816111727.3218543-7-cezary.rojewski@intel.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/pci/hda/hda_codec.c | 41 +++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 384426d7e9dd..4ae8b9574778 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -931,8 +931,28 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
>  	}
>  
>  	codec->bus = bus;
> +	codec->depop_delay = -1;
> +	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
> +	codec->core.dev.release = snd_hda_codec_dev_release;
> +	codec->core.exec_verb = codec_exec_verb;
>  	codec->core.type = HDA_DEV_LEGACY;
>  
> +	mutex_init(&codec->spdif_mutex);
> +	mutex_init(&codec->control_mutex);
> +	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
> +	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
> +	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
> +	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
> +	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
> +	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
> +	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
> +	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
> +	INIT_LIST_HEAD(&codec->conn_list);
> +	INIT_LIST_HEAD(&codec->pcm_list_head);
> +	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
> +	refcount_set(&codec->pcm_ref, 1);
> +	init_waitqueue_head(&codec->remove_sleep);
> +
>  	return codec;
>  }
>  EXPORT_SYMBOL_GPL(snd_hda_codec_device_init);
> @@ -985,29 +1005,8 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
>  	if (snd_BUG_ON(codec_addr > HDA_MAX_CODEC_ADDRESS))
>  		return -EINVAL;
>  
> -	codec->core.dev.release = snd_hda_codec_dev_release;
> -	codec->core.exec_verb = codec_exec_verb;
> -
>  	codec->card = card;
>  	codec->addr = codec_addr;
> -	mutex_init(&codec->spdif_mutex);
> -	mutex_init(&codec->control_mutex);
> -	snd_array_init(&codec->mixers, sizeof(struct hda_nid_item), 32);
> -	snd_array_init(&codec->nids, sizeof(struct hda_nid_item), 32);
> -	snd_array_init(&codec->init_pins, sizeof(struct hda_pincfg), 16);
> -	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
> -	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
> -	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
> -	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
> -	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
> -	INIT_LIST_HEAD(&codec->conn_list);
> -	INIT_LIST_HEAD(&codec->pcm_list_head);
> -	refcount_set(&codec->pcm_ref, 1);
> -	init_waitqueue_head(&codec->remove_sleep);
> -
> -	INIT_DELAYED_WORK(&codec->jackpoll_work, hda_jackpoll_work);
> -	codec->depop_delay = -1;
> -	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
>  
>  #ifdef CONFIG_PM
>  	codec->power_jiffies = jiffies;
