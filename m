Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD050687D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 12:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiDSKQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 06:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiDSKQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 06:16:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D63255AD;
        Tue, 19 Apr 2022 03:14:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0mo9pOzCF729klFgnqAF9cC1YqijvbadbBojN2KR3vx6/fDP3WowVdYkKNVAdHfhgo0tp/7lAuyNfCBbOHaY1eeWinG8hup9RSUCiH3V+xOzOx9QWRPm+VRALXIJnSvi9VZD5I9vn9qSm5elHLe5FPJTujQhJMQmdB/1dSGKZLsf4dJbA6JbUuL2FNjRkrun9hVqfcsADPihjnOaGyaachnG+QluLzIhPDMazO2iCwFEHTRbL17sViq3W4fDeyZvm89ZgQ1VFQ6IaDFUBnMxx1dDeZWgZRdfz9BhmMacgIxL4lIADcBdMPmile75F9fhdyyjPoGQ/VkFm0AGcsmUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qE2AClQI1EVGQMaF8J2X3KgcMuUVbIXZxCUlj62/dzk=;
 b=XzWZLaldLJyZUQyzR+WAZ6cWOzjMkOrk2oKq5aZojXTq9XPdoK7neNH2j/ZzxQ3dmPrbV2vmUfMbetxsMmRb50cPMlvP/BzHK9mDGcApS8dWxwLqhZkInWMIFaIRLMSHr8vkG3ANy2L304YTpt82TyuTZyK2XxgPX9y0HAuLn2QZJoPiQJ7yiknXFh1K3ZGNGODN2srhTuMEav6pF9IQQkFCrfXmwE09V8TLiEU6nlZPQqd2/PT0KP7GDin/jBdymiky7HMKh+w5yo8GJLHes7yk8K0EOAAsij0v3Oj3HkFsTjak8d1edw+0WO+ezIsVmyBsmC0gFxkQAlbsc6eF6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qE2AClQI1EVGQMaF8J2X3KgcMuUVbIXZxCUlj62/dzk=;
 b=VazJpprnj6cruKBQaKmKcRFXZo8PImO6GLUqYC46mGM+BKl0pUFH3QjnJu7+JNlzBEolyVQgklmDQszJwo2K6waeahADkq83ESIrWWsnYgxNPlfX3PtqhOYOjJUg03pA5qB+EhHDR4bDwS+eReyiCgq3aUgiXARs6YlKFmsh0gGLm2uq6kOsaqVcv6u3ZFA6PkZ8XtWewzN37qJUaRYoefPENNZB0Xs+jPao5VCEFyTAtsnTC4ziBFDezl/CH/cliZ4k8NbhKVAHzdqpy1Kgav/v+VNes112l9IOMxpbEhwnoFLltZiKV+FsFnmlptXfobhE0ntNpSJQxbsybWYaig==
Received: from DS7PR03CA0014.namprd03.prod.outlook.com (2603:10b6:5:3b8::19)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 10:13:59 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::e) by DS7PR03CA0014.outlook.office365.com
 (2603:10b6:5:3b8::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Tue, 19 Apr 2022 10:13:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 10:13:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Apr 2022 10:13:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 19 Apr 2022 03:13:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 03:13:58 -0700
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
Subject: Re: [PATCH 4.9 000/218] 4.9.311-rc1 review
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <325255f1-5e76-4a52-bca3-422e7bf15f24@drhqmail203.nvidia.com>
Date:   Tue, 19 Apr 2022 03:13:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0478cb6b-73a4-4172-a97c-08da21ed524f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4051:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4051131F44B45F9C4020100CD9F29@BY5PR12MB4051.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNp/lBgf5DaeBBzApoysdMO4MuuFQUraKHwcHb+zG21LiQvbBMOoZPjFchpkiPagLIhTG30/iJytjEULXrrTKK4QqE1LjXvlYUFMzPRyS5IHZfVvbWcRwTHfHyJ+hThrohNwfK/L+qpnCPaTiRfqT1+wbmtegBSbagVSqZw5NqbLFm5RNQjJfPbr0wJErMVg9ipya5rNEMM/ltb4TeZvoa/7bXtnPeTL19BJ24WDShch3UUwGiq0kJrlnwKv1I6jYtTL7glGZ9zDOwAkWuaKoVy16M1I1H4/AhxZoVshSj1Df24Wl/GV78O0kt1dPcgjXDGXMNFEGOaUG0hieCbXvhWpSPj6RWMAoTND4zKfX3UnvTvbdfYSuVavaF5xXb+9d4FCiQvTyApfWJKnVK5WVMcN2DAuquGyuf1rg4UluLqbbFO72fAT9WPRPRm7eVSJz9Ri1Mhf2U47MflfbGs+H+m7D9Rz7mZi+0YL4+pb3VKqtEn9ur27N9FZY06ZbxOykmXasDaaGsYTI2mbQL1wcaH2J/I1/VkPqwkHV2NZGDwyiJJXqJ1LXgDOzMyknkI07bWlwbXqlm4zJYJ2oDUB84KuzrwMJ76hE+WEq77YN+u49haeERKIu+yQVR8vtrz/XNZ6THzU99HEe8Uvtl7Hc59uN1haLeMGFZpTHpGVsGCJswq86ods3N9ss8SLZbwuqPcFAE/cjEzsEG01kpXxrdWH2e8QyJ3EvL0Tbwhk0tdRBGHhhzNj8ZGBqqwNmgLN4mZSwwGPNcUgq9MVYBTcxpXmiyqXwB8c8OSL65mHY+4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(966005)(508600001)(86362001)(7416002)(5660300002)(31696002)(2906002)(40460700003)(8936002)(356005)(316002)(82310400005)(81166007)(31686004)(186003)(336012)(26005)(47076005)(6916009)(54906003)(426003)(8676002)(4326008)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 10:13:59.7014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0478cb6b-73a4-4172-a97c-08da21ed524f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 14:11:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.311 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.311-rc1.gz
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

Linux version:	4.9.311-rc1-g3c9d972c8d8f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
