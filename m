Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20747B2C7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbhLTSZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:13 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:28256
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236695AbhLTSZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COQSVxKKn88tBPtwdQReSc5hmsCOQyD0hUaIHCQ7D5YQkgEX+q5g57c3Et2wKOfq+GTJ/O/BTy4rdXL0kHBemhMo6oqXwSkAOQoHxCSPSLmMRT4dGAGUsolzU0dhA+LffhkRtYIcvGUC6LCxCfvgpAieszqZaA6BpHJF2zCe/v1YQeYpdW/8IK+ja1hcnyuucZ/fbYDwhICRsRySy3QDPXTnLTL2+CTfoibVLwmWtBnsf8+c5jZ9Sd6TnLRgBTH6cTrZ7vIaAAnZEYWnYo5tWXY+UZxwoLoTwWJ2tOmjb50+hshO7Undepmfh94JR7MqJRWsIfRb/eFARDHR+0RpmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk+G+YlneiK+/r8oan4uEqze9QamGE019jwB+vxhBO8=;
 b=KbI1640tpnxSC/THHAep4K9YPuOhZ50Us94kvDzWOau9F+91pXlwuLtscvTWRQEyLEv+2hLUYuK88q6GpuFEKC7TCptXkSJxoI5P9eDLWJaEaakLq6ajy5mRK75V+HxYcbw6iPttk6e71bjQy9zhkwbxY9nmoZUl/7EBhxyyK/K07GJdCNnPRBon742W5dWZWRkh4UtXc09JgJIbnzCGz6JT+qh0u2dCCj1r/NSgoK7j3grJ0WrpCvv3xoPM8xgsaZWFKY1g5LCdygEvy5S4hNYMmFObRj53TUhxuN/jx/MHxer4oEd8hWfyc3oz/NDvG2CQwwhN1hwFIY2MYfLjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk+G+YlneiK+/r8oan4uEqze9QamGE019jwB+vxhBO8=;
 b=kG7oZzC9lLOoPgId6IPULoqxNzuNZ+bUOwp9ezpz3KrGcOq/nd+VMjv4si4lZPAKNsYez8wpZ0w8uEbqrQtDKr2mWL/m5D7LMb8mZ+FCAtL/vQjOe6nkarTJH76+OROVfreWaZraL+naxZCZU1kR0ObQH3ZHo7NLnBmUP8SIxAMpaFanWM1CyzN2X7PsCb/mmI7hYyUNSenudxC4Ufq6L4ulBbL3w+jUv6ct5lvf9DVhOQJZHl3UXzEpN++zlydAK/XaymH0lynRJAy/1LMriRU6E8qsODL3nkYlGF4+4rZkJUC//DowYp4isZ3WA5nII9hSQdUv7ifCc3Y9eEMrzQ==
