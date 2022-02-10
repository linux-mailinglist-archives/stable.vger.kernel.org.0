Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D85F4B1074
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 15:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbiBJOb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 09:31:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiBJObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 09:31:55 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F9B37;
        Thu, 10 Feb 2022 06:31:55 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 905F61F465B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644503514;
        bh=vnMYZtzLYUlEjqvEffkcsiOlW+x9zxo48b5WEnCoJBc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VJnEf5dXMaVgu7QFE/IW21kmLJ+XXHAjjPtyT0rtTTImZtBbVRXTV0mVIUz9Xgib6
         isHyrOcpGK9FfvZC+KidtsgsIu4DGevJQoms3+BKSUi90ikZQSkKp/ExbB1gEFkOeG
         /44ffKLTzSQPg6N27CouFvUb2McyUj+yogaNXgHFTKhW/ode6pMy4JdkwwiIp+Iv8c
         44cpJbZuu/8e4+B2P7pCEvofXYC1hmg/4rCMcg4pCai8ylMNiC7g1M6aPea2MxspvM
         pP43/V7+J7RI5JQ8T0gpMMs+VmIwtZvdFvxwzAWH5qwFu8lvPm22/NB4rt/L5pVxTV
         y8gLMNi/amv2w==
Message-ID: <06446828-b589-5d7a-0e9f-25f6321e0da6@collabora.com>
Date:   Thu, 10 Feb 2022 15:31:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2] PCI: mediatek: Clear interrupt status before
 dispatching handler
Content-Language: en-US
To:     qizhong cheng <qizhong.cheng@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-pci@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, chuanjia.liu@mediatek.com
References: <20220210012125.6420-1-qizhong.cheng@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220210012125.6420-1-qizhong.cheng@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 10/02/22 02:21, qizhong cheng ha scritto:
> We found a failure when used iperf tool for wifi performance testing,
> there are some MSIs received while clearing the interrupt status,
> these MSIs cannot be serviced.
> 
> The interrupt status can be cleared even the MSI status still remaining,
> as an edge-triggered interrupts, its interrupt status should be cleared
> before dispatching to the handler of device.
> 
> Signed-off-by: qizhong cheng <qizhong.cheng@mediatek.com>

Hello Qizhong,

This commit is fixing an issue, which means that you *have to* add a proper
Fixes tag.

I believe that this is fixing commit
43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and MT7622").

Please add the tag and send a v3, after which:
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


> ---
> v2:
>   - Update the subject line.
>   - Improve the commit log and code comments.
> 
>   drivers/pci/controller/pcie-mediatek.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
> index 2f3f974977a3..2856d74b2513 100644
> --- a/drivers/pci/controller/pcie-mediatek.c
> +++ b/drivers/pci/controller/pcie-mediatek.c
> @@ -624,12 +624,17 @@ static void mtk_pcie_intr_handler(struct irq_desc *desc)
>   		if (status & MSI_STATUS){
>   			unsigned long imsi_status;
>   
> +			/*
> +			 * The interrupt status can be cleared even the MSI
> +			 * status still remaining, hence as an edge-triggered
> +			 * interrupts, its interrupt status should be cleared
> +			 * before dispatching handler.
> +			 */
> +			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
>   			while ((imsi_status = readl(port->base + PCIE_IMSI_STATUS))) {
>   				for_each_set_bit(bit, &imsi_status, MTK_MSI_IRQS_NUM)
>   					generic_handle_domain_irq(port->inner_domain, bit);
>   			}
> -			/* Clear MSI interrupt status */
> -			writel(MSI_STATUS, port->base + PCIE_INT_STATUS);
>   		}
>   	}
>   
> 


