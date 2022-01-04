Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D745484091
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 12:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiADLNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 06:13:22 -0500
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:59488
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231834AbiADLNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 06:13:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiIqPRhRy7x7VJHFQieYsKxfNUCYZ9WlYVftlMV+5RuCgdODtj3CJXUdPxRCXy/VMSmQW64rGwNel6OpuOHB+JTp9x0UHRGUGOkJCnE6SszxFu2vNM/s0pA7M2M7EBxZ4kNGElPBmQ1PtJuuxbmTu6BTABWuT16ijwPSOWY5vOIyaIrsx5Rtc2vJdd3Q8xPU9AnWtQUA/ZjPyorkBXHXv/b6uWD4qJfMhnlEgZdKHpDzI6RNuq4Ix8vmO4MEx0gMntxjAzqqU6UYjqAND+Uu/Ck7oZW14QA+f8nCxCD5iTjoCnsC+JS4kEtti+3qrmpwdTudhLiM5XUrYsdkdFn1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9DPydi0uzm78LocxF04/+EYXHin1DE/9p0Tu8awu2M=;
 b=Qdygcnhsrsn6mlBl6Zp3osyaoPGwtlXitF60svWgepchgSnRkwURSj5Y8tMCrp2+5kbloQ995IkHoGyb0xtUdmEGn86jFA7V9ovx03rMBH6OBSr/b02TiJLtBBIltQ+Xutrb++DDHyHRBdtx4BR12smrG5TYsrytBsJbxQ86jh8KlgMuh3Hv/9WmFbuqjoF6YzSC9gtHwF1wyeD4CpGmH6nOmk0GIT4mlKi+J2K/bOG2TBURKl1ufyfwFDg/teBMBwAw2q+GU3UYdIIH8Kf6iSKxn5vXFAInNQTPW6Lpi67pWhXv8SnCfxQVaHZEtu6uJQXPOh99E8A4Zf1KNHCsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9DPydi0uzm78LocxF04/+EYXHin1DE/9p0Tu8awu2M=;
 b=boe1wutTvzwOqOvnqn4z0IShR4ADiNBWy5rsg1ZGP2MVSD31DUbapEObt+/5HaFG1Z6FhdzalNs8vNKPCnk/58PS+Dpf4n4LuaA4CeosFh/TWpOQl99QxwrvExSKKWkgzKrzLTZLt7dFvdwc0s1M8hKmN9o0s3xE/gSqusdfyCAhoaQhHqiiuNEiikaf6p0GmCNaJwqbyj8s18UYPCEf5FMBlbqVGDGHXLMkGu4AS3A6m0mr6Hl2To2CNP7q6PWKqCmaczK28kuVVXK54mErnIxcH8PreHtPDTZx9GEVXkned5GyQlRNiIECSlsF01nPwkF0av9dShyqtNVm1TEnEA==
Received: from DM5PR18CA0083.namprd18.prod.outlook.com (2603:10b6:3:3::21) by
 DM6PR12MB3481.namprd12.prod.outlook.com (2603:10b6:5:11a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Tue, 4 Jan 2022 11:13:19 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::2) by DM5PR18CA0083.outlook.office365.com
 (2603:10b6:3:3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 11:13:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 11:13:19 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 11:13:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 11:13:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 11:13:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
References: <20220104073839.317902293@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9a5a70b7b9db4bfbb355946f673baed5@HQMAIL105.nvidia.com>
Date:   Tue, 4 Jan 2022 11:13:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8afe5a4-f5fb-4e9c-8e41-08d9cf7336e9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3481:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34815D5A95391348B36BFF4DD94A9@DM6PR12MB3481.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN0Tl07QaPrn/neBwKgWrLxLhxO3msTfbfZX+OBtK6oRGriCLADJoh5wQ2eMvbJ484LuywsOlxryaJMM2tS8JrBEKTzST+EMrtNltORox00Q0UweRfSyRiHTcj4gIWQd3hxWWj7Y1BSzI7pDOBEjwHxYRufuBjYx9OHvsFODUqOlM3+d4UmLOsWx4WivIYbdVYY3zlGKEnM78jjCWr3eUeuCzAUOp3BlKbM1+9LJCH760r6gztuqTrOEXpDen3secqD0EUOrcWnpUCg7ntmSB5jp1HharT/nPyszXYCUQPUD9tiyFa7Px1TXq06UA+qVmCSMYxKWaOfK/Q/mNJ9DiiSHbjeAcYNMi3fvA5oT5jvbcxf9QDfV2R9vJcb2qSmeFFkuk3F6hqt0dVFTlrphsFhHGe1HOgPiHGQcID0VzF2PmtN2QymlHAz9rNF/fnQqQ/caiwK3E2ONqrrRwAxEmeXTpusjCc2nqYGLm/D8okyCMyqesFxD5xwfRiFCWNvL6Xay45k9WJLEmDi3Twf4ZkYJ7YC/Sm3W2NverK5gLe3xnudvWRHXVypTAUzzQqSEKp9yZ/IQzK1rc5Kozxt6x67gQ4o0IoGMxc1McyA+xVk1LqYQYDuUbgTF0PtgYnn9UvVYzpI91O4qJYf1miOZTkCnMS1itSya49A8l7uTQNNpyxmK8z35eXqu855egtOapkDc9u0cCcuSrqL1UAD8efZrYoB74qRleTG7MGfUzFO903Hrn3ylmn7BEAprAaIKzsVq3L9P08S07egqEX6/rhiLSa3rCqtnmScJGcb9MiZHnf8AZf9BFv9redtCebEgHEWVdoRjo6YsbcLfKdBxhGC/e22N6XMN9eVCm/9Ugbq6l63dgzKhMjtsQ8gP8KyP
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(86362001)(54906003)(5660300002)(356005)(508600001)(8676002)(8936002)(426003)(47076005)(966005)(7416002)(186003)(2906002)(336012)(70586007)(82310400004)(81166007)(6916009)(70206006)(316002)(24736004)(36860700001)(4326008)(26005)(40460700001)(108616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 11:13:19.7694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8afe5a4-f5fb-4e9c-8e41-08d9cf7336e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3481
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Jan 2022 08:40:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.170-rc2.gz
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

Linux version:	5.4.170-rc2-g80ddcc564ae9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
