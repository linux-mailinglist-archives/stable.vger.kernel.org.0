Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E467D192C46
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgCYPY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:24:26 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:22386 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727505AbgCYPYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:24:25 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PFO1sb013405;
        Wed, 25 Mar 2020 16:24:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=251aijJqzn9yU8MYctpjTqFbHgxmUCK4PXt+EtiJg48=;
 b=WKKjM5ybNsKQi5XoeHM7JN84FsIs3NlGRoaL4ek2paCb3OrTni7NtZm0fsCFTC6b3bkE
 aGz/X4HVmXYamniB8SgQIF7tOqG2Khi3EU2eSKSpyr1qhVS0AnBm/BI/vLMBY68mjnSm
 4H3PytXKQyJoTNUyCyMS3vB2b0Xkfb5iVZB1HLTvI+M+xRvFjriFCPcdee9xpsJYPeFy
 SE4LM/QnpLIW9knaM2tZzcBsCXU4ZKtW1zP/Gtd2Ie00nJvz6rIVdB05tEZZOrslDKhN
 0YjuL8//4iowC2Unc6oTr/4Dq4URKYht9MTo7erzejwzqpunFnLKms4LhJle22RLgi+6 +w== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yw995pgh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 16:24:08 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0D0C510002A;
        Wed, 25 Mar 2020 16:24:05 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E9B3F2B5D06;
        Wed, 25 Mar 2020 16:24:04 +0100 (CET)
Received: from lmecxl0923.lme.st.com (10.75.127.51) by SFHDAG6NODE1.st.com
 (10.75.127.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Mar
 2020 16:24:03 +0100
Subject: Re: [PATCH 2/2] amba: Initialize dma_parms for amba devices
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
 <20200325113407.26996-3-ulf.hansson@linaro.org>
From:   Ludovic BARRE <ludovic.barre@st.com>
Message-ID: <f73aac31-d243-dbc6-474e-95174444fe3a@st.com>
Date:   Wed, 25 Mar 2020 16:24:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325113407.26996-3-ulf.hansson@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG3NODE2.st.com (10.75.127.8) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_08:2020-03-24,2020-03-25 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 3/25/20 à 12:34 PM, Ulf Hansson a écrit :
> It's currently the amba driver's responsibility to initialize the pointer,
> dma_parms, for its corresponding struct device. The benefit with this
> approach allows us to avoid the initialization and to not waste memory for
> the struct device_dma_parameters, as this can be decided on a case by case
> basis.
> 
> However, it has turned out that this approach is not very practical. Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
> 
> For these reasons, let's do the initialization from the common amba bus at
> the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
> 

tested with mmc: mmci_sdmmc fix
Tested-by: Ludovic Barre <ludovic.barre@st.com>

> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>   drivers/amba/bus.c       | 2 ++
>   include/linux/amba/bus.h | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index fe1523664816..5e61783ce92d 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -374,6 +374,8 @@ static int amba_device_try_add(struct amba_device *dev, struct resource *parent)
>   	WARN_ON(dev->irq[0] == (unsigned int)-1);
>   	WARN_ON(dev->irq[1] == (unsigned int)-1);
>   
> +	dev->dev.dma_parms = &dev->dma_parms;
> +
>   	ret = request_resource(parent, &dev->res);
>   	if (ret)
>   		goto err_out;
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index 26f0ecf401ea..0bbfd647f5c6 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -65,6 +65,7 @@ struct amba_device {
>   	struct device		dev;
>   	struct resource		res;
>   	struct clk		*pclk;
> +	struct device_dma_parameters dma_parms;
>   	unsigned int		periphid;
>   	unsigned int		cid;
>   	struct amba_cs_uci_id	uci;
> 
