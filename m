Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3670F45E1B9
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357109AbhKYUlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:41:44 -0500
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:39521
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245612AbhKYUjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 15:39:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Szfp57+7Ua2He34HtpjjOAVXFS5MIXlvsxu/77hJNiusTm/julKAkB99wlXDpX2qql8jNJaEgjck5qxyU7XSkUI2BoEFHSM69TbxltJQH5ZVCjuCJkAPgEr2Xg4qvyBFNgUFP60Ts1lr2dWB9D5nzAXGVpr7SHk1cKXIQ3IFBqklO7/0hcrb4f4sMyiw5EuYLGm6pmAfuy5vRXnCdhYH0NuUd2tA1v1SedK+JqdfIADOIajlh92LtuMuahKZldUV/zkFMhXXjCOPhQiSXqfAeNPg2UxCDi9Y39oTMPQYgZtQnIp/ORFIIl1gV57Uqs1+37TWZx9pVOh0cZ+xpDRMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EC92GxehMZo7npiA61Ej6YksGDM0E2LkZJ70s1RT70Q=;
 b=YND4CDkpoqnU2oFj4w7EyH95Vu1npF4QLsETr/lXc0K6jFNv/ekb26yX3gr70MQGCKBQFmLhNlv6FVv9kVug4NSnYHzJRVN4c1swkE5caKNb0YzauAIgz71Fq3eNpIMSuTNm5UWQstJG73PZpOgmBpDRMbQPkC1wRfTS/YNeEEpS5gVajkDqqz/yXw1607xw4/P3phVVLwHagWPiMsvgRTyYGqFjKTYisjZTv8iXfYNTNe3nrdvNb3mPobtUswgzu49n1CIl+ZXqIfvCiNdbF2658EBwI4Z0SQhf3ehxWgX3ROlZ8P3UtxZEzmkF/dLavu/5t1zcyGEBCC942I/ang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EC92GxehMZo7npiA61Ej6YksGDM0E2LkZJ70s1RT70Q=;
 b=WzpE6Lr+k07IgiSrsP1V+4cYjFXMVOAmWkE+iNEmgDWsUhHBwRRkkY+2B/JI81j2IPGau14t/goVacHWy+0CmxeLT/X6uVrU+HwCjWH0SPheQitTrtT13uQlgj7Bzrg8meSAohvLPb9JhH9Iq5wf340lz6qsXFBTMk4BmcKxdUpMJBTcG7HaPwpLafn2zdrtsti4cwZI7t/Uxr+2xzuvAdsZMv4Bpks1RNZE7s0/S59KaQQV3Al/5UZojeNp/OtMdn+aQ1mJkhC5iFyTsuLhluUJb0RJboFCs89L6KHmw1DcgCPtOCqvMiIJJB5nU3ENoFl4Q4zxh9a1v15Z9JyhJg==
Received: from BN9PR03CA0854.namprd03.prod.outlook.com (2603:10b6:408:13d::19)
 by BYAPR12MB2807.namprd12.prod.outlook.com (2603:10b6:a03:6d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 20:36:29 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::46) by BN9PR03CA0854.outlook.office365.com
 (2603:10b6:408:13d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:36:29 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 20:36:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 12:36:28 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
References: <20211125092028.153766171@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e58952b0cf6d46ce99485750f2cd1c9d@HQMAIL109.nvidia.com>
Date:   Thu, 25 Nov 2021 12:36:28 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cacb3606-c9aa-470f-0cfe-08d9b053427f
X-MS-TrafficTypeDiagnostic: BYAPR12MB2807:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2807B31D1EB5257AD4DB6420D9629@BYAPR12MB2807.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tEBk2DEGRQ/XlmKdWQYc6MCaBd34NaYIk2aY2FoVEWDTJ/2xiCNnHUBEKTtS8CTuYsnO5N/HAqcElM2PZtE4o2XC/nQGwsBgnYr4sKoCguIRCqaQNJW6lJHK20Fki6bNzgfMWoAs22pep9J2TCwEvYusrum5XQJi2GuhI2hX2ZH8GKdjE9ILabADba8yUZWX9K/YtXwUb8LIDzMTxigUNj9V32bvMVtmqWtLR1zFL1qhccjT1ELjGPJUdojOk7kZypZORK0jwlFfFIMa+W6JeVY0FRxTjYrMlipZhiNsW6JOE3WWw+s2V3Vf6x+WL6VKmqdicUNK6spDEWJhCPxr0Au45bYzA/LOCCo78x7U8myyh6AK0CKke7/WYGo117m0Cc4AkGNWdJ82+eTVjNN4a3smxPT9+8ytevrpuLKqBTwwHo2s/9i920Wz5ABMc2HFKhXSCg8z+FUBequOj8oanQMgYEfYKOSkZxGJEKBqJ0K+wdXcOFxl2hzNjGw2cm2Z8ZfpXA05T/6S+qJ58A2XzVkEpjdI9agLLzLK64lUfg3y3/k8qkONN1Yv8Chfb+rngOvUwG2rHfQFL62dg+5c1QFdaIBSnfrPzE8Tb2fLR8njuPMNY0giuYZSg8veAy4ZjpnCT8dWkeX0SwvvM/gVdsSrcasAR+N/hFy5zcAICEsaurRkO6pILwsLwNLTVHoefyrjUhUeNFS1j8ixAaqIz8XAfDE1szjBqul8mZnbScV3ubb/ztCmbVz3cFFmLJF8v1VDNm73F4N6GAgLhMuW9npoSuYd0wIxo7WD+AHxgg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(5660300002)(70206006)(24736004)(70586007)(336012)(7636003)(8936002)(426003)(8676002)(186003)(6916009)(7416002)(108616005)(356005)(966005)(47076005)(316002)(82310400004)(508600001)(86362001)(2906002)(54906003)(26005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:36:29.2320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cacb3606-c9aa-470f-0cfe-08d9b053427f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2807
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 10:23:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc2.gz
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

Linux version:	5.4.162-rc2-g79d16e9015f9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
