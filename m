Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C041453AF9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhKPUe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:34:26 -0500
Received: from mail-mw2nam08on2042.outbound.protection.outlook.com ([40.107.101.42]:36193
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229553AbhKPUeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:34:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVnFXqQo6MmX7WUtpXmnw90Z8umZbSuKPGu9JELK1JqWe4hy2NYoeBgHLFqmuWkLbIkpCofIC8tEeSePbQTaku85lrOYkx8yjSYZS4MTmVhiKuEki0tZ/DSgmsPU6Lvm81mRGqDFYfFkjUlIXr/Dj7BBEJIXoT7Kkg6YmD14xxTiyEVLxxfLOTtdqjTiG/Xy6lrBeO6TjgzakXPIx/TrzsV0OirbNZHAM1p3vxmqQCRulEa/v4dGUNzvmazE8S0Fy3drkkzV5FMH2RGRPtExZgiiX0uL0ZceU/hwOr99Lj4ojiVcKdjzyFEecM32dvw+YvS0Mts0ZBc0Hm995LIaNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHZLWFNDy1SSEgCIjdwSolb7bEvNIgNhyI4JNFEdnMQ=;
 b=gtsZeC4izIEXyQ8d+F28Kp2NG6kBVDJp0JK/9JXIy7CXZXXCDfMeeHGrxcSaXu8H09Ofo88634Zedfy8teiDoSdZDR0gUoyoRP/JrPYII3d5H7D7GCG1eWUBhocvyuK3sKHZmjtGAyc5Q9m6QIFRo8FxlJDTT8rntbrzgaPRIywaYW3iI3Ao6beqKSHnWU7IILofmvSoURcjOQXUjqvffOlrFKAcbz+67c0upk91DkFPY/QYANprg4M6gYPYAwl97neLsCT8gvNZtyvi8CkIn/AickdatMeclktpX4zYX2qjvLziHCS8lwLTcsfWJF9IDWMz9QYHgcUQZs9Xo6pwng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHZLWFNDy1SSEgCIjdwSolb7bEvNIgNhyI4JNFEdnMQ=;
 b=t/wfS7xPlFIj+MXWdXC4tF308td6XAYTdZD0hJJ1ZK4ZZejpEbrWTvjXO/xIWRbXRrDVtV/lGDULyFqz81/4jAwwqY5DVO8mVfeBLOwVSkryG3zfNbRybcMHSLMiX289dfYa84VeZCB+p5I+xQ6j0fNalL36hQO8f8EqId5r6if1AUUvdo7Gt+SfH/sjrSpIU8KU1dgGtcXtqQK9PaftVthFtBH1q4CZUTWc1lEcFghaDgP/KMk8Mkvo/85cqjrTsXloXiJmYYB98ldfIyK71lx+QYMNUKyTskUOXQLomhzC6JHzeo4xlgTRcJfJwTY2Nno0/TGOvHdwjN3vX9LSAw==
Received: from MW4PR04CA0243.namprd04.prod.outlook.com (2603:10b6:303:88::8)
 by BN6PR1201MB0193.namprd12.prod.outlook.com (2603:10b6:405:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 20:31:26 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::88) by MW4PR04CA0243.outlook.office365.com
 (2603:10b6:303:88::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Tue, 16 Nov 2021 20:31:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 20:31:26 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 20:31:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 12:31:23 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
References: <20211116142545.607076484@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <73432cd5b63549919f478a7fa3ab16cd@HQMAIL109.nvidia.com>
Date:   Tue, 16 Nov 2021 12:31:23 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb9027a-0444-47de-a9b5-08d9a9401021
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0193:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB019370B09AA1A4DAD0FA969AD9999@BN6PR1201MB0193.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LEoTPryj0oepSm5RB6biZMUZOe1DC3IstaEZfq525XJVRDWca/Wgmgw/fyF96TQX68bElpDj4QXSB1VCwsGzBQCX464olHB9lsl+wKMmxGZHa7RMPDLiyB0DBBYwQSdBETVNLV92c34uiWZKDLbDiNlk33iivyirrWn39VLm2TNDIiPaCQvD75PPYKavJSKm2kEOMyvlQUANyJAmEZr/UAtnSFtRaQ6gWFbspSfDPQcwM5vbOzjXpmocXwR+kqVtFRwI6wR6SPMQtxRh/dtZc/X6EJDZPe6UcAkiDaD1J0GI8kG+Nnt8WFnHVmytEjcj8CBnUDeJl8oPW38arpxVTdZDeom84DEGRQ5dKKya9kLZ6p2IsbCMDgNzs3X1ZotD4yu6ag3hvYbgV4DFz16BDuniNWdoyxN69SiQ+kTcPenPxnzHRcHEMIWpngHyUVB5QWicP9lT6NZFP0DKCCeIQ5mUim4jbHvGZhyvMvDFlG2T5ZRIdEJdqH5glcICJK07OOpjCNxN09HKP/awRwdZpR0SSMl39oRQ8I7PwyS+eq+SAdEQt0JavHkPN4GHQYiZJkIrUxFxyDFbmq1cH0NyhhYpYznfHP0fZET819YvUmMnT3cd4dAW3FDufPLA12+3khSKA4D8S9p/phNqYQsdHGZAAl5zNxMtEnHygaCwmOxwxn9pIiVPUAubNmIK9jEnnJrF4FxPljC0JwpHSfkOEkcHOZ5zWJtGIjJBjJi9r3XE9lYwDg722e4wGskquW/W4bp2+bvqlnGUBnNT8KkcjDzxuFOYOCtnmdcgMj20pD/7NFFLjmVGdAipPX/ZQpvfqAdgGQsX2jN1JXy9ARwfw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(5660300002)(86362001)(8676002)(82310400003)(6916009)(2906002)(8936002)(316002)(356005)(7636003)(47076005)(426003)(4326008)(7416002)(26005)(336012)(508600001)(966005)(24736004)(70586007)(36906005)(108616005)(70206006)(186003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 20:31:26.2209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb9027a-0444-47de-a9b5-08d9a9401021
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0193
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 16:00:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.80-rc2-g739c1bb0c245
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
