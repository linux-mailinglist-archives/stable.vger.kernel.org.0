Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4341854131E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358048AbiFGT4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358765AbiFGTxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:09 -0400
Received: from mail.tpi.com (mail.tpi.com [50.126.108.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279472494B;
        Tue,  7 Jun 2022 11:22:19 -0700 (PDT)
Received: from [10.0.0.212] (sushi.tpi.com [10.0.0.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.tpi.com (Postfix) with ESMTPSA id 0508747EC7AC;
        Tue,  7 Jun 2022 11:22:19 -0700 (PDT)
Message-ID: <2527f90b-eb5a-98ce-6b7f-d3b048a7dd8c@tpi.com>
Date:   Tue, 7 Jun 2022 11:22:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Dean Gehnert <deang@tpi.com>
Subject: Re: [PATCH] ASoC: topology: Avoid card NULL deref in
 snd_soc_tplg_component_remove()
Reply-To: deang@tpi.com
To:     =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.com>,
        stable@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <20220603201425.2590-1-deang@tpi.com>
 <238510b7-fc5f-4f1b-9e25-6e38b49c2535@linux.intel.com>
Content-Language: en-US
Organization: TriplePoint, Inc.
In-Reply-To: <238510b7-fc5f-4f1b-9e25-6e38b49c2535@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/22 00:40, Amadeusz Sławiński wrote:
> On 6/3/2022 10:14 PM, Dean Gehnert wrote:
>> Don't deference card in comp->card->snd_card before checking for NULL card.
>>
>> During the unloading of ASoC kernel modules, there is a kernel oops in
>> snd_soc_tplg_component_remove() that happens because comp->card is set to
>> NULL in soc_cleanup_component().
>>
>> Cc: Liam Girdwood <lgirdwood@gmail.com>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Jaroslav Kysela <perex@perex.cz>
>> Cc: Takashi Iwai <tiwai@suse.com>
>> Cc: alsa-devel@alsa-project.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Fixes: 7e567b5ae063 ("ASoC: topology: Add missing rwsem around snd_ctl_remove() calls")
>> Signed-off-by: Dean Gehnert <deang@tpi.com>
>> ---
>>   sound/soc/soc-topology.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
>> index 3f9d314fba16..cf0efe1147c2 100644
>> --- a/sound/soc/soc-topology.c
>> +++ b/sound/soc/soc-topology.c
>> @@ -2613,15 +2613,18 @@ EXPORT_SYMBOL_GPL(snd_soc_tplg_component_load);
>>   /* remove dynamic controls from the component driver */
>>   int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
>>   {
>> -    struct snd_card *card = comp->card->snd_card;
>> +    struct snd_card *card;
>>       struct snd_soc_dobj *dobj, *next_dobj;
>>       int pass;
>>         /* process the header types from end to start */
>>       for (pass = SOC_TPLG_PASS_END; pass >= SOC_TPLG_PASS_START; pass--) {
>>   +        card = (comp->card) ? comp->card->snd_card : NULL;
>> +
>>           /* remove mixer controls */
>> -        down_write(&card->controls_rwsem);
>> +        if (card)
>> +            down_write(&card->controls_rwsem);
>>           list_for_each_entry_safe(dobj, next_dobj, &comp->dobj_list,
>>               list) {
>
> I'm pretty sure that quite a lot of operations in this list_for_each_entry_safe() loop require existing card...
I get your point... Many of the cases in the loop, the functions are also dereferencing 'comp->card->', so this patch may not be the actual root cause fix... It worked for us since the kernel oops no longer happens, but looks like there are many more dereferences that could still cause problems.
>
> And trying to investigate more closely, there is no soc_cleanup_component() mentioned in commit message, for quite a few kernel versions - seems to have been removed during v5.5-rc1.
Ah yes! You are correct. soc_cleanup_component() functionality has been moved to soc_remove_component() in later kernels.
>
> I would say to not merge this, unless problem can be reproduced with latest kernel and even then would consider if it is a correct fix.
Agreed... This patch made our our kernel oops go away, however, we are going to dig deeper into the kernel oops call stack to see if I can find the root cause problem. There is something going on with the sound cleanup since this happens during rmmod... We just need to dig deeper and see if we can find what is really causing the problems.
>
>>   @@ -2660,7 +2663,8 @@ int snd_soc_tplg_component_remove(struct snd_soc_component *comp)
>>                   break;
>>               }
>>           }
>> -        up_write(&card->controls_rwsem);
>> +        if (card)
>> +            up_write(&card->controls_rwsem);
>>       }
>>         /* let caller know if FW can be freed when no objects are left */
>