Received: from BN9PR03CA0732.namprd03.prod.outlook.com (2603:10b6:408:110::17)
 by MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 18:25:10 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::6d) by BN9PR03CA0732.outlook.office365.com
 (2603:10b6:408:110::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:09 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 10:25:09 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/31] 4.9.294-rc1 review
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bb41582866f544d3bde9da6e8ee07bf6@HQMAIL109.nvidia.com>
Date:   Mon, 20 Dec 2021 10:25:09 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 676a277a-eebb-4605-17db-08d9c3e60eae
X-MS-TrafficTypeDiagnostic: MN2PR12MB3053:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30535717CB6AB5B71725BAE7D97B9@MN2PR12MB3053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TytQbFpuUWFEak40a3NIT2xNUmlHaTVoQlhHYlhWWDRIcFdPbmpqS25LU0U1?=
 =?utf-8?B?b2Y5TmwyekF2WUw2MkVtUVFkbEM3UDNGOU1YSDRGTkpzYndyMnRSTHRpN3dm?=
 =?utf-8?B?Z3RKdHF2UFVjR3JPOE5keG1oSDE5dHhwZUl6Q0t5RXNWeHlpdTlVelFuTk1F?=
 =?utf-8?B?eUlFU3U4b29vN3JpUnJNTHo3d1M2aXpmSUtBZ1NsQXVhOS9YN0h5YnFldWNX?=
 =?utf-8?B?Q213d29RSk16T2N6TkdpQ01uOGNGZ0RTR1FFSVphbTgzWU9MTXFqNVFPend2?=
 =?utf-8?B?aXRZL3VzWWtXREhtOGt3VTFOWmg1QVhGd2pSNG1VN2puZmpORXNSeWI2RHR0?=
 =?utf-8?B?enkzb2hrNzdiNDJURFJxRC9zMnFkN1pWcUhIVlF5MHNwYmVaeU42TjRCdmJl?=
 =?utf-8?B?dllsV2Y1NWkzbzFxR0FZTHN4SmpoQTNUamxvcmJZMkZyeEVvejZVZjRQV1VE?=
 =?utf-8?B?Rk9ncVpJTk91QXhXY25JUXJzeTdrMVI4UUJvNjdWSmhYcGx5Uzg1eWZBVk1m?=
 =?utf-8?B?NkVhSWpZcWF2WWpSOGtBZkNXb0NSVytiNWxMdXhUNWhUUXIrL2xtN2tRK1hr?=
 =?utf-8?B?Mml0SmhJTXhtNkpKMklZU0Y0VUxSVEZPcklmN1p0dGJlNkJRYXR6dWwyc1BN?=
 =?utf-8?B?T0V5SU1jazdIdUYzT1NiSkdpM09ic2phZ1NNSWJGNVp4QW82NlhJNHdQb2Mw?=
 =?utf-8?B?MXdTbXZzeXkwZFAxM1MvSCtFYWhTSGxqZU1TM2xFWi80bzFTN3JnZCs2RlFR?=
 =?utf-8?B?MUZBUURLQ0hUMnBPTFYvaGpWMEd2M3NKb29JSGN5bHRZTnRkeTlURVFFejds?=
 =?utf-8?B?elYvOWx1bkhWcnFWTXBCTURjdkVhZkxtNHAwazZsSHJ0aXB2aFltZ05sMzlM?=
 =?utf-8?B?UzY0OHJDY2I5ajAraThpSGRpejZBbEtLQ0RBWW4vdHlZU2tVeTYrbzJNeVVI?=
 =?utf-8?B?eUI1dnJzTUJGaFRyMjYzRlU4QitQekEvT1ZEZ3NjS0ZiVnc0bEJ4UXVjbnRt?=
 =?utf-8?B?aDNONmxXM2g3K01Ma3NuWFBiUEZtdlUwK2Vrak9XNFBCbHZ4bG5KSElhTEtv?=
 =?utf-8?B?eVZFa1diNE90aVlDL0ZmQXRqQ2dvOWx6cGlQNElvN3ZrWkJxWUdnMHQrY2cv?=
 =?utf-8?B?WEF2MytFMVFVbVFwOEd1allqUVZBK1pYWVArSGdVdU1zbkUrQXlhL3M3T043?=
 =?utf-8?B?TEtrNHQySHlxZnVUTVFGcmV4cEJtYzAzbDMzR2xHNXhaMjZrVEFjVWx2SEcv?=
 =?utf-8?B?eGorVWc1cDRlUVhtWEdjSWk3allhMlZHNjVlb1FwMDVpbHh5UT09?=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(26005)(40460700001)(316002)(186003)(54906003)(8936002)(356005)(34020700004)(70586007)(6916009)(7416002)(70206006)(2906002)(47076005)(966005)(81166007)(508600001)(36860700001)(426003)(5660300002)(24736004)(4326008)(108616005)(336012)(8676002)(82310400004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:10.4058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 676a277a-eebb-4605-17db-08d9c3e60eae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:34:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.294 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.294-rc1.gz
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

Linux version:	4.9.294-rc1-g4578d170efaa
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
