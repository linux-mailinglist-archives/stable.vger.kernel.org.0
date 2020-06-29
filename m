Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B060A20E067
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgF2Up7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:45:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64471 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731551AbgF2TNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:13:55 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200629105805epoutp04d7f0485cec4dab729fc5779a525257bb~c-pVd8yVk0072900729epoutp04_
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 10:58:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200629105805epoutp04d7f0485cec4dab729fc5779a525257bb~c-pVd8yVk0072900729epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593428285;
        bh=VMvsCOc0g1L/vP8ASue9l/AZQpxWrUwtrbzi63icst4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=UEvs/kAnbxEs7PkgCuILzGqE4gX6LPZRbqGmIBLDyfUBHenVJiT/qWGuZL+2tmE1B
         HjeS9UNfxg3xCB3c0pA0spgc3bH3FdW0JI5BQOZGpZ1KMZ90oAa6vB3zrlB+eAPQ5H
         gEscMiR56T11/SgOHJmmbz0+XSeSFpsMEJllcfm4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200629105805epcas1p1c0765f3c09240d1535cd2ed39bdd3340~c-pU-OWSU2867828678epcas1p1C;
        Mon, 29 Jun 2020 10:58:05 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.154]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49wPbZ6vSDzMqYlh; Mon, 29 Jun
        2020 10:58:02 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.85.29173.A39C9FE5; Mon, 29 Jun 2020 19:58:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200629105801epcas1p3b0d2f187ac1690d1e52c5565361a7fee~c-pR5x4Ni1179011790epcas1p3N;
        Mon, 29 Jun 2020 10:58:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200629105801epsmtrp1bd0a9bfd651093b33cacd691496690d6~c-pR1sGxT1334613346epsmtrp1t;
        Mon, 29 Jun 2020 10:58:01 +0000 (GMT)
X-AuditID: b6c32a37-9b7ff700000071f5-a1-5ef9c93a2186
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.46.08303.939C9FE5; Mon, 29 Jun 2020 19:58:01 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629105801epsmtip253245245720269e0ad401bb917495be1~c-pRhpRn12311523115epsmtip2x;
        Mon, 29 Jun 2020 10:58:01 +0000 (GMT)
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Marc Zyngier <maz@kernel.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
Date:   Mon, 29 Jun 2020 20:09:12 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <87tuyue142.wl-maz@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmga7VyZ9xBhfmmlqsuX2I0eL/o9es
        Fju2i1icbXrDbnF51xw2i8+9Rxgtds45yWpxu3EFm8WCjY8YHTg9tu3exuqx4+4SRo9NqzrZ
        PPq2rGL02H5tHrPH501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgosC/SKE3OL
        S/PS9ZLzc60MDQyMTIEKE7Iz7m/oZyz4q1BxYb57A2O3VBcjJ4eEgInE4S2rWboYuTiEBHYw
        Srxo3MUI4XxilOhp3c0KUiUk8JlR4ultJZiOtn3LmCGKdjFKXNi6gxXCec8ocb5hJRNIlbBA
        vMSNljtg3SICURKXez6BdTALTGKSmLTsA1iCTUBLYv+LG2wgNr+AosTVH48ZQWxeATuJZW0b
        wWwWAVWJlqMt7CC2qECYxMltLVA1ghInZz5hAbE5BbQl5nXMBZvDLCAucevJfCYIW15i+9s5
        YIslBNZySKxvfwfUwAHkuEj8OxUC8Y6wxKvjW9ghbCmJl/1tUHa1xMqTR9ggejsYJbbsv8AK
        kTCW2L90MhPIHGYBTYn1u/QhwooSO3/PZYTYyyfx7msPK8QqXomONiGIEmWJyw/uMkHYkhKL
        2zvZJjAqzULyzSwkH8xC8sEshGULGFlWMYqlFhTnpqcWGxYYI0f2JkZwetUy38E47e0HvUOM
        TByMhxglOJiVRHg/W3+LE+JNSaysSi3Kjy8qzUktPsRoCgzficxSosn5wASfVxJvaGpkbGxs
        YWJoZmpoqCTO62t1IU5IID2xJDU7NbUgtQimj4mDU6qBKd59lvaGpvvL3253+DHXen1Y/Vnp
        xJYMx+CyM0fuBJ2YFy3n3qh5xC01cLfdgjmqZ8P9MqcIHo33nvX+U1RW2bvNm7ec/7hRTrAi
        1XqxWHRY5LIezo3imj7vp3UeL3FcKCiy7VbA59qH753aj8bPO/ysM1RyRQnTg9KS8rtPOA/3
        Tq0t2P5863mtdZFVf02PrJiZtkxR5kolx7TbLiYsV56bLC+7aiOmYN7RZJG/KiLliZPE/j9G
        /U3Plv3SfnHuyjSfQ4ukXEXvL/Labr/yiWF37QYLo/3MXyMvHv8c862IW/xsTIwE74+nPaGC
        vty9l3pjAj917fKs3sR67+vxWe46nYnOa0MLliXXdfAfV2Ipzkg01GIuKk4EAPWzkgk4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXtfy5M84g+fnVS3W3D7EaPH/0WtW
        ix3bRSzONr1ht7i8aw6bxefeI4wWO+ecZLW43biCzWLBxkeMDpwe23ZvY/XYcXcJo8emVZ1s
        Hn1bVjF6bL82j9nj8ya5ALYoLpuU1JzMstQifbsEroz7G/oZC/4qVFyY797A2C3VxcjJISFg
        ItG2bxkziC0ksINR4n9PIERcUmLaxaNAcQ4gW1ji8OHiLkYuoJK3jBKXD8xgB6kRFoiXuNFy
        hxWkRkQgSuLGckaQGmaBKUwS9//sZoNouM8o0b51KiNIA5uAlsT+FzfYQGx+AUWJqz8eg8V5
        BewklrVtBLNZBFQlWo62gC0QFQiT2LnkMRNEjaDEyZlPWEBsTgFtiXkdc8HmMAuoS/yZd4kZ
        whaXuPVkPhOELS+x/e0c5gmMwrOQtM9C0jILScssJC0LGFlWMUqmFhTnpucWGxYY5aWW6xUn
        5haX5qXrJefnbmIEx5mW1g7GPas+6B1iZOJgPMQowcGsJML72fpbnBBvSmJlVWpRfnxRaU5q
        8SFGaQ4WJXHer7MWxgkJpCeWpGanphakFsFkmTg4pRqYRPbt81/zVrky3aFh3eZi1Zz9wtxt
        75Ze1FPguqmx34W/ZPryiYnZJjX/dvV4WavG5Xxe8txC7a/TCX5doXubH2TNPRrKX1PR+j14
        tZn02rMcf0/v33P0T1rli88dM12679kXblZQNlN2f1TVfF1qdpb559+xZhI31i3tU3sgoZDy
        vbHQTG2p9fqkOUcerHiusoJx17ZPIdEBwaGPNW5vVLnU2TJ5AyvHVZ9Xk354bymPmKTtrn/v
        xxb5aL31+zad2Ci+5OYGsQOtOaG5Fxj31z/be/i4tOiXmJrykypLUtXcl35Y0lKdLxRi7xS8
        xjHlnVHl+lPxj0M6phVELpUUOPPhWJ+C+p5oho2z+4tOK7EUZyQaajEXFScCAMwudCUiAwAA
