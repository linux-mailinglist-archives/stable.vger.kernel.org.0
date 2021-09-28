Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9C241A935
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbhI1HCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:02:00 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:19873
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231882AbhI1HB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bgz1ZP1LAfW11QkLnw6Ex0Ii+hlWDnQxWjpNCreACYrT+JzGzg7w2sGG7RdqutMPeQjkEU5YUUMfPjRBIU2flQhmoxuTaIFkNQpbpIXaRa8iB9j5YkIOVYzq5HV+emQBCAoApR5xVeRV0hqYSmxlyn5iB79H46ZE5e0LB8m9Qj3x9vCPsqiSfKIkKA/hwsubNUC9HM8mT+2Fv187/+vkBb8j+robVEDU14t2qZf17obbqo782xkMw4JQ+ZXsFjgc3ChlbT++bjGGmyesgIa1IogQfYcw/B/BULBihqx3RQNxn+oPC9h8vWh9tBlcQ5Davcxllxuf2px5HIgX9sVQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pxG09rRESeCry8Qc1RENUQ93iNm4yOnTEeiWpY4c9Zo=;
 b=kSt8vNNCLvBpF0fwHSSenUwr3PWOoCIoGzHEcdvBXJKBiy0LapVy5UFt35UcRyKDPWZj0hFz5o6M2pwEr8U92TSIQ6LojivrB8xnr+hV3syV3jc1OCdRUNN2x6wh1eDE9UlpFCRK3MNEH6Ya6+Pb0efwKU5+vyCrv4Mjeb8eTGzRrXhGr9C7H8iAlfLETTWHQ54d7Qmr63JJJ9jTXijRBVtezbCQvwBheIo9RNnpD206CsU90/HdhS33263hE6PvkMHwJxbVM7q366I4KRwulYFeG2mu8A7fR6y5RVg8pR/zoTWoCIFibFtvupYf3azobjLf3Tu9wE+ypCrAJtpN0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxG09rRESeCry8Qc1RENUQ93iNm4yOnTEeiWpY4c9Zo=;
 b=ssUrcjMrbp45QzBxKqbLdWPOIxaqjN9qVxAKfEehrC2G0BRQeG5JT/gdGRyAHIZOnKVbW0590djUGXYkU44SZxXkuMygp9Ed4lW9wqWoo4ow5yhnwloiXso6oXokzc+MzB5Ya1FK/RYmE7TBVBdWq2gikIXH2cxzo5HNOh8CFNkmeHHwICr5SjiT4FT6gH4OmpByVmodmXxy37qX4Z+cK9oStqO7WiJ2QQYigEhzp4EAzf5OycGfk/YHr07pMXBGmGXINTL5LYhcfzikfWXYMeG5HGPP+h+QnDxzX8KanAhPQkqPZdi5QC2xCPJq/NWWQckTa2dMePtVMh3/xTpt2g==
Received: from MWHPR17CA0087.namprd17.prod.outlook.com (2603:10b6:300:c2::25)
 by BN6PR12MB1475.namprd12.prod.outlook.com (2603:10b6:405:4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Tue, 28 Sep
 2021 07:00:16 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::be) by MWHPR17CA0087.outlook.office365.com
 (2603:10b6:300:c2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 07:00:15 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 07:00:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/103] 5.10.70-rc1 review
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b4199ea9b8ac48a9b26455ee2e1f3d34@HQMAIL107.nvidia.com>
Date:   Tue, 28 Sep 2021 07:00:13 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 077bbe25-2c0b-4b72-99fa-08d9824d9fd5
X-MS-TrafficTypeDiagnostic: BN6PR12MB1475:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1475AF09DF84D5AD7AED6589D9A89@BN6PR12MB1475.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlknp3yX67qiD9Qw8rQ3S16LPuawIzNbQUnhiOVmM71prEtSb3uaVGIQu4X0BAsxj2oPLwyktZPe4pe/H6n0sRiS332bpQB+VQGJ05xAdmoyPA9zj9D2N4oB6IyJ7ZU+yeNSOW1pwFDozyVTgQQ6hM0IypWW/k+97+pWNY9rzszmgfKdwwoZwbWAjCfQav9ygJQ1Oq8jjSzp6dasoPwNKdvPNm3w+mPeH25FFRxS6ZqMrzAW8S1Z+AcbWNupuPBca+ItOUPyTr8q5nO5Pq0fLTqY2WXmm4NAniB1WLwj5UTxfRCj6Aq9S7WmnJXkADXn/AlrCf4pk6mtmzzewok77SCoRdjvXwz/hGHqMO8yz+mpG9PlpjCd9Y56XOVquGdREIxvEg9m+GQZ7Qv/Bk4BMcZlmyPcBzjmRal/EXc8YpFPUhfe86MakfotZGh8Kom1Uk4ZHTeN1wHLBm6igt0bPiPGfT3TIUzvNwRKgJAQgl6O2ra+1Y+p+C/PouTnOXS58KJr8ptAHyOL0rXyER1hvfMmip2qMsuvvpNkXQsleutQWGAhCbLzO+OOe7VvzKlAIWCdcyu1Z8sk7obx7A0rqDdM3HOd6eNwUhpkCX0+CmhnTCZ/jPKk63/J5sEFrPUPhZ1P707G7J5UZPpirQlocxAc5x3YwXk75FI0LLc28c+oUFCWa9dCMWshpc/VujkUPePBK/lR0dPuKAGVfCfr+LIgFxA1CXLumWQRx/N4SuFBmQckbtFP3LqYP70iLS9QIPkOzL+MR52rhJ2FTd4UL8IKdvrcAa4qfDfOskZgolI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(7416002)(6916009)(7636003)(26005)(356005)(186003)(70586007)(426003)(70206006)(508600001)(2906002)(966005)(24736004)(316002)(108616005)(86362001)(82310400003)(5660300002)(8676002)(47076005)(8936002)(36860700001)(4326008)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 07:00:15.4255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 077bbe25-2c0b-4b72-99fa-08d9824d9fd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1475
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Sep 2021 19:01:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.70-rc1-gf5ab3f2ed675
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
