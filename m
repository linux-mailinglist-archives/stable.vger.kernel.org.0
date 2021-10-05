Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76E7422858
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhJENwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:16 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:20321
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235259AbhJENwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVzVtVd6gQADftCVtNqzOgWkqNmBHPNMAdy23G41fif6pvJ5d5B+ct2/uiERGZ/z1S/B+HXL6hQptVnpKZ9uGzfstJ8QFySrpAew1FqdbH5s3yF0RsE0GKLzO35Um+v1DZ93f779mvML+9eueV9s6jtaRFxWNG4cHwBs5+uTmdva/XXSLcvr6X7bJtGr5dL/jhd7zeVGZIjVXF9Lfj4gkST2JxvDvflYta0t/An748v3lDI3rGvH9fuiwWMZpa6X0SmCXkMApqnt/puAA7zLyuYovbs5uZlZcx5Qc6h49OlQ/X0xZx3WOuXGE/Vi+cGU5M9V67wwzJkzsFmNmqOt5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFNaxRADeCi6YMDUPDV/QG5SjFRTlcpvvHAyy7rkHR0=;
 b=msuj6q/7a+R0hfQs7tB1RX8jEcwOz9XpcD7zJ8P9BgfA0YNOJGodpgWjFVqb6sVknn10wZNuj68jDWLb+0klA9NAvKoYsMIHgVslGIFJifs4bD06J4EFdtTGvH4NcOxlQN91mB3oLtDxWJBBOMhX09Vh+SfO96obSciH+havH5b3rLKBoYkYFK/NiTlJiEISTAXelyhV1UMgdaZFM+RCDa+ohiXUPuazGFJyzQMdIApcZy9ex4hnOrOFL/5iefpSFgOMeuqspYPi1Y4JIsPKKd5d0wDdFCI9m8ty5DZhhkjxQHfsJqxhwOeonfoTeQ3hh7Vrnwyp74hHLauzQizulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFNaxRADeCi6YMDUPDV/QG5SjFRTlcpvvHAyy7rkHR0=;
 b=j5Jeiu1LXQDWazoelpDYC6EHkf+eOL0BV3BjIgYsiHtNHrV+nAlPOTl/77ZS5yWq7GChKuLOtRE8OG1PYOmVKFlaeOLenKBFRt1aJcSno5kjKQwfcexsWy/boUw4yehi7Ld8S5KNLpT3CxHhTYZkHvUpqqqkaCxLGAvlbIBZo3m75WQd3ZBelE8JgyaoehZa28d3wWbKzQqO+5S6MxaQf5vCSLu1VfcyWIHZfZMsdgUPTsYWxcY0CYj1ZKRGoitN3fzt7IcosRJGzRAsHIRcmvd0rXuVLHNr45RKVJJs2yZ+YfArJWK22rCnfGCEKuOADJmuGcOhrtrJ+FzJHciLjw==
Received: from BN9PR03CA0288.namprd03.prod.outlook.com (2603:10b6:408:f5::23)
 by BN9PR12MB5113.namprd12.prod.outlook.com (2603:10b6:408:136::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Tue, 5 Oct
 2021 13:50:21 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::9) by BN9PR03CA0288.outlook.office365.com
 (2603:10b6:408:f5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:50:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc2 review
In-Reply-To: <20211005083253.853051879@linuxfoundation.org>
References: <20211005083253.853051879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3fb77fbfdba94969b582af4c951c330e@HQMAIL105.nvidia.com>
Date:   Tue, 5 Oct 2021 13:50:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e0f39f2-7528-46e1-1a98-08d9880712fe
X-MS-TrafficTypeDiagnostic: BN9PR12MB5113:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5113FD5D943675E6D3ED8166D9AF9@BN9PR12MB5113.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K4qD+zLH6JIkJaK6zPrB1ffFY2TZA44VtAW6ideq3wWUUscL+xFeq370iA3Xwo5nAkw+lm2wj6Coy6lCou/ruY2cucUjMyqdQTz66J+Q0fG5S2/86G9sznHtUmppKEMSqjq0vvKQTGJlImbeht/js+PxcEpFykwAXcayUAtF45Iek+rIRxbYbiqT8XbJtjkWyEmvdhXkuKeG1WhKk7d1bZBb2JKDZsjkv91r5/IDPUISMcAmWDaHk8MyEiBfwQxwtPhlV0O75TwvCyjnzhF9drbtr9HtzVZTcO0W78UXnNMpPek/XFqTswF2ABYNbRIHgYAgYfY9Dk7g+jp+PeLL1PinMq1O0hpI7b3ZztGRcauUkMM2w64/twe8BojPeLoI+1EjiQD7ApiEIyXBI17D9+zVTDdWxWiX2Z/x5+MdF/vSzYgrurYD0nEtcnJJuowa+clETVsDfFIKAwx55Uq9xjaeTkgeQ60YI4c5Sse6BOzMzVwfVJU/WxYIV2iaPillaLPcRzn6c6dDhURQAd4CgS+FNEIh4lu98x3lQjCzwL8iqWovEisWe1oizOK9UZirk4lgh7jykuVTwBLKdJwvBD3EzvTjpSiR8yogq3c5XSWknhtCZ//o/w9xyBenGMxelqhyavJCEGx/n7swjqmBMPICoQNOryWSkiL+Z0TEGLFuov2WyuwKv7Aj5egqu5+h/ONKAQTB7OWe0LIKM7zHgVCSssAd/TSDVVXcFnjTd68uSz3MS2fFguySKsmI3QCsFqjrMU6INtW0Y+kDY/0cawc3IU904sHHi2oi4eZIsUw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(26005)(36860700001)(426003)(24736004)(6916009)(86362001)(186003)(70586007)(70206006)(7636003)(8676002)(316002)(356005)(108616005)(47076005)(2906002)(508600001)(82310400003)(5660300002)(336012)(8936002)(4326008)(54906003)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:50:21.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0f39f2-7528-46e1-1a98-08d9880712fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:37:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.286-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.286-rc2-g72b93c725842
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
