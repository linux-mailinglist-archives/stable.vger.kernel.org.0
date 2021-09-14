Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C48140A889
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhINHuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:50:10 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:62816
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239057AbhINHtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:49:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndpj68rmCDT75ivlPEprK3e7wuz4CQw45+HTx+r3EiKQIzAahX7vWF+mzyfpAWRaoNGb/T0abxvKZ8FDEq07v+8ezmaFF4OCf7LaVeVCEGlZxziK51pjyvLO3DZZt1LdOaL5Yk1QA7moUwrwS00YOtSJWvIsLzxg9574h6w1C/AM2KEcAQYYKUWqemyVYK8z8Iq0hDu4vp33cNhv6fK9B5V/SXBBMhQXSkE6Z1an8uXHqc5hjfqLXx0q8zRxdGSmn6Elr9CbDKY1Pool46JE0wEVGM/d2Vm4RMlsRBxGyc2PLBwcC08OHPWW4wEBq+R88jF52y4NNp2yigQ0bSFNMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=n/y/JwvADuC2cDf9OOhec9znacH7NMDxI1gfWUE1YXM=;
 b=g+D6uct/fQPqpRwm1rNQz1VfA9pJ/rleTxj5SKtmOaB1JGZ3KYhNMFURyX4cAHVnPlkfZWmmef+XlGsEMYveSOAQen8U9VfufD5/oDeIWQVb5gYKQBasB1k7gthXgNmBUPUJrf5v7fKOC9UwRlXuZWQErzYwMzV8dG+NmdIhp8qemzQqO740G+NkclfvmhOp37tByiuj5DYWn+R6k5mmZbfW+cMzZgDPosG62eSsbGQP9b38txsk94cUQbMH5A263bhfZlrLO+ZevOyhrPEdlSlXSy4rySDDPX6d3ogeUWIZCGd16x67Mf/Xlv8hxTb5y0mtkxjt/SbHqR4ETN6uHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/y/JwvADuC2cDf9OOhec9znacH7NMDxI1gfWUE1YXM=;
 b=r0K1JjxogwvnGqvzp2LqnrqbF8N5w56Lj7JZ5j7+TPt0lr5FeIeGoRqMysFzTLPbYnFaYrXdT0frlbcQgWN/JnLa/H5vlBPH+Yo1S3J+8EcNP7VSgJs+wPAFdxp+Nrbg9SOt4rt0fn0ag3sVVAGXZ4iM0AKyl1FlmtukjBBQ5bRmoOn3fRXiFpX3bMbg5cdJwiHthChDw0gSJsjOvyn+LyJBHy5O0I5zqEW2y2/Vol1qv+BvNTjtpf7SG8EJMFHpJ1PopB0N2m/RcxAr+E/TaKDhuKvQTKVs5EJADjR0ZF80pbzWFdqQtWu+IpTRUA5lC4Ivp19azt1+bIidhUGWGg==
Received: from DM6PR03CA0038.namprd03.prod.outlook.com (2603:10b6:5:100::15)
 by BN6PR12MB1138.namprd12.prod.outlook.com (2603:10b6:404:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 07:48:30 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::ec) by DM6PR03CA0038.outlook.office365.com
 (2603:10b6:5:100::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Tue, 14 Sep 2021 07:48:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 07:48:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 07:48:29 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 07:48:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 14 Sep 2021 07:48:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/144] 5.4.146-rc1 review
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <016011e28b774ec69112d00c873e5f01@HQMAIL107.nvidia.com>
Date:   Tue, 14 Sep 2021 07:48:28 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56fe8a5c-2710-45e4-ec66-08d977540b2d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1138:
X-Microsoft-Antispam-PRVS: <BN6PR12MB11381899F764246EE4FD37C9D9DA9@BN6PR12MB1138.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IuBQditOrZxkTf7Cl6j+jCMrHt0iH/D0GbsbOZDioWn2+XAYdZ/rVnYfwV1uiy1xHjwgsqWZrpNnfugJlb2ROP4jFxGAavo+wpaVItikV2dGeKFojmgPFdzmBrLqQXNBrMypV5kUwRsPSUeJdIqO3fBVovhTSTEGFrtTkHwRRAdt4iM5x3KELFo2HPuJrG75ieFKngvZJxXL6YXtL+wwqWlp96h8/VvFBqk823ixXOs/2ZfFBj0/RjWnWRTEP7bik6L02uI2InDkcaO8me1cu3rXtd3VaR62p22j9QP8JcCdMq+sJACAszEdz8Cba6qMBZdUa65m/oUm9HW9kYwtsttHCBavjl91iEn4PPNpmNdTJ6nMqwR+OIHKPaGUezD+vTjNUXhVvX4Y3s1/QplyfgfavT/qqY1SqS28qaMORKroHOFN2QdzQwmZQduFbke18ZRD+S6JNrCnz4C/FsZVnecDvDQemYSRhq4qYm20C+qbswCoduYeqZQDMr5o0xQy32lQACRaRfkErjaKbF5FLH4TzqhStqDvsFStJ35BERlkGwkCqfw5ZvzKsrsZ+cmoA+HEzOYB9tOfEQRaCSVd99QS3/Q5zb6hXU8+TsFQa7H6wLNtRADbtsp4kVGSHJL4wSzpmW11cBSLJqgsYveOpDcBut2ZebcWEbmHOHFnVMSDbrF0rUQfc23HZ6A2WfyMfuYQl5GcuFDLBgMsHZSpY6N/QxCaice8saJuwX4ZIAYCSdCFSBihndM7g04VXfPB/waQZCU/sIMFVUe3yFt9St6ZX/CagiQY6dm7ourgjg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(70586007)(36860700001)(6916009)(70206006)(966005)(7416002)(82740400003)(36906005)(316002)(7636003)(186003)(426003)(478600001)(108616005)(24736004)(8936002)(26005)(5660300002)(47076005)(4326008)(336012)(2906002)(356005)(86362001)(54906003)(8676002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 07:48:29.7053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fe8a5c-2710-45e4-ec66-08d977540b2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1138
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sep 2021 15:13:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.146 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.146-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.146-rc1-gd4596c5864b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
