Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8450F58EE42
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiHJO0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiHJOZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:25:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97131583C;
        Wed, 10 Aug 2022 07:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCY4JlrL+679LFdIQ18Xv8faBkKqKLj5T9jIxfNLgITBdx/0QoCOPNDNmEAR7dYKkrpYSQ1sudkD+eqxPQ6+39daxSkTcXTNc/zFTbpWF/cTwiYbg00dPws+HBl5OdCqr/9024aCGPu5mVsrMtTHAgPzcJ2L/nCzlJWJxKmD6ClBUGAEdRw0D+qVhfb8VZqaSXI/2rF8rRJLIfzDCKu9Ch6z15Sb8f+IRSm15twA4T3V6VmEv5pJvRCnUVGVKKmhXZMJMFleNCuqsk8xYnXQbSXxc4lC0e5swwUw2QTzAls1Sv/tQI6459Dv3L9rtJzUpxEDgx0QTZ1JnNyMXAZ0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVnoWzl3pwxZuLS9JO/ADaxZWWZMbWgbK48e80afRwg=;
 b=G0z3ea/ajfU2oRoUV2IUCeWHOQ3lqFFSTUdZIAC4HrdnaHFZp7utoKiFvbVo8W6RF7OIznVHZTtuzrB2jA1GhWuCCsk2bqiJWCq1rT0wo9Otwa0DtiP2oHllHuZ9hfHnIDPhVW3GjnD2caihSY5OSepWQ2O1xh90M6qbBDsOEZTrBDMcZBiI6Ks48cooeOdzHgA58kEy+ZW4iEMdz2qm80+rdysEz5R3qN/m+eZ5M4D9jivIZRUo5WEaOnwkHT/vzWXaLWRBKU+t/vZi4mRIMORaR9tKpWt7XZPL1eUumqObF4pvT/MReSLPbecuyiLuc5PNkdAhZzEPnNYYGA6R6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVnoWzl3pwxZuLS9JO/ADaxZWWZMbWgbK48e80afRwg=;
 b=CK7/nHJGuhSjsMdxpwgmdgHc662MHKhcPRjL3H9+AgqwLvCfY41IHj8vh1YoLRQFj+Ffe6mHm8fyB3AdWqJDw0/XuOpKNFLMQeIskLENjEngvxTOkc5bn3E/T6HqdxtayuqIW4SDRiLG2tbAuNVBSAV3KDThIV/TsfLj7JtgxA10JZeGwSozk/XdKuCPuRszIvT5mUsLtQon+uYQEnj0ryMv1g8ncjv3n1qDaACEPTbMzUtaDVdp29hPPVX4LGztTVlyf0FXlsRmlFYjKqba1eGeidGt2fLrX0SDciOMZCP8h0/3ClUXIPqJeVt8HmW6/mvY5/NqmMIes6CNJpAkPw==
Received: from BN0PR04CA0064.namprd04.prod.outlook.com (2603:10b6:408:ea::9)
 by MN2PR12MB4472.namprd12.prod.outlook.com (2603:10b6:208:267::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 14:25:45 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::c6) by BN0PR04CA0064.outlook.office365.com
 (2603:10b6:408:ea::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18 via Frontend
 Transport; Wed, 10 Aug 2022 14:25:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 14:25:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 10 Aug
 2022 14:25:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 10 Aug
 2022 07:25:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 07:25:44 -0700
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
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <543d7adb-5436-43bd-aa03-14f6ead54696@rnnvmail201.nvidia.com>
Date:   Wed, 10 Aug 2022 07:25:44 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed07bd9e-8ce2-47b5-87a2-08da7adc36c9
X-MS-TrafficTypeDiagnostic: MN2PR12MB4472:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IY9NfQgAHyyeUprND9N+244x3XiW7TklMp+dI6g7znd4LNq5i9ZB6oDNOFv3q49JQoXqs4Vlp6IdWQkz3kVqE7jyWfSQLPF4IXO55JPULgOTQwsc8jHGJqhqR6j2Br67eDsc74cJLLe4bRg3gBkt1sozyzwTDBvKjB/azgMTW7SnGn9yhFghlBm/JEwN51hVuwn6DifDU2bUqre57aa5NDwhtvkb4DYAbfcp4/9zJNDZQ0INuXAnZn6t7rOIxA6A9dTtYstcBxsx3Lg1313B8MmxO5r52d+yJeB5usvoR814ujx8yl9QGniasJa7HlAziBEE8eHnbwJgrT3Tn4S4P8PTOEoBPZXdIEdWPUR/jgF5n4+Bh/8FwHgTj+Ue8Qhs57xivgCQDlzBAUD2q3cgkHrfPp59tNRmQ3WD8PEWXJRTdl9MhFlLcWA337Y1ZCKpFZftEPc+efu/BEOVmTRqQPU5WHbKYwmW85P7gzLZgFKa3d9QwyLvjeFrh0Pp0FPXzBn3V629lb+3ebaZZ2U4PXHgm9OcDJTNPmmSy8GV+xQui+7JjuLdwZhdpQuZF4LVjRRtFtLgAlUawr844/ffYQH0aGuP7STgRIbdRyrxL1urm5mjkiWfCV0+2088/N/9O0asTOY+YFEBaM6BAzPeoSLUdMcYqDrb484RUo3vVgL5XAROZKhiNKEsrbSPgtwML6lxdDf18q7WupNsBFEib4fBrYhEQg1AtRyROZBMPkbAFcMz3s9WwufpSr0Y5VBVM4MYxCUS6z+MrcIB+gziFiOQ44imL3U1B9Dfi1652bo9vcP/ww2e4/BdqbX8hT7YVMPYdg+vLBjEFOto7rG0Urjiid3eid80ESTykRn3k7lxB6hP9rn1/eV68xcLsAiRMP7FoM8b5bvfXndZGIBzIA3wrqcOkJu6TgF9xlt8SA=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(40470700004)(8676002)(70206006)(40460700003)(478600001)(54906003)(70586007)(8936002)(4326008)(426003)(186003)(966005)(7416002)(5660300002)(31696002)(86362001)(6916009)(31686004)(336012)(81166007)(26005)(316002)(356005)(41300700001)(2906002)(82310400005)(82740400003)(47076005)(36860700001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 14:25:45.5355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed07bd9e-8ce2-47b5-87a2-08da7adc36c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4472
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Aug 2022 20:00:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.18.17-rc1-g732bf05a92ab
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
