Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8BF3D724B
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhG0Joh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:44:37 -0400
Received: from mail-bn8nam08on2072.outbound.protection.outlook.com ([40.107.100.72]:18944
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235993AbhG0Joh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:44:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDiMAGKzdRgRl9DU9kci1Xm25OZ+JhwN/3H7X84iFBcGA9zGBLzweXuKbpG7OgcdiCdc49++dxmv42Suf6ddtsH6eThtC1HYUHtRWbRTJiCglUJW8c7G54TSYzqGqYEs6/+oQGEDoynlep9wlvB5N15AUGR6JcJHK1tTp9KJn1FBR9yzZEM/1uet1aVUs+nqrki2jCbf02B2ZZTwVic7kw6oxgw/jvaJZ79iGqZiSA1ny22JmoZmB18ftqE3IcbzAV/p1cJiIARSTIVOdaipbo5hI2n8wOOS+2osBP6KDZgHvVNo69KmeDsMIaYpeg6oGSfE8kKjwOIwTU0ULab1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2s9UmuyBZa4cjPWnbzAa7NKdDO4j8+/Ho7cjRGRncvQ=;
 b=E85oplQHTRlk9XyfjmkbpFLAKg2qo+MwwCAA5uqMozE2p3QP+5EjGX8Qskip3JkxJlZKKfNPgW9NWH71FsrNYrr8Hv4d4blr3QrWWIZmMh5YjyDs4L+HD4KhYRdg39ETaYnhGXRsgnxciKE5O+aRQuqDv7XIYtvEhWarSqGKXRpdZoOrFSdJLaoR5tBiHP1raT0rmF206ewQJI3DRXiU3zQhd0pApg+mBVM6cGyPy1LYxzpNXJCajoU3I6YNX8Ls3ZbaFLdyQH+9UawpHy8L081zz6k1Lzc8MkSmOUVpxgQOkPjlTg49pl+JZQHrGWyIoLTnLrcjD4GPJA4LKJ+XbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2s9UmuyBZa4cjPWnbzAa7NKdDO4j8+/Ho7cjRGRncvQ=;
 b=SF0+qiDuRhy2xhUN6pDEUyHEGesJGSK3fORQFndvQiKyC5XlXDjFtU2e3Xlo7QC31Kw9NR9x8k1ngLry8ZK/QU4iBu0qS0XarKoVH6rN7/8q0aiARthl+zYq/PbQTBdbcYaZN+IyKZXGWuhdgU6CpxV5RkMM4kS5++qSQbPKKyfy8zK3+jYKbXQg0ZtJLR47DJIFiVFlt3ZcBEGcJjwMrLMuYYV3NWzV2Cy7JIE28ool0Qh4IU4NULPtHty5B7zRGbZOWirQPs1CK4UE2bjN7qcbk0Z6JABRRs7aGn6o7s+rWeHf4EQjljhKRmJNMiVnQVeaLo9UwnlfObGndxqn1w==
Received: from BN8PR07CA0010.namprd07.prod.outlook.com (2603:10b6:408:ac::23)
 by DM6PR12MB3817.namprd12.prod.outlook.com (2603:10b6:5:1c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 09:44:36 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::6d) by BN8PR07CA0010.outlook.office365.com
 (2603:10b6:408:ac::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Tue, 27 Jul 2021 09:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:44:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:44:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:44:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/224] 5.13.6-rc2 review
In-Reply-To: <20210726165238.919699741@linuxfoundation.org>
References: <20210726165238.919699741@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9b290288e0f14237b0da17ddab03cde3@HQMAIL105.nvidia.com>
Date:   Tue, 27 Jul 2021 09:44:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61fae9e6-071b-4545-a5ef-08d950e3250a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3817:
X-Microsoft-Antispam-PRVS: <DM6PR12MB38174CCC5995660F84BE8262D9E99@DM6PR12MB3817.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdXhOyqcSIn3RKeRfozQOizEOxqHi6GL70yqgKE4bU38V5kkQ7gcn87MKi6QUMNu/qBQ45pTjXMV2Rynxg1uj7l+PnXd0QmzUETh2SJ/1G8RjfAAsLAK2IUw5eafopOsfhn0wQsFOu7BrDJfVKnPLsqAJAPzTMoshsNnzpWZcA0x23eEhavJtZSLE4V8zGkpdCwOdK77Um0fJg2KaQBj42+EecYkJeQN9iu2gLraR/fMnkrqZaAVD/7B8uZ7aPY8a06UqQ5B7G5pyhUlhweOANmR4i6iP0Xm24vumgJfVcwogde79DgRYt1qh6ANh0LxURxjXTLJFsxvl+BHuSF9o7gTCFS+r9AzLq58ISY/Gxnodwt2MPrzqEjEJop782+MvXMyyXTO8bAiBvXde8DI1iRmBAzb22bGJC6SNFvdzVjkkdhTzdd6oh8kqyPpPrvYbtYoLBOuQt1+ken58tvVRJU/to90Ht28ZZZCQSzrZcKTpXA6HmCnU8S8lqNDdfkV8Rt9lrkf45RNwSf18Joe5duOcppI2DbdJ8yzoVniH+wtQx3Bbfpaboe1SDuIbCBWcBNfC87Upxzid4KKB5x1BTBecSeDyKWfHtWmfNsSoJA5AyjP7uqkr/mQgOytLxe+wCVGieOJULhn+lfAhqhNmE7A1N6pmhlQAE+E9fb82Zfe9DrkMY+J3LtlwIjIFUrZynBblQ51DYtJJ0lss0YPo3koYkmKirFIECxOzAnFq+NaafmPy+hkQrbarKCgtKaG33P9mdJptw/uRuy9E3TSuyJJm9Mmnj0hq6GT8U639+U=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(7636003)(47076005)(4326008)(36860700001)(82310400003)(70586007)(7416002)(478600001)(6916009)(426003)(356005)(70206006)(82740400003)(2906002)(54906003)(966005)(86362001)(24736004)(5660300002)(8676002)(336012)(36906005)(316002)(108616005)(186003)(26005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:44:35.7289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fae9e6-071b-4545-a5ef-08d950e3250a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3817
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 07:06:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.6-rc2-g692072e7b7fa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
