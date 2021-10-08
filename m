Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B288426DD2
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243285AbhJHPpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:45:54 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:8128
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243182AbhJHPpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzGZBbYxUeXUzk8ONrWxGflhnASaaGFyLjrU0A8RX5i1HmGOr9LD3UPpZny3SDcWp5K5Vew74MgriOZS+qEAzt6Gj3HpPgFzOGATJI7WT2fzyxpQgO9nl19/G2oDJyJpq+lpg6RNxdwsGX+cgDlLzj04BHOhHLeD8LmLEX/YieQVayDgb1oPvAWGg5R8vM0k84y+wCpPtvdCRPvc4NUSE4DRZfedq2MWTlBOTgt9zidCl6M9mZC1FIVvDYs5fJC2Ur+iOJLVtUv0Em12dHZkydZWbcKwsNVJOOQ5DettfH8opHdqcy5HVsXA3H9BJVtdT1PAEOuO0gsj3kBVk79RFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJN/3n8U6uFrO7YexV7G45zH8BE8wZkqgYzIGqfZItA=;
 b=ZtCkTykKcCYiszcIFAoPIJfoo+4ygpfVNE/V3ckE+TLQYFjrCXzA223teH161mAbXdnGy5iB5UdoA2wFAE6r2heNounbqNjSAJyLzsqOdULO8KVyN1/js2CgM2WCikWIrHuAlV/vcIcWU8OONIER7hWic1gbiYQx9oco6hovGOCQSMWqErEiZqaqaympHXvXHC76sOEVpYGS0FP78O4m6O0BWuZPbZnvN7Sn2iMy1hq/udL/OvYvxl9HR6fpCIBr5WgGVcxqltcQD/CAgRTwOwnQ1+gMi9fZPuYhUfdBRGzL7WJ3RG8vcEu8H5c9gQFBsTW1PdxgrRfKl/30l+s7qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJN/3n8U6uFrO7YexV7G45zH8BE8wZkqgYzIGqfZItA=;
 b=gbcwsvSeYsnMJbYeeJwrPzk68ZEMjXyji082oKc0SM99ZEiSBvEP1dhLHCGfSwTjFlmkAHV14NYtPZdNBUKgm8RBsDTsgrRK9k0Eeu+m4h4fcjYSgeTWUqCBh8lBq/FLrmhIiu2eMFj8BwnkCrfULbrN+2H1hqSG8NwEHcm+G5ga3GZnL/dpLCU/ibnRwaDh2AyA8vJW6e8g7CWEF3sBKpUqEOCmQvNg5gxYbkSMkdB7FkqCOQ4fLJO7ENMmWEvhJjbQviA3IYh0UePBpfJJFWsLofjTJk+106h/vs1C74vdDNOKL2TzWJ4wqBcSyg7UWMHFs03TlcyBJN7uA5VtcA==
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by PH0PR12MB5497.namprd12.prod.outlook.com (2603:10b6:510:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 15:43:38 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::ad) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/29] 5.10.72-rc1 review
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <02a17ddbfd954e31a9b04d46c68f0e12@HQMAIL101.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:36 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bf72b02-9254-4cf3-14c3-08d98a72655e
X-MS-TrafficTypeDiagnostic: PH0PR12MB5497:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5497AC5B747EECC6BF893E7ED9B29@PH0PR12MB5497.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxBBIOhEQA19ZUdjuQ+6RASRzD2d3c9IKrJcWOobzERYDVmkclGUqQPJTCDL8OUGlm6ayfGOuyhMSPRR4HTN+8vYl12JdxpD1EAFzgqIIPX71ZBHKrtl2UtP7tDnaHPJJVy3gK9WVhX/v88VO/8ij/zRBWM2TdFe0MEwYTaS5yveJ3WUeGPAHIcKQ8blesJSgMN1Y117cuLIvgwkSgw7+8m2dtKX3xGS2zdmd5pQpHHqGopgBYcNlGmg4ACCu11YnCy09ffIa5HywKEgCGPcjXilL8VoY/xDNXlXWrFZfxfO+g9HpjKPKp/2860VooGzS11QziWsWI4F3aHTn+OkHdZX9je9UUK1KQoB4U87XaZLdFlkUImW33utCCWZ1OM6hFTLmvlD5BPyr/OJ8TVcwyoSmzjl1cptddmtO+4ua+QAaCYJGt4zUHd3MIr7d8CDlGBXpXozOlafb7caIaX6/Hr0OUZ0Pg+0ykSVRF9ArntpxY5x4O/ML1kRqXxu0fyhl6SY7y8gZJCaV9VDnygZbSkITMWF55nHaWCl42vOEKBp61agCyR6NCOBsdeKbRgrbL1KFEOthYTIvO5tsqTLwXkPggufkI2MSfWm2IqqcVCKAVXB3TB0w7AuIN8ScImXlYQMeCg38H5eliEkflsukTz4SQ+MLfQelJD6wbYTszOp4H0bUgfQvOTV7D77LnxzqSh0u7/DhXX7JAC9u5UPUEGK3s8HQ8P8o6W96Q1j4acLd0B6Iv+XmIn5NPQCuElsMJLWgRz5feVRUXaTVTS9sPIO0eFIEPtd+IArG4ytLPI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(316002)(54906003)(508600001)(966005)(4326008)(70586007)(70206006)(186003)(36860700001)(426003)(108616005)(5660300002)(336012)(2906002)(6916009)(82310400003)(26005)(86362001)(7416002)(24736004)(8676002)(7636003)(8936002)(47076005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:38.0125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf72b02-9254-4cf3-14c3-08d98a72655e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5497
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.72 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
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

Linux version:	5.10.72-rc1-g1164874f979f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
