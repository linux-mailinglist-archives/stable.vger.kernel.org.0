Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C640B44EAA9
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 16:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhKLPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 10:43:55 -0500
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:54622
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235142AbhKLPnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 10:43:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlXqO2FVbfgjGJXsHKbXOXNMma6nvzWPzYDGcWj0hOF9/J7gXUtaer/9Hl30D2+ltGr4CuJA8pEa4151Oqie4cteXrsgr60CYW/ge20dG6bT87ZAsE6Z5lJl1Rr1oiAU5BCAn8eOmsLbGmBW+Ee0xWqOd8FZL+yjxnT8+UquisZBKRkI0UNoeN8twgc6MSTDwkkSoQTFZseo8/7wbLoUbe0gcyn7rFxlKP3+efklVQ6Pi1oafsXg6keyX8efflToitbFetXq8AxT3Y1RWx0BCqyFQ28sE0SNYvI78wpMIdGEt5RVdcJtZnIbyP2lv0LQTZvKSSrT9mzO8LZYnD6Muw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CJ3Y3VRP9ZzXI3qpuWmcNx8aQYjH2RhxFJgo2eote4=;
 b=gilNeEQSj4lHQmuGsRkS+oNymeq2KIuplx8nGLgUgD+I/3Q25GwP0Uc74j6POTfyafhIiQFNozyDV3Mys0n1mnj7lHfy1XPT8FMRo1lOouY+r+PZ24rlVDP5rAJag7Km8NPB6J1QVlNenSTFyTRtR+qrdxsH2T4KC1n/22pr0GVz2Avdq4ZejoCke8UV+LXkA4JqC16D/T9iC49ZgY5yBTXswfZcg7R7Tp7fwNRvGrRP0iLJJjCUONRNd4WkqkOkzWCAi/gFaAc1gL73tDYMDJgtVx9hdcsSdwZEWJUGjUUe4ZjXeYihLesNvgTBxSzpTKEIj8s6BPVASLKTOS8w2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CJ3Y3VRP9ZzXI3qpuWmcNx8aQYjH2RhxFJgo2eote4=;
 b=qcLopNQhj012NDRC3xGB3gZ9vhAo3PW+7b2bcs/Dtep9P7uJGDNJ76LyJDBeBP+QkDZFPdBbf7yV/GQEJP+kC8AHZkmzLNSNiZDB1Vcvl4qEufTFE5fkyh/Mi/4JPnz6ubQst4EK2dky3WAPerDNA2hmxSuuXyutGYWErkRfpMsCxk+pZws5WT3lL9JBNatDYqvx6gzqeyw1LllxnvTnBsL9Z2XxIj/dykA/aEZAaiJJwuSV9fg1WQvNqyZVZb6hCCxYxnqZgtUqLu7QPCJsuFedWlGcuWRS+MJsqjNu+1eJTlV23Dfj5J1sDCuHShWOYKciyMAmtXBovl9ZPJnGgw==
Received: from DM5PR1101CA0001.namprd11.prod.outlook.com (2603:10b6:4:4c::11)
 by CY4PR1201MB0262.namprd12.prod.outlook.com (2603:10b6:910:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 12 Nov
 2021 15:41:02 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::4c) by DM5PR1101CA0001.outlook.office365.com
 (2603:10b6:4:4c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 15:41:01 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 12 Nov
 2021 07:41:01 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 12 Nov 2021 15:41:01 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/22] 4.14.255-rc1 review
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
References: <20211110182002.666244094@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <074a9541349b44e8aee52221118efb83@HQMAIL105.nvidia.com>
Date:   Fri, 12 Nov 2021 15:41:01 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf434e9f-a279-496b-ef3c-08d9a5f2d4c5
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0262:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0262DDDF164DFA3441C17E77D9959@CY4PR1201MB0262.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l47+cAAYU0LQu0OQ/ahXz9rjPzaiFewX3Tex6nJc8KPbWZ+E4qCo5LV0hzuNhCd2BCRDwu/JBfiWh8zLnbpQHrkGh3g6Q71tlbL3/HjGdqK3+OYQLKkbhCh00AUsu4rtitTIKplh209kGoBwct3TK4UxnL1DZdEd7gsmRFECQ8WMIzPPSuHs504Erl2q+hjO1nSXj007mRiqA9cXjS/E0iBpIQQ7kAnYvMYQKgzL84N4G4KW4YhFDvXnEgGYCF/Uz4D+NaMhrriA0Q4nBElNKDtemPJcfcfr8VjqvwrIfWcgT1B9E2gPGk35eNCgJf2M3qdbty4n/Tk8stAOqF15eeF2WisCnfvLZ8429fvBBTI1uHl6hWMgRKum8S/G9s01NOkZE6eaKIO7NS59paD8bXyzbX2D2hl9coDQgsmA2f3QooZkbMoz/RsUWJ0n0A9l4FJVJ1KOYriAeEyBYGTrxtZV0DxaIkY0M/1KrbjotApaPYjhzofFg5yymRr/iIDgxlONlgAT3S/NdkHeBtvQToNGAZ7jds2xIVfxLisKwy/kAmJHC48N2M/e8ej0wGhatFaDzC4zVk44asDp/SD2NAKMBEYmpRUckwJg+F503KCAbe8FhDYSqAQAqGQMLNs3/a+z9vjqR5U2IWhOWQQ5ohQ9jwmbNQ1X1ME9rl6b6DOrF0vdgggJifx2SN6SNCKPWS3BAjmWuU8X/Dj0MsN/gMByc5rRGynq854B8EiHFxa9fvfi0gRgYxLSnHbTH4J8YUx9WiVeW4CIxqGtZOkaYXvjZ9IIX8OO83Ji990CGjY=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(336012)(426003)(186003)(54906003)(8936002)(108616005)(7636003)(8676002)(7416002)(26005)(6916009)(4326008)(966005)(24736004)(47076005)(86362001)(82310400003)(70586007)(5660300002)(2906002)(70206006)(356005)(316002)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 15:41:01.9046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf434e9f-a279-496b-ef3c-08d9a5f2d4c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0262
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.255 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.255-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.255-rc1-g0e0c342dbc36
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
