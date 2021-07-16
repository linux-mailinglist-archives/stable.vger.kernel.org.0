Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880883CB6C5
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhGPLho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 07:37:44 -0400
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com ([40.107.223.74]:65217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232248AbhGPLho (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 07:37:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjViL78CAnaH5Ky88K5UOjEVoVeSrFvG7ui3E8sjJn56BeRNXlhxQ5169sCqZmTHXdKSpgbYxr17v0T58XAdXqy5xa3pjwrONgCZ5MG9tnPY28n+HgBOQnr6QTvINymLxhDp//AtxbCI+rROy+eqqq1GmEOmwrywdrB36lxEOLhRyPzxXOMuq42xsXAkL0hxVj963i7bqQSEwKHIf5GsqjdtCcMPsOLyJRyfs8S4UQXVJn/pNm8c2TQx9NR67c1ydf92apA5a6OGq8MUHPnAGjLduffgfHAcv/1T5ksdmY+IM1+gJjlSJ3MyUjwJ6dOIITwknpwKN4jOl2FRszDo+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2e/55SIS9Rf9ZIUmsT2qSQ2x6KkMD4qPsQK9LdZF9I=;
 b=BVQCw4PUFCnXm59avA7OkOMjH1SiUw4K4lT18yuSKoLGfXCIA+yCHoTprK9quAwKU2tmkukbcOjlyaKMPilm5rc085d80qS3gfoWhh+ndfJ3oWYNaXZzwerhCZc57a2TZuTjPg/Bbg0DBvjn94GzPcCgV9EVyXVg1ynifhj+tviOD3nTPRFplQVsYzHeptQ3h02NVKwp8lBb1WQpPWEjBLfS3eR5zLV0kdHqUmzxk+Pfrud7cuhAo6yd/DkLqB/u77/Kw/4ejKNhZy6fLzUmdvYCn/hHMxgqzyJcH6YzWPPmSoeeBbcWqZUXUBtnelnfkgDh5AVDp/TNIOAWgSQqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2e/55SIS9Rf9ZIUmsT2qSQ2x6KkMD4qPsQK9LdZF9I=;
 b=KWUZycH+YjI7bjaTrPXuky8pNTd8aBY75mKzbi4nTu7gKOUbBALCrea0dVCD3ZRiOC+uDnrlyB6iKl4xG2z3N6q0WTPldtYyErfTSGn7yXJ3a4ahet379SGQFDa7OTaNWdlooxsOzvoieUvpczGfMBAWwbNB/iEUrxrH4dhiwdjnnOpp3Jupqu5nwb5bOCoWCMyFu75XNfNRTMiBSA6wNuIxdbuC5x9VH8QlR7Mdb3CNUeHAs8KMwVcOPEaNxd0YSGnkIjDUJylrUkCbgwDI8Edy6N9rq3i85msucSBDmlvad8mov2Qg/kGYtwSziU/wlDlrGTUoqEe6OgLj1YdCCA==
Received: from DM6PR13CA0022.namprd13.prod.outlook.com (2603:10b6:5:bc::35) by
 BY5PR12MB3668.namprd12.prod.outlook.com (2603:10b6:a03:194::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 11:34:44 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::ec) by DM6PR13CA0022.outlook.office365.com
 (2603:10b6:5:bc::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.8 via Frontend
 Transport; Fri, 16 Jul 2021 11:34:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 11:34:44 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Jul
 2021 11:34:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Jul 2021 04:34:43 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/215] 5.10.51-rc1 review
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <87f0efa4fa7d47f5a3b4f77098e8fa7b@HQMAIL109.nvidia.com>
Date:   Fri, 16 Jul 2021 04:34:43 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ced4d650-8884-48a4-1115-08d9484db591
X-MS-TrafficTypeDiagnostic: BY5PR12MB3668:
X-Microsoft-Antispam-PRVS: <BY5PR12MB36687223CCCD58723460FB85D9119@BY5PR12MB3668.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lz7G3RQ2ucBfr2SyDH/O/DMSM6z2Sx28az+w9m9DSKL7/PQkUXsjwiS8cllOcIvpf3A7uPGkGK1bOQwBNj61LFQ8ksMC50m4jVxkJBPtdeo/LCFHdGCfFzvSaUJOEOfNSMifiadYZZIzHGVAiIbAc86EYJmXbA4uASm03tfun0cjXxiYQgOWSSu9ONDdeBy3IjQbAnpqGCYy/aKnn/Npdpzvew6tkBvUNEaLXaDqv0ENOrrLLC2gl4WZV/uRTa5w47WzebMbqESYKZaH0guWcWKIr+VBzVyLxZn5OK3zzsCNBu8MSCStl+N3dBkQgL5HzcQRWkUAUUnfkxI+vgbIDZ+meeJZ+CSZuhgRnXDWbPPt8hROg3QwMoyYRFOopXaBh8dRoJMvLx9Foa2UW+au8T7WAQgVV3UT2/J/tW445JqyHQtXEftt4q2L7JeyPLyrk780oUEdjvCihGAeOxOcLuCiLWqvNoqmG0LKMOM5roPiCLOWtR86Lq7xOOS7UfSlSrDOcy2HmnOqQqGX/pbvgtI4wqPJIdUUfk54gxsRPKwLPYDa5aGuq6PWSK0tuNNCP88L26mkj6nAn7xghWfGwyEYwSNStlPVvDwsl0ACHSKcaWvP634TanMdbMxuhUK7YfkpBY95WIjw6c71sE03ZfdyGYc1el/sdWlXLeokfh2BTcGtq0iOHhrr565C6XUt2d3gLub3+79HTGAbApq0ncZshgga3tA0UlYphCPQqlabnP7piPitlA4emevhV0On2SmhwJhf4wd4Qd/k1OM6yDbvVI0NzftG/JG6AyfE/qeh6YHHc478VKUxajamdg8m
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(86362001)(426003)(336012)(36860700001)(70586007)(6916009)(478600001)(54906003)(108616005)(34020700004)(2906002)(82310400003)(24736004)(186003)(36906005)(316002)(4326008)(26005)(8936002)(7636003)(8676002)(356005)(47076005)(5660300002)(7416002)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 11:34:44.4391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ced4d650-8884-48a4-1115-08d9484db591
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3668
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 20:36:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.51-rc1.gz
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

Linux version:	5.10.51-rc1-g36558b9a3bb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
