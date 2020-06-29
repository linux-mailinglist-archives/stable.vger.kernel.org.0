Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8338220D519
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgF2TOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731795AbgF2TOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:14:24 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0433C061755;
        Mon, 29 Jun 2020 04:05:33 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: eballetbo)
        with ESMTPSA id E26C72A2184
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Chanwoo Choi <cw00.choi@samsung.com>, Marc Zyngier <maz@kernel.org>
Cc:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <CGME20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569@epcas1p2.samsung.com>
 <20200622152824.1054946-1-maz@kernel.org>
 <784808d7-8943-44ab-f15a-34821e6d4d5f@samsung.com>
 <87tuyue142.wl-maz@kernel.org>
 <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
From:   Enric Balletbo i Serra <enric.balletbo@collabora.com>
Message-ID: <3de68490-d788-e416-dd5f-d4d6e7eca61a@collabora.com>
Date:   Mon, 29 Jun 2020 13:05:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chanwoo and Marc,

On 29/6/20 13:09, Chanwoo Choi wrote:
> Hi Enric,
> 
> Could you check this issue? Your patch[1] causes this issue.
> As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
> as the mandatory property, your patch[1] didn't add the 'rockchip,pmu'
> property to the documentation. 
> 

I think the problem is that the DT binding patch, for some reason, was missed
and didn't land. The patch seems to have all the required reviews and acks.

  https://patchwork.kernel.org/patch/10901593/

Sorry because I didn't notice this issue when 9173c5ceb035 landed. And thanks
for fixing the issue.

Best regards,
 Enric

> [1] 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT
> and auto power down parameters to TF-A.")
> 
> 
> On 6/29/20 5:18 PM, Marc Zyngier wrote:
>> Hi Chanwoo,
>>
>> On Mon, 29 Jun 2020 03:43:37 +0100,
>> Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 6/23/20 12:28 AM, Marc Zyngier wrote:
>>
>> [...]
>>
>>> It looks good to me. But, I think that it is not necessary
>>> fully kernel panic log about NULL pointer. It is enoughspsp
>>> just mentioning the NULL pointer issue without full kernel panic log.
>>
>> I personally find the backtrace useful as it allows people with the
>> same issue to trawl the kernel log and find whether it has already be
>> fixed upstream. But it's only me, and I'm not attached to it.
>>
>>> So, how about editing the patch description as following or others simply?
>>> and we need to add 'stable@vger.kernel.org' to Cc list for applying it
>>> to stable branch.
>>
>> Looks good to me.
>>
>>>
>>>
>>>   PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
>>>
>>>     Booting a recent kernel on a rk3399-based system (nanopc-t4),
>>>     equipped with a recent u-boot and ATF results in the kernel panic
>>>     about NULL pointer issue.
>>
>> nit: "results in a kernel panic on dereferencing a NULL pointer".
>>
>>>
>>>     This turns out to be due to the rk3399-dmc driver looking for
>>>     an *undocumented* property (rockchip,pmu), and happily using
>>>     a NULL pointer when the property isn't there.
>>>
>>>     Instead, make most of what was brought in with 9173c5ceb035
>>>     ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
>>>     to TF-A.") conditioned on finding this property in the device-tree,
>>>     preventing the driver from exploding.
>>>
>>>     Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
>>>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>     Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>
>>
>> Note that the biggest issue is still there: the driver is using an
>> undocumented property, and this patch is just papering over it.
>> Since I expect this property to be useful for something, it would be
>> good for whoever knows what it does to document it.
> 
> Hi Marc,
> 
> You are right. We have to do two step:
> 1. Add missing explanation of 'rockchip,pmu' property to dt-binding document
> 2. If possible, add 'rockchip,pmu' property node to rk3399_dmc dt node.
> 
> When I tried to find usage example of 'rockchip,pmu' property,
> I found them as following: The 'rockchip,pmu' property[2] indicates
> 'PMU (Power Management Unit)'. 
> 
> $ grep -rn "rockchip,pmu" arch/arm64/boot/dts/
> arch/arm64/boot/dts/rockchip/px30.dtsi:1211:		rockchip,pmu = <&pmugrf>;
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:1909:		rockchip,pmu = <&pmugrf>;
> arch/arm64/boot/dts/rockchip/rk3368.dtsi:807:		rockchip,pmu = <&pmugrf>;
> 
> [2] the description of 'rockchip,pmu' property
> - https://elixir.bootlin.com/linux/v5.7.2/source/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt#L40
> 
> 
> If don't receive the any reply, I'll add as following:
> 
> cwchoi00@chan-linux-pc:~/kernel/git.kernel/linux.chanwoo$ d
> diff --git a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
> index 0ec68141f85a..161e60ea874b 100644
> --- a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
> +++ b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
> @@ -18,6 +18,8 @@ Optional properties:
>                          format depends on the interrupt controller.
>                          It should be a DCF interrupt. When DDR DVFS finishes
>                          a DCF interrupt is triggered.
> +- rockchip,pmu:                 Phandle to the syscon managing the "pmu general
> +                        register files".
>  
>  Following properties relate to DDR timing:
>  
> 
> 
