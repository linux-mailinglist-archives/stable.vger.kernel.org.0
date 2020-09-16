Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7E026CCCB
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgIPUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgIPQ4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 12:56:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB69C0086CE
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 06:39:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLSLQ/9rOPSKxn9OxZBFAX84PLvbjoyYIvIgP5EPhGt+lEQWSS2pSAj6KvAcPF0qMeNVGylhhe6YyJRXxAhwgYpq7lsq09Y//aG/2AVZj61VFj4sr2mWB1sNaTarwRbO3gcW+rItagfvaTrw6l5v4HAzUqWoBxo9HkqHmLn69H7sj4Y4vTbSels+CHmuPtWtSfhd8Z6MzyM7VqH9L5uQblvBLbvjxbx4a3q+flYY7ks7LfI7muXJ0VxX0sosblLZivsDfdPrhwTDY6A1wwX7tnXJAA6pZwkhmgDkqvslB/BPLYmofYhWCoZfF8Z5vUt/Adkm703On4CEIWUAk4J9qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvkyFiSHZAl9RK6NHdio25rRlnJMbQ8yLUgqRDSUq3M=;
 b=I8Zz0Rgci6Tp/dVz8eHz1t4SrSdExyj1Uv5BRWFhaj6+EHYGwlNJVg7c4E/Zi2vNhiEILQhnlJrvk+byPikTQ1dPv8wrkaDnc3FZ4BJvITquB4qR+vwnnh4fAlohZB+Df901k/fTi9RxnJd+2GVeSbA+/+Wg2ZTuB+LRzSgz3swimFO+ZnvMxlTLIZiwvS40bmtn9UBEXBa+edOF0PhAEzIPkIrL8LZ15wr5LZ9qL4AqxJRH6/usJhfi8G5R2PEg4DwGuMr0Xi53i4C/UziEe0PyW71pXIlHnBEYRURnnD/tBryrkFZ28XqFfsgADAvUvrAw3ZNhhxJr1f239hCIxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvkyFiSHZAl9RK6NHdio25rRlnJMbQ8yLUgqRDSUq3M=;
 b=r+95VVBEvxdWw6Des/j8eJ+90SRA4lGoXjavUue6vRz+42wsGfBomiR3HIvgTN5W/qSWLNNpNRL6R3G3Gn7NmfSaPaiFZt6pf+lJ3yjGlUqga6lOOJZN8Ku+wGesJae+M2GN5WtdxcED7JsRgWO02Iep0qiLvriuurK2TYbfhUo=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB2617.namprd12.prod.outlook.com (2603:10b6:5:4a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Wed, 16 Sep 2020 13:19:49 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 13:19:49 +0000
Subject: Re: Patch "iommu/amd: Use cmpxchg_double() when updating 128-bit
 IRTE" has been added to the 5.8-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
References: <20200907030521.EF51E2075A@mail.kernel.org>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <831ea167-0e19-3557-8812-b42a8ef23d1f@amd.com>
Date:   Wed, 16 Sep 2020 20:19:37 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200907030521.EF51E2075A@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR0101CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::20) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (165.204.159.242) by BM1PR0101CA0034.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 13:19:46 +0000
X-Originating-IP: [165.204.159.242]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5259e0b3-35ea-4072-b82f-08d85a433013
X-MS-TrafficTypeDiagnostic: DM6PR12MB2617:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2617A5FB7236C33E652189DEF3210@DM6PR12MB2617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Bq88Z7/iT16GXYd53F/jDizdjPtH2OksS/AQzDM51akr97im7p47sPzfT/44dE2KjMdkCzNH5Q+7mK+3wozf0i4vbn4uV3JOuksVg6WToZUYgGs/gTaIBDrcj3Ury3BSK6UqS6fhi5QGTPhiLJe+CCccovPLk5GzC3IRjidCiwZOazKsUTIliAh8iBvNnPx8NXvurpOhlAvtdLpADfAervFZAdXBeaKOt3CBdJhdNPVY4bSqPct6OEVfdCgOTsVECGuRg+oZhB0hw8cQyOOY7CSt6MEoN3ETvz0yJk6qeSN/1Y848BwhA1NfzUPT0rvJELtPXZ56Te4nbQxLWZB+PEw94LuBgoRUbJ4xphEprQghzMdI3r6/D5gtdJA0SG/gICUla2Og1xZRD6+BFCXjGs4g6dN6S06C9lv94cfkRSs6fSz6ZeukctuEYq047mLFWxDCQ4+5QKiDuIilZ1cHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(83380400001)(6506007)(4326008)(186003)(26005)(316002)(6486002)(966005)(66556008)(6916009)(31686004)(6512007)(31696002)(66946007)(45080400002)(2906002)(5660300002)(52116002)(66476007)(53546011)(478600001)(86362001)(36756003)(6666004)(16526019)(8936002)(8676002)(44832011)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NABdkGPnwH7sVM5vBf4y4ZOKMe1tq2lU1og3d2GBpR1qzokAi5ik/B8JBIiZCuqVxRuF5X0H2cwq5K4v5dPT6A9Uzn48Mynd8uJGYc4nRRdxNgID0iFWFrMpezu6Rm24XOA9IBVXcV/ferrxOpQIiUWHLxBdlMIwGE8iF4TuI4lKfMtsv4FKs6tIbw9VaAXzOsOEgRMOzlscPXjl1gv4jufU5/3T/p3ISXPC8pE2bpWg106NwOrQ6ro8BeX8QYDmEYVhWQzZBING3Z5Qpph6IVy1YkxD1+RvRJ66w6Z3JaPnk3IH9mqSy6ooxRgYZTZnAX0sP/KxqQtF9JeWlrgRpFqT+AU8kH4A1U+fC1NGdZDZgYTU7YlFfjto7RHAH+3DZOgn8yOTey+mfkzda429VdevYiv06PKo/s6Cf8O/8rTxBgoLoRod8oxws7zCKjczQIrowILH3/J4c4n3cbUb2PqnbkkrtDYqHhvqBimZaDhDhhcpblvZRY958zZ/sM8eLT6xPD413olBEtGM+x/p6+gD8dWKfDtMq4ApLI/j1b9ZMg9jn6DMN6Zp4OhVMd+mA/4nG+lXOfTiFQvDvv02AONKka30DLYiMMPpYNGI2CgAC/aQDY1MAPFeq8+rFTq+95pmD43giNb68hBbC272dQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5259e0b3-35ea-4072-b82f-08d85a433013
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 13:19:49.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: faBwiVnX5EdV5E7jipZFm77BODLwYXuyY2FWm3GUlY1Rn0bSKimzgPcGwNnX7MUG4Ge0hXeNpqQVr4zkf8OOvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2617
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

