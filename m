Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76E20D4AC
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgF2TKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:10:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16423 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgF2TKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:10:41 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200629120111epoutp01ad88341ae8aa6a395182d21812120235~dAgbEKDEE2747127471epoutp010
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 12:01:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200629120111epoutp01ad88341ae8aa6a395182d21812120235~dAgbEKDEE2747127471epoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593432071;
        bh=Nkwx+fzu3X0xc6Y/GQe/dfl93aOi9to2z0NjebNWLAk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=S4KcnfRxe8kvj+5KLtOW02fH0HRyd7Rlm2Wcnc/PrRxLqT7+8v//oYwOwqZFtimGv
         k+dut8KvSVROgRD7sVdAPQQrctLvRuZfg2jGcaZO3MAcLKPkgOVcV9Vmua5ixJ88fP
         LyLkPE6R17zgeKuRRhMdW3BNPEHYs1RT2hRQgmug=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200629120110epcas1p40f28ff568b492deb15a1eb663584ef3c~dAgae_U0E3257632576epcas1p4_;
        Mon, 29 Jun 2020 12:01:10 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.157]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49wR0N3krPzMqYlp; Mon, 29 Jun
        2020 12:01:08 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.07.28578.408D9FE5; Mon, 29 Jun 2020 21:01:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200629120107epcas1p3d599c93a005a36d3caba86785d27da27~dAgXxD_z71595315953epcas1p3u;
        Mon, 29 Jun 2020 12:01:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200629120107epsmtrp1088d1483b95573ad0fbe7ba43562b3d2~dAgXwTlHr1642016420epsmtrp1B;
        Mon, 29 Jun 2020 12:01:07 +0000 (GMT)
X-AuditID: b6c32a39-8c9ff70000006fa2-bd-5ef9d804583f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.C9.08303.308D9FE5; Mon, 29 Jun 2020 21:01:07 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629120107epsmtip246ec2fee9326708f827b30a009d3db48~dAgXcx1352885228852epsmtip2e;
        Mon, 29 Jun 2020 12:01:07 +0000 (GMT)
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <566d2f93-b5ff-b583-3965-83d4b9188c36@samsung.com>
Date:   Mon, 29 Jun 2020 21:12:18 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <267623b3-9fc5-886e-3554-b86fa1e57ccb@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmri7LjZ9xBvv/S1msuX2I0eL/o9es
        Fju2i1icbXrDbnF51xw2i8+9Rxgtds45yWpxu3EFm8WCjY8YHTg9tu3exuqx4+4SRo9NqzrZ
        PPq2rGL02H5tHrPH501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgosC/SKE3OL
        S/PS9ZLzc60MDQyMTIEKE7Iztn+5ylawTL9iXusv9gbGX6pdjJwcEgImEvNXb2TuYuTiEBLY
        wSgx68E5dgjnE6NEy7mzTBDOZ0aJaz+fAzkcYC0Nf6Hiuxgler6vZAIZJSTwnlFi4vciEFtY
        IF7iRssdVhBbRCBKov/jN7AGZoFJTBKTln0AS7AJaEnsf3GDDcTmF1CUuPrjMSOIzStgJ3H9
        0hawoSwCqhIr3s0Es0UFwiRObmuBqhGUODnzCQvIQZwCjhJ/PgaDhJkFxCVuPZnPBGHLS2x/
        OwfsNQmBHRwSJzoOsEI84CIx/SsvxPvCEq+Ob2GHsKUkXva3QdnVEitPHmGD6O1glNiy/wIr
        RMJYYv/SyeCAYBbQlFi/Sx8irCix8/dcRoi9fBLvvvZAreKV6GgTgihRlrj84C4ThC0psbi9
        k20Co9IsJM/MQvLBLCQfzEJYtoCRZRWjWGpBcW56arFhgSlyXG9iBCdXLcsdjNPfftA7xMjE
        wXiIUYKDWUmE97P1tzgh3pTEyqrUovz4otKc1OJDjKbA4J3ILCWanA9M73kl8YamRsbGxhYm
        hmamhoZK4rxO1hfihATSE0tSs1NTC1KLYPqYODilGpjW+N7MFS38GxJxlO94uQYbVzzHzoUb
        hQ5/0/2/nWnDlV+2Ng/+fplz86DSdhnR+JpZDzbsWXD+g7Jn7Iwl5cn9h5SDEpLTNncZ+58N
        +7h1+29xud3beurudb3475Dy5Le+zKzm/8w+3cdkZv3fzPCB2/3wM+7HihbPts/8Ez1dWuzy
        scz+VXfuMhVqzzzad5TxJtNrhZZTv5trc3dZr/Tu+dbr8ujWuUbGz5P3mfKL6Z1Jm1O883GZ
        g8zNoIPhFbovbKfczll24tyf3g0ace8Dvv5gPBmRrbN48cWmm7xxD99JzYjg+9L/++wPjnzj
        zXL/9+Qt+z75z9k7gq8XOvS5zO6+Vb5e1iFIP6lI89eiq0osxRmJhlrMRcWJADb1Pfc3BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvC7zjZ9xBqv6FS3W3D7EaPH/0WtW
        ix3bRSzONr1ht7i8aw6bxefeI4wWO+ecZLW43biCzWLBxkeMDpwe23ZvY/XYcXcJo8emVZ1s
        Hn1bVjF6bL82j9nj8ya5ALYoLpuU1JzMstQifbsEroztX66yFSzTr5jX+ou9gfGXahcjB4eE
        gIlEw1+mLkYuDiGBHYwSpx8uY+ti5ASKS0pMu3iUGaJGWOLw4WKImreMEo8/PWAFqREWiJe4
        0XIHzBYRiJI41HOHHaSIWWAKk8T9P7vZIDq2M0usebyZBaSKTUBLYv+LG2Ab+AUUJa7+eMwI
        YvMK2Elcv7SFCcRmEVCVWPFuJpgtKhAmsXPJYyaIGkGJkzOfsIBcxCngKPHnYzBImFlAXeLP
        vEvMELa4xK0n85kgbHmJ7W/nME9gFJ6FpHsWkpZZSFpmIWlZwMiyilEytaA4Nz232LDAKC+1
        XK84Mbe4NC9dLzk/dxMjONK0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHez9bf4oR4UxIrq1KL8uOL
        SnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXAdE5H0CJ27ZNpnMWBl+9MjXWa
        ut5twakjV36Knj3G7XPw4KR5/+ct2SV26lFS5fTZ7q9394n2lstqbHh+Ze3nf0Hzqh/+DFe2
        fRSp6n376ny1pRnyNf6cBp+bls06XvOK54LU9LqWq+dtVBv23vylcEP7/C53V5mb0T63cjy2
        3HMImyRYN+msRv6TAyvXcYq6NOje8WEPP7DF9p3ZdVmpNP51aQ2LL97ZnarbuCsz4nr34jdN
        C7eY3Jiw9d0Cfrf1BobqRRYNMuz/3239LLa2/f+WSRG9FYbhR7g2tYSfDApPeCd0vsLoo3vE
        +wtGc7M1U/o/aN5t3jGroHN24aya0jMP8pynaJ2Sl7HoY0k9HKPEUpyRaKjFXFScCADYtlxw
        IwMAAA==
