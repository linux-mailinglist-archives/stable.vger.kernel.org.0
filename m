Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC949BCC8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 21:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiAYUOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 15:14:40 -0500
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:32864
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231487AbiAYUO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 15:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBYLA23fjL4bWU2QlfHXvnNlgr8W2yi4QYZVW2bRMTDdRCtNFH2Atk7TuUHo6Us36Z/AaX81Vg6+ZZxi4CMZ76OBgExl+Gcae/9CMl0SiSetgHxO0uwt7ILaIx1WKpAAOKRbD3DupANuRp4TyfKCr+1f0Zb4uF9Oe8YvmdFRs8Em/dkixufk22ZAqxlZ4vQp0Zm391EnOuEOlwilLOZupM0K3+Qkjpp5w6gvHKvaOxl8fhj0Ahp2f77JZ001C8pJn4L9nJPBUNBzAuD9CzOD17TyGPRYzz+z+ffIQCYOHoYkJTRlUdMJQL/4aeVzHC7K685meTt39zf98vVa9kmejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFgrov+uaQHr3V507ncWoY8FO4zxFejh3boy2F98tKU=;
 b=dFjs+vDlPfAD5531kKomoi2iQFOuT3aVt45/FwG3qLEcqHmtRlgq3dWdcC+Ds9dB8wIsG8P1wWekwghGV/9Y3HRjqxwmLmIkUPw4O5qtT8272WVaxPgoOSWZZiByCLvxdSg+xgRysm6lL7/WB0xbnBPM/gF0q0gEU1JWUIp2mIyqeVLb19jb4cm3UCiAsJ0qQCZCfChHtck/p5bny9PrsiUF78yNLW+xG5+NFoxMoCE2zcQ6Z/NUV9Xs1p3pcZj1/HqxdDZyFva/r1cEZJ97nujZMppKwrHLsVHZRAHYjN44TMqaofI2BJCjpd05AzDDBVfLU9lmI08GY2980tmxwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFgrov+uaQHr3V507ncWoY8FO4zxFejh3boy2F98tKU=;
 b=feNHJvjEwTFDsmO5Bhtou1M7csxgBRn8MxFQSlFh9E5+4aNWiR8OTImKQyXUx9TFoi2R89rXPmoIgQ4quJuWGpPSCx4h1lQ7ySOTaFsSXd8qdOH/NmvKtRN6wJEfefiizuMlxhfiueh8FV0QtIAFIXQfKYJvHKWSqEhxGw+HQX3IxiK6ijBeVmGzfAiiZ8e9lF/0dU/SlZTdf4WmIySG77EHtnddNlKYZk9FUxLouGnpaXYkFmUcyPfaMcGmRGZZR9ooGM8/mc4i3D08bA0+MGoqfsKIBwlYJR46xeeciJc8YbDpD2jLB+2jlRjyw3lpa3/uU7UXYksXbjvlU6beSA==
Received: from MWHPR13CA0033.namprd13.prod.outlook.com (2603:10b6:300:95::19)
 by BN6PR12MB1763.namprd12.prod.outlook.com (2603:10b6:404:107::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Tue, 25 Jan
 2022 20:14:25 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::34) by MWHPR13CA0033.outlook.office365.com
 (2603:10b6:300:95::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.4 via Frontend
 Transport; Tue, 25 Jan 2022 20:14:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 20:14:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 20:14:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 12:14:22 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 12:14:22 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
References: <20220125155315.237374794@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <04b5f7c9-a53e-4365-b22e-34c5b02119b4@drhqmail203.nvidia.com>
Date:   Tue, 25 Jan 2022 12:14:22 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccbf9b2b-06e0-4088-9fe3-08d9e03f478f
X-MS-TrafficTypeDiagnostic: BN6PR12MB1763:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB176317D4FFA934BB60E68DC7D95F9@BN6PR12MB1763.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aL9V1SDIjNdOaT8nfvj6RQFT7TWmNpkrI9Z8nwQcgtNCCMuq4pMcvsQIdHA666yzq3ZFrk20w1m9BaSuNf0v0DOZjg51ZpH3ZhjM2HDZ+3XhNk6RQm8/lacgyiHdF6jBw3cyG9MY8omqFx7SyUA8eMqR7xa3nIR4PESr7aeGMAI3C3WJN8ER/FCDegThvGkXjqJ55sc5W5wkAgTmW7mdmDwGLBEr4UyqxGIpa9IuP3r/bppw6X3khmR17Md69vbXKQVeulmQtNAhC28eJ1yw8+2WUO8dHThRU/D3X2CVZGOWjfDhJJSYNbcmYKeDs48RbmRoLxXZ54WsofKRWNAuNBRF6kEweMaU/v04/XplAANVT0+3CJBg4Rz/gyYfCq51PJnz4PXPHD1wQd0LQfqAsZZS/AHdSUWEaTsT5/uvRRpoBErINiD0ki036AyIGoPkHzhZgwFi0lEU0jedmWBV5ppP6OcJS3QgPqoZG//lwISNRJRY4JQfDqqlbke6AgPTkLNQEOoIAtmhpBLNRbHhWRv0rGuy8fe3V/VW9kQRdduoUssH88GGbL2XfHacZCwJ2BauBv9NHw59jOXkHfwRZyDdLqjLix9DTux2jDMxOi+GhfNFinOGMGePqOYF2aNqt0AQKTPwkhKo6IyulzG5myBaV1Yy6emB266zHpB6yoZRpSeEVOCcL6fjPiX3VEA1AKNS1yroOlVRv/6OWpk3nS1ze/12505i6/s0bgVA1YA3PdaZJW1nARCfgFMdm7zXRet4NytGSGUgRfm/1nVTKdNyaRoakPepUcNVXBYh6IlWGoCHmTnGkV9xWUXt15Kx+3AcoEcPWrOCBO/wyCr+PRc0wlOzzCMb0hxqlJfHe8ugA4qsU+RZ2IrQg7MHpHsG
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(70206006)(356005)(36860700001)(5660300002)(70586007)(54906003)(86362001)(81166007)(336012)(8676002)(316002)(2906002)(6916009)(426003)(966005)(82310400004)(7416002)(31696002)(47076005)(8936002)(31686004)(186003)(26005)(40460700003)(4326008)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 20:14:23.6698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbf9b2b-06e0-4088-9fe3-08d9e03f478f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1763
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:32:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc2.gz
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

Linux version:	5.4.174-rc2-gb9fb58c8fa63
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
