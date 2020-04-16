Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7651AD075
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbgDPTjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:39:01 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4671 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgDPTjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 15:39:00 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e98b3e40000>; Thu, 16 Apr 2020 12:37:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 16 Apr 2020 12:38:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 16 Apr 2020 12:38:59 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 Apr
 2020 19:38:58 +0000
Received: from [10.2.171.241] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 Apr
 2020 19:38:56 +0000
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific set_timeout
 callback
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        "(Exiting) Baolin Wang" <baolin.wang@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        Aniruddha Tvs Rao <anrao@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        <lkft-triage@lists.linaro.org>,
        linux- stable <stable@vger.kernel.org>
References: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com>
 <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
 <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
 <753ec108-858c-660e-af0a-f57922134609@nvidia.com>
Message-ID: <512441d1-a9ba-912f-ed2e-46edad22278b@nvidia.com>
Date:   Thu, 16 Apr 2020 12:38:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <753ec108-858c-660e-af0a-f57922134609@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587065828; bh=yof6X6rV69zuRCOOErruqXvyViu+DLoQF5o7Ja8s66o=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=nx/sEQY+aDNWeB+UH9SVf4IMJhj910xm0DhgM0XdemImrdQv0A04QyPTOPdrZbaaH
         kxnwowMfDRxaDAXfjlBIN56Ksg4YOy0uHTn+Ff+54UY32A742M+O2swtVcaWtp70jL
         8yJ3vKw6Bmf/hWcyvzNUod5vb3v0zecv060Gp4ALmrr1Vv93BkIBOwseiP8Tqf3SBJ
         Exu5XAg/WXdX8ohkyIosK39pbcNKy691oBACr3DkcpQj+2BOxAdly1Q6TnJZlKTG4B
         +Zx9Hih3bZA0jbT1I9flwKbyKKSEpHlO+QPHfjAtnG64RCKLGZrg75TMKkHTK2+Wu0
         BzlNhlF/6MrSQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/16/20 9:29 AM, Sowjanya Komatineni wrote:
>
> On 4/16/20 3:59 AM, Ulf Hansson wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On Wed, 15 Apr 2020 at 19:55, Naresh Kamboju=20
>> <naresh.kamboju@linaro.org> wrote:
>>> On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
>>> <skomatineni@nvidia.com> wrote:
>>>> Tegra host supports HW busy detection and timeouts based on the
>>>> count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
>>>> timeout it supports is 11s in finite busy wait mode.
>>>>
>>>> Some operations like SLEEP_AWAKE, ERASE and flush cache through
>>>> SWITCH commands take longer than 11s and Tegra host supports
>>>> infinite HW busy wait mode where HW waits forever till the card
>>>> is busy without HW timeout.
>>>>
>>>> This patch implements Tegra specific set_timeout sdhci_ops to allow
>>>> switching between finite and infinite HW busy detection wait modes
>>>> based on the device command expected operation time.
>>>>
>>>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>>>> ---
>>>> =C2=A0 drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++=
++++
>>>> =C2=A0 1 file changed, 31 insertions(+)
>>>>
>>>> diff --git a/drivers/mmc/host/sdhci-tegra.c=20
>>>> b/drivers/mmc/host/sdhci-tegra.c
>>>> index a25c3a4..fa8f6a4 100644
>>>> --- a/drivers/mmc/host/sdhci-tegra.c
>>>> +++ b/drivers/mmc/host/sdhci-tegra.c
>>>> @@ -45,6 +45,7 @@
>>>> =C2=A0 #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 8
>>>>
>>>> =C2=A0 #define SDHCI_TEGRA_VENDOR_MISC_CTRL 0x120
>>>> +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT BIT(0)
>>>> =C2=A0 #define SDHCI_MISC_CTRL_ENABLE_SDR104=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x8
>>>> =C2=A0 #define SDHCI_MISC_CTRL_ENABLE_SDR50 0x10
>>>> =C2=A0 #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300 0x20
>>>> @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct=20
>>>> sdhci_host *host, u32 intmask)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>> =C2=A0 }
>>>>
>>>> +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mmc_com=
mand *cmd)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 val;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * HW busy detection timeou=
t is based on programmed data=20
>>>> timeout
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * counter and maximum supp=
orted timeout is 11s which may=20
>>>> not be
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * enough for long operatio=
ns like cache flush, sleep=20
>>>> awake, erase.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ERASE_TIMEOUT_LIMIT bit =
of VENDOR_MISC_CTRL register allows
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * host controller to wait =
for busy state until the card is=20
>>>> busy
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * without HW timeout.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, use infinite busy wa=
it mode for operations that may=20
>>>> take
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * more than maximum HW bus=
y timeout of 11s otherwise use=20
>>>> finite
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * busy wait mode.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D sdhci_readl(host, SDHCI_=
TEGRA_VENDOR_MISC_CTRL);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cmd && cmd->busy_timeout >=
=3D 11 * HZ)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 val |=3D SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 val &=3D ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdhci_writel(host, val, SDHCI_TE=
GRA_VENDOR_MISC_CTRL);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __sdhci_set_timeout(host, cmd);
>>> kernel build on arm and arm64 architecture failed on stable-rc 4.19
>>> (arm), 5.4 (arm64) and 5.5 (arm64)
>>>
>>> drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
>>> drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
>>> function '__sdhci_set_timeout'; did you mean
>>> 'tegra_sdhci_set_timeout'? [-Werror=3Dimplicit-function-declaration]
>>> =C2=A0=C2=A0 __sdhci_set_timeout(host, cmd);
>>> =C2=A0=C2=A0 ^~~~~~~~~~~~~~~~~~~
>>> =C2=A0=C2=A0 tegra_sdhci_set_timeout
>>>
>>> Full build log,
>>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5=
.5/DISTRO=3Dlkft,MACHINE=3Dam57xx-evm,label=3Ddocker-lkft/83/consoleText=20
>>>
>>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5=
.4/DISTRO=3Dlkft,MACHINE=3Djuno,label=3Ddocker-lkft/158/consoleText=20
>>>
>>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4=
.19/DISTRO=3Dlkft,MACHINE=3Dam57xx-evm,label=3Ddocker-lkft/511/consoleText=
=20
>>>
>>>
>>> - Naresh
>> Thanks for reporting! What a mess.
>>
>> It turns out that the commit that was queued for stable that is
>> causing the above errors, also requires another commit.
>>
>> The commit that was queued:
>> 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout=20
>> callback")
>>
>> The additional commit needed (which was added in v5.6-rc1):
>> 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
>>
>> However, the above commit needs a manual backport (quite trivial, but
>> still) for the relevant stable kernels, to allow it to solve the build
>> problems.
>>
>> Greg, Sasha - I suggest you to drop the offending commit from the
>> stable kernels, for now. I think it's better to let Sowjanya deal with
>> the backports, then send them in small series instead.
>>
>> Kind regards
>> Uffe
>
> Hi Ufee,
>
> Will back-porting below commit cause any issues to other vendors?
>
> 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
>
sdhci-tegra driver in 4.19 is using same sdhci_ops for Tegra114 and=20
Tegra210 and separate sdhci_ops for T210 started from 4.20.

5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback"=
)

So above commit can't be applied to 4.19. So probably a separate patch=20
need to be created to apply for 4.19 and back port above commit along=20
with its dependency commit (7d76ed77cfbd ("mmc: sdhci: Refactor=20
sdhci_set_timeout()") for 5.4 and 5.4.


> Thanks
Sowjanya
>
