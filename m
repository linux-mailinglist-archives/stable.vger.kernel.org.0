Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9AB1ACDB8
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410734AbgDPQ3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:29:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2030 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439478AbgDPQ3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 12:29:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9887dd0000>; Thu, 16 Apr 2020 09:29:17 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 16 Apr 2020 09:29:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 16 Apr 2020 09:29:30 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 Apr
 2020 16:29:29 +0000
Received: from [10.2.171.241] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 Apr
 2020 16:29:28 +0000
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific set_timeout
 callback
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
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
Message-ID: <753ec108-858c-660e-af0a-f57922134609@nvidia.com>
Date:   Thu, 16 Apr 2020 09:29:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587054557; bh=eOQ+w5nhOdv04KeF4PFobQIPtNvZjkMJ66eBaSJNtCw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=MYWrHESZKzBtEwhd96npLAmGcMdMDTgqfrVKWeywoups5jqGjxXweQEXayywyvIrx
         zF6ExcqtSN1y9J6xy8Kibwqg001eOcBOr0TlqustT0/JEI5YiETrMl0NsqH5JzoRQT
         ONj+1WZchStALqtZ7Hlm/DcOTZoKN7XXuvYKGXMC5OGBB8JtjZPA1RspaCEEbLe3rv
         RSIGGnOJz0qEtOZh8/2BL8Zzl6nsVHpypntHdxPcyq/Z8BZS071IrweUPpAwxiY4oX
         aG+6WW5D4jRVgEpsFX2T9jurBxl36m8m/00rlATQEbpzXwrbRNPsHXKYtwWsLCSU5i
         CSYlHmLAo/qZQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/16/20 3:59 AM, Ulf Hansson wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, 15 Apr 2020 at 19:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>> On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
>> <skomatineni@nvidia.com> wrote:
>>> Tegra host supports HW busy detection and timeouts based on the
>>> count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
>>> timeout it supports is 11s in finite busy wait mode.
>>>
>>> Some operations like SLEEP_AWAKE, ERASE and flush cache through
>>> SWITCH commands take longer than 11s and Tegra host supports
>>> infinite HW busy wait mode where HW waits forever till the card
>>> is busy without HW timeout.
>>>
>>> This patch implements Tegra specific set_timeout sdhci_ops to allow
>>> switching between finite and infinite HW busy detection wait modes
>>> based on the device command expected operation time.
>>>
>>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>>> ---
>>>   drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++++++
>>>   1 file changed, 31 insertions(+)
>>>
>>> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
>>> index a25c3a4..fa8f6a4 100644
>>> --- a/drivers/mmc/host/sdhci-tegra.c
>>> +++ b/drivers/mmc/host/sdhci-tegra.c
>>> @@ -45,6 +45,7 @@
>>>   #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT       8
>>>
>>>   #define SDHCI_TEGRA_VENDOR_MISC_CTRL                   0x120
>>> +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT            BIT(0)
>>>   #define SDHCI_MISC_CTRL_ENABLE_SDR104                  0x8
>>>   #define SDHCI_MISC_CTRL_ENABLE_SDR50                   0x10
>>>   #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300          0x20
>>> @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct sdhci_host *host, u32 intmask)
>>>          return 0;
>>>   }
>>>
>>> +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
>>> +                                   struct mmc_command *cmd)
>>> +{
>>> +       u32 val;
>>> +
>>> +       /*
>>> +        * HW busy detection timeout is based on programmed data timeout
>>> +        * counter and maximum supported timeout is 11s which may not be
>>> +        * enough for long operations like cache flush, sleep awake, erase.
>>> +        *
>>> +        * ERASE_TIMEOUT_LIMIT bit of VENDOR_MISC_CTRL register allows
>>> +        * host controller to wait for busy state until the card is busy
>>> +        * without HW timeout.
>>> +        *
>>> +        * So, use infinite busy wait mode for operations that may take
>>> +        * more than maximum HW busy timeout of 11s otherwise use finite
>>> +        * busy wait mode.
>>> +        */
>>> +       val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
>>> +       if (cmd && cmd->busy_timeout >= 11 * HZ)
>>> +               val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
>>> +       else
>>> +               val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
>>> +       sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_MISC_CTRL);
>>> +
>>> +       __sdhci_set_timeout(host, cmd);
>> kernel build on arm and arm64 architecture failed on stable-rc 4.19
>> (arm), 5.4 (arm64) and 5.5 (arm64)
>>
>> drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
>> drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
>> function '__sdhci_set_timeout'; did you mean
>> 'tegra_sdhci_set_timeout'? [-Werror=implicit-function-declaration]
>>    __sdhci_set_timeout(host, cmd);
>>    ^~~~~~~~~~~~~~~~~~~
>>    tegra_sdhci_set_timeout
>>
>> Full build log,
>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/83/consoleText
>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/158/consoleText
>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText
>>
>> - Naresh
> Thanks for reporting! What a mess.
>
> It turns out that the commit that was queued for stable that is
> causing the above errors, also requires another commit.
>
> The commit that was queued:
> 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback")
>
> The additional commit needed (which was added in v5.6-rc1):
> 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
>
> However, the above commit needs a manual backport (quite trivial, but
> still) for the relevant stable kernels, to allow it to solve the build
> problems.
>
> Greg, Sasha - I suggest you to drop the offending commit from the
> stable kernels, for now. I think it's better to let Sowjanya deal with
> the backports, then send them in small series instead.
>
> Kind regards
> Uffe

Hi Ufee,

Will back-porting below commit cause any issues to other vendors?

7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")

Thanks
Sowjanya

