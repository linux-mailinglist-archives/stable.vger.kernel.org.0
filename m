Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667F33C6BDF
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhGMIGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 04:06:55 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:44896
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234542AbhGMIGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 04:06:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQLKs/RkQ0hja0BEptFZd6x5AvRgnUsE6wnX+ohvRVAEi94SRtIi/ZbGTvAqnQ2R1b5uUtpMKiuR12jBw99sOygzSNiuG8dZCbrTGxeyCPZWlvIeLE3DCFKvYDy3O0lwhTJGsbw+/8FKNBQuvrjVxGiqeUGcyTmuJAuTDcFjvSiGviX9tauIS3uKPVNW8KxgB5SpdRfbsawUOvtujSU5NeatpMPCklFkAb9YV17AXB2+T+MTbEQcGhz2WM7OvFOOUFUwKnN9VOExl32EwbU2UxaoEsuT6FnahVgM/pweQjSIE384fHXvjjSPwO7XVOPok7BLF5oTQx6p+faU/qG4YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zwkjs5np7OCZy3AWR/ix0/ziQ/NoI6toWKTigk4uWM=;
 b=BGXghoTSMrFZ9hE+pUo4UH7EzKJqBfD/rqyqxXX+LoLGy9kwsD4hAet3lOjSFQ23sr8SngkanonAuWOSxhnP6Ynum9Em+ta53365t3ogSPljsb1QUn3lFMbtaqEgR8D+WhadzKTAQ/InDimbg2NwbxL7xPmPu3aeh8qNAKYH5LzjetEpjJHfy8V64Fx1nZDpXKj+a83rzL2wNeqzqmXhLrT+MOWLYUOUdnYvla6chkw3lXTPBy/8X1sSWUjXLXEpmPT8agGSXsEUHCUy1UHxdx8VTBAyUwt8kiI+buBRFOXJPx7KMjM+ZmRAt6bqZb5KE00wyFD1CvyIowGVxyBTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zwkjs5np7OCZy3AWR/ix0/ziQ/NoI6toWKTigk4uWM=;
 b=c4m/mbvGwIZplWz9Ax3zNbjSpZaqjsry82WhQF3QdelWOErWvbDY2VW0if1RQ2A745/EoprhVElQt8SjoZVRU6wPUs3c8uFHxQXRfn56NrnatK0e9GJ/YJtjIayHHoR3g++oYp8DGhLNnJJmDuRY9gqxQRSFVYi5SIKHrhfg1e1U7mEYYP9MhauqpNdsn+o4W/Z+jwCoZ7s4NstpbkGXTol1pNYVQr5I84QffwPJcVikUCgywe5uLKS5LUh4T5e95fC+vpn0XMG+RBe3R9ak08cBW3uIop+6yQC44AaJKvdmpDpj5immPGuiyvK8rkzOoLl7Ywy8YEdhW/C3L6uu7g==
Received: from DM5PR07CA0154.namprd07.prod.outlook.com (2603:10b6:3:ee::20) by
 DM6PR12MB3723.namprd12.prod.outlook.com (2603:10b6:5:1c8::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.23; Tue, 13 Jul 2021 08:04:03 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ee:cafe::e8) by DM5PR07CA0154.outlook.office365.com
 (2603:10b6:3:ee::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Tue, 13 Jul 2021 08:04:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 08:04:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Jul
 2021 01:04:02 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Jul 2021 08:04:02 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b74781dc3d0a4c0fb2cf058f2b1a6b47@HQMAIL105.nvidia.com>
Date:   Tue, 13 Jul 2021 08:04:02 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 158d6da2-4a8a-48cb-206e-08d945d4c7e1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3723:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37230B9923699C07A2F49069D9149@DM6PR12MB3723.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9F5TI0+6AlrKCCf/4mEWuCiEHTysBWaV6ldtCt7bLkDv7nPrKDzp3lmgAjLwNAIWlVe8OrgwZNYnQz6g6GGR5Of9dBLq7yQkmkqW3ZxaDhr/Zg9eXl1S1w1dlnH69ipffImIc2XchvpGUwiIxHoIHDT4xItQ3o15fj+bJxEguURaO1vX7SNOBgIXnaBa04TKPYhRlcD2wk+gpKT+ARMyviDKp8EnaI/44ikk43TWtQpI+xWaI1r7U2JC9OS/7NFRSstxXFvWx5AYMpfJ/GBEXtrwQxpjE3b2/rnFoHMHo1gcg3u1a+MHSBUavweVMwigYdn+w35ZvwKSCV39azFIb5jvmRXq2YMEbkAAVO+egQx6Op6hCmsrs7MYz/+gwHr9S/7NDszmANYhuzuFuSHnpY54QsY3eAUdQbi55rQIsVNtZ1yrlIRgSiyDOQ+OPUkJTHxaDPIr6hlc0+KWh6MJsXefJLg4bzG/iBXYlplfTY2Sc6orLiB5ByQ63hNKG16/p4OiY1cRoBDXMZjYuW3Qe/8dN8g3QRR116IIuf53lfNJM3J8+A0QvGVTRhlxLZ0iUF3s0amvqoyI9MNXbwrsfWRBAObnkSXlpMWkrDQU89JcM42Rv6CgylYRQYHDwf1Az/0Lc4tz5vFcjJW8GsDMyesFYplGoV+Mnp+6SJpxGMOtJOosAWEQY2gTa8x8IqSzJ9i0BVbkUupfT6KY5gEDO4tLAeBXl3eE9rhTaS+vYXTJzDqa6PlBatHS1oS7QczuiussdP72m+us1k//s7nHs2VsqUEv45XQbRu4UgNYsImexCnegaVciDC5em7UvnvR
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(46966006)(36840700001)(26005)(316002)(966005)(54906003)(86362001)(5660300002)(108616005)(82310400003)(47076005)(24736004)(34020700004)(8936002)(82740400003)(6916009)(4326008)(336012)(356005)(478600001)(70586007)(70206006)(2906002)(186003)(7636003)(426003)(36860700001)(7416002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 08:04:03.7359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 158d6da2-4a8a-48cb-206e-08d945d4c7e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3723
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:01:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.17-rc1-gfd3222df4dfe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
