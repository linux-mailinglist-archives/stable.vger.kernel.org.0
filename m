Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FDA41ADBA
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 13:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhI1LVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 07:21:43 -0400
Received: from mail-dm6nam08on2080.outbound.protection.outlook.com ([40.107.102.80]:56033
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231202AbhI1LVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 07:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpMsZkIAWs34MbtLo6pAWVys5iN9aLe+/FR1VVksg9Xc0h/HMnzb62m6lmj+MtcsT8lNQ6Hk3gki8v6ZKVQIcVmhn4UB/UFk6JEWG5t4+9O8e18fyZ3PP75UCBdypIbVXXpE98K3YWWDjRkhxXWfiFpSlYJDe5740RdPMgD6cBd59qezNdWtqx63NO+mUS3YCOk8LVCW3sFgBqUEALC5rdXe48oqJyJHqQD6a89St5nXTLX6JIm4G97A5ko27SvjYViuTcDVPVXRnbCrT5mNYZYdrDuW7shyUw73Mx0MPtych1AU6G7eMc3XMVYxHMaUOVY4VMpLN8yPv1VO0bj/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8VFUUYNvNenteMhBvlADSDTGVKVT/6wlYS8elewM5RY=;
 b=OQ59WLDzK438vDfpL4AzGcx77RyunJf1+Ilz8R/WzoTpVgyFnpBtGweTJ9VmuxgnnLg2mIgnmMUeCXivkpvZjIxZ79PR3y/5aUWAQeCPxYogbj5S0AbiUGDiV9Nl4tJuVW6P0OlXbkFI3WeJxMUC8N7lFrLNbuFQbksOz5Gk7+BPX5PyZb1sp5iKrHZgMtxB9yLzAdYXFE4aS2g/Vkjuwbmfqcgu8PiGSpLeHN1WfV2Fcgdqj0FPucyYoZaATJKCFhK8bE3HOMF68QJAw0uttwUPhKBhWeNeTgMfjFlcxDgCY1o+knzWeSZIMmQHZgRfwTtSiPMqFr14t2Q+im9uww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VFUUYNvNenteMhBvlADSDTGVKVT/6wlYS8elewM5RY=;
 b=AxpYFxdKWmMxoU/v4kDoPsjllyVwrCWNBB6mdM4qW64O7O8WvfoW71EkUoZKhlXFHVYq/fsN4BlgwChEBBckB2wnACI6yRfS7XqG1jyzoZCwR+Ah2pNGMokEPTAoBUDnRaNpcUpOd8AhmxqA/Eyx2QEz7T4p4g0nF1mFtABj08PtyMOUD677gb4Oeb/Wa7ebWj8RPKlfWpMK1EOSOiJp83w2/OCEgIkGzUiN7ZC+PsJanASdnrezz1+esmGraoIQCKQd3PGrFzCRc83edq1bl4NNIDbn+Q1P3gDDx6DVazKMITG2RmEx/QYF7myNUXBli2r71JHimBpJTSz8TopOFw==
Received: from BN0PR04CA0144.namprd04.prod.outlook.com (2603:10b6:408:ed::29)
 by BN9PR12MB5367.namprd12.prod.outlook.com (2603:10b6:408:104::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 11:20:01 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::f9) by BN0PR04CA0144.outlook.office365.com
 (2603:10b6:408:ed::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Tue, 28 Sep 2021 11:20:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 11:19:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 04:19:58 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 11:19:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/161] 5.14.9-rc2 review
In-Reply-To: <20210928071739.782455217@linuxfoundation.org>
References: <20210928071739.782455217@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <489252aec90b4349888111d708da612b@HQMAIL107.nvidia.com>
Date:   Tue, 28 Sep 2021 11:19:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00269847-a630-4fb9-08a9-08d98271e943
X-MS-TrafficTypeDiagnostic: BN9PR12MB5367:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5367800370EE0CC6C372773AD9A89@BN9PR12MB5367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTM4NUcN2yD9HQfUKCWRyyCYxanS+e8GiyLAHC3b9Muh5LZL7VWNZHFkfrsoRxv0xdptINYE8N4w5K3uznPpOJx6poNx+sTBAWgjE29KGbBSaBzQy1w0SumuyBiRXf6Khb1eNyKQSLXjLp0wej6n2fJhKMNVq0VOy+sZC01TZHh4R17U1PjQS3ePBK8X3aFzPdUI9gIwMPAImu1a0TdjYNtIQzetE0lh8FUzRKR3IwSpaXC1+5gCvqh2mUgZmyqqYgl9LrvxfzGaws+eoLMjocn/7IherCq/5imsF+PAw0ixUCtkv7oI+CEM/ViZG/s+SUzcPNxr/uNtMloWoit9VHPlZv6zOBGWeN6SiXL9wf5tkOYAFbC45zDFMMsiCIbOBkyjyuJBbEofbIjaThRPx7BhHK3sdxH2TBJHmaJ/JgDyybJpBIRhzVV/Zh8n/dL6O2v4aFBLOYjuHNxHmXgSHBxwqW37alpEmsYrG5J6d8Dnz8Yr8L9L/5UmwvPPiCHk+uvc6Qy890qU0S1nDObp7hJi0gsOGfPAHdFGEAHh9PJ2nFwsckVZ+9ux8MUVZp+rkpaXD5vCVDxocfuF9/FDcpVXDcY0KNud9FVY/qNZqJHddUk8kk3EshICuSHhyd30JkFqHUbOe7xXnDswch2/FOzU/mdwrcGXOo1brv+Avgu2NRW72g2b+w+QDM9nhDPNO5GMA4dXKzaVWycaZOd6CMi6OsGXdtzBe6a3QLivpDZOAjCRuPSF19F+/KHKN/HA7UlQuuLw59sVSV2F5xDo6W1sQUqGmzJOJpRndbVzryQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(316002)(70586007)(8676002)(36860700001)(54906003)(82310400003)(336012)(426003)(7416002)(8936002)(24736004)(508600001)(356005)(26005)(7636003)(2906002)(4326008)(6916009)(5660300002)(966005)(186003)(86362001)(108616005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:19:59.2673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00269847-a630-4fb9-08a9-08d98271e943
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5367
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Sep 2021 09:19:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc2.gz
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

Linux version:	5.14.9-rc2-g6ee566ecf238
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
