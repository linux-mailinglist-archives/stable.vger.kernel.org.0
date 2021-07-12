Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C943C5D0A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhGLNSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:18:10 -0400
Received: from mail-mw2nam08on2086.outbound.protection.outlook.com ([40.107.101.86]:61751
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232274AbhGLNSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 09:18:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCDSEFrgDQ0nisE/Y1gg7gtpBE6JgsSxxESGLD9FMc0UEEIM5bTlVaKs9zKM4ask9AQnlCFFjyiGTFW+eDpYYqvFd9ZuAlfdmsIBoBcIxAfS0OkCHtYTlaZcMH2AwkQo6CQdWVEfarGmUG8YVoOQ27XXK+gutYyj5NlUBwHS759thdsGh2Brj62dtwwwaMVjDiawrcdbCOkuX/aIkF5PN00E6evPnibzp/f8jLfrKwCJhrKT6UmBJ5EJyHf2YihVbMSEO/3cyumeva3+ciYBzQbHyclWn81ExbAjl1VhJQUWUjKc/DiaJxJGkpS7V0OXuRLaQ2CYfbGSk7LnLaDrxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hijCJoC/msYH3Tk+tub3GsvPzTJPEEQsXqiHDJCldpk=;
 b=NB9ri5+KpqrAwyH4rflkkVZK2GGCXSD25yPmTwKTHDRwaqyo0gyq/Zh7f2m4xdFj0iUDTb4VnF2r1sXMep3QpJJ4uu0P006nwl/M7DZUxwwbdaBg1xDWfCi0VBnAHjL3ixnv5f7DDoT7yKt2nAQD2HfCpjsK0G2m/T83EgVvxrWgYE2Baszl1z5ZPDUPhj9ErCJBOzmjVio4pQZiYRfr8M5PF37wL8K1c+TRBMajJilgLLjvEhykk0/pKmSaVkE4S3ZAQFPf/MWd/0mre3xRRorO0wZCgAwtv0rbgpRxcS710x1VY7cfYrwa0JBsIHnpMDjtAAGKumZ0x6iYAwCh8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hijCJoC/msYH3Tk+tub3GsvPzTJPEEQsXqiHDJCldpk=;
 b=j1cmj5Mqp2Hpg7eZmbFGLTxBvl5Ed7NPIrNB/wPfyhJ/UzoSQIPgcsuZGc24PZEEMTt1jsulNE6ehn6rB0CGHqWr5xHJP2gZMDJJ6fPRLrcTZtNyQY7TBzrG/x24pQNGB7t9K2/0gI6q0Y1zV4WbiZrRRJsHiQ6R7oWYBixNz+m/1vcQWC/wOMFHLrncMNNfiGh5pK4VXmcbV/dxVEsgDmMTViZ7hVEGmTuvABdzfDuheoOmZrE3UrKL/Wr+6OQNFtKHAMOcb7OWlFa9raK86sgu5/EoBNxmCdSkAUV3zRFb6qZrr+t8z+C4uJsxesVZ6M/J1ZvbA0Ns3664AZRgoQ==
Received: from MW4PR04CA0072.namprd04.prod.outlook.com (2603:10b6:303:6b::17)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Mon, 12 Jul
 2021 13:15:20 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::10) by MW4PR04CA0072.outlook.office365.com
 (2603:10b6:303:6b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend
 Transport; Mon, 12 Jul 2021 13:15:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 13:15:20 +0000
Received: from [10.21.180.219] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 13:15:15 +0000
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210712060843.180606720@linuxfoundation.org>
 <dfcae9165b814757b9853c28cc11e820@HQMAIL111.nvidia.com>
 <20210712093526.GA23916@duo.ucw.cz>
 <028eb5b4-c0bb-d4a6-5e06-ad508cebd0cf@nvidia.com>
Message-ID: <e926a04f-78d5-3737-a1d6-b052f6b405d3@nvidia.com>
Date:   Mon, 12 Jul 2021 14:15:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <028eb5b4-c0bb-d4a6-5e06-ad508cebd0cf@nvidia.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d521b86a-5e3f-4ae9-6815-08d94537197f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:
X-Microsoft-Antispam-PRVS: <CH2PR12MB42620269CEA777D02855FDF8D9159@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMZfs0P93/jHg7XeLOpMuYrzA1tYvzw8NvdGLHKjIhxfIne9Qtd5P+VscERV0q3VdhsbOwG+Ow8UgwyC1a+uky0n+kipwoue1Fgvh/sNgtyl43N00Dl2RpuT61l60Y5psWbyEadJ8Ex6KBYJSu+MjnfM2FN3VZGgfr+zbBryeMWCim5f55kIjlCe4xf37YLArLLa9Z91UKov9LzjHU8eRypZW4cRIV0umm4Ph2khSrEWqrjUqIJVYMAOUS0olriaixAU6PC1G5jtTnmKuAjij2kkKRtrdI7enN1aGwuvLuMSkuMmz1KKe2My4yfMbGigU+eWAPCk/3hVc4dK90Tm1mm66wTB4NZcg8k/dVGdPDhf1/twZDkJqvAd7Gms2a1CkxS7VmMrhRmJJPUPpz4qQCc+e0yg6tNWnQX27HwfSvPGNeW7szqOnuprvsE3il1j+X726FxYbN902Pf+xjvMeQQdHFMvp5AQ5QQDd0g8j2rHGsMyhgcGk3GW83MYPbYi/z9hINvKoiwsBTy0OLB/ep8gdZ18A/JkyQPk1mDJubBE0X3aH9bmSqhLjE1xXpW4Glx0K8kJ4KV+dmVKc5jRFwnCT2QwmUFrbPtLE2mMb6P3Du3WYpxxsiVMf3ceHKsfKRitFtGBS74o6+M1AmcoJuH8O6UGHKOL4vVM46k9pYaSHovofHvO0AVGNHBEcN56tYUC3HlRFGAp3zYoG6RxhO7VlJlyzFbHJnKR+gBrjsTHchfa/XDhjzA+BMklYmmN9Mivn6Zejp1c/wrN6pONZA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(36860700001)(5660300002)(8676002)(47076005)(8936002)(34020700004)(70206006)(70586007)(26005)(82740400003)(356005)(7416002)(83380400001)(82310400003)(6916009)(2906002)(478600001)(6666004)(31696002)(2616005)(426003)(4326008)(36756003)(186003)(336012)(86362001)(54906003)(316002)(16526019)(31686004)(16576012)(36906005)(7636003)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 13:15:20.1404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d521b86a-5e3f-4ae9-6815-08d94537197f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/07/2021 10:42, Jon Hunter wrote:
> 
> On 12/07/2021 10:35, Pavel Machek wrote:
>> Hi!
>>
>> (2000 lines trimmed)
>>
>>>>  tools/testing/selftests/vm/protection_keys.c       |  12 +-
>>>>  638 files changed, 5205 insertions(+), 2782 deletions(-)
>>
>>> All tests passing for Tegra ...
>>>
>>> Test results for stable-v5.10:
>>>     10 builds:	10 pass, 0 fail
>>>     28 boots:	28 pass, 0 fail
>>>     70 tests:	70 pass, 0 fail
>>>
>>> Linux version:	5.10.50-rc1-g3e2628c73ba0
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>>                 tegra20-ventana, tegra210-p2371-2180,
>>>                 tegra210-p3450-0000, tegra30-cardhu-a04
>>>
>>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>>
>> Thanks for testing... but could we get you to snip the parts of email
>> not important for the reply?
> 
> Yes I have noticed that too! The script we have use to trim that, so I
> need to see why it no longer is. I have recently made some modifications
> and so clearly have broken that. Anyway, I will get that fixed.

OK, I have fixed this and resent the reports.

Cheers!
Jon

-- 
nvpublic
