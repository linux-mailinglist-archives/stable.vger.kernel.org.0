Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF4510916
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354177AbiDZTgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243928AbiDZTgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:36:05 -0400
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4F184F81
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 12:32:56 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id jQvenj84zrYGrjQvenImsG; Tue, 26 Apr 2022 21:32:55 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 26 Apr 2022 21:32:55 +0200
X-ME-IP: 86.243.180.246
Message-ID: <6e3e881b-787d-30d5-054a-2ef43e3731b1@wanadoo.fr>
Date:   Tue, 26 Apr 2022 21:32:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH AUTOSEL 5.17 01/22] ASoC: soc-pcm: use GFP_KERNEL when the
 code is sleepable
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
References: <20220426190145.2351135-1-sashal@kernel.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I don't think that this patch needs backporting.

It does not fix anything and could introduce some regression if 
b7898396f4bb is not also already backported.
It could avoid some (unlikely?) allocation failure, but as this case is 
already handled ("if (!dpcm)"), it shouldn't be an issue if it happened.


Just for my understanding, why has it auto-selected for backport?
I thought that a Fixes tag and/or a real reported issue was need for 
this to happen.

CJ



Le 26/04/2022 à 21:01, Sasha Levin a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> [ Upstream commit fb6d679fee95d272c0a94912c4e534146823ee89 ]
>
> At the kzalloc() call in dpcm_be_connect(), there is no spin lock involved.
> It's merely protected by card->pcm_mutex, instead.  The spinlock is applied
> at the later call with snd_soc_pcm_stream_lock_irq() only for the list
> manipulations.  (See it's *_irq(), not *_irqsave(); that means the context
> being sleepable at that point.)  So, we can use GFP_KERNEL safely there.
>
> This patch revert commit d8a9c6e1f676 ("ASoC: soc-pcm: use GFP_ATOMIC for
> dpcm structure") which is no longer needed since commit b7898396f4bb
> ("ASoC: soc-pcm: Fix and cleanup DPCM locking").
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Link: https://lore.kernel.org/r/e740f1930843060e025e3c0f17ec1393cfdafb26.1648757961.git.christophe.jaillet@wanadoo.fr
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/soc/soc-pcm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
> index 9a954680d492..11c9853e9e80 100644
> --- a/sound/soc/soc-pcm.c
> +++ b/sound/soc/soc-pcm.c
> @@ -1214,7 +1214,7 @@ static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
>   		be_substream->pcm->nonatomic = 1;
>   	}
>   
> -	dpcm = kzalloc(sizeof(struct snd_soc_dpcm), GFP_ATOMIC);
> +	dpcm = kzalloc(sizeof(struct snd_soc_dpcm), GFP_KERNEL);
>   	if (!dpcm)
>   		return -ENOMEM;
>   
