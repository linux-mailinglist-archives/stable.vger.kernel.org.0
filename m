Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C674034E48F
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhC3Ji1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:38:27 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:61472
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhC3Jh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:37:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+O8HrvctcrhkE0uGZVzopeLPc3w8QVHovb7VInV5xhZY+w/Nv+wZCeCLWl5u3EtpY3GT4j7A2wxfa7pKMsnoZ7RaVmSgAwvvW1YzOKhADOk9x30QkyFIC1hJ/SZsL++yr935TN1NlCwjTaN1/lgO2emyjnZU1dA17JYjlyYsBRUywEURHDgXVjlA1P0ZHLazliiZpfhG/TMgFgG/MyTdMQHPH/h5JafgTqt7Y88hc9rQ5ZcNkJQVQggI9es3GF0d9m9flJJyQDajj/YNOJzwzi/unmyp0mEFcFki0PG3JoeiNUuUoBBrV8y4kqj0DeVTAj75XlKmOuAX68nqsl1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVS7GnyZvBEk8ZPerWId+dlXWpN+sOGKsyff4w/EHEo=;
 b=GmNDMGTuU15ba7DDITd4OVX1aVXuJRptpLty4teXEUGTsmchFoT2dwGEWiPSwVrKRmrod6pUlNxK7mg2ypjiLkL2W30OENrX2mmH17Nk8UzO2y5/M6olmKt5jYg/CxzBiz60DX98ABg04mPTuE4ZA+VAgxLW0fHAdOGIOhfIFzi2chEvRsRTiEWZ/Z2E3Ns3xIZ4yBi5gjEccZ0iyDw4CahT89iw62uxEogoKFu0SxSRwoHiYXboejIQVBcWc7u8QRJcGDZeAM8JPIVGbviYnGDSeLwnYf8OG0R29Ldmy/ueL34UDsr7Su2cTbzTSMP65lDp6z6lzWoyssDJ4xNUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVS7GnyZvBEk8ZPerWId+dlXWpN+sOGKsyff4w/EHEo=;
 b=IojWP6eVyS7rZKa68nyECbrz8bmxNyf4pr8W1OfwMJOQD9nC0a0o2r5p+JgXlymGxNhq9Z6jxLen6nFxCSekgSqaJXRl1ULtzhayQkFlwvXIUvHbG5bGdQkOGLOOrTYTpXMARTFCjeetzDo1XpPhdaDVZnAODNOfydk70qTONozOArUGdNYDfRwUzUSuenoD+lh9saBfJcgVHJo2FN5ORJoS/DAc3d/HD8fBndIsJdulC9+2BEvieQwY0xqAq3E2WONSzURvmw+onKspj2lliWAleVjnHfhpssIExDhry4OCugWDr2cXdgxCSdUlM/bxMAFP+tC9qBXLQWwAF2/FWg==
Received: from DM5PR12CA0059.namprd12.prod.outlook.com (2603:10b6:3:103::21)
 by CY4PR12MB1672.namprd12.prod.outlook.com (2603:10b6:910:11::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 09:37:56 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::ee) by DM5PR12CA0059.outlook.office365.com
 (2603:10b6:3:103::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend
 Transport; Tue, 30 Mar 2021 09:37:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:37:54 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:37:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 09:37:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/219] 5.10.27-rc2 review
In-Reply-To: <20210329101340.196712908@linuxfoundation.org>
References: <20210329101340.196712908@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1898926dfdbb4a41af36688d75b09f86@HQMAIL105.nvidia.com>
Date:   Tue, 30 Mar 2021 09:37:53 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4653c9f-fe2a-40c1-8cff-08d8f35f7ecf
X-MS-TrafficTypeDiagnostic: CY4PR12MB1672:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1672B319FF4826649C4D1847D97D9@CY4PR12MB1672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qv5A8akN0NpBi4qARoWkJf7YZnQ672JfWzWw4KmGTWWGmqGDjC5Va/hxxUbftiUXn3IH9spcPbIWBCtss/Y+LOJsc97aDyLbdDbgc5PVThmdzfWoOXVNjC5Akul9Nft+da43Jw6Vanie1ZWW1z7t1tNspZNxNi5yNVxZrBzGOsRkbCQLVRXIkiQXLTpuWznL1yO+2VudV93VAm9PqPBzAFpxGuBCclxNj1ZGiAawxRvRk6IBNlFStDEN+k3azZMjWjQVLC9ooKrWi97KxGOGM16pm2+VAiB08bPSfLy919VwnA7USoGNTYiW6Kll1ZJ59HFpFLpHzq1oU2K4J5+4UthijRYAWq3ezAmRWkSnBumS0I0pDRkCu1062YCX5qRN8tqOwvnolYKZWCp2CMk01b7DpFdLCWb2SjJYaP8gSimNrb0X8VzF4GOo30lGaGjxrQfnXHqUxv3aCeqMTdrvTO2D9tsGpprEFc+R725v1IFX7mIkQujsjWOUhi8j9AKftjOdlamlh0mnVAu+0oIaEaQdP4BcgIoAc/iPcO9E02FRJrk6+LtzEhhtYG6D1R3onIUiTM7EKlW0Yr2oHwViWldHJ60VhtlpHRsXrR/eC26YJIwmVcNXyNIPHdFNHuNzz6C4DnArneIYVmT9GLBX4BwgzuorUVHDZ3NpZggqFAuzolfQdIgcUis3uKTLjEz7Z9PDGgF0mXHhdee4ohwdgqGtOh6fw18Ig2HoBwvX9Dk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(426003)(7636003)(8676002)(70206006)(47076005)(316002)(70586007)(54906003)(82310400003)(5660300002)(36906005)(36860700001)(186003)(4326008)(356005)(8936002)(966005)(6916009)(2906002)(7416002)(86362001)(26005)(24736004)(82740400003)(336012)(108616005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:37:54.6799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4653c9f-fe2a-40c1-8cff-08d8f35f7ecf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1672
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 12:14:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.27-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.27-rc2-g8c8bcec35122
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
