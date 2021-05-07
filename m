Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1559A3764D5
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhEGMEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:04:12 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:19648
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235743AbhEGMEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 08:04:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOz5vBVvBtucvSqDiRn26Ddqnvylgw01Taxao07ysH5aezSBQ8sdFbQO6+K8149usqmZAxPsaTkxE3Z4bKql9R4vC8BtTi2J5s1lmeXnAPrbFQqbo+meONFCqFMnmB0ISsZocAqH//NDHXVXXfuiDW4sMSipX6nsE1mvXdrutRm/3MgxQatL70uhm2dvxwghreDHSX82ZCY+23R15cKB6qX3+BqYuRS+VUTp/4AwfKjq0Cxkb67irEOQ5ECOh2bUgZEJ54wQkPRhkDvF4MVE4uFLy6gzKa13s6ypN1D19DX81b86AGdDyFw125z6TP2Ic/mPe/LVr2/gri6PSJz+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1ZsXqAmb/oRh73mGwxLjK1/nvpcV7MOPmoyevni9eA=;
 b=VZv8S9PFZpxtc702+yMrGhLtmhyti99EX5F6qmJiaBMZ/YO6+kwQyLNzMqquHbOMPbvr54/33qErw6F7S5CeMkls2nk+qxwlram29rBaCLOUqRQxdeCYNo4BIFwMPy+phxeTtNRnz2KFomDwQIa0OTTvBrwYc4TLFJ5FCaSs8ZJKVPlrgsGvRdkl/XfaM8EQOUW+lmeIul13JInRSmAJigu/2yhhRDsUCjTXiB3htrdfGk7GFo/emgkuwgG6oqJbbMsU/IhpYEUkR1X8DTkdu4tp8ECKiZpqYmHPUxj6Dige+4398kSeeW/pBLhLbRRMHf4aQsBIyDcVfC0rCS/Y2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1ZsXqAmb/oRh73mGwxLjK1/nvpcV7MOPmoyevni9eA=;
 b=m9/cpXGfoklLdpRibbRvkaxY6wq9n95Q06vI2EbRWSrA9gXUjixCM7Bm06qduVgQoLSMmfZNtDhaP9CAjQu0/YLYCAFZbpQiIJti4pv9+Epq5GSybkx0KcsI4/+UQZIHWOQ3ko/qsv6qqBhA1YzSh7rAUXDxDP7A2DYHVOB8EiUYh2haYHZhiDsm0yJ6OXtUxEJXxs6m1sw06wWhjGMLM9bYsPUPqMZ9ccYcxn00IqAKS1FK0xtv9EW+hHTKh8QFAf5atLT86CK6rnkJ2w5guDtosiUZ9JEaevQTyxDHIx3EP9Dgnucry8+K5E9nubkZJO+yVjXhLmWIbv9e/RDxXQ==
