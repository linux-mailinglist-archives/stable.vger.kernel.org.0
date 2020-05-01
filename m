Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705C21C11BA
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgEAL5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 07:57:34 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59674 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgEAL5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 07:57:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id DD19F2A2F63
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on
 meson-g12a-x96-max
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
References: <5eabecbf.1c69fb81.2c617.628f@mx.google.com>
Cc:     kernelci@groups.io, Kevin Hilman <khilman@baylibre.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com>
Date:   Fri, 1 May 2020 12:57:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5eabecbf.1c69fb81.2c617.628f@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please see the bisection report below about a kernel Oops.

Reports aren't automatically sent to the public while we're
trialing new bisection features on kernelci.org but this one
looks valid.

The log shows a kernel NULL pointer dereference:

  https://storage.kernelci.org/stable-rc/linux-5.4.y/v5.4.36-52-g35bbc55d9e29/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12a-x96-max.html#L1113

The call stack is not the same as in the commit message found by
the bisection, so maybe it only fixed part of the problem:

<1>[   16.007376] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
<1>[   16.016300] Mem abort info:
<1>[   16.019269]   ESR = 0x96000006
<1>[   16.022571]   EC = 0x25: DABT (current EL), IL = 32 bits
<1>[   16.028075]   SET = 0, FnV = 0
<1>[   16.031356]   EA = 0, S1PTW = 0
<1>[   16.034705] Data abort info:
<1>[   16.037837]   ISV = 0, ISS = 0x00000006
<1>[   16.041876]   CM = 0, WnR = 0
<1>[   16.045128] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000be0f0000
<1>[   16.051702] [0000000000000010] pgd=00000000be117003, pud=00000000be118003, pmd=0000000000000000
<0>[   16.051709] Internal error: Oops: 96000006 [#1] PREEMPT SMP
<4>[   16.133466] CPU: 2 PID: 33 Comm: kworker/2:1 Tainted: G        W         5.4.37-rc1 #1
<4>[   16.141566] Hardware name: Shenzhen Amediatech Technology Co., Ltd X96 Max (DT)
<4>[   16.149087] Workqueue: events deferred_probe_work_func
<4>[   16.154419] pstate: 20000005 (nzCv daif -PAN -UAO)
<4>[   16.159428] pc : snd_soc_dapm_new_dai+0x3c/0x1b0
<4>[   16.164252] lr : snd_soc_dapm_connect_dai_link_widgets+0x114/0x268
<4>[   16.256970] Call trace:
<4>[   16.259647]  snd_soc_dapm_new_dai+0x3c/0x1b0
<4>[   16.264129]  snd_soc_dapm_connect_dai_link_widgets+0x114/0x268
<4>[   16.270167]  snd_soc_instantiate_card+0x858/0xb88
<4>[   16.275083]  snd_soc_register_card+0xf8/0x120
<4>[   16.279656]  devm_snd_soc_register_card+0x40/0x90
<4>[   16.284575]  axg_card_probe+0x9dc/0xaf0 [snd_soc_meson_axg_sound_card]
<4>[   16.291299]  platform_drv_probe+0x50/0xa0
<4>[   16.295524]  really_probe+0xd4/0x328
<4>[   16.299319]  driver_probe_device+0x54/0xe8
...


Guillaume


On 01/05/2020 10:32, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on meson-g12a-x96-max
> 
> Summary:
>   Start:      35bbc55d9e296 Linux 5.4.37-rc1
>   Plain log:  https://storage.kernelci.org/stable-rc/linux-5.4.y/v5.4.36-52-g35bbc55d9e29/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12a-x96-max.txt
>   HTML log:   https://storage.kernelci.org/stable-rc/linux-5.4.y/v5.4.36-52-g35bbc55d9e29/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12a-x96-max.html
>   Result:     09f4294793bd3 ASoC: meson: axg-card: fix codec-to-codec link setup
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   Branch:     linux-5.4.y
>   Target:     meson-g12a-x96-max
>   CPU arch:   arm64
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     defconfig
>   Test case:  baseline.dmesg.alert
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit 09f4294793bd3e70d68fdab5b392dff18bff62ca
> Author: Jerome Brunet <jbrunet@baylibre.com>
> Date:   Mon Apr 20 13:45:10 2020 +0200
> 
>     ASoC: meson: axg-card: fix codec-to-codec link setup
>     
>     commit 1164284270779e1865cc2046a2a01b58a1e858a9 upstream.
>     
>     Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
>     playback/capture if supported"), meson-axg cards which have codec-to-codec
>     links fail to init and Oops:
>     
>       Unable to handle kernel NULL pointer dereference at virtual address 0000000000000128
>       Internal error: Oops: 96000044 [#1] PREEMPT SMP
>       CPU: 3 PID: 1582 Comm: arecord Not tainted 5.7.0-rc1
>       pc : invalidate_paths_ep+0x30/0xe0
>       lr : snd_soc_dapm_dai_get_connected_widgets+0x170/0x1a8
>       Call trace:
>        invalidate_paths_ep+0x30/0xe0
>        snd_soc_dapm_dai_get_connected_widgets+0x170/0x1a8
>        dpcm_path_get+0x38/0xd0
>        dpcm_fe_dai_open+0x70/0x920
>        snd_pcm_open_substream+0x564/0x840
>        snd_pcm_open+0xfc/0x228
>        snd_pcm_capture_open+0x4c/0x78
>        snd_open+0xac/0x1a8
>        ...
>     
>     While initiliazing the links, ASoC treats the codec-to-codec links of this
>     card type as a DPCM backend. This error eventually leads to the Oops.
>     
>     Most of the card driver code is shared between DPCM backends and
>     codec-to-codec links. The property "no_pcm" marking DCPM BE was left set on
>     codec-to-codec links, leading to this problem. This commit fixes that.
>     
>     Fixes: 0a8f1117a680 ("ASoC: meson: axg-card: add basic codec-to-codec link support")
>     Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>     Link: https://lore.kernel.org/r/20200420114511.450560-2-jbrunet@baylibre.com
>     Signed-off-by: Mark Brown <broonie@kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
> index 1f698adde506c..2b04ac3d8fd3b 100644
> --- a/sound/soc/meson/axg-card.c
> +++ b/sound/soc/meson/axg-card.c
> @@ -586,8 +586,10 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
>  
>  	if (axg_card_cpu_is_tdm_iface(dai_link->cpus->of_node))
>  		ret = axg_card_parse_tdm(card, np, index);
> -	else if (axg_card_cpu_is_codec(dai_link->cpus->of_node))
> +	else if (axg_card_cpu_is_codec(dai_link->cpus->of_node)) {
>  		dai_link->params = &codec_params;
> +		dai_link->no_pcm = 0; /* link is not a DPCM BE */
> +	}
>  
>  	return ret;
>  }
> -------------------------------------------------------------------------------
> 
> 
> Git bisection log:
> 
> -------------------------------------------------------------------------------
> git bisect start
> # good: [aa73bcc376865c23e61dcebd467697b527901be8] Linux 5.4.36
> git bisect good aa73bcc376865c23e61dcebd467697b527901be8
> # bad: [35bbc55d9e296d37cf01555d415338b84a70d4c5] Linux 5.4.37-rc1
> git bisect bad 35bbc55d9e296d37cf01555d415338b84a70d4c5
> # bad: [924f1d37852ff357658c205dd114c70862865fc9] svcrdma: Fix trace point use-after-free race
> git bisect bad 924f1d37852ff357658c205dd114c70862865fc9
> # good: [b848f65436665b5fe675fd3f645c1a458e49f60a] counter: 104-quad-8: Add lock guards - generic interface
> git bisect good b848f65436665b5fe675fd3f645c1a458e49f60a
> # bad: [04b53ed855129c1703d00d8494e4c61309714a99] drivers: soc: xilinx: fix firmware driver Kconfig dependency
> git bisect bad 04b53ed855129c1703d00d8494e4c61309714a99
> # good: [ae886eae0318c71a6125347d6810a1578a83d262] ASoC: tas571x: disable regulators on failed probe
> git bisect good ae886eae0318c71a6125347d6810a1578a83d262
> # bad: [2c0990070379284dda0b51304ce19c2b96e083a2] ASoC: wm8960: Fix wrong clock after suspend & resume
> git bisect bad 2c0990070379284dda0b51304ce19c2b96e083a2
> # bad: [09f4294793bd3e70d68fdab5b392dff18bff62ca] ASoC: meson: axg-card: fix codec-to-codec link setup
> git bisect bad 09f4294793bd3e70d68fdab5b392dff18bff62ca
> # first bad commit: [09f4294793bd3e70d68fdab5b392dff18bff62ca] ASoC: meson: axg-card: fix codec-to-codec link setup
> -------------------------------------------------------------------------------
> 

