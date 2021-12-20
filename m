Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E1747B2C9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbhLTSZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:15 -0500
Received: from mail-dm6nam08on2057.outbound.protection.outlook.com ([40.107.102.57]:21216
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240419AbhLTSZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fh06NsVPPF9JM5PCEnYVK2A/uxEeRgU7wyh8c7kU1Dzwu7xwIkXohMtG1ACnbnnRm0SSk066F79U086LpUV10JZD9dC8Jy6lx6FeRxm/iacEcS1Qj1OoqvWaWYBqDEfMmlJxWc7aEz0/hD+2XPs0E7ENT+dlcxEsAMmfoeMd1FCZhR2SYbCvh8bIv89rSVfqdmAUwB2IsPTDaR+ikFvxCRhZrnhK3uxzRjp+WClcDyQW9E6aAFqT8ohBTsP4dpjkjss8ePbo1iOEaT1UHjEXYFzV+O0StZt0Ddv0YWHkWIugu2obh5WWfuzmHF8j12GYD6B4+JhTRuIlqrt7c3p/mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43wmntFn+nWMuxYkWavjY0GsrRuEdgy3RiLGY2AYalo=;
 b=KWCEhZPjPGT/BOqjZ26O09lVlH0bRvTLKXpxw98vamsubJ+3BtDxnn0PgYeqErYTncL907U8ZK/gOa4po+2VEfz0V8X/AEVngUjuahUDeEy7+6mcoSoB9zJp8bBrd0pQ9iRTQ7hGLzi1UaF0UUZUs0sivjR8oyMqsq0ai0IzfyvhECiNzmenp+KwbIPgkrdEyg1/xBLAwuVgmmyOQpm4qs4AxE8YZ7RJi/pehUzId8mYEQS4jt3fMJtrGvKe0qIoGkuNhVMJF5I1BaCOm+pxsVDWCl37HwF8zcp920pcyK42mbEPp/kfOd11pp2ba81PhVhgodixbkrt02EZHAwlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43wmntFn+nWMuxYkWavjY0GsrRuEdgy3RiLGY2AYalo=;
 b=Xsf4frINCxdUnDaw5Un9mm7YnsW1pB0iYY8xHkkdTVkQ+VBDOW+z2I8GFrPMshGXcN3GZvFr56Sesv3HLAW7bse51ZaM3Ey+57LBVPBAaWuq5x/Om+SLSHnhBg0B8cWbK/simWn9+vISsX+f3nUgjyGGmv0JKUi/8min/Aaw5tpPSsYi5P9yTMXeGibJsCAnWpSg1h1O+rWPsnMFptDs0Rz0hy7RbSPj2cmD4hbky3a5lM2atv73W/zeBe1JDP7X8jmjKl5jkT+3d5SQFngVLErlqeXnCfPGnxiJurMob6TbsxUqSsX99OMX579oXitORzSj5LDVaE/1CtrgmfHIXA==
Received: from DM5PR1101CA0019.namprd11.prod.outlook.com (2603:10b6:4:4c::29)
 by DM4PR12MB5104.namprd12.prod.outlook.com (2603:10b6:5:393::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 18:25:13 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::3) by DM5PR1101CA0019.outlook.office365.com
 (2603:10b6:4:4c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/71] 5.4.168-rc1 review
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <192926ee67674b18b5ace5c2d4f5477c@HQMAIL111.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d9c59f-9b47-4f8b-f097-08d9c3e61033
X-MS-TrafficTypeDiagnostic: DM4PR12MB5104:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5104E2A2E9128D338591EDFBD97B9@DM4PR12MB5104.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnblPavdWImxgfd2K3TXwG7zNOg9xVGCupRf40z3l+gebBAJR8loLZVfBmY47cPquSZ4eIvl9dLxNRLtFUIXChcpt2g6eZXCgNKTUwC7VeI6REY+2zc8vEPlI0sAfLs8+xtg0earqdWnQdDiJmTg0SbZeGTBI2WR4NNch6o9ZXBV2+8XxVFW7pWOMjW23LKBiYd8EAvWOwSjBNxmpt2ynxmONuYw79+ThQFyGmELh9XuXfB4vEja+ckTDQwAZnrkzBFiToZdt0e0cU2VXKlIZmwX70CMNx45tlH3Xed+M0ff3G2s9g594SvZTikX6TbgknyNxirJewUnFAnzVxE6i1S58kqKnWxE6WUvn6B/pcP1XoyWrOnGBDY2fZ1MzqCo6i7vnNCymp46qSPtZ8cVTK0h0XzgD+g99RPDtLkogTmOkGIgUGhk+bqEmmc7VvbLcV/JTCNNvYVLlhd3VECu29ZetfdxtDdB5kqwwKQdxTRZTHK6Cu6ZN8RERFV9M4OCS8ZSNDaJufT9x5RobqSMYjErc5gjrz385Csk05sZlktbllYLjKvDAcmZVet1JTE62gas3iysS+keI8sePBXIvYoBcYTaDHrfiaN0ZDer0iknGb294cLG1PeqziS1nkK/siXfhss7DKYDPsQKVSeor0SvaoUjVLA1cSczYhXts4s5gXDk9qqw4T3kPukVWhKTxYk1X/LAonPyXPgA9KaB6/LTOMIHQ/a8VvMGqYInoFs2CXfE5mZPtXHGP0wlBGkm2eCVhq06PTCsSv5QdDYa12cr4MQmlvYo0sbhSoOXEA69vF3bzT3+tSZTOrRgkhU662gPFJTwplpW0sbHGQ45Xgwlc3meidEDwBbjZuO87/jTc1PmQapWY4efVmeSiw/Mf5UPB1313XGT1m365AoFjFmUb8OCzoaI+TBxWKaUKDI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(356005)(82310400004)(26005)(316002)(54906003)(4326008)(8936002)(2906002)(8676002)(70586007)(81166007)(47076005)(34020700004)(336012)(508600001)(5660300002)(6916009)(86362001)(40460700001)(36860700001)(7416002)(108616005)(426003)(186003)(966005)(24736004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:12.9967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d9c59f-9b47-4f8b-f097-08d9c3e61033
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5104
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:33:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.168 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.168-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.168-rc1-g13335f539c37
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
