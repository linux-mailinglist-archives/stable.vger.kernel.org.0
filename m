Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8023A3C33FA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhGJJ2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 05:28:22 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:54890 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhGJJ2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 05:28:22 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 499D620CDD48
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH AUTOSEL 4.9 04/26] scsi: hisi_sas: Propagate errors in
 interrupt_init_v1_hw()
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
 <20210710023604.3172486-4-sashal@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <8881b462-f4c9-232c-124b-80f44b45073c@omp.ru>
Date:   Sat, 10 Jul 2021 12:16:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210710023604.3172486-4-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.2021 5:35, Sasha Levin wrote:

> From: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> [ Upstream commit ab17122e758ef68fb21033e25c041144067975f5 ]
> 
> After commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have the
> error codes returned by platform_get_irq() ready for the propagation
> upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
> probing. Let's propagate the error codes from devm_request_irq() as well
> since I don't see the reason to override them with -ENOENT...
> 
> Link: https://lore.kernel.org/r/49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru
> Acked-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index c0ac49d8bc8d..5c49806a7ae3 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
[...]
> @@ -1729,7 +1729,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>   		if (!irq) {
>   			dev_err(dev, "irq init: could not map cq interrupt %d\n",
>   				idx);
> -			return -ENOENT;
> +			return irq;
>   		}
>   
>   		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,

    Again, this patch is borked without a preceding patch mentioned in the
changelog.

MBR, Sergey
