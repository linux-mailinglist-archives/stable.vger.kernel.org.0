Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE734C8785
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiCAJOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiCAJOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:14:47 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE8F5642C;
        Tue,  1 Mar 2022 01:14:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+136xrmtZP6XuPvgbRMmWhy18JSsP5WR7bxNJF2h2kmNBc2cJpkaf78VpnWEnPLoVkgB/6uHPLENgmhlws6rMjQtrvQ0ERPFNlET9XzlV9OAP4+yCnhr05Uih4MpDjuOO0Zty8jHrEInJID805UJ9lW1lg9yZfPthViTEBsCTRvjYR0onWpyie8VYUVRhga//myIbFq8oZTn26cjDNO9pV15LOSdMQl3mufrk4ARhnGcu3vNbw68eB5yi3qYV0zGCELWhEdwIe8bg8KFjc8AjSB8Fejze3Q0k810vUEFK5hnUbLaooz1//dgDd7JPZDJLz8tWCwx5MT72wqrZF33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqzIJa7LjVTRwBzBEmETSs9VzDdRgrJWJPa2N0hgh90=;
 b=Z+QeJli70rePbUfq5X8yq8kj9WdTFtW1+QV6YTypmIeAeKCGo9PZKzm2ppisgddcxKgCcnran7NIWUlrsETEYjhhgh8L53HjEAfqmaEj64fOPcbAN0R+uOJ5uSAhfAAEXSHEwmRoK1WBXyNRu+Mb1/U+WlE3s5z5Qon0sbkYEtVMSFx3/c/Z0IXXg2KsIZry1ZqnpAdK5zKGsgTdM1Wheo5fDNSHcReuTfJCCCWq6jrgAmOh7mGoTameWFSaMt+/wpw0bR2eg2MYcrHzFfHzvFoAoUYGrwdgqg4Xcsf0/YjzUTUU2X44sxiPhgGv6UF24w/KzJl+Dwv4vxW+/84mBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqzIJa7LjVTRwBzBEmETSs9VzDdRgrJWJPa2N0hgh90=;
 b=FLudjdr76OkSqOoPqigf7OIs4cbEyPEBqAVosaFYdGHcZIaIEmk+7j4pMg9/i6hZpvGE6ir0zCJra7oIjTiV/x0hnfwQ2lh0LT7KImUf1dKKHRLTHDzvLkq+z8q2aJtV4BrNOUYAqg1ySW5/P2mAtxR5AVSFLIZK/JUzj9Zbagm5Cl5z4r5BM45EpvTFFg0XGRu55chjuLXxUsE04rsD1z+lgtaqLWHu1nG6jbEXrCZPSHpL06LTJh6IuYdFwzk0CW8NJhGA0zDKEe1aU7NBtBbhaNQCuZhXpmpNULRZDONhHMu1IM8vq4o1dKDw1khzpWi0UpmNTClL4zgQYhzF/w==
Received: from BN9PR03CA0935.namprd03.prod.outlook.com (2603:10b6:408:108::10)
 by DM5PR12MB2374.namprd12.prod.outlook.com (2603:10b6:4:b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 1 Mar
 2022 09:14:00 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::c9) by BN9PR03CA0935.outlook.office365.com
 (2603:10b6:408:108::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 09:14:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 09:14:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 09:13:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 01:13:42 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 1 Mar 2022 01:13:42 -0800
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
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <07992a53-34b5-482d-8027-b52c71f5ca51@rnnvmail202.nvidia.com>
Date:   Tue, 1 Mar 2022 01:13:42 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a47b0e2-e7cf-48cc-32cf-08d9fb63d2ca
X-MS-TrafficTypeDiagnostic: DM5PR12MB2374:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2374AC958EA3985345BF41C0D9029@DM5PR12MB2374.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8W62vXh8aF5woXTxLzmXIkfYNajMg6jpc0QPOpJjVf7A3EyPwiai+0EDJgNpXKULYAw4+1dNziwWbnarHte2BQyuVqy1tBbHOxLqj/WaKWvAmRZZu68tY9VF5lQ3QtPDZ93fxUVmHhjeSh5Vb0LFpvWRHPgqgAitFVZYANzaCXtVEYHKegoJS7J9degvBQeHbQs2sHxutmfzrQ3A9t7Rk+7XXxIkXK0mvxOILAa0KNu4LBRDaJ5FwIZoVFPLVhLiy2DrWyFtiTAT4swCeJNQGrw7d/JhvmkkWNu2ORsAXkWdYG4cxC0M1I66nIVmnDWk+J+3VRWX1mOoPaGsV+ueIvAS2sCWWkBtpEOTq6+9KCxOFLr0cJHOTQPlcSMJbBhlHmbbVXm6UCF7Awz5FxWP0xDNWL3hlwTKuksfs+tLBcq+SKEFZqDo8xP0bbrtcxduYB98pucadOExhW7+3lLloKhXJovFk83Cw7YBhndRL8pdfjKogrIQ9zj07tye3trgKfSP7ENeyY0rZlo0qIbtpkg6jAkZdIrueYTKn0tzYBIG7s2Vrb9QD9s+yrNKuXxZM/V0jPKh1evdoo8kzGd86Dw+o+9Wqjnn9ICgAKQHOjP87Ck++zcO7vM7y/jNB0/1l4eZISx0GvuO7cQh009kpIuhCcjh52ujKD8Canr7tYFOzby+g4kSFYdNMmmqN+gUkWOsi1vZJmIf2PaExe1nHHjvBi1bUneM62DhVeRvvnP287747rRkx8VmVLHHA5vMsAtR1nHUHOMl6n7fr2glaaT0UBneuGy9ohaVbbbbFJw=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(31686004)(6916009)(336012)(316002)(426003)(31696002)(81166007)(356005)(54906003)(36860700001)(47076005)(966005)(508600001)(70586007)(82310400004)(86362001)(2906002)(7416002)(40460700003)(8936002)(8676002)(186003)(4326008)(70206006)(5660300002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 09:14:00.4717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a47b0e2-e7cf-48cc-32cf-08d9fb63d2ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2374
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 18:24:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.232-rc1.gz
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

Linux version:	4.19.232-rc1-g277110482a84
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
