Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D1B192C41
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYPYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:24:21 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:64376 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727505AbgCYPYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:24:21 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PFDlLC004627;
        Wed, 25 Mar 2020 16:23:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=+JxsGMD/HKpVKs1dQBQK8ygKLAo12R6x7cJ4kdNJpoY=;
 b=xUFx7a3pQOkxiDSq2J6BidiHMoZH0DtRUrMcypx4CppI5NKTKD3wy91Azg9nRqmN2hmE
 9HoeknXJEi2L8XvYLo1rzw6W3ijYD/2Jj7Utp7/ws3OaSVAKV7+knBoj1ifNWWQ8q2CA
 cIGy9XoSWSrSAvcu2cPVuSZ8tJZqimSwi+3f/wBUTrMNPOMHcPLZZE/NfPv6HcaZiNiQ
 mdtvcroqOlKKjQjPZrDIQSSrMiYDAZ/psPG8lTzsn75FiAmwENHU52BNSwR5wqvjQUN6
 5mcBiTcGF+YrTU7kN52Hs/bUq6wJOUAiTmMYWNHTYWyrd+dArbdZSan3MSU8h3QkQZRd bA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yw995pgfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 16:23:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 67B6110002A;
        Wed, 25 Mar 2020 16:23:48 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 3A8062B5D06;
        Wed, 25 Mar 2020 16:23:48 +0100 (CET)
Received: from lmecxl0923.lme.st.com (10.75.127.51) by SFHDAG6NODE1.st.com
 (10.75.127.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Mar
 2020 16:23:46 +0100
Subject: Re: [PATCH 1/2] driver core: platform: Initialize dma_parms for
 platform devices
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200325113407.26996-1-ulf.hansson@linaro.org>
 <20200325113407.26996-2-ulf.hansson@linaro.org>
From:   Ludovic BARRE <ludovic.barre@st.com>
Message-ID: <598b3a55-0321-d7ea-8758-edaba5d5cb2c@st.com>
Date:   Wed, 25 Mar 2020 16:23:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325113407.26996-2-ulf.hansson@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_07:2020-03-24,2020-03-25 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 3/25/20 à 12:34 PM, Ulf Hansson a écrit :
> It's currently the platform driver's responsibility to initialize the
> pointer, dma_parms, for its corresponding struct device. The benefit with
> this approach allows us to avoid the initialization and to not waste memory
> for the struct device_dma_parameters, as this can be decided on a case by
> case basis.
> 
> However, it has turned out that this approach is not very practical.  Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
> 
> For these reasons, let's do the initialization from the common platform bus
> at the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().

tested with mmc: mmci_sdmmc fix
Tested-by: Ludovic Barre <ludovic.barre@st.com>

> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>   drivers/base/platform.c         | 1 +
>   include/linux/platform_device.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b5ce7b085795..46abbfb52655 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -512,6 +512,7 @@ int platform_device_add(struct platform_device *pdev)
>   		pdev->dev.parent = &platform_bus;
>   
>   	pdev->dev.bus = &platform_bus_type;
> +	pdev->dev.dma_parms = &pdev->dma_parms;
>   
>   	switch (pdev->id) {
>   	default:
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 041bfa412aa0..81900b3cbe37 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -25,6 +25,7 @@ struct platform_device {
>   	bool		id_auto;
>   	struct device	dev;
>   	u64		platform_dma_mask;
> +	struct device_dma_parameters dma_parms;
>   	u32		num_resources;
>   	struct resource	*resource;
>   
> 
