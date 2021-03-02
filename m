Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC0932B162
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhCCApk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:45:40 -0500
Received: from foss.arm.com ([217.140.110.172]:53692 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1839414AbhCBQRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 11:17:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3525E12FC;
        Tue,  2 Mar 2021 08:17:01 -0800 (PST)
Received: from [192.168.122.166] (unknown [10.119.48.4])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14B223F7D7;
        Tue,  2 Mar 2021 08:17:00 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.10 11/47] mmc: sdhci-iproc: Add ACPI bindings
 for the RPi
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
References: <20210302115646.62291-1-sashal@kernel.org>
 <20210302115646.62291-11-sashal@kernel.org>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <445ed4c0-3b2c-1371-931d-b0de7bdb497a@arm.com>
Date:   Tue, 2 Mar 2021 10:16:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210302115646.62291-11-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


On 3/2/21 5:56 AM, Sasha Levin wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>
> 
> [ Upstream commit 4f9833d3ec8da34861cd0680b00c73e653877eb9 ]
> 
> The RPi4 has an Arasan controller it carries over from the RPi3 and a newer
> eMMC2 controller.  Because of a couple of quirks, it seems wiser to bind
> these controllers to the same driver that DT is using on this platform
> rather than the generic sdhci_acpi driver with PNP0D40.
> 
> So, BCM2847 describes the older Arasan and BRCME88C describes the newer
> eMMC2. The older Arasan is reusing an existing ACPI _HID used by other OSes
> booting these tables on the RPi.
> 
> With this change, Linux is capable of utilizing the SD card slot, and the
> Wi-Fi when booted with UEFI+ACPI on the RPi4.

For this to actually work on kernels < 5.11 you also need:

c5b1c6dc13da mmc: sdhci: Update firmware interface API

Which I don't see in 5.10 yet.

Thanks,

> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20210120000406.1843400-2-jeremy.linton@arm.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/mmc/host/sdhci-iproc.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
> index c9434b461aab..ddeaf8e1f72f 100644
> --- a/drivers/mmc/host/sdhci-iproc.c
> +++ b/drivers/mmc/host/sdhci-iproc.c
> @@ -296,9 +296,27 @@ static const struct of_device_id sdhci_iproc_of_match[] = {
>   MODULE_DEVICE_TABLE(of, sdhci_iproc_of_match);
>   
>   #ifdef CONFIG_ACPI
> +/*
> + * This is a duplicate of bcm2835_(pltfrm_)data without caps quirks
> + * which are provided by the ACPI table.
> + */
> +static const struct sdhci_pltfm_data sdhci_bcm_arasan_data = {
> +	.quirks = SDHCI_QUIRK_BROKEN_CARD_DETECTION |
> +		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
> +		  SDHCI_QUIRK_NO_HISPD_BIT,
> +	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
> +	.ops = &sdhci_iproc_32only_ops,
> +};
> +
> +static const struct sdhci_iproc_data bcm_arasan_data = {
> +	.pdata = &sdhci_bcm_arasan_data,
> +};
> +
>   static const struct acpi_device_id sdhci_iproc_acpi_ids[] = {
>   	{ .id = "BRCM5871", .driver_data = (kernel_ulong_t)&iproc_cygnus_data },
>   	{ .id = "BRCM5872", .driver_data = (kernel_ulong_t)&iproc_data },
> +	{ .id = "BCM2847",  .driver_data = (kernel_ulong_t)&bcm_arasan_data },
> +	{ .id = "BRCME88C", .driver_data = (kernel_ulong_t)&bcm2711_data },
>   	{ /* sentinel */ }
>   };
>   MODULE_DEVICE_TABLE(acpi, sdhci_iproc_acpi_ids);
> 

