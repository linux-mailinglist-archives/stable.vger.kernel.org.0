Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9293ED7C7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhHPNnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbhHPNnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 09:43:23 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99939C0701DD
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:32:06 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id g1so10933038vsq.7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vw1hIl2ADwG2m78ptVEwLN6bEzVxPb9phd3Fg2IlShw=;
        b=kxXehs1T3BTjdCPUS9vBJHhI/53PZUwf3GM8KDvQpw6MG1Mu1zZT0bltNtYaEgmBDJ
         s7l6ecO2vnDcLzlOmRhRnO+5124m7MT6sZpasVBL6DPTOpHHbO46HYmdQvFgbQLG87mU
         XBTXFimckSGOO53p+VpAc6epDwWeGq/mtvdtN6z2Ua8lp3ir1YQfXh9aIRxZyxQh/PVV
         +Wv9Ycy8+c9BkCNqCXxXkpHgL9JdXyRKT1Ku06Lm5w6QhwuWgXq02DzRWE+FNjLnSceR
         iRbGdDf68OHzZPdJvqmKD9JworCgbgCqbg6jeqOt13v3Yz0huuzsM7yQ438KGSrleFxB
         BgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vw1hIl2ADwG2m78ptVEwLN6bEzVxPb9phd3Fg2IlShw=;
        b=CY5kMw5FkCqZQzZYtEGfuwCt7ZlnBBDW6XK4taMCIiXjRAX4Q8xSfInO5Hc+Xas6nq
         W6P5Sk1b8nJ1PN0olxQHoC8yofF9TKMrcQPpT725lNQoShJXoV/IYZu9//1wpxcSmrGK
         jurfNS8I6sXInIUSLCVwuXtrk+cTm2VD9t1YgB8MH20/y1tFuOdvIs33T+wKQo3USdx2
         HAGe3Zv//vcgb17DPnK8O34iV7yIjdlmbcENybqkl+H64DHOIdxy6rTQQG2A44UK+ItJ
         ZUcZtlOCfpkIy6DtiL3xeWid+grgL+qPeB85FA4WL+RRHasXcr5RsSYPR8q0mMPTxN0U
         eo3w==
X-Gm-Message-State: AOAM531MCvdCfjFLRvATNb5G0qVLBY1DzkgDUxyHLxwbvXecWtGLCbMx
        MQMEpExYXsAq0a+uDvFYGcJZF/Z2LKKhc4BwEG8pPw==
X-Google-Smtp-Source: ABdhPJwAqlLj7+EOoii0TmnBL3S7g8Dl+Oe9Gl8pyzTER6yGFj49hI0B954cXi1tEXoqrGcI8bBm1VwSWsc0V/SRVUE=
X-Received: by 2002:a67:7cc9:: with SMTP id x192mr9837769vsc.42.1629120725376;
 Mon, 16 Aug 2021 06:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210720144115.1525257-1-linus.walleij@linaro.org>
In-Reply-To: <20210720144115.1525257-1-linus.walleij@linaro.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 16 Aug 2021 15:31:29 +0200
Message-ID: <CAPDyKFpm6Vicc8WnYfx_VYjsvKzO21pT2G_sbbEYGBcDUdSk4w@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: core: Add a card quirk for non-hw busy detection
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, phone-devel@vger.kernel.org,
        Ludovic Barre <ludovic.barre@st.com>,
        Stephan Gerhold <stephan@gerhold.net>, newbyte@disroot.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Jul 2021 at 16:43, Linus Walleij <linus.walleij@linaro.org> wrote:
>
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

My apologies for the delay. Unfortunately I am still not convinced
that what you're suggesting in the $subject patch is the correct
solution. I think we should debug the issue further so we really
understand what goes on.

For example, when the controller hangs on the CMD6, what state are the
controler in? Did you confirm that the mmci driver is waiting for the
busyend IRQ, as our earlier discussions indicated? Perhaps a register
dump at the point of when the driver is hanging would tell us more,
for example.

I can certainly help with some suggestions for debugging, just let me
know when you have some time, then we can discuss this.

Kind regards
Uffe

