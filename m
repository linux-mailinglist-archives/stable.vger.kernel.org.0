Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319FB4B532A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiBNOWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiBNOWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1501A18D;
        Mon, 14 Feb 2022 06:22:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvJqUKkT0i4W0di3OXiRmg5cyPHfnDp/+i3L38UUmz7f35ktnbsje+hTuQYPWhZnqs11/nk0CC0UT9Ekq/uCO1agUIiS4XSb7hY/OK09f3u2JjepmaBvcZHYVh/K9aNdfX9Nq3SeKbjbLfRG7A8xjbT9aOoRiIY9ztSBfjJNna7UrlQCroQXM4diu0y9fONeKFyRoJV4rA7RjsitbLPsjIyKSD05vWlAsqq1Cr4Tu6IsrYQk/1JDd9V0zxeTXjhfygJB05ANB1VfBC70kn3pBOqK1jNWUbGRaNylOsFGRIlJqsLxzJhbLd6hUhc/SB90JzDpiOrFT0C5P3SUQgJZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Try630XBFS912KyZZqLcEkXUpLr/F97A82ce1kqW6ZQ=;
 b=MPK/v3TlNUn3L51phe9o7Vijq7KuujUndd5sgDQlHcPxmzJdihK1ht3YrkDbNZjpZ31sFbewiYhpF+fpD707TuSgHrYT2YEbEA9PYT/l0mLh/bmcI0rKX4Ht5/IyW9hGLBh3iic9yi2uqO3MbfCs/w7hOsZVwFv2WaapOdtg65hiXnNWe5fBTG8YSsNXuh3EGbrGqwSzy93auDkiBi54On2p8JKRGZmM3qnZ9/O8ZENuy6MdkxuX3NHyfPc1il4hcDtY4UK53D/2jujNc3+0EVEuF/LP63nimvPA7+6xZp+DN0SO7GFdmjMzEI1nXHpij1qdiGICmNjcwEy+erDRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Try630XBFS912KyZZqLcEkXUpLr/F97A82ce1kqW6ZQ=;
 b=AfudheoGBJC+mFTOozFEjlyGVei+JjAjSgaAtw5GCpdrOFc015KBFxzf0mgfMrnRCqyBEpTocYl2vAKDTb17mR8y/1ZHqdUlv0XEEEyDjuwjcRMweo2LGlLmLCjsbjicK8R3zlgUxJf328Q67kmM8RZcnYoro55E3n8Z04lDONjuJiWDwPsSg2fX/S32VGXPRRFY4n7FfiIAXQY/Q6AdE3BPIaM+Obh0wFAWt3nLHYFRBg40p/4M/r2g5OnL1Waj0oew7g31X2tlAbvnIMr/BzutSd2xAKIfFpG3NVcUvMOOxByJhBiB7XCKkC9ovuKkFkJ7m7ic8gKEahtsclfcgw==
Received: from DM5PR04CA0065.namprd04.prod.outlook.com (2603:10b6:3:ef::27) by
 DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Mon, 14 Feb 2022 14:22:26 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::66) by DM5PR04CA0065.outlook.office365.com
 (2603:10b6:3:ef::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Mon, 14 Feb 2022 14:22:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:22:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:22:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:22:25 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:22:25 -0800
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
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8de4a37e-a55b-48f2-80ab-611a7529d4e8@rnnvmail201.nvidia.com>
Date:   Mon, 14 Feb 2022 06:22:25 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f8b4da4-f05f-4229-f323-08d9efc56d18
X-MS-TrafficTypeDiagnostic: DM6PR12MB4434:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4434D4C70E63691680437C64D9339@DM6PR12MB4434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pCCY3f01UnqcTQPo46SvBRh5x9y717z5XM9hQUW6geB+M5/gFwuBUlN5FxX4OAuSrQrb1n0VwV+9IaAoDuMc5K9/9bRBuNHcsT6fzcRIWnuhR1Oo21RifF5M75w2Qw0AfnC/8blRHis4C182n4NLOdDHQ+60EQsdw7qNP/eceUarvtHmWXhoRjQwif5FHSMTl8plCVe8RcPtl+9/Ylk9nqKiq3npSIJW5F/QAmzCX/lP2HQxmE37QZpVR9A1og9ss5ymcfoEKeO3mCiU4cuA+Uxv8Ab6mExSYfnudB9Mr3o3ev48ncxdioGHBweiJMJ+bWRDYEJrnS8WZjoZ4hk+L1lxZDzHxSaHGepARq+Q7DS3JgPDDPiE0mZrkJP2uTLaWEyR5jyj52tGaf2DK1tNrZUyKRwwMP1dKQZPg2ys2L40qN+TJWYsP4jHvZY+f/LrLRxFcPZSXs6vT9nWN18EXb3r40IvhRHYThO73aKWKjAdF+vC/1HqU621TpuCS5jdJ7V5iVqwhfzsIb8dI6yDaPlJl68qe3I7ZOEGO35+D9rODaIJ55JdkxU+z5l00h/mUIzhlJS1ZKxVik/M18ap4BeOxtPirgeRpki0CfZP3eq/WbzVOiC0cYz4mEuzfJkJGH1PI23Jw2r9whX6vvZGFS4+VSPPjDU+H/9IJ49sHdcWHYEZd5HBBTZdswhc11nyJdoFZQ0ZAlcCP2CEFX7rrUMVz+Pe2L1QL9SpYeW9sQQQa85nhgf91KJwups30o9slfClFUxTPGHTqjk/STc1GC3iHTXkrbmHWYSia2QHaI=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7416002)(54906003)(6916009)(356005)(81166007)(5660300002)(8936002)(40460700003)(316002)(26005)(186003)(82310400004)(2906002)(508600001)(966005)(86362001)(47076005)(31686004)(70206006)(36860700001)(4326008)(31696002)(8676002)(426003)(336012)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:22:26.6489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8b4da4-f05f-4229-f323-08d9efc56d18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:24:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.24-rc1.gz
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

Linux version:	5.15.24-rc1-g2092ea833107
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
