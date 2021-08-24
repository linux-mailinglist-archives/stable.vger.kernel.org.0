Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976F73F6203
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbhHXPv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 11:51:29 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:60608 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238287AbhHXPv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 11:51:29 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OEY4h3024948;
        Tue, 24 Aug 2021 17:50:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=VUg5CyG2p0On/1rhTFMvWxFwJqU9eMLANRit4xI0Kvk=;
 b=tWxcgaw9smj99JjxJ8sonnOERR5TXhtHSpyVmhOkMw78SVyU9AL2Dc0q5jJ5x/RjRHW5
 EgVzkhM47kxhTBbMyBcZQ42GvQRQQmQk5J8zVvzbtXDqwKUAhBtoED2jrZaVxUfrYWlQ
 oYppZwPnMwBT3s++3rApq3vK+RqtNmQimKHFHi6qpRYyBlA0Qj4keDDD6hoZpxV0tPnc
 g4Epr0TbmWG61E5bDX/qYKfm0a6E4AH7hE1kg//84vrcED8UegCGNOxiY1gKbDUmH1A3
 YAJzB9yqS3u2N5mRiTExRrvzaFNOHAm1duly/zNxuWS+Qgvt//8Tx6kw+5tcBw10vAcy gw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3ampcvcg65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 17:50:39 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 794FD10002A;
        Tue, 24 Aug 2021 17:50:37 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 32DB622A6D6;
        Tue, 24 Aug 2021 17:50:37 +0200 (CEST)
Received: from lmecxl0504.lme.st.com (10.75.127.48) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 17:50:36 +0200
Subject: Re: [PATCH v3] mmc: core: Add a card quirk for non-hw busy detection
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        stable <stable@vger.kernel.org>, <phone-devel@vger.kernel.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "Stephan Gerhold" <stephan@gerhold.net>,
        Stefan Hansson <newbyte@disroot.org>
References: <20210720144115.1525257-1-linus.walleij@linaro.org>
 <2f449f6e-bca0-3c70-4255-26619e957d44@foss.st.com>
 <CACRpkdY2GnqNYqPPctqa_t5ax1SDo7nEc3a1jSncF8N-V-Da-g@mail.gmail.com>
From:   Yann Gautier <yann.gautier@foss.st.com>
Message-ID: <1c458c1e-8730-ae74-de93-45d2d634beb4@foss.st.com>
Date:   Tue, 24 Aug 2021 17:50:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdY2GnqNYqPPctqa_t5ax1SDo7nEc3a1jSncF8N-V-Da-g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_05,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/21 12:37 AM, Linus Walleij wrote:
> On Mon, Aug 16, 2021 at 4:03 PM Yann Gautier <yann.gautier@foss.st.com> wrote:
> 
>> I was just testing your patch on top of mmc/next.
>> Whereas mmc/next is fine, with your patch I fail to pass MMC test 5
>> (Multi-block write).
>> I've got this error on STM32MP157C-EV1 board:
>> [  108.956218] mmc0: Starting tests of card mmc0:aaaa...
>> [  108.959862] mmc0: Test case 5. Multi-block write...
>> [  108.995615] mmc0: Warning: Host did not wait for busy state to end.
>> [  109.000483] mmc0: Result: ERROR (-110)
>> Then nothing more happens.
>>
>> The test was done on an SD-card Sandisk Extreme Pro SDXC UHS-I mark 3,
>> in DDR50 mode.
>>
>> I'll try to add more traces to see what happens.
> 

Hi Linus

> What I think happens is:
> - You are using the MMCI driver (correct?)
Yes

> - My patch augments the driver to not use busydetect until we have
>    determined that the card can do it (after reading extcsd etc)
> - Before this patch, the MMCI would unconditionally use HW
>    busy detect on any card.
I finally found the problem.
The assignment of host->card is done at the end of mmc_sd_init_card().
But mmci_set_max_busy_timeout() is called in mmc_sd_init_card() before 
that, and card is then NULL at that time. This let me a 
mmc->max_busy_timeout = 0. And this value is no more updated.
mmci_start_command() will then have a unexpected behavior with that 0 value.

Maybe we should not use mmci_use_busy_detect() in 
mmci_set_max_busy_timeout()?

If I use this patch on top of yours (reverting the 
mmci_set_max_busy_timeout() change), all the mmc tests pass on the 
SD-card I was testing:

@@ -1741,11 +1741,11 @@ static void mmci_request(struct mmc_host *mmc, 
struct mmc_request *mrq)
  static void mmci_set_max_busy_timeout(struct mmc_host *mmc)
  {
  	struct mmci_host *host = mmc_priv(mmc);
  	u32 max_busy_timeout = 0;

-	if (!mmci_use_busy_detect(host))
+	if (!host->variant->busy_detect)
  		return;

  	if (host->variant->busy_timeout && mmc->actual_clock)
  		max_busy_timeout = ~0UL / (mmc->actual_clock / MSEC_PER_SEC);


> 
> Either we have managed to wire the MMCI driver so that it doesn't
> work without HW busy detect anymore, you can easily test this
> by doing this:
> 
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 3765e2f4ad98..3a35f65491c8 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -270,10 +270,10 @@ static struct variant_data variant_stm32_sdmmc = {
>          .datactrl_any_blocksz   = true,
>          .datactrl_mask_sdio     = MCI_DPSM_ST_SDIOEN,
>          .stm32_idmabsize_mask   = GENMASK(12, 5),
> -       .busy_timeout           = true,
> -       .busy_detect            = true,
> -       .busy_detect_flag       = MCI_STM32_BUSYD0,
> -       .busy_detect_mask       = MCI_STM32_BUSYD0ENDMASK,
> +       //.busy_timeout         = true,
> +       //.busy_detect          = true,
> +       //.busy_detect_flag     = MCI_STM32_BUSYD0,
> +       //.busy_detect_mask     = MCI_STM32_BUSYD0ENDMASK,
>          .init                   = sdmmc_variant_init,
>   };
> 
> @@ -297,10 +297,10 @@ static struct variant_data variant_stm32_sdmmcv2 = {
>          .datactrl_mask_sdio     = MCI_DPSM_ST_SDIOEN,
>          .stm32_idmabsize_mask   = GENMASK(16, 5),
>          .dma_lli                = true,
> -       .busy_timeout           = true,
> -       .busy_detect            = true,
> -       .busy_detect_flag       = MCI_STM32_BUSYD0,
> -       .busy_detect_mask       = MCI_STM32_BUSYD0ENDMASK,
> +       //.busy_timeout         = true,
> +       //.busy_detect          = true,
> +       //.busy_detect_flag     = MCI_STM32_BUSYD0,
> +       //.busy_detect_mask     = MCI_STM32_BUSYD0ENDMASK,

This was working, but disabling HW busy detection is not really what we 
want.

>          .init                   = sdmmc_variant_init,
> 
> Or else there is a card that cannot work without busy detect which
> I find unlikely.
> 
> Yours,
> Linus Walleij >


I have the same kind of issues with the eMMC on the STM32MP157C-EV1 
board. But here it fails at boot when trying to enable HPI, in mmc_switch().


I then updated the patch like this:
@@ -357,7 +357,7 @@ static bool mmci_use_busy_detect(struct mmci_host *host)

         /* We don't allow this until we know that the card can handle it */
         if (!card)
-               return false;
+               return true;


And it then works for all my use-cases, but I suppose that's not what 
you wanted to do.

So I guess we need to have the mmc_card structure, to determine if we 
have the quirk, but not from the mmc_host. Through some new callback?


Best regards,
Yann
