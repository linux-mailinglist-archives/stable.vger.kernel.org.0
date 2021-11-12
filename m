Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A17744EA9D
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKLPni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:43:38 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:47136
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235357AbhKLPn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:43:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdfoHKqZvnVIBVd3/hHcdzx8IW7fYBKoHuL4JP2KwMPCj1BqMDm7Ynn1apaQWW/qEoxais1k5Atiyk20UFatuGwpGrIXyk2tSmj/A1R3DOCcZqnHAC04NPdGjflwnU0ul5kfp36PgfbyCToyLBlErnZKIEchv2RMtITllAWeHHYLCi22u6yoVepYSWDC7hRjDk+kvY6VZDNi8bcGx7rH+ApzaYKjoAspugM66DDZX4MEtjn8qK3Lqp6IjjdocX4TRXZXVCnt68i9IOCWPEjtgYTSK462hlQTP0n3xaSx216RAIhwyRz5ZIkGyQrjWCvhEc/5mrDIVV1Kasl8iA2XQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qox4NJEmLrpIgzykWePd9oZUpwX+VGhFupXMaDAONE=;
 b=kcT0CnKkiElGcpOkvAI/4YNFYpWfcdXpdGU9Jb+Fg1BArRMWfm59MFkhIEvhqlXNOS84Kg6vSxs+H1ug9tv0TAXaeshw3qY2Vxtuc3hczgCn7mb3MXz1P3zEZxPXOdHRVPAFknTOI1zw0AQ67M/fjsVkNNtywTCMo6Z4AIk/Mo5BE4DeW1oLujLjzmz54Kemdnm77Pg0p2pKfxrBSKqvbC+3ZJEG3KT314qHSPzjayfF45jRDArYNnAAB6HFcXVm9alEOEGSnqAw+YN9Id6Xc+LGmuLm9Oo59JPe2PXoryOG8UHuYLoHsCPNkwQzg75eLpggfGD/ORUL+2mOJyaxVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qox4NJEmLrpIgzykWePd9oZUpwX+VGhFupXMaDAONE=;
 b=sEu0XVzZTYspAhn234M+2HIOR4Op8EoMLoaRzrmohdW0cO81LmCkjzd3Y3va4t0tTqjG3p09esdwATl8hT8ZduqkAsTC+B/WDhpH+MfBv6IOYgAHlgaYJOfOv/D6ytDcOSAzxcPkhbElVIJgoH3QWbj/GsCrxh4sZc+TdmRDMsIWKSjddNssP8GgGDwzq+vl8cPYo2RiqZQHy8NRovwiopaHRLEntSgk2KPG/u/AjIGQ1tKvKNxa+SiNhomqoxh9Qg/CLAKsgQ9Xsh8YuUzNkCHo/BSwhDXwoD3292e0TXNUGC4cSQK03DH99NzpDBoQjjkpmV6qzO+AF3wPInKgXw==
Received: from BN9PR03CA0909.namprd03.prod.outlook.com (2603:10b6:408:107::14)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 12 Nov
 2021 15:40:36 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::a1) by BN9PR03CA0909.outlook.office365.com
 (2603:10b6:408:107::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.19 via Frontend Transport; Fri, 12 Nov 2021 15:40:35 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 15:40:16 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:40:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/19] 4.4.292-rc1 review
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ee79d199b899489fab3188640836abeb@HQMAIL101.nvidia.com>
Date:   Fri, 12 Nov 2021 15:40:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4325d53e-7777-4c2c-8300-08d9a5f2c518
X-MS-TrafficTypeDiagnostic: DM4PR12MB5183:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5183A66FEC783C5928AF6DF5D9959@DM4PR12MB5183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: riJtg9N+bNXrlApg+4fLqyBdJ21WaKpMTyqjwutRBKerAJtzBCJcUBSd5Mhlc+kDKFV/GRj/ZTRFIK30KsMOT1oDYHwH8vWstoltDdfcZmN7CB5V8itcLR1PLPqq6UOH/R7017up0CkNP2+kkQZ4E0hvDz2LmeYaxTamv/eUZxyotV+RHoJdDhM5hzW3b7LiBfAWBdZpjpiq/rwSmrG61cc+10fhpsAr1UkViMHOESgRv0sxsllWtHsMjaBx+j20hjj+5jOUd8JKpypW7BnDOUuA4XnFrDl0yuVQvCa+vPdOwUbDHUBo6VmWvNpsSnXKy/6N2rx9Xbd1w8EMnn+1fKNqS4Td4sMnysq/pG89h4hAFZbM5qDPSvaTFgi4/HSGTdE+qGRmXbxLtbnHcVRGOz20cujQ5mxTLcnI0qBFh1zENHGPYXV+p+9L4Tgq4AU9atg+5tKFy5/z1kBceY2CXLZw1cZGtN2Y97kiOTa5N2UZ3AcWkNkOT148F4QRmSGKC5EGrrEpxZI1t171BH8HdkCuv+X5PdluEcH5a2VUTRyzaWMbxJrFzlwnc6m8iv0bimvo8r/x7kZLK56KHAZwhjJZCHFg6YIpGs+jZ7ChysoHQKxsHLgCBvoNVNOiTs3uijQTZi3j4SnDKxEFgej9sWc23VCvaErXiTGXJW+buYiSdAIp5Z1kScq++aLAW7U6bRSYf4AuvEgr2btoEhV3nJoNoXab5zgBOJYkHmVDfmpeT8blkZB7E+D3c1aASHhdDVK/UUekuqil/whRh4kqqRi2pTGxidhtM1K1dC2fc7w=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(86362001)(186003)(70586007)(2906002)(966005)(508600001)(8936002)(36860700001)(24736004)(426003)(82310400003)(6916009)(108616005)(47076005)(4326008)(26005)(5660300002)(54906003)(356005)(336012)(316002)(8676002)(7636003)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:40:35.5403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4325d53e-7777-4c2c-8300-08d9a5f2c518
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.292 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.292-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.292-rc1-g17cdd7c2c6dc
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
