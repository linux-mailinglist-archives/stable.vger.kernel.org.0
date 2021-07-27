Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228983D7241
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhG0Jnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:43:39 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:9600
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236152AbhG0Jng (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:43:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJXhpHGc8Fd0zD2STkG63uEyK6GFYLjOdrpWB3McLVcsYt3eSLlRjrIslMgxeLLzYZR9QiepSZNUdj12W3lh+MQ/8zFTb4mXsI/M0XUdONsuySsLotByjv+U+qavsLCXFNXmb1koTCdnXe1UUQtuM4QahnN2KrQ+ojnce5LKkZltp1AnWFFfE8tJdU1T7aN8dToHuGeHGttZ0RVVyn2Z3agLfdAIFuw51eNGugHTW+/b4QoKLsvA4dQlFDvn4aENAwiECmSoJW1NlD+1hxDqJ+I6LgC2TkGjIKMvcULLJxD2wEeKBWYko/XjS9QvyWWgO5rjFauzngG+638yBgnuUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D7CZKl/7X+qMv8sYOUnznxSXnAh9xt5lUtk+O7A3gQ=;
 b=ACej+mTDDvrGjXsnANiT5ouaYRJ3J89afby8wHXKvCYyv3XvoobG0pE5stUYnF+6Q7UEy6wEP+eLm0eKFYv8x34tBWDpFdZPpjhMxqNL2AVcB3XCCIWwkpf26eD78z+eYIGI6Kau5VIWHy//Ay0fQA0/vtGhuA8uNiSujcCM47UEVPxKCcOTNum1hRL9loC93oz1fOLFmDMZfTXFEHm06ox/euiNZZWiMeMlR3wBcOzMjXkCaBz+hIizJ/UXccEwX4OBjOepUKv7c55nyrqBCcG9FBbJxZWWp8EUT9m6k/srNvWcGFvFOfIYReqk/cTEAIPeniVUlzLVc0j8g2ENfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D7CZKl/7X+qMv8sYOUnznxSXnAh9xt5lUtk+O7A3gQ=;
 b=ZKwgMAlb90XrQTAvr5UPSuUeL7AxL/nRe5LhNF95bzVS72RgepjTELJ7pbLDMV9g/vF0eHpp3VtopOG1dqv/P0VOIhxuFsJv0DNVIXi8QvpwQf2V1stO4e7v++XzYDJ+K6mwjlyzTE6YdiK3Yh/Ixdj9SqLCwM2lq5R9jLr0GLE02EKqwHMASksdYVPhHj5WkuMdyZsESzpwViQCyNAcb+2lLtWdKM/BBjquO11RoQP0c0TV/sHTSNTtAwzZiVU8Sc6o41q0ESe566lrIksAbIBjROWtTVsnTKTJo8PQiEPUpYeSar4coz4Nm3RgL0JTjubU5NzXYChPcwwXimanRw==
Received: from MWHPR15CA0065.namprd15.prod.outlook.com (2603:10b6:301:4c::27)
 by SN6PR12MB2750.namprd12.prod.outlook.com (2603:10b6:805:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 09:43:35 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::5d) by MWHPR15CA0065.outlook.office365.com
 (2603:10b6:301:4c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Tue, 27 Jul 2021 09:43:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:43:33 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:43:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 02:43:33 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1d74dc20543c4116b0271791c0b0fd83@HQMAIL109.nvidia.com>
Date:   Tue, 27 Jul 2021 02:43:33 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9beb9cea-aaf6-4354-d63e-08d950e30035
X-MS-TrafficTypeDiagnostic: SN6PR12MB2750:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27508611BA23EE2F4B4B71DFD9E99@SN6PR12MB2750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t72io7ZnvZAh3BIcLcsZTOBpsF/u/Ql2hBRMhG0YfmmxwMJCj8d16CECg6IitxG+UgLu/+2dryowSLqHx5x/srBr4W4EftKOrkF3UGMA9lPMgtDNvc/8ad8KMcx0MKcrmiLqpYlmYVoktH23OE3+0z2J82eI8KntfVXEN/7GUUvh/qYOuMW1cEL/6if5jMr50Q/e49HrTLVsceCwYB1MDUbETTJai8kPfyk6TPflhVTZs+kbcQ40gxJA22Ljwgl//IVXV+rn4rzujDvP/RycAv9wOXoUBRE0PrbjSaNjrQZ1U+z0h/kBo3ocrKdagBhJcNQCGNanTMcvrhu2wk2hvPcywNqUjnJ5/6YsvBNyTvo8wniKOgrm8xTzy1e5Rq5ORtRRMZfv4bSlgzxZhUB6n3TAPVwNwafrKObpMidV/kyV6geBq1q+13XZhgqh8ZaeCAn7N8jC7Tvw/ssVZfdbJVdK3r674yp1YFwV+dunG65oyjQ2oyZdhfBK6Cf6SSCaqD5zB0HKPs4EXgjFgmfU8CXWnvRO0AFkwVQgZ/GZdXRfyNqrWE/z/le7j74A3OUMLnBupRG1V20ciOCFCyr06pviaAkRSXEn1hsgDRc1h0hS57crEApdNrGciFa7vxAsdh80IBRG/QyfJ7v2GDmj0gLQLJ+4YpOZOMyrEE4F03KErkN1AIz6VSPoMSUtgVguL3vquwgnVi4dGCw2SqQszUqdkS58fKYaos7EoNEE+LQmPp/CaVMwI1amH+cPmPg3tYeLmN9/DleeMlCpZGaVBQdiYlS1SHUPKZZOo2AjVBg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(186003)(8676002)(86362001)(2906002)(7636003)(6916009)(8936002)(36860700001)(24736004)(82740400003)(356005)(26005)(478600001)(426003)(47076005)(108616005)(336012)(7416002)(5660300002)(4326008)(82310400003)(966005)(54906003)(70586007)(36906005)(70206006)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:43:33.9783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9beb9cea-aaf6-4354-d63e-08d950e30035
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2750
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Jul 2021 17:38:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.136-rc1.gz
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

Linux version:	5.4.136-rc1-g77cfe86f3223
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
