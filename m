Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DAA4EA53A
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 04:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiC2Cfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 22:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiC2Cfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 22:35:50 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B961116E;
        Mon, 28 Mar 2022 19:34:04 -0700 (PDT)
X-UUID: bf9bfe96da7f47e8a2ae7259817316b0-20220329
X-UUID: bf9bfe96da7f47e8a2ae7259817316b0-20220329
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <trevor.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 640139202; Tue, 29 Mar 2022 10:34:00 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 29 Mar 2022 10:33:58 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Mar 2022 10:33:58 +0800
Message-ID: <eef98cc24f75f9712acd3fe5e597d49140cbc943.camel@mediatek.com>
Subject: Re: [PATCH] mediatek: mt8195: fix a missing check on list iterator
From:   Trevor Wu <trevor.wu@mediatek.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.com>,
        <matthias.bgg@gmail.com>
CC:     <tzungbi@google.com>, <dan.carpenter@oracle.com>,
        <jiaxin.yu@mediatek.com>, <rikard.falkeborn@gmail.com>,
        <yc.hung@mediatek.com>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date:   Tue, 29 Mar 2022 10:33:58 +0800
In-Reply-To: <20220327081712.13341-1-xiam0nd.tong@gmail.com>
References: <20220327081712.13341-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2022-03-27 at 16:17 +0800, Xiaomeng Tong wrote:
> The bug is here:
>  mt8195_etdm_hw_params_fixup(runtime, params);
> 
> For the for_each_card_rtds(), just like list_for_each_entry(),
> the list iterator 'runtime' will point to a bogus position
> containing HEAD if the list is empty or no element is found.
> This case must be checked before any use of the iterator,
> otherwise it will lead to a invalid memory access.
> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'runtime' as a dedicated poin
> ter
> to point to the found element.

Hi Xiaomeng,

About this bug, I think it won't happen anymore.

mt8195_dai_link_fixup() is only assigned when the corresponding
snd_soc_pcm_runtime is found
in mt8195_mt6359_rt1019_rt5682_late_probe().

On the other hand, runtime is not used in the body of
mt8195_etdm_hw_params_fixup().

That's why I think the problem doesn't exist.
If I misunderstood the problem you pointed out, please correct me.

Thanks,
Trevor
> 
> Cc: stable@vger.kernel.org
> Fixes: 3d00d2c07f04f ("ASoC: mediatek: mt8195: add sof support on
> mt8195-mt6359-rt1019-rt5682")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  .../mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c  | 14 ++++++++--
> ----
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
> b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
> index 29c2d3407cc7..dc91877e4c3c 100644
> --- a/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
> +++ b/sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c
> @@ -814,7 +814,7 @@ static int mt8195_dai_link_fixup(struct
> snd_soc_pcm_runtime *rtd,
>  {
>  	struct snd_soc_card *card = rtd->card;
>  	struct snd_soc_dai_link *sof_dai_link = NULL;
> -	struct snd_soc_pcm_runtime *runtime;
> +	struct snd_soc_pcm_runtime *runtime = NULL, *iter;
>  	struct snd_soc_dai *cpu_dai;
>  	int i, j, ret = 0;
>  
> @@ -824,16 +824,17 @@ static int mt8195_dai_link_fixup(struct
> snd_soc_pcm_runtime *rtd,
>  		if (strcmp(rtd->dai_link->name, conn->normal_link))
>  			continue;
>  
> -		for_each_card_rtds(card, runtime) {
> -			if (strcmp(runtime->dai_link->name, conn-
> >sof_link))
> +		for_each_card_rtds(card, iter) {
> +			if (strcmp(iter->dai_link->name, conn-
> >sof_link))
>  				continue;
>  
> -			for_each_rtd_cpu_dais(runtime, j, cpu_dai) {
> +			for_each_rtd_cpu_dais(iter, j, cpu_dai) {
>  				if (cpu_dai->stream_active[conn-
> >stream_dir] > 0) {
> -					sof_dai_link = runtime-
> >dai_link;
> +					sof_dai_link = iter->dai_link;
>  					break;
>  				}
>  			}
> +			runtime = iter;
>  			break;
>  		}
>  
> @@ -845,7 +846,8 @@ static int mt8195_dai_link_fixup(struct
> snd_soc_pcm_runtime *rtd,
>  
>  	if (!strcmp(rtd->dai_link->name, "ETDM2_IN_BE") ||
>  	    !strcmp(rtd->dai_link->name, "ETDM1_OUT_BE")) {
> -		mt8195_etdm_hw_params_fixup(runtime, params);
> +		if (runtime)
> +			mt8195_etdm_hw_params_fixup(runtime, params);
>  	}
>  
>  	return ret;

