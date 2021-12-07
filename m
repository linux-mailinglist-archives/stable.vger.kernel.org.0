Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8680B46B3D6
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhLGHaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:30:21 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48662 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLGHaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 02:30:20 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1B77Qjt1102414;
        Tue, 7 Dec 2021 01:26:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1638862005;
        bh=bcyuRKsUbEucdY5bi4P+Quy6bxtDLhKllKVRytdr384=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=L/jiHSuYk0q3VEm5qZ/YXSj6zmorhdLCVzakbbvypKEGI8XMOoQUZZGtB3FNkE3PQ
         f46Qu5q2e3uV6WYOMzv3zhAY9yKvW/lqt5mO0NyBIWimvx9Q/DJGMrxwdF1eqJ5JLN
         B/eACjD1mPJN+PcKzuGVwmbB9VOGgaDEn50PVgjw=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1B77QjGc081739
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 7 Dec 2021 01:26:45 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 7
 Dec 2021 01:26:45 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 7 Dec 2021 01:26:45 -0600
Received: from [10.250.232.43] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1B77QgZs100046;
        Tue, 7 Dec 2021 01:26:43 -0600
Subject: Re: [PATCH] PCI: endpoint: Fix use after free in pci_epf_remove_cfs()
To:     Shunsuke Mie <mie@igel.co.jp>
CC:     <lorenzo.pieralisi@arm.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210621070058.37682-1-mie@igel.co.jp>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <ed4de030-e0b3-503f-f0dc-75b103769dfc@ti.com>
Date:   Tue, 7 Dec 2021 12:56:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621070058.37682-1-mie@igel.co.jp>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shunsuke,

On 21/06/21 12:30 pm, Shunsuke Mie wrote:
> All of entries are freed in a loop, however, the freed entry is accessed
> by list_del() after the loop.
> 
> When epf driver that includes pci-epf-test unload, the pci_epf_remove_cfs()
> is called, and occurred the use after free. Therefore, kernel panics
> randomly after or while the module unloading.
> 
> I tested this patch with r8a77951-Salvator-xs boards.

Can you provide the crash dump?
> 
> Fixes: ef1433f ("PCI: endpoint: Create configfs entry for each pci_epf_device_id table entry")
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> ---
>  drivers/pci/endpoint/pci-epf-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint/pci-epf-core.c
> index e9289d10f822..538e902b0ba6 100644
> --- a/drivers/pci/endpoint/pci-epf-core.c
> +++ b/drivers/pci/endpoint/pci-epf-core.c
> @@ -202,8 +202,10 @@ static void pci_epf_remove_cfs(struct pci_epf_driver *driver)
>  		return;
>  
>  	mutex_lock(&pci_epf_mutex);
> -	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry)
> +	list_for_each_entry_safe(group, tmp, &driver->epf_group, group_entry) {
> +		list_del(&group->group_entry);

Need full crash dump to see if this is really required or not. Ideally this
should be handled by configfs (or a configfs API could be used).

Thanks,
Kishon
