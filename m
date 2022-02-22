Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F7A4BF7D3
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiBVMIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiBVMIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:08:21 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE70B3E46;
        Tue, 22 Feb 2022 04:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwiRf1WXm/juPOwXhcfj6f2X/Em5GqHbba56VC/1DRii6AHA0NNGwwE/6uB1GsSoSKOdPTBImP8tR0DzDLP3hHkz18H2bhfrxasBwynAtdpTo7nxE1im6+pSHZ5pmV9UuklQBrVm2wiHcku6Pntm8tL7aFlITpVJ0paHP0LujCdy56VVBHPJGTN7tI3sYi/WyPIgO/4dFKo09nPbkkZUlN6ogQfSTb1GQxAuMVgXqdrGYeADHEosc1Nn/KG5J1gN5Nc6rmStrZUXEdwsVSdR9Sybmoba7sVv7Py1mTGC5USut3JKqg0keCpONBKrwg+VXOWB45D42dZe96XlVWuyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KNpnasLKTJifoHjhghFyLHr8M7lauNokq8i9BAsz0g=;
 b=Jiwks9zWWh+l40ffu8Np1H1dWcsVvkn18geITe9Qjtxvv68hNLicp4BQHEnkHmRIEWK1CGHOnzYQUT9j5HqQK/ZXnIY6p3cF1fs9y/Vx23sZxoxoMF1RL/K0pPAE8CoEpRShxmo1n6k/i11rwbet29hwcfpBCAdZkkLokmLCQ7zQcGzWibG+LjeTH5gjyuU6oixjthGZYnQJQPzifyV6LgZfZBtd4qd/rmKTNQwqI8llgLLav6yNAGXB2SEyJuuFOAy+iH0+P2BFfPbvNcYKamhhRIr5fQlsSqpNxolB3x+ceiVOEhD7OHs5+tleiddI3f54WnE4SvWm8pATrqZYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KNpnasLKTJifoHjhghFyLHr8M7lauNokq8i9BAsz0g=;
 b=ZH5KdLlae0B1QNtvN5T7UKoVPLBaHSuLsq59uS8yPG3fqTNMKaq5ksk0NzZULpJtrbgZeIrqrSpTCi8bA6Wdi9RaWDShB2zDrqVEyuokZR6pbp8SFYzrQRxjX0tD7Lb+skC/ZDjCryfp+Qy/g4WXl2CEWfLbSnmNlQVBK2wik9JSaSw9429M0S8gF3M83Il1nqr0wATi5p/aUe9nrl+kAtOHscn7L1YQiqhGL01vtFaeDJET4CCRgB04P9TrbsxWktqAxs66vJeybWMqwhzxdxe3i4xLiOg+R+Uu9KNJlqUC83BbIpbb+W9a6BmMkfAqPsZ5nCks86tUO4pTe2fUPA==
Received: from MWHPR2001CA0019.namprd20.prod.outlook.com
 (2603:10b6:301:15::29) by BL1PR12MB5875.namprd12.prod.outlook.com
 (2603:10b6:208:397::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 12:07:52 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::32) by MWHPR2001CA0019.outlook.office365.com
 (2603:10b6:301:15::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.23 via Frontend
 Transport; Tue, 22 Feb 2022 12:07:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 12:07:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 12:07:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 04:07:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 22 Feb 2022 04:07:48 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <05d67be9-1bc1-48ad-93c3-45be66148c66@rnnvmail201.nvidia.com>
Date:   Tue, 22 Feb 2022 04:07:48 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6dfaa17-0318-44a2-480c-08d9f5fbf393
X-MS-TrafficTypeDiagnostic: BL1PR12MB5875:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5875982E0A50D92069A90825D93B9@BL1PR12MB5875.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2IoCKQykT86tqfjG2jI7EVIWuzQzDZv60+BzGEQmFbQ6wOecLgRShZZe+opY39Ep469FtNXg0azg4Degm089fk5V+bsrJbbQLh2A3qGj1unLHtA/u+wuCo9AudpSp8ngp6m4i56c6SAZdfhzuAUm8Lw6BEZVj09kjQFykTkD+NGpzMYB9WoatAZrZN3F65OC6XJkK+1RWlvYKtUVphpWvPgCowl5fesJ9TIq63seT64l9Dmq1z/2QLJ24sTP3g2nF4PUhGd305y5f3Zx5wjO6BGZKpXxAZ3uITLQ47ja4IkqlTTj/NTwC7GAlyWa/9t1jU3ypzf6WgzIkhv4b/niVemZL15HuOa5XfoHKe3oVV5iZGrB3PiPF61Dpt/pik3uJmau21sweE5Hc73ZmDS3H6rQdfFdfqEJVIOotgdQsdyvqkxnjP+F6+IvDExISanP2j91HpfiVmMEh1rt1GLdttl2DXXGscYmLBFyJyFcbDwc9mVJvIjFAQCq2C+bSLhMEoBb0MuaSUrN/7HFPzJlVxF65KmhIkDKH8AEkFdbuVFRxTpwJIHj5ERiftiRHPs1PEmi5gel8Gv3DafgGIxOMQqqJ8Qbml+QuSHwOlHDGm07Zh2kVT1Cqkn4orbgd4UQPHGdb6MRByfkJKDP29tjGJ1mp/IrLu+YrfBJrnXgwFX0XHb2h2tNaDu8J7zeRp33U3J1CDYSNQHv23+VMcvLclReZjSYxYDvE5exhAdo+bUAsaPgK/H/54d/IismGEFhRAknTejOE7an/BPYuM/h8Zdj/2GIKrbXlPTleQ/sNBQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(426003)(36860700001)(336012)(5660300002)(6916009)(316002)(86362001)(54906003)(7416002)(26005)(40460700003)(31696002)(186003)(47076005)(31686004)(966005)(8676002)(8936002)(70586007)(2906002)(70206006)(508600001)(4326008)(82310400004)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 12:07:52.0654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6dfaa17-0318-44a2-480c-08d9f5fbf393
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5875
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 09:48:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.231-rc1-g354a12b76a6c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
