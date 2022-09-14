Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633105B8BBD
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiINP0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiINP0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:26:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFBA7E31E;
        Wed, 14 Sep 2022 08:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asD5BoZSwdJcwEIHw9cFWgdt9AzBpi/TKdBpUs3oY9Pz8XYjfmJTcCSQhHKkONTrGbFACfkBy8UmJgN84vbs7/fZd4XMP6KJJe3YBOLRCdUrl3QfN/PXuCv/uHyiNKwqSPYMPy2ShzM7aWqbBXiaVi4DcCVQMuewivxdc9jsoFuTKSG+6akLDgLrzOgSMlhAmHNNN8uamtYGkk5o2m7E+jPhciP3UbnfaY0W57Ls77gSHgkp3BD6nlfs7EAyNiOos56wssyX/Q39P35b6xGUed6oRCD1EWNbq6YL8FZM8sG8TmpzGpSaDTtG15NxD5UMScOrLtSkhzIL+6/SuWx5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ktg6AhH+9YGOT9I9t7XVBfD1GPxS0WroEtOJGOxlRrQ=;
 b=D3/+frGeYPDqBpJ+QDVimMSy9/jUjUPyudK1lMlLRxvmVFSj8Z0tZOC2GXOj80mRdluHpVhlqXOdzjJICDq4xsviil7RszYrEz/+9LEcl3cJihodFOJkEa+09dRQd+v+zwrExIfbBwx3KsM4tuLEKfceVLrf+0RMiKvUv2eMF0IipMMPFM7pgJxtGkDaoquopToj3lQFugOnCsznN/3FUcU0cKZ85/E1Vahs/gpPKC3eKTLNZkLHu6J5XATN3AEQJGCatFF5+VP0xduAWXlqO01Ne304UL6OwGBi7uovTFUx0DZBz9LgqZ5v7z+49xu2aeS8mmZcLy57CQK2mcElAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ktg6AhH+9YGOT9I9t7XVBfD1GPxS0WroEtOJGOxlRrQ=;
 b=f6RlMe/ea4CqyuKypX6aCJDAAeoahFymHQmdKfrM3EN9JxASvmyEUMbD2LaFwtduQppdTgwvKBPdDz/xbYnbLKL/3fcvN5YvNFRclKtcyCKCGOOhk7SgYvKsmZgucCnnIO1ijq+ev5CJclSF/uS8boinKxNYJwuTM2a6y9E9gYKuMgtQvZjtNO4e2qJhlCtoZ0ut87PuA8sp3dcQGSs7+NRgsQwq3bGygJ6zcgjAje/BLh/y9sr8EC9RAvD8zqWsPXV2vcfWSIJ7jdtfopRN02WssgOX+x42QyCNTiEJpdVJSTbewGmXXCN1b9yrJS5ruiiDKJx/DvK9YHnW35Sjng==
Received: from DM6PR03CA0018.namprd03.prod.outlook.com (2603:10b6:5:40::31) by
 PH7PR12MB6466.namprd12.prod.outlook.com (2603:10b6:510:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 14 Sep
 2022 15:26:43 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::b8) by DM6PR03CA0018.outlook.office365.com
 (2603:10b6:5:40::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Wed, 14 Sep 2022 15:26:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 15:26:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 08:26:31 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 08:26:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 08:26:30 -0700
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
Subject: Re: [PATCH 4.14 00/61] 4.14.293-rc1 review
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <059c1ac1-5cd3-4368-aaba-6bb9545038a7@rnnvmail205.nvidia.com>
Date:   Wed, 14 Sep 2022 08:26:30 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|PH7PR12MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: dedfdd25-67a4-46ff-d4df-08da9665872d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+l6crSbUZuOWaEFdCActm7ka2XAum44fFLetsyg4xu0TPiu/YjMmMuV6dt6dXwCbukC5KxOjK6+qyFq6q1DCLhcCnu+Oik6G5pVFkuXetwUwGPFkCyZzlkpsdQVT0b5np/RvnKtEgm4I4bsczEV32TEncyQ7uEz5cx34prQZQJtjAOLdfU7RZ7EKnj9WpixgfgE/6HuNdL9iirMQohyLLiCPEIJhfOggvaPewxE/oQuS5Y/sIGQB48d8cSTGfKbG+HFBjPuy6VjhejB23ylGqE41Z5Y7xkEgmOEp2CBLTY1xxCVJz8ZeCH96CyLCvyYkadoqe/UNHH0KGmDnjOt/6Cm3WLkw3CxlbFniZjl4Zb/GUzDblJBroxfRI5vsq4g/S07nlxmcXJvagRkmK7AWQPNQxYGBt+LAbdf3GgbZKU/wVPAbHey0p+Bl0TrT4AmncfKTmaga+RVm514iYG2dgHItQqJ1B6sskd895qi4fqsYy4sPwww5IEWVSQlOu3qOUbXttFM73wSBgU7duTDq7VD1iRGED6sG6IyqiWrEVzG/3teqvw01flbDf/4+8S9s8U2jK3dzlHviAn+izLl69DXmr7z2Sk+l8UEMzXouInS61ySMLsET7FJyHdQIs+KO9NTkJ5WYomTHSJTEwyma9rDA4xhvLG9tAHQEWKwmz3bFTa61p/iRL1NLUzyJbZV8zTKdW87gui7l1p8v//LKRj+2UEMpHhugq7nQ7BdX/g70B2Mbq2prSJggvPxpxsnGETPC/wUk90ReapPaUH7GWKH7rWtUTjR3B28mtSVSCYOdFu75peXYYRZO9WkGQQd8SKvCm8aQ4uKVJ7TPzoO7vqhLykjWmEeGwVl6snTerk=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(86362001)(966005)(356005)(7636003)(36860700001)(478600001)(8676002)(70206006)(40460700003)(70586007)(6916009)(41300700001)(426003)(82310400005)(82740400003)(4326008)(40480700001)(2906002)(7416002)(316002)(31696002)(5660300002)(54906003)(26005)(31686004)(47076005)(8936002)(336012)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:26:42.8575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dedfdd25-67a4-46ff-d4df-08da9665872d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sep 2022 16:07:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.293 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.293-rc1-g348b7ac1445f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
