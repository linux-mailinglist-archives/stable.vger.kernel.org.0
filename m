Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08567426DD5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243352AbhJHPp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:56 -0400
Received: from mail-bn1nam07on2056.outbound.protection.outlook.com ([40.107.212.56]:49639
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243293AbhJHPpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtqWNEtSQOnxdG69m8/F1om/zh6hsyR5RfhXq1S8iQIdNHm3Ep1B8k0toAgjUQDIjZcOGcXKi9d3cbfMJCYVWhEXNMTlZjYWR18w0HMD5Fcfa1OPY1vkpL1sW1T2vCRJOz9GekOu/xpFth5CagpkqbjMhbtcDrV/FWDxxmnBRe2wzhLAFGba4gQXqobQY5+susIPTuyQmPXFexzTHgHcQ4FMZ0fZQ/kPkjMDBtVg1jMzn3vHPsnLpk8Fp1J+5AWcL6g29EkrShfQWYrlzkJlrRGcL+lKvhS1BS+S6JGOyF//WdlWLHF+frwu+R8IfJ/fRhVHWNWso/NpfkZ29TewYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtFkYm3wKfWJiQ6NEAKKw4Te9H7RjdGYmDpUKmceLZY=;
 b=VwFqpdfliNUoaVVGjKWJfnVdwqJjGEuHkqEyb8i3Gx3fTnN4Fw672Vj0M6bfGPtSKserxTLFLMYwKIfW0zTzXHQDB9oiorFEViQqPIcS/o7W5jkeqfHcT449fXpBIUfwbVnMhNAlEiVS/uUwhAwRNkadJ1VJGiSJmVemEEoQ6XKQZy25MIDoM+zG47Vso0FzGyvUvEREAqfTjCAjrFtN7mUMC3xU+2q0kZvq/9MoRyQX43Kj6HdBTJ/7A1juZ6u00k669E1ySauwM722xjeG67NXYIiuhUiHjWo8Au5AP3eTWP9kRETpf4bS50ItI1htpwlt1kQAuC6DtVIeiiL/sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtFkYm3wKfWJiQ6NEAKKw4Te9H7RjdGYmDpUKmceLZY=;
 b=HvNfb2muHZQMnbsitQ0/v5tBtXt9uG7eawRtC16BnrU5kLkyAmRB9WQ5m4/qla2pPMBelw2cudXT3HtdeBKkcd6JT4bDql0arLa2XPQe3Liz/Z3LSV1fmQpv/DwJPKC2qOrCmu8+1VXNSJBFWjrHLFaqF10PsiCXabQJRv24tVp3sZidH3DPuGtrSWvlecUS7OUk53UYD1zaCOD8TuD/tht0gOkbQYrjdOtG62sJQrwODKRIDNsg9vuR3LDvBfEN0z20PwJon5+N9OyueRXJo+Rr99XgN5i2Oj0IHAGinrnSC/2+wbFSvyy+EFab+m4Fcq9mzZnSd1NSCPOa70rPcw==
Received: from DM5PR21CA0019.namprd21.prod.outlook.com (2603:10b6:3:ac::29) by
 MWHPR12MB1487.namprd12.prod.outlook.com (2603:10b6:301:3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Fri, 8 Oct 2021 15:43:36 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::5a) by DM5PR21CA0019.outlook.office365.com
 (2603:10b6:3:ac::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:36 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/48] 5.14.11-rc1 review
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <651398ab9c8f4561ba0277c38794a7e4@HQMAIL101.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6607255b-5dca-485c-0435-08d98a726443
X-MS-TrafficTypeDiagnostic: MWHPR12MB1487:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1487DFAA63DB00155658AD97D9B29@MWHPR12MB1487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMDS05BpQKo0COitf0qJf4bjjTOzgKqcsfaDVU1lWN8uRZggT9PPmCAA7PiQW7UBLbj01JqRnxMAJoCbhhoivwRiki5F6IlWaYmJW0U4J6dXRCvmm9HYgibOYu4uiaUUSm/ennBYwhSMqoSsvli/wL1c/C6h81d+bDkjv4VOYFTl+qfNIQl12Ol8TD7VNVqKy256tdDaKvW7Y6+SUXhMw2XQkhk2jRlLuTuOBMER8xkh43IUWnis6lUXPtt3PLvLcmEwZS/k1YNy3T0XxR2hc8zJ70XrAukUulrHNInRJV06ldIG/eaHDNqEc7zWMt5vlWQPAIOCgKbkzx515E3b/G0eTPZKdiPOcM4wd2HSZSTO8rkUuIC4FU4M/5dPEnfG/akz/nqEmx6mjLkeTaxwnebFkoI9+COpY0PaFN8xnLOe27OwMGLY9+arsoofl0n0ZbdHMYM14w1bfEIhoN5IrvRhANUrSpQIrMXfuauslgobv2A9qzlmZgfs09bEIJjgv3pBgWdYnKqWsOVb9leVCgITCPesvUW2B1aTEwfkDt2+x9IcWHwqN+CHwFgewBI0pyEJipcZxdlILOZZ+qjplomb+Le0FVb90stdKaTBGqKfF7ebMFr09RbmBL4UDovBJii8zQtRMOn0aIdwmXRRP9brC6BaYEqctlchgx00UgqXZrWXR/lPMqmMDNAbv/7xRHqSFeWK8XtsiZ43KTtqz03aklW6O8+MRuYTgk+lT/nDrFk2oyJOHBZTGh8RX3z0PT0hKSYwq4E26wzAWBEsIId/v3fJEfhghD2IAqvbN9s=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(54906003)(2906002)(36860700001)(316002)(8676002)(108616005)(24736004)(6916009)(426003)(5660300002)(86362001)(47076005)(186003)(70206006)(336012)(8936002)(26005)(966005)(7416002)(82310400003)(70586007)(356005)(7636003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:36.1654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6607255b-5dca-485c-0435-08d98a726443
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
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

Linux version:	5.14.11-rc1-g24e85a19693f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
