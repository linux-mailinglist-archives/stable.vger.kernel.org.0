Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB5D452DD3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKPJYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:24:47 -0500
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:16128
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232882AbhKPJYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 04:24:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZXfwLH+sm9OMgh12mF/zhYk3E0Btv3k2tBBuPgPLVO06VWbDcogD9hIpgd97FQrqsKkDu76TQHbQvWiqlwWULZYFQCE/6etX374Az671FS/mEpZhuR1zPiTY25tw8ZPa7pKr4a8Py5yOrAa+9YcdIyM9eY4+eK5c4iLyBkLuJaedkqj7cDsmDdA9hxWZjzIoe9JV+Q4Us+A2L+Ck0csjnq10yjgNzpHGLMCzxq5wmh08OgMrKZwp+2r4tMmYi/1Z8PfxVNeC+lnEGu7GUB8EpPpGCFI6uWB3C/1JKsuxXrkHjncnfNwdvOaSxincv1WcFkhigPh2ueh66JcnzxUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTVSwAPz3JXvTQGUkIH99pJtf3lRF0E1HbzKnZ78vAU=;
 b=EMUVBEsvqlDmXS9dAGLqz3FalY7kb8SlYvqxeNCbAoZKDyR/bzgNbBPRECK/1Q2JYpce2DUbubx8H5IsZn2Q5D0GqxzIN59iq1qkxQ41e/u7G8FLCMy63qmW4nsNn9sZzobk4at45Wu+Hq+6sgNGZ7d6vuBc1TqtI/lacx20vJsQOQsp6sF6Yu3Nim/wDiRIg2qWkApArkKR8qBy7CGBfV/OuGvDIgwHzFOrjhetxarPT1klNRdD0bBeMLKfs4iUHAjDBYVRjKgr/f9T/rEAvRRVXK//fAofrqgnFBA1pKo5Jt3JDTgCGE/CEcjXZdEQxfRQtuQ8gMnItIRJgbH0Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTVSwAPz3JXvTQGUkIH99pJtf3lRF0E1HbzKnZ78vAU=;
 b=SsCtrPs7DStsK1vMIjeuaQaHXlcQLPmiC3D7oEg/fyazjXUXrvMQD1MyOxuI6RzRs4XccfFqPPaPcisxbCus94BnquYjol1k/6lhts3cuT8gxU7UzTVa3ypkJFWfRDiVPQCnVaziNQbV4KtTQyMSWjSyTULZywTNCuy2PIe5H40DZtvFcCLblJ75yD+hd+qg6E0WfjsdArBCkloaNdIOmzBj7Xnep9pnvVx+8bd+MRun+Y7+W8kTVsh/5uJnX/gDqhusEKdpfF2dPKxGGTQIXNIgoSHnIROdumGEDYtxpE/QMTzbuO7QUJHhl+qDvHzSaSNJdlqj/+ls4Yq9XkNjPw==
Received: from MW4PR03CA0188.namprd03.prod.outlook.com (2603:10b6:303:b8::13)
 by CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 09:21:46 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::cf) by MW4PR03CA0188.outlook.office365.com
 (2603:10b6:303:b8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend
 Transport; Tue, 16 Nov 2021 09:21:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 09:21:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 09:21:45 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 09:21:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 01:21:45 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d98a65c6e91f4ae0ac0d2dabbe8c62df@HQMAIL109.nvidia.com>
Date:   Tue, 16 Nov 2021 01:21:45 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31648594-f966-45e1-e6ef-08d9a8e28310
X-MS-TrafficTypeDiagnostic: CH2PR12MB4293:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4293060DADDAE4687F34B1E9D9999@CH2PR12MB4293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mSYkNRcemjDfSlZZC7p/Gb9B1rKUh9QeRI/PcH55da7C+mHgwScT7giRQzCP1FTNBQnnjQEd6xRzUYXCsEd0m1LgduU6qlLPi+XK96YNF6g1E/VrKfqRLpe+VruWFr2Ut0xIikBIu4cLXbj0ktw7P6ZBrs2TlNyMrkT736M088kPQX7QfyL9QJ9Eup0PJLmPUSCwHi+Hle3Yr6an0t8hUTvDs7AfsnnoFzLqI994IdQ0qkarH/xxUgoA+CfpUW6KOyJtu04hMeyHD+N3CCO0w05O0T++KmzYGecNy364OLwKUJ1AQph5BFq89NBTDFtQNGGat1QbQOLA7TK/BPSiOlu0Ox4E/TaZabV3ztOgHcLMEg218OE81vxWMtuAva4HqEO6eqA3zaKTeMhi4ksDuIgAi5WoIEDmp0fKiDKnymxa/og5sMa/v0vHnGQ1UwB6g91hXuzN+1XvAu3GtPowiBWNH0NaD1LUSdDzhuBG0/KxADtmTHPwZl8/ajD7+9ALDcz6FRwoAN9TXZ/rfEEcGFIu/Fl2HnBP7W7vK3MsJ5Hi2Nf9wpqScQX7+5/noLsJA/7xb4/JnzQWhEq2Wgy/ZD0C8O6d2VH4g+hjoKwXFDuS2eZeyRq3NUbQjrCqDGLH7ewQMvB1/KMC71d3cQw10jP1hVXfumlt0VtlXkLXZC9Ee8lQqn+QPX/N6CA1ToLUEzMnJF+4VxraubNWC9rX7/nBpAHirpZnfi+Lu2AhE53lFa0JWtkO+5akE1QiRLzuiFsPmgVBgCIJTym7ITu/sYZbAfY7fDB87HtQ/yaj7oZBNhSakJgKAT3MUOqGhlVX54pxGZOwpycjuUOELqrO3g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(86362001)(82310400003)(70206006)(70586007)(356005)(7636003)(54906003)(316002)(8676002)(24736004)(108616005)(47076005)(8936002)(4326008)(336012)(6916009)(36860700001)(5660300002)(7416002)(26005)(966005)(2906002)(186003)(426003)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 09:21:46.3544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31648594-f966-45e1-e6ef-08d9a8e28310
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 17:58:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc1.gz
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

Linux version:	5.4.160-rc1-g5d92321b6b90
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
