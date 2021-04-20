Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E823365222
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhDTGOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:14:14 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:26849
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229831AbhDTGOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 02:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfE6PHX6HIaw4Py9O+AIuuwOK7TinwIzBcvoFVQGAGR3VyC3KSGzRVk0jCZWldPg/4job5n1GoqC2dRHeX0sVmTiejZTtj9NCe+AJKfXx/jqTrCibggLaw6JlZJyu3soxsUdAa3yAoQ2Z7TzUPaUbZEEjccnsoVUoTuoD7PYTy92czBbETVvTfmMpZE8h+AjlB2GjjpYaD3uJJY8hzI2FS0U0l1lu93qJOUChVKxSCLQ+zgMIJnRcj93O8Vq81GXz9I/wRU8HUstXf9hhnbeZYZeBv6QKN4qWnMuRW/kB9M7UirtduEsL2bBoUj7d10K0v/SodjzbOwYcFkiHP9kDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5CJfD3LjuUCSbW61YueZkzbxMxSBjv4yElXWJV5P2M=;
 b=KJWl6+YTQs6YyD1r6jorjQ40x2Y8c8m3y+R+xFMoKKxdQVRqNt5a2HI04ht98LJA3mBAtgYVyvw8CgzCKWIpJRx1cSGeLRHHBeRE2kmu5QGREhPZB7J9KNGdyasc8R5Mtx4lX3EdPSsZiyxT0nRSNGPqpTa7ZpFLVmoGZXCquixXICkwUVllPKK9/whKzmSqYjex0zboy4JLLrhc4NSCrMsLFwSk9nS4SBvLHwMJ9CQLPx05Z4uzKy7vgbBaJxqL8Y85yhOlHpuCTCHSnpGoODQhuXMRcM6mWuRXdOYkjJlt2TUtypudbsMDCShDsowly38EixrjvqHkHxbWeehS6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5CJfD3LjuUCSbW61YueZkzbxMxSBjv4yElXWJV5P2M=;
 b=bTqxTAQvGkHvcitBcmoVkFdzhyrgPFLikba+XbVmD90vlPaWcOjv4q/EBz6vfNJxyesrZfvvpEmCSATp3SOLxcSFcSEHOAvq2cA8OQ9XOeDcjtjd1T+WS/Mh1LwE7w3RfEdG4SAWirwGKImWqqKmbKZKq52TBh7A4ObEQxsfGWBtltxdgqTVlE8yAU84h/Hm5q7ZThUcbK+N1P72PSE2xAC32Qp/+BS8rgRljej5fdYUl0max8V6aNghE3ajF1c+Is0Bk6sA5Wfvlx3lczNhhXzrLBqrA+dGTOcijRtQ1VIFzGV+kiiMuj5+kh7kPOzUguzj0ZfA7jJmccZeuLcBSg==
Received: from DM6PR07CA0041.namprd07.prod.outlook.com (2603:10b6:5:74::18) by
 DM6PR12MB2795.namprd12.prod.outlook.com (2603:10b6:5:41::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.21; Tue, 20 Apr 2021 06:13:39 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::b6) by DM6PR07CA0041.outlook.office365.com
 (2603:10b6:5:74::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 06:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 06:13:37 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 06:13:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 06:13:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1312cdcffaf742e1a44033eaf670fc5a@HQMAIL107.nvidia.com>
Date:   Tue, 20 Apr 2021 06:13:36 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db40167a-6f9a-49a4-c62c-08d903c36fbc
X-MS-TrafficTypeDiagnostic: DM6PR12MB2795:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27951FDBC5FB8F4CE5BD6564D9489@DM6PR12MB2795.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItJ5nU1HRyDVqRHBQpGgy5+FC4bzrdnFkzrU6rq6adsWa2J1GUPVM6eFr3r8FAmcM56gX8A78CbDkVJx/KzyQX0XFaS6JfB2F4Z9K5L9Pvddv9QjOWaTgw/Bmq9g9gGraGrACtVBII4Uk3BqT7/Am4f27nn9rXZ4hZjJG0knx3dji7FvyaoalFwl28k8sAMnNFkG1T9AfcxMLn7dkEnRmO+riCOwtj4SwfKirou+yUh1anlWZQbrcnA7FIffxS3DjmFc3YanwMMpyfiw0wCOkNjfLplLWjWVHIl/sv9S2IiLv0t7QGWkLoA+ajus0hCCPuO//D46l6Q7ZGtpYDY7dInjGmxcfbHPJNQF8AMVkGdfERkq7SjFceRjyqT6LjRpgdmka6pOES3PdimSnM+m1TS+eJSngABspZ1CASdiPG2Wdy19sxv0ED/OC4F3bVzd+s5Zc8/a9B5jXZwrApSrbVUSBHfiHuS/k2OCnJ7M7scSy8QmKA29kZm69xW6XSBWOWYdedJZfmjk6aTDczt/S469l2JEcONJOIOUDPye6dCgylLZzxrR7BFwgZcYp/W7B8NIxfyqENwOZkuOnTOphkfsThL3+WzlOJBT0gq2p/5MYiD3hKBG7TtjDFvXIFdxAvEZGm60EkcdBRVfeicvniF4sc2u+deUrQp4n6JAnNj/YT9BBNE59ucC/B6r6p93/fRSLNihzGIUPb9hGziXFK+TjM2IPD6Nlu7GP4ArwSY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(356005)(7636003)(186003)(4326008)(108616005)(47076005)(26005)(316002)(54906003)(966005)(82740400003)(36906005)(5660300002)(7416002)(478600001)(86362001)(70206006)(36860700001)(82310400003)(336012)(426003)(2906002)(8936002)(70586007)(6916009)(8676002)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 06:13:37.6615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db40167a-6f9a-49a4-c62c-08d903c36fbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2795
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 15:05:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.32-rc1-gbcedd92af6e5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
