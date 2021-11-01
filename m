Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29591441C10
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhKAOCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 10:02:46 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:38529
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231906AbhKAOCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 10:02:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLLf6L2Owo8eBZYi3zK1AmCZ+wsGqntWZB0KJr/zBxLmh9+294vVh99YCCDewblWdBKHN+u+kmdXmLBQCKTIFzTtdysg9+/ESfoATdYoJi5vhY1nTNAWPa7wmR65ptcZRF6+bzCQHt8lqxd5wxtQttLMVnRRskHAf5KQrTFhovSA7fhhdgHfjKd0l/un9bvMheiMHy/wU/A/5NrEtLDp6842pGAE/iJrkTJkj7ag9AM/SS7duIfsbyef0SfpUnptrCTlrd8aEnVH4lRaiyxzsMdRnMF6tkSh7xDDkQyDUYPHKR+BFTI7aLTzu3BcNhOVllCD7gjyG2vDpG0f1AtG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hxt34h8AsaoKRI/kS/zHeV0W4nrap0diXPEWJhEXIhQ=;
 b=UgBTyNksjKh3zHY1Rl2v4iEX37GJg1daHloiXHWMNwiP5dd7dMzdMqtaDQr1w1T42999u0FXOs5N34xSYhuwXKhyX14/EsG/jUrqBWPq7ejW66ktxtWZz5VwDTC0fjro8j2CzJTpwF07UaL1kC3IBDZo9kb4wF6BDFUC4IRkVUzYOtnWUXAXDzrhrVzsVpckbZZlHOKgXaFRaEBo/ErTbg330YLDl748kCRxw8vdv3EVJjBzcacDMAgXT4z6yJYz0Yuhhq2liAM7lobkGA4HXM/2Kt+8Gghy0KvSE60AGEBQUvHJsOgLlRqaq7rS7Eo/xlEFf38UX0VibFHj+n+QIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hxt34h8AsaoKRI/kS/zHeV0W4nrap0diXPEWJhEXIhQ=;
 b=fS/Jwfn/OzqRhmwzX2TlE2P2H58g7yredQtamKIhTsR5J6WdXL2u7A10DtAXdNUG2/Wqj98FgOJT/xZRX5qjG+FwtX61PcnbQYK6QH4hRVctkbzMbzrYkbleCMthIpE2S5Rwbeeezc00piZ2o5rWOu5Q/fl53LzNaktjlQ+5wQCPayQ2ED4g4cccT6oqClYTl2hxvVR/VbwzWtvPw/cYYp3081gqzPWTkC7AHE90t3nsXayxC/9E3Ye/CNHp8RgRssGxCrDUzodubksB5Oz6FFlqXih0b/ocZohDYmK47zuCLpAsHEU1KmbFsq+ruZZZHfcysYNEt1lWuzafi40VsQ==
Received: from DM5PR13CA0043.namprd13.prod.outlook.com (2603:10b6:3:7b::29) by
 MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Mon, 1 Nov
 2021 14:00:10 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::27) by DM5PR13CA0043.outlook.office365.com
 (2603:10b6:3:7b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend
 Transport; Mon, 1 Nov 2021 14:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 14:00:09 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Nov
 2021 13:59:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 1 Nov 2021 06:59:58 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc2 review
In-Reply-To: <20211101114235.515637019@linuxfoundation.org>
References: <20211101114235.515637019@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c81846aa958742fbb2c570041cf9c969@HQMAIL109.nvidia.com>
Date:   Mon, 1 Nov 2021 06:59:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d72e268c-cb54-4927-e50e-08d99d3feada
X-MS-TrafficTypeDiagnostic: MN2PR12MB4077:
X-Microsoft-Antispam-PRVS: <MN2PR12MB40774834B1F6871F2BD58A31D98A9@MN2PR12MB4077.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0wN7yRMWE39ghq98rIxPK5jOf3sM4tKHHxRZYtiwuFyJXmKFg5zl1hN2AYtPpiewTPzOJ9Qaz16iVLpB2ypULepIWQ9ao09dO4eVZjX6Lx22aXqhQpb1bWYbV2sqIZB0cZhS5x0rvixq06i2ouagP5GU/U+FpbBpjBcR8QCb1HEI26zBnhw/wIyQc6H2/Jiq/81rZFpc9m0ah6E36iT7nmhoN0QyGvTxOYJbG+YPewc8zI//drF02CKXcd6jgoF34vcLyxRHKSJ9uXBqaDIStPa1QUY6xx5LRYvj94sJSd914XY/4ZaSLBmDMYpMLThZ1skqvVqvJzM1wTvMwGBbPxC/LMRzOt/OZCHJgPuCNJxk2Z+91gqOxdbbDLT9+q0m0LkoRXovDawBYcrFUbxn+k5KmP0Kxdsx4ZWuZAb81qiKuOB02hNy+M4GsDC3XYhVaWGnaW8lojpdFDvhgZ2jLqxIJX/1Da+iaDncfVCwR8F350lCvelUgB6y9I0rH2AOFoLJqqpQcg5pzn+yQ72LRA77etbSE2tJuKie9PBFF+p6rvxdHL59HzkY8ROHSChxBVmvv2c6ed5G3ZYg53aV3OWbTxQ6IdhIftv//uG48di1pmsYYeYBJo1xiUUpz5wSwLWE2/HFeNVy/q7y2Z3Vv8JM37At6vwUR+JIr1fIR68+7EodclpQMGOIdZ/eIfkpXkXUqPLq7/JYcxylS3OIno+QOKOjMM+g49Vzl+ikkmtWur0J0b/4FWp2Nvu8FSeplenat960RPSXp0pl2YFMzhwpu9HONyD+O2ZsVTBB2w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(54906003)(356005)(82310400003)(7416002)(36860700001)(7636003)(4326008)(24736004)(108616005)(2906002)(5660300002)(316002)(966005)(70586007)(6916009)(86362001)(70206006)(26005)(426003)(186003)(508600001)(8676002)(36906005)(336012)(47076005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 14:00:09.6491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d72e268c-cb54-4927-e50e-08d99d3feada
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Nov 2021 12:43:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:42:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc2.gz
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

Linux version:	5.4.157-rc2-g48b0aec9543c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
