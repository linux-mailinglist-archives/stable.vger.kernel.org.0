Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FDC34E483
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhC3JfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:35:13 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:45460
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231698AbhC3JfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:35:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf1e2Kr6X6hUBmmeawWhVrLzssLhUVKozuogsoua6btAYfMcpQQPT71S9n82Id9iXQmz+47WBUtI7virnkOwGdQWA1JnQ4XvlAe/eIsEDV51DEWAAn2I65M1ozMm/yUFUdVLFrlJjVhAClT3XjHUtWaHnV3XhUofqmMPjlAExMQjC+u8BmsyWakQndJ+RvJgSe8cteII9gDeLDXHwupYu1cGMy34ecmEo5ve8Irj1fI5gTcV6vtgp82GhcBKCsSX1qAQfSuBk0d5v/7O38XG7J6LE+0R3fKbh/foXqOV4/BhmZ/S7SY1VzJwEwLDxygrvBn6rEXWRncnDYTFHPYTBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEOdy+25ro5dzSeUbJez3fnqzl+eJ2cJevwYqZcEYbk=;
 b=CyvgUXvGevlzLLooOfqWEL/1r7oR8BTam2Npb3vY5G8g+n6SZ5Ix1scrbOae1XBAbXjEveUaLaPnTEAyZ6pt+l5gD1xYWoueJ6EqWNzhblH9jIw9qRtlBs9NAUnO0VPeKJ0H6Tzn0Ds+YH0TFrM/Cdvx46v5gUD1kZpCtVQ+eP99nJLh0RgrLvKmaiSzO+IxeZZHQOFNSB/3QyIfiI+B42HrPJtvhFVhH2FqoaDBf5R6PbjfsvbaCF6UZHS4sxp6JaVjs6d8h5FZjQfpWZn09Xan8ZhRPBT1Yh/oABJ+5pv7nCF7GItko8wDF6dPehrcpGGog4w8S3qdKMRCkqP/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEOdy+25ro5dzSeUbJez3fnqzl+eJ2cJevwYqZcEYbk=;
 b=mJwYSuMjhSK9bZOqYR6f+MaGij7WVmaN4fU7K+x5lsrmYYfD/xN1Da0/SYCWNxN5iIas5U5wfvAKMOk9p66gzIjdtxBjWZ8+sL2qXUM+cw5YyNJUsN5M1y8cdQfktgxS07HQq5YBGP4OdySrNRm23Ld1dXKDhKt8s4Q5ZkSBWMfx6onuHGAPMlaePG3lRUbkJBohFG9tbo8lOO5dpyiT+6V88kfyroPTPTH73rABsKWkybugoJOukN+36OnfA72AbJO1lU90lB2YeNtGvdZfVXwkdqw3AuM4biuw9K7PQ0HAH79c+zWSu4eQI3m1wDtNzkGVFu6S0r1E1Ai/9PDoQw==
Received: from BN6PR2001CA0002.namprd20.prod.outlook.com
 (2603:10b6:404:b4::12) by MWHPR1201MB0031.namprd12.prod.outlook.com
 (2603:10b6:301:57::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 09:35:04 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::9c) by BN6PR2001CA0002.outlook.office365.com
 (2603:10b6:404:b4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:35:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:03 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:02 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/72] 4.19.184-rc1 review
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e0d9aa5fbac14c9d914f3ec0c3fbb059@HQMAIL111.nvidia.com>
Date:   Tue, 30 Mar 2021 09:35:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bccefc1-d029-4df9-afd4-08d8f35f1900
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0031:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0031C28BD22158C84294D2C0D97D9@MWHPR1201MB0031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5mKR9dYXZFR1xxVuSgy+sAzUxwR2w6D4cu8jccLZLm4r0XQeW15l67GcutmnU9CSYGcuog3ZaK42Y1gWRdh1yAyxMLzurIbmVz5tBGYvFtgRIg8PPpPlm5qC6CkzRQGg8JXifAKIukKP+jGYtMFVwstEG/BoRFU9yggC7i+1NSbF0+dNWcgIz/qD8cXBOn7n2vTZohZgBoJf0MGgoCDNbIz85GbsRP/FUZjlQ0Oe1i0/y4ysKywhu9XU2Ya0fkcpnBOfzoKSA8ivUrlGNeKLSDJj6tfGYv/EA3RQ4bdWMf/UvhOT467K1LXptuOVWDM5ClWKnq3KPXoYPSIDQq/voBjBUwBh2fWhJF/ExRzUKtdTjAIrlECaSuwZqHTYtyX+CquZ2AfqTR7qIRKEjCcHBmGtqo9JWielyJFFQf1y42MYy444PVk714CkSG4AQmBUBQTUxi+ji2dU/RxtQZ6wRMKKtJi8exV5nlKu6Wcih3ut5/oaUTbzSdsftfUVjRf1QDmAR0kuH2pwcvX99jvxRtVI9hLWV+tqcChBYA4GKWfzJVRx3rcERZVZe+wNcSjm4s5Xl15o37kk2eJ4ny2YMpogr88LQzRPaIvNKyaccexdhHHaYtyPWQhtohXex+wuPuRnzmrreA+azoXVCeNISrgiEbhBo9kMqoTGpsexP/SbuVgJMxJ9L4R+spZPs1q66gC4tpVPQL1MIzY7dnK7elnCWtevlmBCw4G2eV0JWA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(426003)(36860700001)(966005)(8676002)(47076005)(70206006)(6916009)(7636003)(316002)(336012)(82310400003)(7416002)(478600001)(2906002)(54906003)(26005)(8936002)(356005)(82740400003)(186003)(5660300002)(86362001)(24736004)(4326008)(70586007)(108616005)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:35:03.8184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bccefc1-d029-4df9-afd4-08d8f35f1900
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0031
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:57:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.184 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.184-rc1-gbbd08292bae4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
