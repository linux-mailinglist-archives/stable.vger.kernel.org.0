Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52AC4462A1
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhKEL0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:26:38 -0400
Received: from mail-sn1anam02on2082.outbound.protection.outlook.com ([40.107.96.82]:3428
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232329AbhKEL0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 07:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwqeauzhuET3bxn66ef+Wiy6Ol/v1qekD6YeX7635fNNEqQ6SyP6WguXnzRMBR56wI4sk18xzUsudgfRUb/GY3HLxtMMZtgwtooNhbDZL16oXUs+693PHOnH5Aw6c/mmQ3iATcnl2pqyiGsYMNZY4M1Hk677ktIB1lmScBZUaxrHiY2+4v4aj59T4obcSjuhO1disQ1JGq8E78WpTvBpDx+i6+KTPV0zL9eg17l0BN13pP8oob13rFgQayG5BA7Tw+lYLvmeE7OY+Ixao7cd4gAwVikkqeiabRQ1NUv50hNLqUftIWMUgAwvcaZeqGXVb2JFfT8oKbxbx9XPXYPCSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjheWEDOR8Afymg1iJzt3pDc9zzC/I8TkKj4fwGuZCM=;
 b=QOySfSkp2FZoT5r2upWg3iBEp1uJKVZUWngztnvQm3KmPAatYKekeiigvAJUB79ooABGi4xnkAxdBEaQyBM0V4lUan8MyAtLle+NYVT1NE99cfP7r5pgLZhRQQ15XgPDuof2lp/cFQv7Vv6Yf84HYkwe64OyBpJPCOrMBjX+MjTPHSbLcdbDAi4wWCAfHhYv3729BKajw+q+vZ0XgaRga3G4FEmDESwB4IFov/DZZAQA98InV5HJtF5fTLa/uJVLAbZ5P4LAR/g82V9wsPtESMFD6lJJEglySfyC/Y+4xOa56tG3CCPpHaojtR4VcTr24Y7b4HSHdDFpuzsS0XZYKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjheWEDOR8Afymg1iJzt3pDc9zzC/I8TkKj4fwGuZCM=;
 b=RRKMXlnQVjY4u5j6W4/nOkNB98h1OWURD6B0zOioQV4UYlaarcDgeTD5LYEsBRudzluFME/O/P25AwYfsuUEptifah4PTIsi3stbcCVAgb9inPJ2cio6yN7A/33V9oCNXPGO84Z1e16fyEUXuQi16W5BGYKJ5zEYFv3jWwo1jq3VA734I5BnD4PzoQBL+QkORve3Kpj5Fof3yfLhFjlh1637FEkCys17kdeFzT1FaBAaFNT1B+76MvGgo7mMf/XjizvXB4PajV1GUujFGs98ze996VAlOKhUgvEh5aohWiMNIUualLCo8ZZWCFX7+lFOnvpQ+7jZfLMI6+q5fwdMBg==
Received: from MWHPR22CA0041.namprd22.prod.outlook.com (2603:10b6:300:69::27)
 by BN9PR12MB5367.namprd12.prod.outlook.com (2603:10b6:408:104::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 11:23:55 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:69:cafe::9f) by MWHPR22CA0041.outlook.office365.com
 (2603:10b6:300:69::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 11:23:54 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:23:54 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 5 Nov
 2021 11:23:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 5 Nov 2021 11:23:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
References: <20211104141158.384397574@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0ffc9bf6f3b042e0a3070ee0b7cf816e@HQMAIL111.nvidia.com>
Date:   Fri, 5 Nov 2021 11:23:53 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 468402f7-d294-4b1e-e57d-08d9a04ec09e
X-MS-TrafficTypeDiagnostic: BN9PR12MB5367:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53674AB305B5C46290F3AE2DD98E9@BN9PR12MB5367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cC/mFtxzM6cxqFsxjslgqOKd45oQuV8mzQ74aREkcI6zG6ML21NFP1kAz7XW1oxtArpO50fj2cRo5CGCGOAGXGuKcUv3xaYeKgpmswW5ANBGbR7dx6dH7Ae7Y+X9hhfZxzfEzOGaAcVoZW4Zkd6nm8u3dh1VCot+V+48TUUtB045VZM4M6qoyLmdNlrVfZJ9AslOCNL4gFkNvYxDeJGR3D7aEWTP8IesM+nWrw3EAWRkOkqGdpJOH1IDAZlHYx1KMY+4jjGZpVqOSh4spOdWt+SFIjz3YEDvvKIkVr0WrS/bVtwvpxx4CRxvbziyiOmMCBbOsAsmYyF/xXQQgWBSuAyrRFfDi1kAYPLQt1EygYHxvcrJvJEcZVpModcr99I7DObCjnDXoEarqpeGITnPi/2Ac3I/2AU6ViUIz4OinhkGrPUPMkm96TZf00mFbo3g+HOQdz9AjJJZIlfPgOjXoaqVKXdSlTOp/qn+aXXCUNY1k5EWNPswPFQ+wDGh8TRU1LpDPPI44qvnyg4wspbAmsICIlxhM8aUChB711YTZBu2tQhjPdxP+wCofeCRj4ASjQ6kh5GVtKoz5QWhO/QyTQPIw/D72PtXzj3rlZSGlh1Ejzlhmszxlb4QTJ/eNxhN4N2t9Pi8swekXwZSN58sSk2f90bEzMjOutTZtxP9MXMW67XmOUUzCcDOmI5jFUXWsoxXoz9GKUG7DI4wn89SLogNkRsC3xd6xW+OrJ+mwDsWr7KMqy5QfAafRJXdIK2XZbi37cUmGnFnmnLTz3wqPUpIK7TC3G79lrR4f5BJe94=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(82310400003)(426003)(186003)(36860700001)(6916009)(8936002)(36906005)(70586007)(966005)(2906002)(316002)(86362001)(8676002)(336012)(70206006)(54906003)(4326008)(5660300002)(356005)(24736004)(508600001)(7636003)(26005)(7416002)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 11:23:54.7289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 468402f7-d294-4b1e-e57d-08d9a04ec09e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5367
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 04 Nov 2021 15:12:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.158-rc1.gz
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

Linux version:	5.4.158-rc1-gf4b30ec46603
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
