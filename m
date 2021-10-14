Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79742E154
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhJNSeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:34:31 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:21281
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231618AbhJNSea (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 14:34:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0ey5s6Qymp02YWO38oQ0Nd7TxxtJF5hTs/IpMKNhznIWJ/1CQTUCGPLWad98s6MuAJTX/0XuyTQwgWTqIdvPybyFwmrhP9pACDnJhDuYorSnuwkbtyRm1aAwpsiU539v365qKpaDYeSf+wesT9mT6VbO1ttbMIGcvGpjWzrbqZ7UBu9F7DwOSrkIh5QSvQZBhHpTRebHcrExdK1VcY0VF3sDWGJUGYrCSfrwrHD1gIiwG330cOAyj7M7VSJuutjG99jHTN0gDYphbLWv2GGwIrYSPPJnbnLhgpUHQg2vubhlnj/apGXyidk5VyJBu370VB7mIEqd77IV05Fw6gwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lz6eTowOIUTeR0wghgGuFOC8fEQX8dtRr3NVGMjeBqE=;
 b=d/jodc1VAHuZm2dg+QsaPfcDLOARJIyvLWZXty8MRZnhW+40groBIHMK3Un0VXHsgYER7DGAcT58ws55OhO2Y5W13SK/EvkF+IQwCvxCCttr4YEyOnHrLz+zow+4KGsp35GBaIIaf4KBQrUT/cEVUw9nMZEmAWqH2yzSqHL4jZt50VsVIQUyRshyFDlevgMH1VeGwe3rn00tkpO3sKf+iHl1M+BD9Yd7BjF60QxGfeY/l+T05HvOUCu1O6tcFKYrcrd1bNcbUDqGv238jOTd+lImAabdi5ds67ujA3sgqP6GO89URjYQWtHEFjFHvrfBIrdvqIdSubsbjgl6rCG7pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lz6eTowOIUTeR0wghgGuFOC8fEQX8dtRr3NVGMjeBqE=;
 b=Mu5u/zDTwdZFLG3IGs9+pGctzS2GWjaCBLh0gR/StBcRYKH5G4y2nWw8YW6gUew57bmVtmsx0Afioznf7pVmR+zIrbWOvNI2Ob+5WVwhYsvV6PdUI8Vzo0GhRWigYB/tWNWn0XRgtSLXT0zSAZu1QLSEMa7v8yLhXzZPJ24bXBiO+aK+sW0pbIz3aBffV7G+EH7I22TA5sv/y68cnVkyz8cWVs1gImkPLDCE0qjRmYt3tHeJJhwVo1kIYcIkYt+fcW75joD/rxv02oD9ZquX5Uogc0OsSBW2Tfgn87DERhlon9AV8gJRS8IzmxChZ+PgyDnq9zFbtKlOV01n+2fMsQ==
Received: from DM5PR06CA0075.namprd06.prod.outlook.com (2603:10b6:3:4::13) by
 BY5PR12MB3953.namprd12.prod.outlook.com (2603:10b6:a03:194::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 18:32:23 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::81) by DM5PR06CA0075.outlook.office365.com
 (2603:10b6:3:4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 18:32:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:21 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 18:32:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 18:32:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/22] 5.10.74-rc1 review
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b4bb532d17c849ea8047fbabe7ea93fc@HQMAIL101.nvidia.com>
Date:   Thu, 14 Oct 2021 18:32:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8425d304-3d9b-4324-e16e-08d98f40f68a
X-MS-TrafficTypeDiagnostic: BY5PR12MB3953:
X-Microsoft-Antispam-PRVS: <BY5PR12MB39533B422EA7865692C8D3B8D9B89@BY5PR12MB3953.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XD0K8iIM8xiQ7/lHchb8b0NhFyHJ+UYF3qCoZYevtg2eFaUBATIcJMqYa0u/xhd2TvcrENSt6j33lXztdoeCc88ukRwIRcQHO/VfsmmcS/LGMjCXe2FABO9uJETWVBJx6FX0uikxnLDVxrdx2NQSlBNKwKeV7QsyqXpQF3G5q600Z27vb8oevJoRRN52Dn5tWq0SFApYOkP6FIBOeDi/b5l3yzTJHy7xufaKVOKvor5mZlgUkAt6Z4+6KJN0i/QxsfCqIt+WmC6Op6Fb9a9nER8zUjghegVEJj5Zb20fHvxeRgX1Utq7hkYWnIOjUC0Rcit4OMMxpHhXaM3c4qOqV2BTWtOVbF7NRZJtghBjpYZyuE0Btfv2YqUcTfBIiAlOCWf3UVBlCG5brIiDGdTvMxnQtugZHZpRaC8GW79zadluaKAQtB8oSc+MwyfMeFB2r7l61/Oyq4gg+wo8WegE27ghV8xZka7//Z/+XgNO2TaOpQN2eyraeAB53Culr+Ev6ksNCWnXy9X3+sVfdTfcYgzIxHWGBFgcz+PpkoUC5inbZfjlXg2XbHqECqfgjLR841cPQB+PgLmWwtGR+wRYAXtVAfXhUZdSAciSNUtrcsyswdTAWaB43FuSWF5xGBpDhhcodQ2OHIT4lujLzNvF5DcgspeZ+FhYH8lAvwidoUnDprz6zH0g5m7ZZTukqh1JUcNPuLZxaczeT7OKmjUG50oVhwWLMat6hM+B7MxE9duNpaJbRNkxXx1+cznLu2I89wnccsxB4vO/HvK6s+t5bkfUh4AxEetM8EGblofIguQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(70586007)(8676002)(7636003)(186003)(26005)(8936002)(356005)(966005)(7416002)(82310400003)(70206006)(508600001)(2906002)(426003)(5660300002)(316002)(47076005)(24736004)(36860700001)(54906003)(108616005)(86362001)(6916009)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:32:22.5522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8425d304-3d9b-4324-e16e-08d98f40f68a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3953
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:54:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.74-rc1.gz
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

Linux version:	5.10.74-rc1-gbcc91adcbbcd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