Received: from BN7PR02CA0028.namprd02.prod.outlook.com (2603:10b6:408:20::41)
 by BYAPR12MB3525.namprd12.prod.outlook.com (2603:10b6:a03:13b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 12:03:06 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::52) by BN7PR02CA0028.outlook.office365.com
 (2603:10b6:408:20::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Fri, 7 May 2021 12:03:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 12:03:06 +0000
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 May
 2021 12:03:04 +0000
Subject: Re: [PATCH] gpio: tegra186: Don't set parent IRQ affinity
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20210507103411.235206-1-jonathanh@nvidia.com>
 <CACRpkdZZHh390cUxi+7cD6D9Gvfbh5KyxjSdHYUDoRXEMAZHOw@mail.gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7d9fc58e-9c44-62a9-3bef-f9cc2f594bd3@nvidia.com>
Date:   Fri, 7 May 2021 13:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CACRpkdZZHh390cUxi+7cD6D9Gvfbh5KyxjSdHYUDoRXEMAZHOw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91fa4eca-bf7d-4f13-bb16-08d911501335
X-MS-TrafficTypeDiagnostic: BYAPR12MB3525:
X-Microsoft-Antispam-PRVS: <BYAPR12MB352541EE713F1BD0D6FBAE64D9579@BYAPR12MB3525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8KLQvAS/8kBMVndLDPmBEK5mFBPcG7xtZtffV4GrU0RcG9DeC8QA6GM1B8BGbP2es1Kymg/9O2UTdB/jP21iRUSMfbwY5eFDSxW21Fic5kgPWCrHL7/SThJmNa4BRL2AXimTZ2ge54C0nHQRvlSY2XlwwmJye9eoqAUg1M290KSgt650oWJh7bWA2expqaoOG020wYsALnpLg7C1v9Cvk2WJ9H6NeBgym/dHk2H3qwb4amZild6a/FTTaVQ+kx5xcdYTiraP9ccJm0vL5v30Et7xVXgbZ3Rc4kQvBG9qctaAoQ4Mr/zQxBV0eUsJ6gO4wVxC36g2AYGnDe/BLjWwjm/bZmiY+hVUdG+QUaodBTql/FtyFK/X6fMGtQdb3k9w0hejoebjbTqK2UOt5mQFFdR116FhS5eqSABFFn9t9ltdr2nwqCgVAemxUGKeNcZTBsQAolmKlVZaOKVbqDo+RQZT7HM3WiedWFfw3KX9yNAYlvWHreoiQMIA1k5mbaNLGasFlpGxb6O96c/NjhaCC9fRyevqCv+Ki3hxb+yGuq7mu8w0UKn3VnlY0lAdTj8oeTBqX68TEbQTglHFLH0eQbMqTpKNoSRTSXoWUqO9v/w3SU5pTn53PFNxWoksprC57WrQyjY6Gg22TBWVVzA66Lr9z5mFZZB78ZYq1FVC98Uh/BXxS5hPipzHwsCq9vQ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(36840700001)(46966006)(47076005)(478600001)(36860700001)(31686004)(8676002)(8936002)(356005)(86362001)(6916009)(53546011)(36756003)(82310400003)(83380400001)(82740400003)(2906002)(7636003)(54906003)(70586007)(70206006)(16526019)(186003)(2616005)(26005)(336012)(6666004)(31696002)(316002)(16576012)(426003)(36906005)(5660300002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 12:03:06.5281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91fa4eca-bf7d-4f13-bb16-08d911501335
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3525
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On 07/05/2021 11:41, Linus Walleij wrote:
> Hi Jon,
> 
> On Fri, May 7, 2021 at 12:34 PM Jon Hunter <jonathanh@nvidia.com> wrote:
> 
>> When hotplugging CPUs on Tegra186 and Tegra194 errors such as the
>> following are seen ...
>>
>>  IRQ63: set affinity failed(-22).
>>  IRQ65: set affinity failed(-22).
>>  IRQ66: set affinity failed(-22).
>>  IRQ67: set affinity failed(-22).
>>
>> Looking at the /proc/interrupts the above are all interrupts associated
>> with GPIOs. The reason why these error messages occur is because there
>> is no 'parent_data' associated with any of the GPIO interrupts and so
>> tegra186_irq_set_affinity() simply returns -EINVAL.
>>
>> To understand why there is no 'parent_data' it is first necessary to
>> understand that in addition to the GPIO interrupts being routed to the
>> interrupt controller (GIC), the interrupts for some GPIOs are also
>> routed to the Tegra Power Management Controller (PMC) to wake up the
>> system from low power states. In order to configure GPIO events as
>> wake events in the PMC, the PMC is configured as IRQ parent domain
>> for the GPIO IRQ domain. Originally the GIC was the IRQ parent domain
>> of the PMC and although this was working, this started causing issues
>> once commit 64a267e9a41c ("irqchip/gic: Configure SGIs as standard
>> interrupts") was added, because technically, the GIC is not a parent
>> of the PMC. Commit c351ab7bf2a5 ("soc/tegra: pmc: Don't create fake
>> interrupt hierarchy levels") fixed this by severing the IRQ domain
>> hierarchy for the Tegra GPIOs and hence, there may be no IRQ parent
>> domain for the GPIOs.
>>
>> The GPIO controllers on Tegra186 and Tegra194 have either one or six
>> interrupt lines to the interrupt controller. For GPIO controllers with
>> six interrupts, the mapping of the GPIO interrupt to the controller
>> interrupt is configurable within the GPIO controller. Currently a
>> default mapping is used, however, it could be possible to use the
>> set affinity callback for the Tegra186 GPIO driver to do something a
>> bit more interesting. Currently, because interrupts for all GPIOs are
>> have the same mapping and any attempts to configure the affinity for
>> a given GPIO can conflict with another that shares the same IRQ, for
>> now it is simpler to just remove set affinity support and this avoids
>> the above warnings being seen.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: c4e1f7d92cd6 ("gpio: tegra186: Set affinity callback to parent")
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> and sorry for the mess.

No worries, your change made complete sense in principle.

> I don't know if it would be possible to take some inspiration from
> the Qualcomm pin control driver:
> drivers/pinctrl/qcom/pinctrl-msm.c
> 
> This has quite elaborate handling of this especially marking the
> lines that can be used for sleeping and IIUC are reparented to
> the PDC (power domain controller) that Qcom is using and
> which I guess is similar to your PMC.


Good to know. I am was wondering how others handle this sort of thing.

Thanks!
Jon

-- 
nvpublic
