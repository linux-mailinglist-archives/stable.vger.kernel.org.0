Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6EE42E159
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhJNSeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:36 -0400
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:25440
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232277AbhJNSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CteaDrBGV8O0rNymaYRJjiCB8pOqs4/rC6Zfx5zY6P6ulUYpcqbnFVwA6tIi4MirKCkfl1UHY4pyTEWpPZNxrY4tilWK66//qs6jTP6VRA77GAbwRtUTigi7O+RPpzV4jHJtCIEnrcIeukLw1qN2AbONq7N3m/4SUyQ7vpUtMxrbUijiDp+1GcaeGG4kUoCMCZKETesw+BmNr6J7PJ5zdcDkzoS4DCd38bUP76VY9+HGW5eqA8Yo444NzjWYaFM0EKLEcBFvI+rCcOo54Op9D0udZTgBauIp6jvWGJj6F04RhJX7P05UKkk4XmTG9eIzKIj/SlxAbxs32xqss8kgCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPh/n9r3ILTunk6D00F1GOEfrGnkm52yTp0TfXMbdxY=;
 b=R0CwH2S6GuMkFF6mAbZp8B3mitcBQstfuDWI9c09ZS/ohPwvgPYExBKaxdv6uXqr/1cWWBfPckwK56d/sGmIyx4X+/TLJFinWESyaxeyBjvrw18CTD+8S5BLWdZ7zMpfdCQGt0OKPdzXZRZxujmxDXJggyILT25SPiFb6xtEDVh3bIdH84Gn0U1BVp9I+RMfrFEDEe7blys0sZjWxmFE7vkXxX/efUBg1m4Yi+CiGtUagLmy9sT17LwtYUYjc58jKRzaY87dGHCYUXtByMaLlhwfnqYsieQdsp4P/BlhA6HZ1b6EueeyqlmGGhNHPdOihldBR7k/yawLY4itFFoQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPh/n9r3ILTunk6D00F1GOEfrGnkm52yTp0TfXMbdxY=;
 b=c/ea1ZrbNkaj4T0px2eppPaIaXANCqDqBUlLRpzl3JcSkZquzBbSrzU0ryBvbWlCTcrma8PBtKF1Q/T++yubPZLrrm81ePjcdBkBtYKEy6Mi00fKqBwedSk/qD/YiXz/3ZkXGL9UOojD9LKtvuRI8Aua0YN5B932RF8VJgmeS548OXsTz4hdpnsnagRaUlMMC11Zag6UqRSnhGPTJqWDAbgrS4jbMBMXSCrtsjFEFoqt0+3vEwihPzWJDlHbk4ezMWkApmX4WwU6tcEtOQSqCqoiAnh1zN0QiUj82Enq9xvv+z2l/8a9AjQlS+Vo45X79S9Teb3nMYPdt/FvPCYNhA==
Received: from DM3PR14CA0134.namprd14.prod.outlook.com (2603:10b6:0:53::18) by
 DM6PR12MB4746.namprd12.prod.outlook.com (2603:10b6:5:35::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Thu, 14 Oct 2021 18:32:21 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::db) by DM3PR14CA0134.outlook.office365.com
 (2603:10b6:0:53::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 11:32:19 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 11:32:19 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/33] 4.14.251-rc1 review
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d9e73a9c802a4c76bad8c329de0eb9e4@HQMAIL109.nvidia.com>
Date:   Thu, 14 Oct 2021 11:32:19 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 098bd09f-0139-4a4c-61c3-08d98f40f5cd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4746:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4746491CA511BABDF6AB77B6D9B89@DM6PR12MB4746.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7C0Hsa04+OlL2JbaUjVJKEMVjwDMX23NqE9XlEQzoN19THSibgzhMJ6+MELeAc9h+YM8Lf5B3nSW8yfBOacp0bU88QruQ4Ugswa9f8TvomH6kJ3Ay4f6/bEaIi2Tye3DN4/4Y2P7iA7hINpFQL3q8cwMvkMayKvLqgbCVF4BPoNnyct5S99gdzHpxH/nnlHcqD4wg7F2EV2EqOQ1RxBwhRoe/7HY/oFG60k06n1/8RPx0myU4aW4qqrRcWP5oNo/iaC88QNexQ3O9wJhuJ3zXIUMgekIW1pXwYJARlOtxZuzk6IYHgk+W7BbTxZ+RYl17HSnMmTuPAkn6qDY8SaRPhYoYD5vZIe5oDFQ5139z6jtp5EXc7f7cln2tx30GsBAMg9z7yRMVm3OwfMrEtYSlHfXeM7zGRbFAvIJA+OlujiXontQ6PNRQc2ZmgPkiQPe+yu5aw6fTathLoO4ZyFpthtgl7sjf3cb8fHpYB1O/MK1NmNnxJpYTg0VZFlD0BBPFA8jfpepeZq3GAIA+8X9XLtsLeBQG7nMoxopSeJtYfhjvqG6HFeK+ArbgUwu2dyaFAHysYZO1YUvf+NKVy2/ohVRafMLNTRQjioXQ0uI+kOm4XGElbhc0EGvYEWamukm/Su0ELSymOCHmlVvwRQiC8vPDuCEFG2KeGh/xF/Wox/Yn+sUqf8MM8lsRsu+Qe43Ic6DYOAFKtrsgjjmZsT+qLK8FcqgdSJRvyuI3xVLO9d5ecfp7TWJVNGuMRyK9ev0EDyninXNxw8jZprdRaLDm+/kDr+CV57m6ZBmDNtEYAE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(24736004)(336012)(5660300002)(108616005)(54906003)(508600001)(4326008)(966005)(7416002)(70586007)(186003)(70206006)(26005)(8936002)(86362001)(36860700001)(6916009)(356005)(47076005)(8676002)(316002)(2906002)(82310400003)(426003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:21.3133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 098bd09f-0139-4a4c-61c3-08d98f40f5cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4746
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:53:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.251-rc1.gz
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

Linux version:	4.14.251-rc1-gdc0579022db4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
