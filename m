Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4923C5D03
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhGLNQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:16:44 -0400
Received: from mail-dm3nam07on2051.outbound.protection.outlook.com ([40.107.95.51]:30433
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231365AbhGLNQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 09:16:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aooKPyerLRvhoBXHuXvjt0VWOUzh1klBUYzIW5TaK+0yKY6ENLOoOo2FH2CY1J1qC7G7nWjR1+bTAks0X1OvK3GSKxne2EL95doSN5yUZ1ihZ7lWGvJyg9iFUWWlcMOxlQXFYPEmSY1z31sG5E4DdFucX7jDFr5q18WyktCmAmkXyjnvEmNgSXC3vgs5vOcAPyCTdSsMlph+JlhrA0Pv6KhMQGv4x5/f6ItHh9v3KEsA1gNoQxA9ZGjDaCYpRX5ebwUTLpT4DJGxEPobq4KBBxm/2/uEv7AilTM7APFIArcmsDDh0odoBVo+pT7EBCude1IM03G7C2Xdl4pPSKzelw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mmXsoTqQVt7rzintZrj7n2J4cLaMQ9z3qWOjBlKQTQ=;
 b=lyAEB9VC/L3jFVLDOo1pl6TMs9kCy/gCG9jgMKuEb4mpO0ZAcCcCrAhnAb5b47/QO043X/5zyRIKnZcjGKXJDSxuM8aWtvWElQIPkh8/tiubMT6Fi/TIuPvBrayxPaBUp63B2Noryp0HmBM51YUC+FaglT4SvAC0BGuEHUpFIUKF4OLP49ourAI5blp5rNXfp244+QwJGrpJbYLL7zXvB0viM404rsW/8E4i0IFwwwtyxCRhpm5yMritdPAl+iEKqfmJKKzgTB6GbNcwkCwWUKuTTrgyVGfAGjtinCmfYVEdkwMGd0WtFHoGjATEmKJaFbxFUy4YXLZPcxnsKJdpZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mmXsoTqQVt7rzintZrj7n2J4cLaMQ9z3qWOjBlKQTQ=;
 b=iLWYWKKsku9MaEm7ZqTQ8XfkFDl8DyboriFSmGrMTZuf9L8bsSQYaJNSeZcReHqMnbOLWMUbF7aHBQp7BRgc1vZfpZCn/QTIA8kTklb8uKvKjp2jqzqUOzB6mXuW3gUYWPxMKZmqBMWk4oMgfcffOMoVwz4zMoterFTPHWtIOegeC8hQYThkaTaTM+bNtzeDdB/ru324HFl2x9pYSW4fiwHIXkqUgz9gJ4KOTjpZMUytxPwjwWyJjEGrR//Xyo4bOxW80AHFftNh34NH7075Dk6xIvFTTZTGUTaKZCDqotSr+m76jkwP/H77Su/0Z+phGRVfC8qrqaww9ELgL0C2kA==
Received: from MWHPR22CA0019.namprd22.prod.outlook.com (2603:10b6:300:ef::29)
 by DM6PR12MB3609.namprd12.prod.outlook.com (2603:10b6:5:118::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 13:13:53 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::59) by MWHPR22CA0019.outlook.office365.com
 (2603:10b6:300:ef::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Mon, 12 Jul 2021 13:13:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 13:13:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 13:13:52 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 13:13:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 06:13:52 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <577cacd6313448a58bee76fcc8a148ef@HQMAIL109.nvidia.com>
Date:   Mon, 12 Jul 2021 06:13:52 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 816a3fbe-b6fe-4629-f877-08d94536e5c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3609:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3609DC20F5FCA7D9182D5B27D9159@DM6PR12MB3609.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEEe7aDRRw7H+a47Z1GWD6auN2Sb+7JXqWimLEuChHjaTySGx6HBCtgNb9nEuc+MYmTU0HLS65K5OeBVfq1pxtr/frucHc+7yn+dy8xUBrSzM4gBHlhmEPTTkY57YE05+t+8LN3/ACd6OeVhmWnWGW02Nploq5NNOkJ2oc7KwTOz+8TsMymq8U1gXKNIefMWsobZqtY2ojTdcYluYhA63wbCUYyd7cUUSWMxTWcb0c3DzMo1TrwiiveC0aRQqQ8Y2UkXXV0YlBZu/FUsukaTGAVu9SSPA51TjGDC+Xf0o/+l7mzDD00xd0LfDuD0tOVNgqfEAPtBzua24p8lw9CJHYsOhiSqOSBbZYzmyGwcLq/V3N51p6/J9jptOWiRHlEnlvWa6NbveXVDRO0Xr3CffZLp32nCxf+jTOJvxjpFmMTiO/39wpOwmvSEhm6M4s4QBu1JKQDgvHXYkX4ZuhxKGEn2IIiuZ3MqqSCWIgilGKPGUKFyRE4AK/mstMO2ae4+YImDEPhk35t55hgIYB8nrrAiK2C+E0Fb6DD1l1iHXgswhiflOHfa1Y1QHnmjyan0t77afaG5sQ+ktux7asSKBQcuolBZdqu8IEUgKlPUrElO8B2KSidYOMUcg3oNj7d4J0mjz55lZLxtZASvLA2XFqqeqpbfcgYMwlFjTTm7dKsrOT1clvkO6hxuF7KJES6KZaKM4HYBVNKCs4O73Y1dXRPNohk1WhJD8yiN2VJ7c3BavlmBJGYCytNhELV8T45Wo/kOr433TN+8dJJJKd5nH6wwmWEEqdtDL3Suj0WgB88otYjUtz7/SVaAQ4LPrhBU
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(36840700001)(46966006)(36860700001)(336012)(426003)(966005)(6916009)(478600001)(7636003)(7416002)(47076005)(186003)(34020700004)(8936002)(356005)(82740400003)(82310400003)(24736004)(26005)(86362001)(70206006)(36906005)(54906003)(2906002)(5660300002)(8676002)(316002)(108616005)(70586007)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 13:13:53.3721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 816a3fbe-b6fe-4629-f877-08d94536e5c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3609
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:01:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.17-rc1-g09f2f41ef84e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
