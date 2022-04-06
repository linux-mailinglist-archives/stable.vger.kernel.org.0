Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4330A4F6BCC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiDFU4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiDFUzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:55:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119E31FD2E0;
        Wed,  6 Apr 2022 12:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV8TTgqNIqnQLx+KQXMD/9qLsjKPRyMItxPz8ekz3kCDFxAN8iNw+2xicQxtJtqyZRx/gCmpTT6TT/0H6PqAA2vPhmXNKzLBFwnDa28RD8NIxD1Sj5uYE6WIyfOS8lTbegfaBSu+r11wEcD83fe0ixB2xXprQy0ooFepUzpKD3KEpedHPPpWj3uwxT9iw0tsiE0SY7Sl2WofvzO9bRPZPeRryooEAWniDXH6Bw0sg+q70UFCZDkfJZ52624XBGeAGb39Q8cI6oHrAde6LXGlTyzjTfAt9sC2V+lDZunTmLbCjdvIVSnHFVdI8jfnpouuoQX/24H5kdmMZMtiIJBIOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wK7IbHBuJ3G13i4HKovK68E0Fbe86x3rDW8nJUQJtU=;
 b=bfIngEn0ESMXK3fGGYgLZn4p28QuBQNS14iSqMStTfvP1yj9SpE4tJ4SMFhudjovmombtFWTMUK/MJ+k3LEF/oABc4AAR7udFrBigQXzvPmSSFkTKOllRQdAB6Z0GA6towQ6fufW/SEwi8Ip1XR7N9nSVFR3nGjCVaNcasA3vyeWcvfoQ87Mp05GThHC18FqRt4G+Fuvy03cLH43/QdLEqgF+ryDSqmk4xY0KpjR3R+7HE5CYiLRSBlNrOIX4zPERuN+hU3zqm1EAqDFfgb0/SMKlfB6oBaEnGikQUDI++UeqNkOErxJTeJDG/KQhVQQTIyurJqsyV5H0B06968hSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wK7IbHBuJ3G13i4HKovK68E0Fbe86x3rDW8nJUQJtU=;
 b=p8WNE0GZXLm0FmFtVgNm8RaNff8A0YpWW9daFEz0tewhcnoS7T322io1U6OqO94YAB9obLQjJUANWeAhI9rHRKl3jxlfLkLn2rX5B9UTfuhTDDLmJwf5bo/vLZuXP1++YOnR2+FME/19AIdmzXOhdXp44stzRSgouh4sKsy5hb53MzW3M0wBcRZIXF6Q4zRSRNvTCJpx3kR4hDrHUCIUWubmCUoJETGLR7CSE2M2WAXEOiPMabqnuQrcMBmyxYAhHuZBchBQ17lGCF1oTwqjenkN9WFq0ZuJ5PXep00ckT9z2n0yosprzbHuDpyFeL7NfG9ouBty3aebAPnzbV0zIw==
Received: from MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23) by
 CH0PR12MB5345.namprd12.prod.outlook.com (2603:10b6:610:d4::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.21; Wed, 6 Apr 2022 19:14:17 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::31) by MW2PR16CA0010.outlook.office365.com
 (2603:10b6:907::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Wed, 6 Apr 2022 19:14:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 19:14:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 19:14:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 12:14:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 6 Apr 2022 12:14:15 -0700
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
Subject: Re: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
References: <20220406133109.570377390@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a78528e3-3a2a-4858-b312-690a631a6798@rnnvmail203.nvidia.com>
Date:   Wed, 6 Apr 2022 12:14:15 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecbaead7-f8da-4475-fd4d-08da1801a55d
X-MS-TrafficTypeDiagnostic: CH0PR12MB5345:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB534534A73A9193F128A866AED9E79@CH0PR12MB5345.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2AyExu7sIe4V/UDbjd+teRtmSbRs1CgaVI1Qik4MmbH6K7TLoP9pxOJT9BKT1OxLHTpke3lutQVI3lnKKOQKtogbXiPb6uXYg9tRiVm1Luzrombr37vxJdJHdd2mDcV/4g1wLsNPu82razAWA/1gPjH/XfuwFGEhwfQ0L5/cPiw1TnnKABapyvrsfDoC2oQwhp+UMWoBK0m4H8HJE/73V95G8hbLgMzPtatjKYnw7BOrvPo7xPolIE5kzhypGeB6Pl/EYnLw39UpQYnCf9Zz3TeBgu+Cfgio9DOdcjJgx96/oZKhYTq8tbPsGdjSU77aCJT5SKBJ9BRoYokjF1r7w5UDTeHwHw5bs74XShrd4qmOPSKt6C9vGwtt95rEXuyWf8cK/IwSmkhUfW0gmwqlTRAP3VceU0zyyFUJtWvmxSOjmTHqZESE774Kz0rpjQ7G6ZbxrxDuiZmh58AztCPmlrruiusrzI+bvWaOZUME7oKkc/n6eE3SX0h4sswz7oaDW2guQDGs+nTMh84dYysPESWV3aiSWRu5FAbAhYUPDsmgbyt8pELqns2GVQz8oSCI5Bdz0pOEIL+vmgyN1mtEhkhsf4mgsU2THGAw/JkAYnuITWtM7t4dJvwD+QMqrwxHB/bFMs5IbRMl8graSv0JFFkgVClVk2MZKvtZF8aFmwtkE9NCCYLQ/fu3HwVNqGhUaktsaRt3/zIQ1QniGaiseO4f9FG4TQsNWGZTMSNY9nXQM0opeANF5Rye6UOlCxXmWOLZ3uTQgnuFBDdKiU3Vt2AwU81lFWmuBRt7XgL4ww=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(70206006)(336012)(8676002)(426003)(31696002)(31686004)(86362001)(4326008)(70586007)(47076005)(82310400005)(2906002)(356005)(7416002)(8936002)(81166007)(5660300002)(508600001)(966005)(6916009)(26005)(54906003)(316002)(40460700003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:14:17.3687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbaead7-f8da-4475-fd4d-08da1801a55d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 Apr 2022 15:44:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.19-rc2-g18299e64680a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