X-CMS-MailID: 20200629120107epcas1p3d599c93a005a36d3caba86785d27da27
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569
References: <CGME20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569@epcas1p2.samsung.com>
        <20200622152824.1054946-1-maz@kernel.org>
        <784808d7-8943-44ab-f15a-34821e6d4d5f@samsung.com>
        <87tuyue142.wl-maz@kernel.org>
        <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
        <3de68490-d788-e416-dd5f-d4d6e7eca61a@collabora.com>
        <154fe5b6-6a05-c2b7-3014-2f7b9c2049f9@samsung.com>
        <267623b3-9fc5-886e-3554-b86fa1e57ccb@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Enric,

On 6/29/20 8:26 PM, Enric Balletbo i Serra wrote:
> Hi Chanwoo,
> 
> On 29/6/20 13:29, Chanwoo Choi wrote:
>> Hi Enric and Mark,
>>
>> On 6/29/20 8:05 PM, Enric Balletbo i Serra wrote:
>>> Hi Chanwoo and Marc,
>>>
>>> On 29/6/20 13:09, Chanwoo Choi wrote:
>>>> Hi Enric,
>>>>
>>>> Could you check this issue? Your patch[1] causes this issue.
>>>> As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
>>>> as the mandatory property, your patch[1] didn't add the 'rockchip,pmu'
>>>> property to the documentation. 
>>>>
>>>
>>> I think the problem is that the DT binding patch, for some reason, was missed
>>> and didn't land. The patch seems to have all the required reviews and acks.
>>>
>>>   https://patchwork.kernel.org/patch/10901593/
>>>
>>> Sorry because I didn't notice this issue when 9173c5ceb035 landed. And thanks
>>> for fixing the issue.
>>
>> If the 'rockchip,pmu' propery is mandatory, instead of Mark's patch,
>> we better to require the merge of patch[1] to DT maintainer.
>>
>> [1] https://patchwork.kernel.org/patch/10901593/
>>
> 
> Give me some time to double check, because I think that at this point, is needed
> on some devices with old firmware but not now. It's been a while since I worked
> on this, but I suspect that being optional is the right way.

OK. Thanks for your reply.