> ---
> ChangeLog v2->v3:
> - Rebase on v5.14-rc1
> - Reword the commit message slightly.
> ChangeLog v1->v2:
> - Rewrite to reflect the actual problem of broken busy detection.
> ---
>  drivers/mmc/core/core.c    |  8 ++++----
>  drivers/mmc/core/core.h    | 17 +++++++++++++++++
>  drivers/mmc/core/mmc_ops.c |  4 ++--
>  drivers/mmc/core/quirks.h  | 21 +++++++++++++++++++++
>  drivers/mmc/host/mmci.c    | 22 ++++++++++++++++++++--
>  include/linux/mmc/card.h   |  1 +
>  6 files changed, 65 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 95fedcf56e4a..e08dd9ea3d46 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -232,7 +232,7 @@ static void __mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>          * And bypass I/O abort, reset and bus suspend operations.
>          */
>         if (sdio_is_io_busy(mrq->cmd->opcode, mrq->cmd->arg) &&
> -           host->ops->card_busy) {
> +           mmc_hw_busy_detect(host)) {
>                 int tries = 500; /* Wait aprox 500ms at maximum */
>
>                 while (host->ops->card_busy(host) && --tries)
> @@ -1200,7 +1200,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>          */
>         if (!host->ops->start_signal_voltage_switch)
>                 return -EPERM;
> -       if (!host->ops->card_busy)
> +       if (!mmc_hw_busy_detect(host))
>                 pr_warn("%s: cannot verify signal voltage switch\n",
>                         mmc_hostname(host));
>
> @@ -1220,7 +1220,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>          * after the response of cmd11, but wait 1 ms to be sure
>          */
>         mmc_delay(1);
> -       if (host->ops->card_busy && !host->ops->card_busy(host)) {
> +       if (mmc_hw_busy_detect(host) && !host->ops->card_busy(host)) {
>                 err = -EAGAIN;
>                 goto power_cycle;
>         }
> @@ -1241,7 +1241,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
>          * Failure to switch is indicated by the card holding
>          * dat[0:3] low
>          */
> -       if (host->ops->card_busy && host->ops->card_busy(host))
> +       if (mmc_hw_busy_detect(host) && host->ops->card_busy(host))
>                 err = -EAGAIN;
>
>  power_cycle:
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 0c4de2030b3f..6a5619eed4a6 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -181,4 +181,21 @@ static inline int mmc_flush_cache(struct mmc_host *host)
>         return 0;
>  }
>
> +/**
> + * mmc_hw_busy_detect() - Can we use hw busy detection?
> + * @host: the host in question
> + */
> +static inline bool mmc_hw_busy_detect(struct mmc_host *host)
> +{
> +       struct mmc_card *card = host->card;
> +       bool has_ops;
> +       bool able = true;
> +
> +       has_ops = (host->ops->card_busy != NULL);
> +       if (card)
> +               able = !(card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT);
> +
> +       return (has_ops && able);
> +}
> +
>  #endif
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 973756ed4016..546fc799a8e5 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -435,7 +435,7 @@ static int mmc_busy_cb(void *cb_data, bool *busy)
>         u32 status = 0;
>         int err;
>
> -       if (host->ops->card_busy) {
> +       if (mmc_hw_busy_detect(host)) {
>                 *busy = host->ops->card_busy(host);
>                 return 0;
>         }
> @@ -597,7 +597,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>          * when it's not allowed to poll by using CMD13, then we need to rely on
>          * waiting the stated timeout to be sufficient.
>          */
> -       if (!send_status && !host->ops->card_busy) {
> +       if (!send_status && !mmc_hw_busy_detect(host)) {
>                 mmc_delay(timeout_ms);
>                 goto out_tim;
>         }
> diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
> index d68e6e513a4f..8da6526f0eb0 100644
> --- a/drivers/mmc/core/quirks.h
> +++ b/drivers/mmc/core/quirks.h
> @@ -99,6 +99,27 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
>         MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
>                   MMC_QUIRK_TRIM_BROKEN),
>
> +       /*
> +        * Some older Samsung eMMCs have broken hardware busy detection.
> +        * Enabling this feature in the host controller can make the card
> +        * accesses lock up completely.
> +        */
> +       MMC_FIXUP("4YMD1R", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       /* Samsung KLMxGxxE4x eMMCs from 2012: 4, 8, 16, 32 and 64 GB */
> +       MMC_FIXUP("M4G1YC", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       MMC_FIXUP("M8G1WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       MMC_FIXUP("MBG4WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +       MMC_FIXUP("MCG8WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
> +                 MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
> +
>         END_FIXUP
>  };
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 984d35055156..3046917b2b67 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -347,6 +347,24 @@ static int mmci_card_busy(struct mmc_host *mmc)
>         return busy;
>  }
>
> +/* Use this if the MMCI variant AND the card supports it */
> +static bool mmci_use_busy_detect(struct mmci_host *host)
> +{
> +       struct mmc_card *card = host->mmc->card;
> +
> +       if (!host->variant->busy_detect)
> +               return false;
> +
> +       /* We don't allow this until we know that the card can handle it */
> +       if (!card)
> +               return false;
> +
> +       if (card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT)
> +               return false;
> +
> +       return true;
> +}
> +
>  static void mmci_reg_delay(struct mmci_host *host)
>  {
>         /*
> @@ -1381,7 +1399,7 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
>                 return;
>
>         /* Handle busy detection on DAT0 if the variant supports it. */
> -       if (busy_resp && host->variant->busy_detect)
> +       if (busy_resp && mmci_use_busy_detect(host))
>                 if (!host->ops->busy_complete(host, status, err_msk))
>                         return;
>
> @@ -1725,7 +1743,7 @@ static void mmci_set_max_busy_timeout(struct mmc_host *mmc)
>         struct mmci_host *host = mmc_priv(mmc);
>         u32 max_busy_timeout = 0;
>
> -       if (!host->variant->busy_detect)
> +       if (!mmci_use_busy_detect(host))
>                 return;
>
>         if (host->variant->busy_timeout && mmc->actual_clock)
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index 74e6c0624d27..525a39951c6d 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -280,6 +280,7 @@ struct mmc_card {
>                                                 /* for byte mode */
>  #define MMC_QUIRK_NONSTD_SDIO  (1<<2)          /* non-standard SDIO card attached */
>                                                 /* (missing CIA registers) */
> +#define MMC_QUIRK_BROKEN_HW_BUSY_DETECT (1<<3) /* Disable hardware busy detection on DAT0 */
>  #define MMC_QUIRK_NONSTD_FUNC_IF (1<<4)                /* SDIO card has nonstd function interfaces */
>  #define MMC_QUIRK_DISABLE_CD   (1<<5)          /* disconnect CD/DAT[3] resistor */
>  #define MMC_QUIRK_INAND_CMD38  (1<<6)          /* iNAND devices have broken CMD38 */
> --
> 2.31.1
>
