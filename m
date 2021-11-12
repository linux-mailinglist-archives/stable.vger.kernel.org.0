Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67044EAA6
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhKLPnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:43:45 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:44219
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235274AbhKLPno (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:43:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTxSWo3gyQt7XmgzyA1lL2rltfzEhw+5OCWNm9OHzTZN7MdY7CU4aymf4OhSOSwA4lSckmq9j0ybkLFsBYBs1/ZBxOMVB7HFsf0bJFUIVwVDsi6xwOHfu13M27nSSk29axoRJUca2jZbxylUX8/KtFh2MBDbx/xA1ZvNkxF4B9KqIed2i+Ynsg6392xQMUsb/sq+dY2ZYjfjnnr39XxpuSJVJg48SswlshqTBr30aPpYF0oSrVJE2MgCmT8d0pFxEHU9dxlYRHL4Qr3zV+4TmLfsY6P4qOE1YZY8vXLeFugcmRQ8e0UVMIjXmVo3HAfjQijaTZJGJtL5yv86j8U6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCwnzHx1Xqcl5WgmFwOGci+Kk7Srth49AucBw/Ti2Qk=;
 b=Gn6SbQ5K0E4ZYnKGrFKASVJP6h0k6MNVC9Ut+14xOnwarPTRaMfQ4rlEc6qrFJSgn8C/2UrGN3LGbhA9XB6RU3PifZafbUC1E+YaGGiI8DB1VSPSHqOB9pMgbbWn3P9ED+yksZkB7V/G1YRh0Db9VZzL2MNMO5NtBl/KC5355wTuBeaAM9PiQqpDxvCB4tBq5QyzCl3YCteEg0FgMmXSGMRmVZRUhDFSmBYq44aHJq5qcK0UENuD5gDKzTLfeA0iOarjbYR8sMS/GctJjZLWP4WLyhSPkwhYb8cGzQTscxcfWWyL3lVjiiGtbQZFSHekRJDyul1lCv20drdQWwn5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCwnzHx1Xqcl5WgmFwOGci+Kk7Srth49AucBw/Ti2Qk=;
 b=HM3nDVEeqdPMVXNujYPxMdJmwWjnMqAJNEIbhRRSq/RosOKnQgbXzbeRqJiNXcN1gztRGoesF31/sdzU/T9YHPw9Aq3Kx04xkMpDlSJ8IjU7l737SSwiZEAy0nO9zLgqbHJBXHvwD7F0VBzQz0RCWnpQzSwnTopXuoXsfJBGjKmkubrIY0YZ/LYUSPbcXRKefJbW+NADexf097r6QeelF7DA+QQkLw0EeffwwshHgnsnlkZDR1ekHsYb+Q579DwQ2xdm9qnm6Qf/WArBjP3MprP+WFJbyxheo73anEVVBjC3nV32QptpRynu6mO2I5p+nzkZUUMuLXq4vTy8kkAkvg==
Received: from DS7PR03CA0001.namprd03.prod.outlook.com (2603:10b6:5:3b8::6) by
 DM6PR12MB2986.namprd12.prod.outlook.com (2603:10b6:5:39::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.16; Fri, 12 Nov 2021 15:40:51 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::6e) by DS7PR03CA0001.outlook.office365.com
 (2603:10b6:5:3b8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 15:40:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:40:42 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:40:42 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/22] 4.9.290-rc1 review
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <840dac166c6346d19581a81d019c462e@HQMAIL101.nvidia.com>
Date:   Fri, 12 Nov 2021 15:40:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dadde77-2a9c-4a12-8192-08d9a5f2ce6c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2986:
X-Microsoft-Antispam-PRVS: <DM6PR12MB298699B516627061B04199B7D9959@DM6PR12MB2986.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFXYSzn+g7NcMvmCltHJjv5Sm0tYEMyPrhnKMbzmGsE3R59cBLhwceoI6OgmHp/HuC/ZIXhxqxAJNed0ebo9lC/eD0wQhtghjmJRFp8rx3cxgOQ7zjkv2qqp1tBtXiza+1lGI/5oW/irmqsplWCOJDmSjOwF7QNth9R+4ei020NuiGphXmt7Ake0axPW+Pg4YBYvUdzKxi8gnPdWdG8d31sAFWt+Em80Qe1UtkX6ybhiU4u+6bDG7xmImjGERBlK6hmXlH9/2mGrExYLlvlpXdrz+Kaj8+658RJmHL/ORPaAzBf06HCL2aQ0KDm5dpjyDQ0UDRG4LV5X0ipzzYIUMtva/ksrliDO0ATOhaPmoXGNxwp6PmCDOZOfWK6DtKz0Nk4Ykcp8MDh6hljtmz2vn6c3l1xml1z41Zy5LuvonTbHtKzhoIzYy0F0yr7q3RawebQ+jE7O97b0hpWRLTiHOJRtbvGwFVB09JapfDjq3ab2+1wOgU9zVzKq85Te2+jq2MsVEGJ6CxE/7qGLXWtO8FpGx8qJRWYEmWHvbZg2ZBnGGyoRV5RYJ4jXDreSPIus7bgzAi/iIA9Zcit9kVN9otBr8JuIUcYYWcE2vJ9zRXgQUiEdomWEtEZm+bAihOHyTBEmrDW8d1GoyO/EmQm21MkcJjMM1nkyPSrcaxTZsgWd6W9RxZ4wdKvZ1AtbB7UopWBIBcFpH0vuZcgjD2B9FxqRkAL3wRvlAIB3U2W5ksbLig9rm/wn5C9lKzdpLXyX29df5wEk+9Et9Ea+s82emw4nusRf9t1f7l45kz0tKjM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(6916009)(4326008)(508600001)(82310400003)(426003)(86362001)(336012)(70586007)(186003)(47076005)(36860700001)(70206006)(356005)(108616005)(24736004)(5660300002)(54906003)(26005)(966005)(7416002)(316002)(2906002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:40:51.2352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dadde77-2a9c-4a12-8192-08d9a5f2ce6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2986
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.290 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.290-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.290-rc1-g6ecf94b5fd89
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
