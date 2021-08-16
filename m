Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A23ED8A2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhHPOE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:04:26 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:35792 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237028AbhHPOEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:04:10 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GDvRii002323;
        Mon, 16 Aug 2021 16:03:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=Pt2ygHbQdtXW0ICSFjcyYa7NBrcW9NOpFdUWwdSttH0=;
 b=739x3S5QBw9KNQogTcwFUGjp5E7yLaQe8aMaDoreUjFt27/BlLa9oYa9/SHEbowhlinQ
 i2RpC+5mdHzUm4BbzfFFWhPT3ssN1Om9ROGHzsvJc9K3nHrA6/OZrTjrc2QXgiMatfbl
 Hwo2T8iVKX2v8MDFI6WmH5RRCU1voEZew5l2qKSQ+Sy5Jv9tsnl/vW7DiRHbtqNNbtIv
 5dYltpAoy0nX2movpnnvHi02alP3LWxTW/v4X5yEkZv5GRIc3QdWqXjcCXjnb9irX/1e
 M4mH0h4+y2RCjV5A6+Sj/g6QA3p763HdysGIlg95JsD6bqDW/GOzwOow9WLZQqGhtqKd 4Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3afeqbu7k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 16:03:34 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2FEF710002A;
        Mon, 16 Aug 2021 16:03:32 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id D94DD2A4D8F;
        Mon, 16 Aug 2021 16:03:32 +0200 (CEST)
Received: from lmecxl0504.lme.st.com (10.75.127.49) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Aug
 2021 16:03:32 +0200
Subject: Re: [PATCH v3] mmc: core: Add a card quirk for non-hw busy detection
To:     Linus Walleij <linus.walleij@linaro.org>,
        <linux-mmc@vger.kernel.org>, "Ulf Hansson" <ulf.hansson@linaro.org>
CC:     <stable@vger.kernel.org>, <phone-devel@vger.kernel.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        Stephan Gerhold <stephan@gerhold.net>, <newbyte@disroot.org>
References: <20210720144115.1525257-1-linus.walleij@linaro.org>
From:   Yann Gautier <yann.gautier@foss.st.com>
Message-ID: <2f449f6e-bca0-3c70-4255-26619e957d44@foss.st.com>
Date:   Mon, 16 Aug 2021 16:03:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720144115.1525257-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/21 4:41 PM, Linus Walleij wrote:
> Some boot partitions on the Samsung 4GB KLM4G1YE4C "4YMD1R" and "M4G1YC"
> cards appear broken when accessed randomly. CMD6 to switch back to the main
> partition randomly stalls after CMD18 access to the boot partition 1, and
> the card never comes back online. The accesses to the boot partitions work
> several times before this happens, but eventually the card access hangs
> while initializing the card.
> 
> Some problematic eMMC cards are found in the Samsung GT-S7710 (Skomer)
> and SGH-I407 (Kyle) mobile phones.
> 
> I tried using only single blocks with CMD17 on the boot partitions with the
> result that it crashed even faster.
> 
> After a bit of root cause analysis it turns out that these old eMMC cards
> probably cannot do hardware busy detection (monitoring DAT0) properly.
> 
> The card survives on older kernels, but this is because recent kernels have
> added busy detection handling for the SoC used in these phones, exposing
> the issue.
> 
> Construct a quirk that makes the MMC cord avoid using the ->card_busy()
> callback if the card is listed with MMC_QUIRK_BROKEN_HW_BUSY_DETECT and
> register the known problematic cards. The core changes are pretty
> straight-forward with a helper inline to check of we can use hardware
> busy detection.
> 
> On the MMCI host we have to counter the fact that if the host was able to
> use busy detect, it would be used unsolicited in the command IRQ callback.
> Rewrite this so that MMCI will not attempt to use hardware busy detection
> in the command IRQ until:
> - A card is attached to the host and
> - We know that the card can handle this busy detection
> 
> I have glanced over the ->card_busy() callbacks on some other hosts and
> they seem to mostly read a register reflecting the value of DAT0 for this
> which works fine with the quirk in this patch. However if the error appear
> on other hosts they might need additional fixes.
> 
> After applying this patch, the main partition can be accessed and mounted
> without problems on Samsung GT-S7710 and SGH-I407.
> 
> Fixes: cb0335b778c7 ("mmc: mmci: add busy_complete callback")
> Cc: stable@vger.kernel.org
> Cc: phone-devel@vger.kernel.org
> Cc: Ludovic Barre <ludovic.barre@st.com>
> Cc: Stephan Gerhold <stephan@gerhold.net>
> Reported-by: newbyte@disroot.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Hi Linus,