This patch and the upstream commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after programming IRTE")
are related. Since the commit 26e495f34107 has been back-ported to linux-5.4.y branch of the stable tree,
this patch should also be add to linux-5.4.y as well.

Thanks,
Suravee

On 9/7/20 10:05 AM, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>      iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
> 
> to the 5.8-stable tree which can be found at:
>      https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.kernel.org%2Fgit%2F%3Fp%3Dlinux%2Fkernel%2Fgit%2Fstable%2Fstable-queue.git%3Ba%3Dsummary&amp;data=02%7C01%7Csuravee.suthikulpanit%40amd.com%7C1e7eb9ea3f5c402d49fb08d852dadc51%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637350447241879928&amp;sdata=O6CQHQFMlNkSLU1SHm5qHmWBN6hq2C8YUIWktEC0Rnc%3D&amp;reserved=0
> 
> The filename of the patch is:
>       iommu-amd-use-cmpxchg_double-when-updating-128-bit-i.patch
> and it can be found in the queue-5.8 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit 31640157d429339f8fffc14a645cb2c9739e0f17
> Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Date:   Thu Sep 3 09:38:22 2020 +0000
> 
>      iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
>      
>      [ Upstream commit e52d58d54a321d4fe9d0ecdabe4f8774449f0d6e ]
>      
>      When using 128-bit interrupt-remapping table entry (IRTE) (a.k.a GA mode),
>      current driver disables interrupt remapping when it updates the IRTE
>      so that the upper and lower 64-bit values can be updated safely.
>      
>      However, this creates a small window, where the interrupt could
>      arrive and result in IO_PAGE_FAULT (for interrupt) as shown below.
>      
>        IOMMU Driver            Device IRQ
>        ============            ===========
>        irte.RemapEn=0
>             ...
>         change IRTE            IRQ from device ==> IO_PAGE_FAULT !!
>             ...
>        irte.RemapEn=1
>      
>      This scenario has been observed when changing irq affinity on a system
>      running I/O-intensive workload, in which the destination APIC ID
>      in the IRTE is updated.
>      
>      Instead, use cmpxchg_double() to update the 128-bit IRTE at once without
>      disabling the interrupt remapping. However, this means several features,
>      which require GA (128-bit IRTE) support will also be affected if cmpxchg16b
>      is not supported (which is unprecedented for AMD processors w/ IOMMU).
>      
>      Fixes: 880ac60e2538 ("iommu/amd: Introduce interrupt remapping ops structure")
>      Reported-by: Sean Osborne <sean.m.osborne@oracle.com>
>      Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>      Tested-by: Erik Rockstrom <erik.rockstrom@oracle.com>
>      Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>      Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20200903093822.52012-3-suravee.suthikulpanit%40amd.com&amp;data=02%7C01%7Csuravee.suthikulpanit%40amd.com%7C1e7eb9ea3f5c402d49fb08d852dadc51%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637350447241879928&amp;sdata=9pKWytGjGIiX0yaE9WC7ahNNnT5oGG8dyufBeqr7%2FkY%3D&amp;reserved=0
>      Signed-off-by: Joerg Roedel <jroedel@suse.de>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index b0f308cb7f7c2..201b2718f0755 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -143,7 +143,7 @@ config AMD_IOMMU
>   	select IOMMU_API
>   	select IOMMU_IOVA
>   	select IOMMU_DMA
> -	depends on X86_64 && PCI && ACPI
> +	depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
>   	help
>   	  With this option you can enable support for AMD IOMMU hardware in
>   	  your system. An IOMMU is a hardware component which provides
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 6ebd4825e3206..bf45f8e2c7edd 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -1518,7 +1518,14 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
>   			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
>   		else
>   			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
> -		if (((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
> +
> +		/*
> +		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
> +		 * GAM also requires GA mode. Therefore, we need to
> +		 * check cmpxchg16b support before enabling it.
> +		 */
> +		if (!boot_cpu_has(X86_FEATURE_CX16) ||
> +		    ((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
>   			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
>   		break;
>   	case 0x11:
> @@ -1527,8 +1534,18 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
>   			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
>   		else
>   			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
> -		if (((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0))
> +
> +		/*
> +		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
> +		 * XT, GAM also requires GA mode. Therefore, we need to
> +		 * check cmpxchg16b support before enabling them.
> +		 */
> +		if (!boot_cpu_has(X86_FEATURE_CX16) ||
> +		    ((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0)) {
>   			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
> +			break;
> +		}
> +
>   		/*
>   		 * Note: Since iommu_update_intcapxt() leverages
>   		 * the IOMMU MMIO access to MSI capability block registers
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index d7b037891fb7e..200ee948f6ec1 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3283,6 +3283,7 @@ out:
>   static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
>   			  struct amd_ir_data *data)
>   {
> +	bool ret;
>   	struct irq_remap_table *table;
>   	struct amd_iommu *iommu;
>   	unsigned long flags;
> @@ -3300,10 +3301,18 @@ static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
>   
>   	entry = (struct irte_ga *)table->table;
>   	entry = &entry[index];
> -	entry->lo.fields_remap.valid = 0;
> -	entry->hi.val = irte->hi.val;
> -	entry->lo.val = irte->lo.val;
> -	entry->lo.fields_remap.valid = 1;
> +
> +	ret = cmpxchg_double(&entry->lo.val, &entry->hi.val,
> +			     entry->lo.val, entry->hi.val,
> +			     irte->lo.val, irte->hi.val);
> +	/*
> +	 * We use cmpxchg16 to atomically update the 128-bit IRTE,
> +	 * and it cannot be updated by the hardware or other processors
> +	 * behind us, so the return value of cmpxchg16 should be the
> +	 * same as the old value.
> +	 */
> +	WARN_ON(!ret);
> +
>   	if (data)
>   		data->ref = entry;
>   
> 
