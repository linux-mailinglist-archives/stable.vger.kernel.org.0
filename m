Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6BE402C33
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbhIGPzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 11:55:18 -0400
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:20832
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232935AbhIGPzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 11:55:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCdgQjdP8p3SPrb8qqRG4nk1QTAbQfzrT65ySRxlIcO8zsY0AVkx3nC0VuLSXCnF8hQcI/0EI8qB2gj5Yu7JgI0qVVrZsvFC6cC5YgArVg2OZ+juSQWxi9T1cdiAENG/6ySstUFHEi17q1RzvQaFpesFDdMtrTgE/34dgJF4qIR3MnLYLJu47BQxaufzHq33h1c+eDtN1FidYhGnvV0DvolhYmfKWHRYT+bCbGoFeEYtnph65NlsycC+JmDcxlLABIzkmY66sDyo1KecvYgXiJKxXQ6JdAN9LD57lUYRhM5ykYWPpyuMQsirloF+/llo/pCRj+ZK8XG5f7vOCwnu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KBAhqjR9wkPvPlG6UwLwHEmTfcE2ipn5rYpmk0L0IoU=;
 b=j40RhvSATno8i8gzujZKNdECg5DNDJrue5/sB0LCiYyuY3BVfnUErBzbHJ4WWr+e3DHeooBEWbs6S/g548OknNNIGUo9YTz8xYOwzbptnUOOjfDERmsCIhKh19IV9dXJ+3Er5+7/6mUqIC1YQwxbxj064nfEup03VjNhIgxKUIvNRyiNo4P0ZgeowMFQH4jAajDb8gd3d6FErQ5ep3DvCXNf8cmXVNCS/nfTRn0Tk6HfCcEFuWU7YqWus352YqbnmAJ/TAK1ErXBkhfE/zbxvJAt5K7sJDxQQs3d952vbnXXSj7b8LPK8AZQSSDRF/8Zov5bC0pEgQvVAH/UZ9cZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBAhqjR9wkPvPlG6UwLwHEmTfcE2ipn5rYpmk0L0IoU=;
 b=CwiF7E6PBeM6mONx19B9BNdHFdTcjdCXwUkalrOQjAIAjFPiwOTQ2WTfTHpxSm2SQrFvaoz6BRTPyxkZ/aJ3Kd6R9PA+TH4dEe6hrQ1uAn9rvSmQaY6jrk6Vypa53IlXirXChvoB1e2iwnz3ic2FwWO0vOCD0UuORaJ79O6qIGl7jhjElw69McAH+nVawf7MDFcVVapkM5A5U0qefqx4+zNPdeDqhDzcfBpsNUrl00UF2nsN5VhNPSLrGBWfwbSzq+Cwd1F/XM0SbUyZby8KcfAsO+6UIYFnXYxbt/TX/r9lrpxIinZaoTqZaW0y1/SpcTvzUYAuoYNjekoGr2JYiw==
Received: from DM6PR05CA0061.namprd05.prod.outlook.com (2603:10b6:5:335::30)
 by DM5PR1201MB0121.namprd12.prod.outlook.com (2603:10b6:4:56::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 15:54:06 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::dd) by DM6PR05CA0061.outlook.office365.com
 (2603:10b6:5:335::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.7 via Frontend
 Transport; Tue, 7 Sep 2021 15:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 15:54:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Sep
 2021 15:54:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Sep 2021 08:54:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <625f0b5354c4485abcddd0e99a083c78@HQMAIL109.nvidia.com>
Date:   Tue, 7 Sep 2021 08:54:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fddec7e8-0118-4786-7bbc-08d97217b8dd
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0121:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0121C62A3DBD3BAFCB034D3FD9D39@DM5PR1201MB0121.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ex44pd+X9dcdqC4IRHoTHkWOstDvpkmD1Sa5qKfQzKnfEmDEeAWiqCMTUYICerUFkLdIIw3ndvJkBWA5HrpQTMhN3uptPno6Y4sIoFxL0FlN5eEL5kcl/YOLRw+lgzzXiAR0FBeA3oqhRAw8O2iceG/w2zr/PbxFXd/PaSb4AVzjDJ9SYp5A/ALkctHCCR7tC60QUAMp62USp7YsT9g2jNA+imClr9z4fXDDWJc2BAfh0Sz/B+QS9PCNDiYPp2APd1VCI3qNtK5rmLG0Zy/tWbmaRLvTrUtWPaE4D8f18BMuqiK+zZTx5lKXEikNd3QmJY04VkhntR5xDluPl2/O6m2wIex7xpGv7ZGIEHkS0uZNJ7HrsN/S2js8xrxGfwXNb+tn/tIZZWdu2MTclKsHxIh9ER1BfQWt95VA4TvRnCcWevudHGxbI3QcKVJMFR9iDtQ5LULcRL/ij+a/YCCzSI0f2bWN0c7U4Ks9mYpcoU2gvhdPKbrUrrHRJzu/xfPgThIcdoulN5wqQFtbGuHILXkoQrwSxip5Opmcl8JuaNA1wOSxlvtCMP/mdHdBk2uVZkVuC9xTtdroo/1IiPuuSVBeL48u7OdzvyD3NMJ9IEbAavmLQBOIIvb6ujkSfhYm6Br+8E/xQ8w3twjG7O1HOxaIzSBqce7Wue6c++pAkdDM9TK76BJMYZYLxIUqBwY4zT3htl9QE/N9O7Vi7+pcwH46hvaLJ2yzxKSZAwBXI8LGtboMmZUKx3f/t3QArKMPy3TScmPlBfc83KKYTs+8cur9dNwflqy0MyBjtmpZjBE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(7636003)(2906002)(82310400003)(86362001)(7416002)(5660300002)(316002)(356005)(70206006)(36906005)(54906003)(70586007)(8676002)(8936002)(47076005)(478600001)(26005)(6916009)(966005)(82740400003)(36860700001)(4326008)(186003)(336012)(108616005)(24736004)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 15:54:05.9783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fddec7e8-0118-4786-7bbc-08d97217b8dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Sep 2021 14:55:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.2-rc1-gafbaa4bb4e04
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
