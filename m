Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF2045E1B7
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243358AbhKYUlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:41:44 -0500
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:2239
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244127AbhKYUjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 15:39:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxeaD4o2PJWFN4OJA0ZbsDTCnShI9IsEqNPxGiqMv5puN/ic3d9Y0PS20Mcm8IjXyWhvZNZNQtNa7a0gdvNOasEgeNdArxBooUvvk92Mix8BooHfKFIz/fLK+Szxh4DFHQDjhJSd49bMmu/CfdobzT2wKBbzt8fAxuvTyU4ElQFlTme3YylbKmGOMu1cBNWFEKJtag8NRfoov9u8OtEqKnHm5f5eaOqlZP4V+IWdViZjE5ecs3PbSAl3A3FQV+pxves/hko71bU7R6gfwORuz9Bg+lrxAPWbxWirsVGPhXeR/KUfO/aMx2elRiylx+WS3U7LIwqp5p9l0GROz1D8Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y18PdKnPq8MEo0zqWlEAfv18qjLshaRPBHzaEoC8V/I=;
 b=PZfC1a8Sppypnz3v1cmbVEycSJt0R+jSq+uQusAq9BQvW9aZGW0yU3QuQQlChsVaSi04Uv1hgOMKGhhbAb5/w6FK8mZ8L3eMZOLYvgI3xD8TwvI5X0DMP1DRxNklXdDUPI4Li33eOMlnSptohf6KSoIZfYiD4p6t6dVymgUlz8OGpg3M92eb9MfIDM/xSiCmVjzC2rvOG8eY86+uD2cHc8vuggmZ7cJbfBvjw0UslUff++XREo8HPWYFA4fmHf1PJfafiVJSV6EH3Hx/fg3Au8KVf2tJusiCknbfh0G4qcD3Xl7/e2wii7SrOecSBqWCAo0OQr094lRr/fRMwVncjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y18PdKnPq8MEo0zqWlEAfv18qjLshaRPBHzaEoC8V/I=;
 b=fe0kvk9AHGeNB2/Pvb8zF6dhAjKOv/RWjHcJWpu7M6IAETkLoTeLDD3UHA99RX5i8wP701MACPkK4r3+JonFgq2vnvF5H0fGrqOUAwfwoEZh1NpVbISl60Di+rAsO0csgEc2ndoMKpQ77ThQzCAO2UFbTBfzqmmrbo+Cpq2weA62kVqZJlh1sCI54kc9XYgh4qrF4d5Ut8+DyqehUPZ1GM/SAol4YJzEld0N/mZy4HzNuVhCNLF0i7GppfQfPe3nv6O9AO1FEkuyyceAwxNgNIx7R8v2yTERsB4ddoF94xR3WVbo55vwJ5z7FDO2gLE5cyAb/F37Fol/mkq89gSGjg==
Received: from DM5PR07CA0049.namprd07.prod.outlook.com (2603:10b6:4:ad::14) by
 DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.24; Thu, 25 Nov 2021 20:36:30 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::a5) by DM5PR07CA0049.outlook.office365.com
 (2603:10b6:4:ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:36:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 12:36:29 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 20:36:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/159] 4.4.293-rc3 review
In-Reply-To: <20211125160503.347646915@linuxfoundation.org>
References: <20211125160503.347646915@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b07b76f85bb34802b72e7cb6efec006b@HQMAIL105.nvidia.com>
Date:   Thu, 25 Nov 2021 20:36:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3fbd1ee-5fa2-4e31-a289-08d9b05342f8
X-MS-TrafficTypeDiagnostic: DM4PR12MB5103:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5103E78A66C1384081BDEA89D9629@DM4PR12MB5103.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OELDaQfHex6GucM0iHXJya4yoyNXU3DRZp0+l8N1IKfz0VWdtTh4MzYO8DrCbOGCDa1NbZasxd7rZxkNKPuYCptvzfshoMjrNz1ec1Xrto1/RarX7H8sL7M71QmU8+dUNNKxR19vQFKfLxMn5jDNvS52ikaryk7ngc2uyh55Pu9TjnvMLDa57owMDgKXGUNxbH7EYdPGmCpCw2kdobFBhHSA3iQufoGMIWt8+YI/H1I53gf/lGg19dGWNW4PMXkMEslbSBZzRKHhciRcnFdyrvTSQyiXmwWg81iNMMM3HLXywl7YwbRdoKYinnbMe0rcxHLe/BfVSJ7ybEQkMUUu6GyytSZsuvL8Dz3gzgMd1SnHJH/qd1Zd+u5lQjNExEydtIAEo1DqB5l2YUeV+hsfiFQ10diRyl8Fr/BzA03n+1RhLJxq9+VWPy53fpZJ7IkbUzb5hNjEOR/w+9o/hngz8VClJU0bksBn5rVhIqtWe3Wmo2c4OQiMxeh6Eb6L8xkTy4xiSt7zAaCZHQzd8xH6FfnTp2I9iLPpdPKD5K1+cMZ3Rfw6IJqK63szZ5pv2URjtTpIVU1u/VRa2Wa62pEl9yf17Ka4pJv5JGwp4kRhKftUY1JS3Hu0vlC8hLa7bN2+lLooxvvPTDOVJEtVGlqVnQ8ooEgF78DhlcLmA5ZwKY7AgGYyx1OruJuYyYA4+E4s72twMr71N0HhZz1zEiPbfrUbQAczDZN5H0/kKOAbIQKJUVVyneKY4Q80Xo88sQjn7ieseVvfZhc/u/ozR0ofX3OnfoSR2TYkhcP9t1pv38Y=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(6916009)(186003)(26005)(47076005)(7636003)(36860700001)(86362001)(356005)(2906002)(82310400004)(5660300002)(7416002)(316002)(108616005)(8936002)(24736004)(966005)(336012)(426003)(508600001)(54906003)(8676002)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:36:30.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fbd1ee-5fa2-4e31-a289-08d9b05342f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 17:07:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.293-rc3.gz
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

Linux version:	4.4.293-rc3-g026850c9b4d0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