> 
> Maybe Heiko, who IIRC worked on TF-A has a more clear thought on this?
> 
> Thanks,
>  Enric
> 
>>>
>>> Best regards,
>>>  Enric
>>>
>>>> [1] 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT
>>>> and auto power down parameters to TF-A.")
>>>>
>>>>
>>>> On 6/29/20 5:18 PM, Marc Zyngier wrote:
>>>>> Hi Chanwoo,
>>>>>
>>>>> On Mon, 29 Jun 2020 03:43:37 +0100,
>>>>> Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 6/23/20 12:28 AM, Marc Zyngier wrote:
>>>>>
>>>>> [...]
>>>>>
>>>>>> It looks good to me. But, I think that it is not necessary
>>>>>> fully kernel panic log about NULL pointer. It is enoughspsp
>>>>>> just mentioning the NULL pointer issue without full kernel panic log.
>>>>>
>>>>> I personally find the backtrace useful as it allows people with the
>>>>> same issue to trawl the kernel log and find whether it has already be
>>>>> fixed upstream. But it's only me, and I'm not attached to it.
>>>>>
>>>>>> So, how about editing the patch description as following or others simply?
>>>>>> and we need to add 'stable@vger.kernel.org' to Cc list for applying it
>>>>>> to stable branch.
>>>>>
>>>>> Looks good to me.
>>>>>
>>>>>>
>>>>>>
>>>>>>   PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
>>>>>>
>>>>>>     Booting a recent kernel on a rk3399-based system (nanopc-t4),
>>>>>>     equipped with a recent u-boot and ATF results in the kernel panic
>>>>>>     about NULL pointer issue.
>>>>>
>>>>> nit: "results in a kernel panic on dereferencing a NULL pointer".
>>>>>
>>>>>>
>>>>>>     This turns out to be due to the rk3399-dmc driver looking for
>>>>>>     an *undocumented* property (rockchip,pmu), and happily using
>>>>>>     a NULL pointer when the property isn't there.
>>>>>>
>>>>>>     Instead, make most of what was brought in with 9173c5ceb035
>>>>>>     ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
>>>>>>     to TF-A.") conditioned on finding this property in the device-tree,
>>>>>>     preventing the driver from exploding.
>>>>>>
>>>>>>     Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
>>>>>>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>>>     Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>
>>>>>
>>>>> Note that the biggest issue is still there: the driver is using an
>>>>> undocumented property, and this patch is just papering over it.
>>>>> Since I expect this property to be useful for something, it would be
>>>>> good for whoever knows what it does to document it.
>>>>
>>>> Hi Marc,
>>>>
>>>> You are right. We have to do two step:
>>>> 1. Add missing explanation of 'rockchip,pmu' property to dt-binding document
>>>> 2. If possible, add 'rockchip,pmu' property node to rk3399_dmc dt node.
>>>>
>>>> When I tried to find usage example of 'rockchip,pmu' property,
>>>> I found them as following: The 'rockchip,pmu' property[2] indicates
>>>> 'PMU (Power Management Unit)'. 
>>>>
>>>> $ grep -rn "rockchip,pmu" arch/arm64/boot/dts/
>>>> arch/arm64/boot/dts/rockchip/px30.dtsi:1211:		rockchip,pmu = <&pmugrf>;
>>>> arch/arm64/boot/dts/rockchip/rk3399.dtsi:1909:		rockchip,pmu = <&pmugrf>;
>>>> arch/arm64/boot/dts/rockchip/rk3368.dtsi:807:		rockchip,pmu = <&pmugrf>;
>>>>
>>>> [2] the description of 'rockchip,pmu' property
>>>> - https://protect2.fireeye.com/url?k=e55f0ba3-b8384f85-e55e80ec-0cc47a31384a-d9c5f6b28aba9be6&q=1&u=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.7.2%2Fsource%2FDocumentation%2Fdevicetree%2Fbindings%2Fpinctrl%2Frockchip%2Cpinctrl.txt%23L40
>>>>
>>>>
>>>> If don't receive the any reply, I'll add as following:
>>>>
>>>> cwchoi00@chan-linux-pc:~/kernel/git.kernel/linux.chanwoo$ d
>>>> diff --git a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>>>> index 0ec68141f85a..161e60ea874b 100644
>>>> --- a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>>>> +++ b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>>>> @@ -18,6 +18,8 @@ Optional properties:
>>>>                          format depends on the interrupt controller.
>>>>                          It should be a DCF interrupt. When DDR DVFS finishes
>>>>                          a DCF interrupt is triggered.
>>>> +- rockchip,pmu:                 Phandle to the syscon managing the "pmu general
>>>> +                        register files".
>>>>  
>>>>  Following properties relate to DDR timing:
>>>>  
>>>>
>>>>
>>>
>>>
>>
>>
> 
> 


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
