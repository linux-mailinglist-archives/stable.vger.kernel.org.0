Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C476CF8CD
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 03:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjC3BpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 21:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3BpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 21:45:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEC64C1A
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 18:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EB7Cij960prXbKIZ2ghpr9053FuyNwH0+iUv0NYHevBORU++zOe+dqcIJ8TCPd1XGGIcgf/0mgLxwh4+7qqZDPPuYyZaKTDsbqJahq6xV5MeJ7xMJhqnqyDdd6bNy2cSs/2e2MwBSozBCgUdP3SXAUvaD/WM/8TxiOQyT5eeey1Y6shmAXPkMOoY7pIa8K4QgHeS9devxJCYYua95P/9K0g77FYMTC4CgLj6god+i3qv9HN+aIw3TbZZcwRtFbWY6kCDuiTGS5y7vQvRcYjXgWkpttYN3AouWz1/t68oANpw0Jo2geWn0spJgJswlg+7U41xAJF/ugAuXAndXqhO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mD9c9Pos7YjQZjtZtuDjFkLrseBBf1D9sgnC0ePsZY=;
 b=Dkj7r7cWpEVCQTGNdS7xVMPMwEzIBH1lxpzWrNO2f773haViOvmYyfROuSQZ6bHw3hHaZy566pw+pQ9YOumhAmTzXhnrHZfEP0xXGO6UTJBot6kQLj9d5WA1UfAVIlfnmajkD76nXndfei6/QKkIRlz91zNasGtbH/k4TDJtmV96dR/VsR/oDiYCwvsHQ7XRh/TPQ8jZs14+ZOQNikXyflwfRy4n6Wl1viBlCUPSjfpIcoNxyItn8lGnwEytb8FLgL1hXBSnc+iR+2/3nnqrsJjcRPSn+w+RkvCGPVGMB13zIsDnMluRrNtit2ODTlgfMQyV4cu7Y7UqrF7tLjTUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mD9c9Pos7YjQZjtZtuDjFkLrseBBf1D9sgnC0ePsZY=;
 b=SK+7syhAGOLSVHaTKjnZnxPJnxHOPJZFhyDh1Q0cGY5PGvwXS45EbacS9Hg27gz6rm4xXPJmKEEr52VtXYD5f5G6ztUKujdM56SIzL2MzHCtnkJFoFaMs0Bxz8ncbk/AdRaZabU4afHhoxOSYmIGmGksFGmpzRwQLeahGMc7rUBAKVvb7vUCf9lyLoNpZAgDw5nKBz1jdkF2hgm6lcEbqsQwZsAvj0IZQQjkoKGCWql09EjgXohNFK+aAEXv+Oeut71zHSQbxfPyJgOiADyQjt+DxUQod2ZylQ7etuy2o2J5jPr6tXO1DPB6OcrKXwwkn8W7yg5Zlju3HSoEbkYzxg==
Received: from DM6PR18CA0011.namprd18.prod.outlook.com (2603:10b6:5:15b::24)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:44:58 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:5:15b:cafe::37) by DM6PR18CA0011.outlook.office365.com
 (2603:10b6:5:15b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 01:44:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26 via Frontend Transport; Thu, 30 Mar 2023 01:44:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 18:44:48 -0700
Received: from [10.110.48.28] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 29 Mar
 2023 18:44:48 -0700
Message-ID: <83040531-ce19-0dca-6e73-ef08407a6669@nvidia.com>
Date:   Wed, 29 Mar 2023 18:44:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] mm: Take a page reference when removing device
 exclusive entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Ralph Campbell <rcampbell@nvidia.com>,
        <nouveau@lists.freedesktop.org>,
        Matthew Wilcox <willy@infradead.org>, <stable@vger.kernel.org>
