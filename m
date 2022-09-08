Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5144A5B1A76
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIHKuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIHKuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:50:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601CA5AC7D;
        Thu,  8 Sep 2022 03:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILSPPTpg37/1jRzOucNgVlJtoavAp2IX4o6Z8kE2SYeXLPrwK2kj2IAtBngvfO2UV1EDyIrOtbVXi+ewcPQJuXyOo8JSXs5zZmvFmotGrsN+7i9u3aMRcvgxHrztDWdqonBg++NeybsvRqm7ENpntJGfPB933RKrNC1y6bmLwOVk8C58XGEZlargzO3v+C8mdOAGd2S1tmeOKcNQV9mgOO82EVnpObucNO6Ciq3hMKTDE6lk2ZkCyXvPuWkzVdSVf6I2cdRXzB9XMFIlq8SXx4LSiHYKi0kBBaHJn8OV2y6Q8DaSBZ3rbjeW7rAA0g9XDGhXXhXmufvLVU0tC3hXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6rJ39WcXekzjTtq01IKqJYtUJinMHgwvfDp0UA9eCM=;
 b=nGPilVxB2JGo1Y84hALkiPaSHAGFrQtMMPoZn3lWYzyG5+htwbSJiadBZxWebjRyfe34mdTk9xK3sYevKtDyD7pTpGWcDyYGvqAermOOZEdblLbNBAPCB0hx0xDWuGPQqkwmw1PlFvl8zPkKDWVEKaC3IMtI3k2fKVvzpk4yGyigE+LYyR8G6r2voMg4BztMLi0+4TDMyh44kepbb47xf7vHNQthWOXC9yNKCNqGegN5+1YUdXyD3rOkDI+w3N25IF7RBYeTlQcHbrP/r8nAKv9mA+vzf3WekSwZg7YNfIgw6vYQn/9p9KM+bLSqEPm+/ZyxaAoAwq4JxWpshrrxDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6rJ39WcXekzjTtq01IKqJYtUJinMHgwvfDp0UA9eCM=;
 b=BFJ9gpDcaSuiLM3tuYpCrQPbbl6rc5lOWnqAglatqQHQKv7clmGLq7ZHPcWMTzSavYDqD17dygASHCo6WGdRpGAsM4Oo5GfiCxJeZpvfS2Dn6aN26h2a3/cNtaWP6MZKF5GDsr+iKZjPS8N8NvJhpxuBlN3oudz3Ki8Q1X5VbGcQt8oMhK4hLPVkBPb1U6ODvLDQBunPonIBLrcWApgK0ZH3tsTVLdpVbbhkEOjgkBWWKdDQfQqwpFDC5uYJo5L5gb7eQ0tn3nSDNWXMY9fzjhyjI55sb7FE4Y2tqXZcnI9pFtQKCZKWdKlo5PgJ5cvigovh3G42sDKNJwm7wXtejQ==
Received: from BN0PR04CA0118.namprd04.prod.outlook.com (2603:10b6:408:ec::33)
 by MW4PR12MB6951.namprd12.prod.outlook.com (2603:10b6:303:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 10:50:15 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::4b) by BN0PR04CA0118.outlook.office365.com
 (2603:10b6:408:ec::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Thu, 8 Sep 2022 10:50:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 10:50:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 8 Sep 2022 10:50:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 8 Sep 2022 03:50:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 8 Sep 2022 03:50:14 -0700
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
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1e32809f-c885-48c9-a2e9-d1e68f085ea6@drhqmail201.nvidia.com>
Date:   Thu, 8 Sep 2022 03:50:14 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|MW4PR12MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: f613fa07-ee41-456f-a457-08da9187e9bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i12Gg9PHWTsbUJ3w7WXQQUbG/wJdE08ImUoBnJdBRKpW+Om/7WX4QtHwC27DqxuFA3Nky4z0yfWjLwLvDSONmPWmQ4kJ8/76wrwuWcMAwvLi72DNTVS5X6+Zc2zzep2byi5pptvcCNol8SNOVrJVIMEsXRBBOgcS5zL+lLb1xzkFBEEknC+G0TVxhXc/tfrnDCMfuoIxcM+J0NUARQK9+fAbzmTUB0PSjuEvaz7QntCMDaG7MvOwChappBgD69yOv2V1SIC+huHNimhnX2vVR8Jg+sLz2ASvOuavpvv5KE7+khiUWZwlUujpYBv+n0O40fl0px8aPSR99GmYknmF+TuYeLeUMYrfVAyhpFaHJVHprO5cmXC/KN5hMl3Qo8Y5ze0B+BTho3AVA1U7i2tIZKYlqLhZPsHtfa6ZbARzr114z4WnOJcY/ilK0Dq9QWARL+XMgnWHDxAXfx+njKWBDvCU8iuofJ0GpOSqYiOK9/lSFfNyar9S+OTM0o5a8w33u8Vlgv2Us3dZIRIQc8mocqAHzsPxJwNXDfPz9ultf4mMs3mjw019o6zImfSikktLcSbevvMYbqpcQNAYC4HpyDZrEf45A1kVCG6NRJfFJOU98l0/2AQ5frRNRJ4Y2uuQbFRlPnJH8sJOUEoY2Ug3i+/MLCEpHA8jLrpVv1/ZyrN5NFps7kGjtocW8kGGTTMw7wATxsvwFMyCpAwJar/BxhBcCWeAWj4jHR1lSXpHnEZ58DgKiOo9WEV2pMOe2IXetnvzHNXgkY2HTJtWEfcO3afrWmZ4wBubqOdmvO/4rcH5KwHVYY5fZbPdFojrdN7LVkoXddqBR/cArc7mJ7/OXZuzt2BgfIW/s1ajAEXt/sUoGzXsZpuuEsnuQymWoixI
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(40470700004)(46966006)(426003)(47076005)(31696002)(82310400005)(54906003)(316002)(6916009)(356005)(86362001)(26005)(478600001)(966005)(41300700001)(186003)(336012)(81166007)(40460700003)(31686004)(2906002)(7416002)(5660300002)(8936002)(36860700001)(4326008)(8676002)(40480700001)(70206006)(70586007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 10:50:15.2472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f613fa07-ee41-456f-a457-08da9187e9bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6951
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 06 Sep 2022 15:29:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.66-rc1-g78a6337a09de
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
