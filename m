Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A073407D38
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 14:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhILMT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 08:19:29 -0400
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:26976
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235278AbhILMTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 08:19:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKu2RIbk60mggFuj52Mde2I4P6oR+CUicXsfH+OgJHBZkycS+iJRBdn8gEqtmqzcZl8K3bYM+Z3fzQpmdIto8Ch6i9wDkAFZGxul2qyQhDQhiRoSx/v+eDn6rmPXhuO4na5ZCf4Wg70qaghLxEDFKn1txI9NugdGhpZVw90gI1Dj6fsWtrjwxN8Hj2j6OQ5ynYNewiOgANGTz9sI0EPwbjopCcCqZ0zQIjIdepwSRoZri/i7eEwR6B3DhpHchuVcnDGoWiAGNetFMWrIkEHSNHLhrTXXTScYOPUTmbtEjgD3YXbrDzeup5+7yV8KUmDuHTYF5O3onoC4DUyKm+eXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iEta5rrNZthAzhfSVxOmzrbEAAXlBVzb8tuJxIE/I9A=;
 b=PdOV0Ch2AUPWlSp8mHRgTWWR0neAg2rWJ3U5merzAsHBtgMnVcd6NOcosrBnwmybhg5x1swR3zUS0yIPUsVfbKQByRFp2fNP/sXAQ9CkIlrGuO4510yiqN+vBp+KynO1tBhg3Z8+3hb4NiGRBHy197HGixiHvd1qCeA0mEYxpi6y2XvlfQnh1/HBRxg0Gyb64Rw6sFBeSkmW5hDctJkxAZ1SSe35t5mYz20OIQ9yxMMimc+sKcAgooEj25QSjSHEUscz1acQmiqgGekYV+Jim+WSX7V80BAF0USFu9Lvd1Q8xFrG4a7+1pixKGZNGB7Y1lWbYzid3I/20tO66oyWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEta5rrNZthAzhfSVxOmzrbEAAXlBVzb8tuJxIE/I9A=;
 b=lKZvQOvZRwhLMvQiBSYCCfSk029t91ZAU9XXEHUKijLYfLqp01Y89BUCbWPKdbkq9FWArE41975qVeOo/tq06PgMbB/MYidVKWZZu+xQL0u5lFdt5adsTiVNkOuCVwOd7ejOaNO5ip5KJOoybKq1oW2G7I9koTQRmOG1cjE1kjxpWNlmkdIDEiJhy5jadFWO+AJMQ7HYDMThIbKRmTXhb5wUQ/3zitsz3W9mQsA2+zaVChw/gy59OIwCOJZvtpzH7786LSEhbX54HTwEv3Ce/5+gga1iNGqHbeqPEW2o+B9KsYpdpVeQawygvVvE0oEGaPHe2lsauN5QSr5vAfIHlg==
Received: from MW4P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::22)
 by BY5PR12MB3970.namprd12.prod.outlook.com (2603:10b6:a03:1ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sun, 12 Sep
 2021 12:18:04 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::4e) by MW4P221CA0017.outlook.office365.com
 (2603:10b6:303:8b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Sun, 12 Sep 2021 12:18:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Sun, 12 Sep 2021 12:18:03 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Sep
 2021 12:18:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Sun, 12 Sep 2021 12:18:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/26] 5.10.64-rc1 review
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <55997c875d6743759876d716d09acbcf@HQMAIL111.nvidia.com>
Date:   Sun, 12 Sep 2021 12:18:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53575ef0-a8da-4f6b-0443-08d975e75ee4
X-MS-TrafficTypeDiagnostic: BY5PR12MB3970:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3970CF8EF4228F9280F0CB90D9D89@BY5PR12MB3970.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMHDrzFSoAE4sb2mAhwMuc2GZZHKz3vSaBGjfdPg+7Bf7M8vnGuy3CriQpq74MBepVpusB4O52HWlH+3qzxGXx35KrWncpVnrHfUiEv3rcRIgnZUBmvVvEvDogSsBMjnhNeonBe8VBwIxe+Lkmo2mNou54V2R0H6sIe3C87mO6uw0Hm8rIJUlbKMZFt37R/D+h6Mngkj5H5tRX7EKhjfQ1cpRWPcHlG0lFlhKEdEqXRH75qxj0yixVu7YSWGPFZ/wGTJTlh8z7lwCz5SCjIfm7UNsgsZGF20lYmMy9lFsQYFl3/iPJG38EtWkwPJECV6GlZowZLsLOFdOEaGH2I+givKYr/lVhCteWXBC1d2TN7V3D1o6q9k6mz23DScCY46aaD4hYtXFbrOQDa4PngtQL0bLCshLLvH1iLlN6Mkv3TF2ileikF7usBsHWOjDo4dLiqOKfhUweec/styEmjlXKNskNe+H3KnXGVf6CHudqROnYnhDS+LjxSov7y7h2psbuGtzJC5qZ259J3w09ohyX35OcOhGocpRTtu14kdAEyY/4Op17/Oa/n64h11s9r0KIOuPxs37JFPIzqcQAfrQKMjcGqzRfbMd5EL1n0gmL7xfqMCCqYAMG4ChQ541gnVuygvvOK2FYiqNqusFlnhNaIuAzMwzhdBit8bztiNMtbQRA4Rs6q9enXZ62yHUIYXUyfbcWPcAfZRbGULNMjT3oWTG4SylO+twqlUfAyY4xUJQGUetdoXQpPCGpp8vz7PGPzD3Zat4Kq3KPRtNRVE/dxgDDzu07cjB9cyh4fe3/U=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(54906003)(36860700001)(5660300002)(36906005)(8936002)(478600001)(26005)(24736004)(336012)(86362001)(82310400003)(108616005)(8676002)(356005)(2906002)(70586007)(70206006)(47076005)(82740400003)(7416002)(7636003)(186003)(966005)(4326008)(6916009)(316002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:18:03.8453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53575ef0-a8da-4f6b-0443-08d975e75ee4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3970
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Sep 2021 14:30:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
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

Linux version:	5.10.64-rc1-g750f802d2758
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
