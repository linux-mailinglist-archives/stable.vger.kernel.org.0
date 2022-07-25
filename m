Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7454D57FAE0
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 10:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiGYIGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 04:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiGYIGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 04:06:02 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C5413D03;
        Mon, 25 Jul 2022 01:05:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCigKhzT6bad61EYr6Eag++WEiaLPwbHQR0ap/i+SGPNzXGTev8n4b6NNLgOz1kH0e5RmMYrQbpCYRRi5RJLwtE3JkLL43SCKUyvM7z1ug9z5biZ6SRpOIj1EtdLA/szhLJ16uGAsoxnpGuwOOpuD5+x14QSqyW28KmQjVAi4eKH3yPlkCKgFPj36tVSaJhCTjwI+kW3eLEy84keJGrsy1+Xd8g4V9xv4sbw6zJ+DGRzsIGfE29Gx/CHZQjED+maXCUO8Qc8aXrRGOU30EeQJ3uR56+uR3hg7BMtxFqFHZ6R/QOyfFQPdkYqIJuLhkUnDEpf8wJEZJurcerylBA85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cwtqjzduta3Acpam7h+m8PCVKyUldDagyQhNCcnSfM=;
 b=IVKlPDt3tnhmi89TiOzvyMnGHaYfa6E45lxNMPs9JD4FhRnnXxxrgZm11LhSVK6qWIJGnuFTcajaLK/57CY5RKn7J9uuHK3ExTCLbXK7VvzSDUvkO5UGGg5CGarPrykclUHn44RxN5mTJRXKUFL506UaSyaa5n6Ts9NCPTymAB/jBWzMixQG0PyysMxcb9TILHqjv+IijFJqj3hIBL4pYFvr19cFFkUFrxX3F83+AELCjemwog4hgHYv6yyOFPyhzuCLZk1FWJczLCFEfJJxzsPzj5LMZM9XFDjZWaTaYYBL3YqR2qFpHqvNJUZXkgHaHPy3cL7nbDCA9xQ2c6J0iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cwtqjzduta3Acpam7h+m8PCVKyUldDagyQhNCcnSfM=;
 b=sbrkFyCh8PpOSUiraLqQs8LuGuTvAeu3O1jRSukE8S5zea5QMIdR+7/GDNygeJTFgaxU5EJx6c/kH5NklFqkGfAIs6qKXLFbmiKgMTFK5p+MEMH3yLpZyHhXRk580lA4xQIPwwwSmlj6iOiQ3q4SI9e9eZA+LUvBY4DiKuc5M1jnqEcRDfpfPUAhzWYEETX7SSmG9UkecKUG7loKlMuLflTwk4lcqbt2N4Ur4w1zhEH2+8BbTlTNSqfyfZfaOF/Ol+oGGUej3GxBf2+386/zKyRZLPxebuy2xm6YbF+k/XkztI+V1C/8MFsWiOWs/jFoGPU64YcZiTjJEV4+6xYSMw==
Received: from DM6PR06CA0001.namprd06.prod.outlook.com (2603:10b6:5:120::14)
 by SJ0PR12MB6686.namprd12.prod.outlook.com (2603:10b6:a03:479::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 08:05:58 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::bf) by DM6PR06CA0001.outlook.office365.com
 (2603:10b6:5:120::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22 via Frontend
 Transport; Mon, 25 Jul 2022 08:05:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 08:05:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 25 Jul 2022 08:05:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 25 Jul 2022 01:05:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 25 Jul 2022 01:05:56 -0700
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
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3019909e-1995-4f69-9491-e14355812ca6@drhqmail201.nvidia.com>
Date:   Mon, 25 Jul 2022 01:05:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1872636c-88de-42da-a859-08da6e148182
X-MS-TrafficTypeDiagnostic: SJ0PR12MB6686:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 36tLrCFJD3373vIECBRDHDS0+eLdgeTfLM3OpPSnJksjnwHH90u3q40ajq5cAGRZvfF7R6ETH/1UHJD00cXBFVjlkJBaja+ftcknsfMfuFG0XrlFpflBHfQZL8OXb1lZFokDjcUU8iRjX1QBnxKx3qjB24YkWIXlO16WNRKZsvZtXa+X//i+IqdwiYTK3YKXCyRqEVGCavfB83jl7auR3URU4zrYpnyyWuevKmpHgAXGR8lP6G+bGx0rlXjxMp6aSWOWJ8onSdZvuOiXnR+UaOzTcORCIwwqHnH7pgsd5/3VilOeDWeCnKB9DFv8JlUYoffmOaJOifV5Tm2CzekGQtIYvLBcKQ4t/dLjfBLFRxz6f6iAZSYNjB55oi/VaQXzN3fituIya1XjcjV44erBhoYcm74aiol/SecUzhC/3JIEExyRb+V35JuwUU3fyr7r4wXxmP/K9+42UPUwmp9XcY/emXDeMaeTJgrg8U80mlcb1SRN73qSo3DlXK71D+e+4dvSk4rLOEC05LkrGNEHtcIjoHVjru8MJ6LvgcU47abtCZ46MQc/B1spbAHp9BvKfxX1I24gq9wx2zbzrfX2n7j0TH8FqZeXD2y7aQY4VZlygFaboMSNGHDCdZcbHeFikedU0xY2IDSN8xMmyMHZDpla1Ch4bp8t0MOheuOK2oI0+pxNhh/db5IPq+X7ZOcBZHHSP+zibxSEFcs0b56L7y+hSMZ33YZoT55HU3z0IiI08avE/HHdZtmlSDbnzBHV+ClemNeCdKXAWLOCo007eWx59P4FjCfJ1tEMJ7QdiQTGYfvXrBvMuUEX5lchNDK+Pp3yPWvH0o0qN+jtnOLu35IRf1wBHl8xo1XHWtCXYsrZKUzgb6QNkugKn6T5UDBC6Oe8YyXQsE1W2RGeDMC9EGb29JVSutQ1Sx8liN17kXE=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(40470700004)(36840700001)(47076005)(336012)(26005)(478600001)(966005)(186003)(426003)(4326008)(8936002)(86362001)(31686004)(82310400005)(31696002)(5660300002)(41300700001)(81166007)(82740400003)(356005)(2906002)(70206006)(70586007)(6916009)(7416002)(40480700001)(40460700003)(54906003)(316002)(8676002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 08:05:57.6321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1872636c-88de-42da-a859-08da6e148182
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6686
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jul 2022 11:10:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.57-rc1.gz
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

Linux version:	5.15.57-rc1-g377c0f983cd9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