I was just testing your patch on top of mmc/next.
Whereas mmc/next is fine, with your patch I fail to pass MMC test 5 
(Multi-block write).
I've got this error on STM32MP157C-EV1 board:
[  108.956218] mmc0: Starting tests of card mmc0:aaaa...
[  108.959862] mmc0: Test case 5. Multi-block write...
[  108.995615] mmc0: Warning: Host did not wait for busy state to end.
[  109.000483] mmc0: Result: ERROR (-110)
Then nothing more happens.

The test was done on an SD-card Sandisk Extreme Pro SDXC UHS-I mark 3, 
in DDR50 mode.

I'll try to add more traces to see what happens.


Best regards,
Yann


> ---
> ChangeLog v2->v3:
> - Rebase on v5.14-rc1
> - Reword the commit message slightly.
> ChangeLog v1->v2:
> - Rewrite to reflect the actual problem of broken busy detection.
> ---
>   drivers/mmc/core/core.c    |  8 ++++----
>   drivers/mmc/core/core.h    | 17 +++++++++++++++++
>   drivers/mmc/core/mmc_ops.c |  4 ++--
>   drivers/mmc/core/quirks.h  | 21 +++++++++++++++++++++
>   drivers/mmc/host/mmci.c    | 22 ++++++++++++++++++++--
>   include/linux/mmc/card.h   |  1 +
>   6 files changed, 65 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 95fedcf56e4a..e08dd9ea3d46 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -232,7 +232,7 @@ static void __mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>   	 * And bypass I/O abort, reset and bus suspend operations.
>   	 */
>   	if (sdio_is_io_busy(mrq->cmd->opcode, mrq->cmd->arg) &&
> -	    host->ops->card_busy) {
> +	    mmc_hw_busy_detect(host)) {
>   		int tries = 500; /* Wait aprox 500ms at maximum */
>   
>   		while (host->ops->card_busy(host) && --tries)
> @@ -1200,7 +1200,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>   	 */
>   	if (!host->ops->start_signal_voltage_switch)
>   		return -EPERM;
> -	if (!host->ops->card_busy)
> +	if (!mmc_hw_busy_detect(host))
>   		pr_warn("%s: cannot verify signal voltage switch\n",
>   			mmc_hostname(host));
>   
> @@ -1220,7 +1220,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>   	 * after the response of cmd11, but wait 1 ms to be sure
>   	 */
>   	mmc_delay(1);
> -	if (host->ops->card_busy && !host->ops->card_busy(host)) {
> +	if (mmc_hw_busy_detect(host) && !host->ops->card_busy(host)) {
>   		err = -EAGAIN;
>   		goto power_cycle;
>   	}
> @@ -1241,7 +1241,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>   	 * Failure to switch is indicated by the card holding
>   	 * dat[0:3] low
>   	 */
> -	if (host->ops->card_busy && host->ops->card_busy(host))
> +	if (mmc_hw_busy_detect(host) && host->ops->card_busy(host))
>   		err = -EAGAIN;
>   
>   power_cycle:
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 0c4de2030b3f..6a5619eed4a6 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -181,4 +181,21 @@ static inline int mmc_flush_cache(struct mmc_host *host)
>   	return 0;
>   }
>   
> +/**
> + * mmc_hw_busy_detect() - Can we use hw busy detection?
> + * @host: the host in question
> + */
> +static inline bool mmc_hw_busy_detect(struct mmc_host *host)
> +{
> +	struct mmc_card *card = host->card;
> +	bool has_ops;
> +	bool able = true;
> +
> +	has_ops = (host->ops->card_busy != NULL);
> +	if (card)
> +		able = !(card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT);
> +
> +	return (has_ops && able);
> +}
> +
>   #endif
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 973756ed4016..546fc799a8e5 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -435,7 +435,7 @@ static int mmc_busy_cb(void *cb_data, bool *busy)
>   	u32 status = 0;
>   	int err;
>   
> -	if (host->ops->card_busy) {
> +	if (mmc_hw_busy_detect(host)) {
>   		*busy = host->ops->card_busy(host);
>   		return 0;
>   	}
> @@ -597,7 +597,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>   	 * when it's not allowed to poll by using CMD13, then we need to rely on
>   	 * waiting the stated timeout to be sufficient.
>   	 */
> -	if (!send_status && !host->ops->card_busy) {
> +	if (!send_status && !mmc_hw_busy_detect(host)) {
>   		mmc_delay(timeout_ms);
>   		goto out_tim;
>   	}
> diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
> index d68e6e513a4f..8da6526f0eb0 100644
> --- a/drivers/mmc/core/quirks.h
> +++ b/drivers/mmc/core/quirks.h
> @@ -99,6 +99,27 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
>   	MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
>   		  MMC_QUIRK_TRIM_BROKEN),
>   
> +	/*
> +	 * Some older Samsung eMMCs have broken hardware busy detection.
> +	 * Enabling this feature in the host controller can make the card
> +	 * accesses lock up completely.
> +	 */
> +	MMC_FIXUP("4YMD1R", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	/* Samsung KLMxGxxE4x eMMCs from 2012: 4, 8, 16, 32 and 64 GB */
> +	MMC_FIXUP("M4G1YC", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	MMC_FIXUP("M8G1WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	MMC_FIXUP("MBG4WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +	MMC_FIXUP("MCG8WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +
>   	END_FIXUP
>   };
>   
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 984d35055156..3046917b2b67 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -347,6 +347,24 @@ static int mmci_card_busy(struct mmc_host *mmc)
>   	return busy;
>   }
>   
> +/* Use this if the MMCI variant AND the card supports it */
> +static bool mmci_use_busy_detect(struct mmci_host *host)
> +{
> +	struct mmc_card *card = host->mmc->card;
> +
> +	if (!host->variant->busy_detect)
> +		return false;
> +
> +	/* We don't allow this until we know that the card can handle it */
> +	if (!card)
> +		return false;
> +
> +	if (card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT)
> +		return false;
> +
> +	return true;
> +}
> +
>   static void mmci_reg_delay(struct mmci_host *host)
>   {
>   	/*
> @@ -1381,7 +1399,7 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
>   		return;
>   
>   	/* Handle busy detection on DAT0 if the variant supports it. */
> -	if (busy_resp && host->variant->busy_detect)
> +	if (busy_resp && mmci_use_busy_detect(host))
>   		if (!host->ops->busy_complete(host, status, err_msk))
>   			return;
>   
> @@ -1725,7 +1743,7 @@ static void mmci_set_max_busy_timeout(struct mmc_host *mmc)
>   	struct mmci_host *host = mmc_priv(mmc);
>   	u32 max_busy_timeout = 0;
>   
> -	if (!host->variant->busy_detect)
> +	if (!mmci_use_busy_detect(host))
>   		return;
>   
>   	if (host->variant->busy_timeout && mmc->actual_clock)
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 74e6c0624d27..525a39951c6d 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -280,6 +280,7 @@ struct mmc_card {
>   						/* for byte mode */
>   #define MMC_QUIRK_NONSTD_SDIO	(1<<2)		/* non-standard SDIO card attached */
>   						/* (missing CIA registers) */
> +#define MMC_QUIRK_BROKEN_HW_BUSY_DETECT (1<<3)	/* Disable hardware busy detection on DAT0 */
>   #define MMC_QUIRK_NONSTD_FUNC_IF (1<<4)		/* SDIO card has nonstd function interfaces */
>   #define MMC_QUIRK_DISABLE_CD	(1<<5)		/* disconnect CD/DAT[3] resistor */
>   #define MMC_QUIRK_INAND_CMD38	(1<<6)		/* iNAND devices have broken CMD38 */
> 

