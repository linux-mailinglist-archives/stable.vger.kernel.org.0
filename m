Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52C4228B4
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhJENyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:01 -0400
Received: from mail-dm6nam08on2078.outbound.protection.outlook.com ([40.107.102.78]:64736
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235652AbhJENxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrY3LWimak+htzs+B5ykc0ad+7mEqQQbD/Sfi+QqR7PaqQXURO+c71W3vL/jcaelt4ZnrdAV8taksINfq+94d1uM6cBTBC68OjMw/+su5hHT7jwnlHfbFiBdT2Y7iHtmOwCWraujCwHSRsAlaNE7ReUGP28gOFfyRvFBYKXInL7ljayGJHbxTX99oPnVLQAl9vrHcI0fy/mlNE1BRIDB87gIOwIt7N9gda1VRt9Y2i5i0ySZ9pl4QnB2nLQpqusHsvh5iy9NsdroCWR5Gt1v7Jn9Yc7A73fOnd6S/dX+MHEB5h5gZBLQ/p7fbkUZSyCqbXbwTJOz7/hrNza7ZLuUDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVMwIdFWNYmGIfq2p+jLedxLbuBh6u9yiYYjaD8xkcA=;
 b=X2ye8+SSicsGSiN1cS2HoOJJe9TAWflbPyVbP7aQbA3+8XOo5znNTtyRbcd6IoC4FI9CAX8n8BTwsCu3Ju9cQ7K1cB9HANTozON/LxU5pmrFncBVsF7W7iRR/gaQeuUTAK9DRMlHIoJtUykRMDMpnjqVbElb+iVt+c2ZqhoWkNLmHolc126+//3Rhd0YrR/OBTQpeO2pLaLXQgY7yL6UfJwPS4gKI7ZB8QWDze2OWajv4TJaWyJWrZ7EcexalxyiOa4ae0hyJewyICiJ/nKotxTIOI+FZCd/Ezk32T6QWY1kUMaMunoctGGhuitCAezqz57TjGTErKz2njPFC87Vjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVMwIdFWNYmGIfq2p+jLedxLbuBh6u9yiYYjaD8xkcA=;
 b=Wac38VfkcMAwIFM0IO+ofRr/ZLShKLTbAGSj2J8EmGkbmArZ57C7Fd8nQyGy1PPyqOIgJfbzToISpF/gv7hZ5jXT90Eo/hB/ZjxTzr3Zvu+kuLXCN8ti5M2eE+P01J+H1FgxlsxZkpDRDxblcsk6EIkIpXIuhZF/zhEB5XS6NfSFqOtIjIQFnfYN9bZZW9+mepJbrMTMLM+IO8RPpMdjba6ig9XVKL56jWl3U2o1rPXDBXxKqe9dfjxBdazsN8sf3S+GKHebsuvqDOvYdYgZcHI7tc+w6BAdrFgHDTCKP1hG9n1PR7vO5o1Hsft4KiebQuMOYCQvwa9zEV8ArIxvYA==
Received: from MW4PR04CA0191.namprd04.prod.outlook.com (2603:10b6:303:86::16)
 by DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Tue, 5 Oct
 2021 13:51:12 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::7b) by MW4PR04CA0191.outlook.office365.com
 (2603:10b6:303:86::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Tue, 5 Oct 2021 13:51:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:51:11 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:18 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
References: <20211005083300.523409586@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0cea07d619ce44dc8dc37cfca9bce3f7@HQMAIL111.nvidia.com>
Date:   Tue, 5 Oct 2021 13:50:18 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d68174ee-a9de-4cb8-1029-08d9880730b0
X-MS-TrafficTypeDiagnostic: DM8PR12MB5429:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5429C9F6D962ADC5F0AA3035D9AF9@DM8PR12MB5429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ur40Mw6F1v8CUQq7j5U6zm12OFNI9tWrtxmA5j5G/4/D5dxXIrqnN+o8dxuLZvbXHHoCClPFVodRKtwyHR2OWd+IKNENmVCkaYUgoFJlgmV6UTiqdjPyuGEBKvSHmU45BYwCrIeIQ1nnOk6KdZ8lhI2gvaWuu+D+NHsd3fgHSSsOs+xHi4/znybIIfVhtCi4PvJVzvTLIFGZGEhxf+78mc3p+BPN4rRXjnEkBJWhmTIY/zxXal8oeZGmzwgGnmmOvqgk2mByAR1LW07qEUGXnHuH2zz/o9K+HsL3OazFhruPcgGZW2SBaI/04N9oabi+ufzH1n3gIfG47L1wVxw2NriOTcEPrSUBtGmhBwCubYRL8QrjA+BabVeC4DRq5qGJTdiP9BuX5x1Wh8wp5r8oaNYBVZ05idDt/LYNIuYCEVcUdR0AOYG7cb/XCDasmTKfYFYFlKegPVn+T/FVcr2vQKgnnZWsxQ8RCHpfzkZTuo5dB+kxihcu2YE5M9Gwo2FDzU9mRJJ9FoxIcdgQ5RIqGTWXWgsLXNHu9hcrmiv7RA9Q3y14k6vi4/cNtX4zkY60pt00I3bfwMYZApgbEE/wS5LW9YU4Sao7UCneivHf5HjyTmBNKrAGBWXWWm9BX+NDqKrpMHf95SADBGkU6dpc7Qlb+RqGWLowyqcc/XGFl1S3tGkvrzFUbMTcOiyetkpFLlI6fVyRXbSxKws8QbMbnKDWMLn8QN4m6GRkn/IImw2uUtNo8WaZkpmIDpd22H/5++ihZfYQwi3PW11o4iBT0KwFhTrknr62UmjSw+JzjH4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(36860700001)(26005)(426003)(24736004)(6916009)(86362001)(186003)(70586007)(70206006)(8676002)(316002)(356005)(108616005)(7636003)(5660300002)(508600001)(47076005)(336012)(8936002)(82310400003)(4326008)(966005)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:51:11.1579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d68174ee-a9de-4cb8-1029-08d9880730b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.209-rc2-g88f9c3c825ad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