X-CMS-MailID: 20200629105801epcas1p3b0d2f187ac1690d1e52c5565361a7fee
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
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Enric,

Could you check this issue? Your patch[1] causes this issue.
As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
as the mandatory property, your patch[1] didn't add the 'rockchip,pmu'
property to the documentation. 

[1] 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT
and auto power down parameters to TF-A.")


On 6/29/20 5:18 PM, Marc Zyngier wrote:
> Hi Chanwoo,
> 
> On Mon, 29 Jun 2020 03:43:37 +0100,
> Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>
>> Hi Marc,
>>
>> On 6/23/20 12:28 AM, Marc Zyngier wrote:
> 
> [...]
> 
>> It looks good to me. But, I think that it is not necessary
>> fully kernel panic log about NULL pointer. It is enoughspsp
>> just mentioning the NULL pointer issue without full kernel panic log.
> 
> I personally find the backtrace useful as it allows people with the
> same issue to trawl the kernel log and find whether it has already be
> fixed upstream. But it's only me, and I'm not attached to it.
> 
>> So, how about editing the patch description as following or others simply?
>> and we need to add 'stable@vger.kernel.org' to Cc list for applying it
>> to stable branch.
> 
> Looks good to me.
> 
>>
>>
>>   PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
>>
>>     Booting a recent kernel on a rk3399-based system (nanopc-t4),
>>     equipped with a recent u-boot and ATF results in the kernel panic
>>     about NULL pointer issue.
> 
> nit: "results in a kernel panic on dereferencing a NULL pointer".
> 
>>
>>     This turns out to be due to the rk3399-dmc driver looking for
>>     an *undocumented* property (rockchip,pmu), and happily using
>>     a NULL pointer when the property isn't there.
>>
>>     Instead, make most of what was brought in with 9173c5ceb035
>>     ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
>>     to TF-A.") conditioned on finding this property in the device-tree,
>>     preventing the driver from exploding.
>>
>>     Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
>>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>>     Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> 
> Note that the biggest issue is still there: the driver is using an
> undocumented property, and this patch is just papering over it.
> Since I expect this property to be useful for something, it would be
> good for whoever knows what it does to document it.

Hi Marc,

You are right. We have to do two step:
1. Add missing explanation of 'rockchip,pmu' property to dt-binding document
2. If possible, add 'rockchip,pmu' property node to rk3399_dmc dt node.

When I tried to find usage example of 'rockchip,pmu' property,
I found them as following: The 'rockchip,pmu' property[2] indicates
'PMU (Power Management Unit)'. 

$ grep -rn "rockchip,pmu" arch/arm64/boot/dts/
arch/arm64/boot/dts/rockchip/px30.dtsi:1211:		rockchip,pmu = <&pmugrf>;
arch/arm64/boot/dts/rockchip/rk3399.dtsi:1909:		rockchip,pmu = <&pmugrf>;
arch/arm64/boot/dts/rockchip/rk3368.dtsi:807:		rockchip,pmu = <&pmugrf>;

[2] the description of 'rockchip,pmu' property
- https://elixir.bootlin.com/linux/v5.7.2/source/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt#L40


If don't receive the any reply, I'll add as following:

cwchoi00@chan-linux-pc:~/kernel/git.kernel/linux.chanwoo$ d
diff --git a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
index 0ec68141f85a..161e60ea874b 100644
--- a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
+++ b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
@@ -18,6 +18,8 @@ Optional properties:
                         format depends on the interrupt controller.
                         It should be a DCF interrupt. When DDR DVFS finishes
                         a DCF interrupt is triggered.
+- rockchip,pmu:                 Phandle to the syscon managing the "pmu general
+                        register files".
 
 Following properties relate to DDR timing:
 


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