References: <20230330012519.804116-1-apopple@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20230330012519.804116-1-apopple@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|BL1PR12MB5288:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc39ea9-adf1-400e-5853-08db30c05eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q37KwuiI9d/8m9NJlkSK8x/NPnH4fGma0+5FOtUoEtuG3gLxDS8xZRW7zX1bDXqsORmbayGP01h3c0XSqKZ28MmbdcAp9+2OiCJQVB1Egt0esg2OKe2XRafgL3RPf8ctPj1LRdzXwz50GyoKOS7AuRFqMhpVCFSPL7tukM8LWc2zU985mgJ+XwJvId4XrCoez+1yBzk4QE2LxrDZFmSOdUfgzYsOXUJl52cy2xg2pe/9JmJATKCu8DuULp7TLnd4Ar8/v08qY8BYEn5a/LpSFw9XOG1AoDBSXwOd0ClHvv2wmBUdh56DoxwWnTrOUet2JAE4C6hcRmi+rHxlBe+MOV7Cn215s6dvq6xAynZpTviBO6wEp6wAzBKWbr71ZcDhPGe+jJkjUo2kRH1qQBXxT2sWnvlswmOkZo7fZddlQsbZLXYFSmq60dW2AdDaUprD40V6z5O2WLilQCLFTnmctLz7lu4KzJQWXRIEB71kYVNOdxi7FMqCdRmQB8baIQBZUcDaLYd3o2UUHiBOqryOMWxlfyRNSMVolYKVODtvKZJJJsZlbWbQu0WCAQZD+4HA76tstM8cxzbpCUTKmnwFAjG6vq+djrL029AgJf421xLmIDGDDAWkF2DqfKMijKO7u4aqLKmK+CUHWp5A5cC6zar3FousOsJgrF9R48Z5w4VqZceuAK5WEhYe0VEk6gS69CZC45vQQYFsdYQfg/y6kSzRRACUSnZ2IwB1qXKeMaohqVE5OZuGcQjMJ1kaCayO
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(70586007)(26005)(7636003)(82740400003)(356005)(53546011)(478600001)(47076005)(426003)(36860700001)(186003)(16526019)(336012)(8936002)(5660300002)(2906002)(2616005)(36756003)(70206006)(82310400005)(110136005)(16576012)(54906003)(316002)(31696002)(40480700001)(41300700001)(4326008)(86362001)(8676002)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 01:44:58.2291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc39ea9-adf1-400e-5853-08db30c05eb5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/23 18:25, Alistair Popple wrote:
> Device exclusive page table entries are used to prevent CPU access to
> a page whilst it is being accessed from a device. Typically this is
> used to implement atomic operations when the underlying bus does not
> support atomic access. When a CPU thread encounters a device exclusive
> entry it locks the page and restores the original entry after calling
> mmu notifiers to signal drivers that exclusive access is no longer
> available.
> 
> The device exclusive entry holds a reference to the page making it
> safe to access the struct page whilst the entry is present. However
> the fault handling code does not hold the PTL when taking the page
> lock. This means if there are multiple threads faulting concurrently
> on the device exclusive entry one will remove the entry whilst others
> will wait on the page lock without holding a reference.
> 
> This can lead to threads locking or waiting on a folio with a zero
> refcount. Whilst mmap_lock prevents the pages getting freed via
> munmap() they may still be freed by a migration. This leads to
> warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
> when the refcount drops to zero.
> 
> Fix this by trying to take a reference on the folio before locking
> it. The code already checks the PTE under the PTL and aborts if the
> entry is no longer there. It is also possible the folio has been
> unmapped, freed and re-allocated allowing a reference to be taken on
> an unrelated folio. This case is also detected by the PTE check and
> the folio is unlocked without further changes.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Changes for v2:
> 
>   - Rebased to Linus master
>   - Reworded commit message
>   - Switched to using folios (thanks Matthew!)
>   - Added Reviewed-by's

v2 looks correct to me.

thanks,
-- 
John Hubbard
NVIDIA

> ---
>   mm/memory.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index f456f3b5049c..01a23ad48a04 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3563,8 +3563,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>   	struct vm_area_struct *vma = vmf->vma;
>   	struct mmu_notifier_range range;
>   
> -	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
> +	/*
> +	 * We need a reference to lock the folio because we don't hold
> +	 * the PTL so a racing thread can remove the device-exclusive
> +	 * entry and unmap it. If the folio is free the entry must
> +	 * have been removed already. If it happens to have already
> +	 * been re-allocated after being freed all we do is lock and
> +	 * unlock it.
> +	 */
> +	if (!folio_try_get(folio))
> +		return 0;
> +
> +	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
> +		folio_put(folio);
>   		return VM_FAULT_RETRY;
> +	}
>   	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
>   				vma->vm_mm, vmf->address & PAGE_MASK,
>   				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
> @@ -3577,6 +3590,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>   
>   	pte_unmap_unlock(vmf->pte, vmf->ptl);
>   	folio_unlock(folio);
> +	folio_put(folio);
>   
>   	mmu_notifier_invalidate_range_end(&range);
>   	return 0;


