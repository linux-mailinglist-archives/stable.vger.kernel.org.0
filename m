Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CBE426DDA
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbhJHPp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:58 -0400
Received: from mail-bn7nam10on2063.outbound.protection.outlook.com ([40.107.92.63]:45437
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243200AbhJHPpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bixksyeul8LwbZCOLwNKTf37tI6hX/26FE0f2GI0L9DHOuHw8QpIyBjnue2NPXToeH7DytA5zMGOtyKiU81FUNju2PPT2kxIyOWynCTHlFPO6xvYb2TutCP87ABfOtR8eSFLS+bmorvFf1s3lGR8X+guwXtGpp0Zq0lzxiR0uQEa94ZSg7pOcWBE/U4mniC2QifMbfJrXIV1c9SuJqI9Xt0+8qfG5Zhrzlyv4FEOrf1SOi3E1Vu2rfWbm/PgzqTFCZS9l2plDv/nzcOFDUfzFL2i5dF7XZQyUtm41ku3darHYzz+K+Z1aT6R7crJ5giHuS5TEJ/sGYmErELxQ5ukZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+nVDfQ2qo0pRnSTgf+IYf5nKXipJnjvPQnYHsTUck4=;
 b=F2kXYn/fRkZO63iT2tcuVOTYZK68/O3oRDoK5FTE6YoeYFqkMCjGU0jtQiic/4nox+hGtWHouRM8eWNC5m6u0xqXEfnM+9MjkqgV5bHDmkO+IX83c4REwK1s/FgtJFo/SFA7TxNUEVDmNRX5Q51soCaSAhXmOGEndwRAN2+8YjcOVyF+6rAcvyla04UA4BKhNpvMkFOrRO7HWuCEAm4d3/nQjEIo/+ZJNc/dfAwZez0dtZ6mDzF88K0HLO4BtkmEeN0q/rySY5mNifFP5sOehwUpDgDxLqI7Xrv5rrxwcqI7AQjzxRtXhPBJ9LWrW6jf9dFaOakq8vsZN1YWVKRqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+nVDfQ2qo0pRnSTgf+IYf5nKXipJnjvPQnYHsTUck4=;
 b=IBWj2jGKvWwEDBBzUvD2TJMeBTLvrbSRql5FtbxXCJsqNjCsD/ZIxP4ulsHRYAu4dO36ZbQzu6mhrw2J/zfgPtPBJ+RQEY0ldyf3gD9+aYWjaa3vYqzDtVMzmOcUO63bKuEIY5Y8aufwVITWH0NvBtiru6yUU+risdrF4AYPqu44eC5BbJTfJNGH8sDHzhsWflGNXOLIOUqG0/fvSy+BqIjXFm/OXqdqcI4KbEEfKDZ07SrozcJ2lOrGh2vFfhrS6Qkvf6jZI9rRgT/9tb6g+OLtBzBNYauJMSFlvCoVjiySZoSvQd5/W2g5eZrR392z/YBq1O+HH30BXKZFxuCXrQ==
Received: from DM5PR21CA0016.namprd21.prod.outlook.com (2603:10b6:3:ac::26) by
 CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Fri, 8 Oct 2021 15:43:37 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::21) by DM5PR21CA0016.outlook.office365.com
 (2603:10b6:3:ac::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.2 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/12] 4.19.210-rc1 review
In-Reply-To: <20211008112714.601107695@linuxfoundation.org>
References: <20211008112714.601107695@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <25007e6070224875a0d6f6aea339a593@HQMAIL105.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150f1158-0e40-41db-0bbf-08d98a7264cb
X-MS-TrafficTypeDiagnostic: CH0PR12MB5313:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5313B2C0F5E795C697C4FCECD9B29@CH0PR12MB5313.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnZBEb45ihHBIHTp9opQTWOhDPROaXeUb8HWTJ32vm1YPVSTfLxILneM04pjy1+Na94iwghrU04EU/fCvvRVqTyPOqfnuC8qAjrROHRon7v5F1QDrd6GGbwiAwg5zzolhqOfPRm+LBZgJS5UmLQvgSuY23Zr6p7b0Zs97+9xQcVLN5TJUi9FN156GytrBVXG18yj9OyfBk7dKz4wAGXujEo7GTpYnmSs9MG+s/C7wYFGz4LVf9tEl23Il7E87q/gSfhp2Py7arfU99OAngZ/NQxkO+uAnNbekNUKbtb+3IlsAOBgKD7AyZaBGvaQLpcOA30/0r5PlFmoNgz9CwU5lqkhIXfGuJK18iB4dDJT5MVPvrqq3wF5ur1JlIHXAR0HE6A91GgdnhEJX+vW2e7tj/X2F99dTkdYZ+MPU8KItgfoVASCSZbqU5aF87Wg5us/qxH6rae9KwsfSBbIr/mcB2VegcAj5P+5Hmc2dj/kXzAG3zL1Zu0uhLoUJSWK+uQHl1Yirdt0TRW7QdU1tt2FapbhVtK20uOak6RUaFZWPKs5iyMqbRCCpebuP+RxkcvbCUauG2Pb22+Ab3ymrM7bXvTIO0H4mIOola76OXNrLulLU99nBsDSU+gQ0gw3IK8RxFbbU7P3mZkW5qdnAfSLPLcpN69+IKaPhK8sSHxMtu0tLq7+eFICoCXFMIsPgDk7NjYaKV+JIiPnGvDSF0WO+BHxzwhm5qrgGaQ7KYFQqPV5HD69hyaFVd7X0AAB7kanHRLCeyQz1VMALPWRQ/PtBILGlv0fS1vBM9FMSCgXscs=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(86362001)(5660300002)(36860700001)(47076005)(7416002)(316002)(7636003)(2906002)(336012)(82310400003)(356005)(70586007)(70206006)(8676002)(8936002)(54906003)(4326008)(966005)(108616005)(186003)(508600001)(26005)(6916009)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:37.0539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 150f1158-0e40-41db-0bbf-08d98a7264cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.210 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.210-rc1.gz
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

Linux version:	4.19.210-rc1-g0cf6c1babdb5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
