Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10088492FB3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbiARUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:49:47 -0500
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:13409
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233264AbiARUtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 15:49:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYgXYG1vQpRTsGZtFC5cITLxpZAuQO0eQF0F0I86oDOLJGdskDVQzPjC3ZwenlH14znabIPaHPhn4RVasZk1HQWX6wKd409rPwq8Lke9rFRkbnO96mayk/ycmoMy0yyQi1gt3yhLweUA5Xmfa905+FLRSXIZqnP9OY6jZr90TFiN9rxTXqyRWyDm2IHDxGKLCahO6FTEXbz3lUzS60juT1yWPrsKXLyAxKs3XpwUW6L9d+bW2xnMLAZAbZTgWkjW1nEzi7WKo2RNQV8XoWZLvsL8sIK4FcyT3k0QGA8HOlLiHip0Y8UKz5mFa8Vvo4y/9tlfO6TGpBc9+c423Wkkfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUs8TTz0z2YgeK9csyPRyxxuhiQj4sNLjyzqYvXsceM=;
 b=nf2u5LYllQBScST7Pa9p1kM58iPoEbHanGaLQ32nc7EnlFDwcmTJFuWanwHoaR3BzGUCB6x2oZVznv0Q9xmkZR7+ejBpBGWb3aDzSdgesRg1wuGvMwo81yf7Ti6oTK3nm7qVmK0WiNGeAcf4aVQ2tvWXtqFQDJIS3cRI8Qi+G+Uplu2svJY7vUyVvZVI9lhqQ2OGrYImD77JU/QhdR7tqd7sdfFoRcNhGiLQJgWPnm3keeuLjLvcuxS9aqkFJu1Z3CcJWMOOQVEKl/afgoRym7Dr0Y9OmplH3aoOIVjtn/YlkFhJ+ZDcTnQV5ejAEmetECwIMYBfWM8UYNbi37l7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUs8TTz0z2YgeK9csyPRyxxuhiQj4sNLjyzqYvXsceM=;
 b=StVH2cNuenMxTy7qjJ52acDQFHSuik/ZWu73JQK7ZfZx/tS5PJYwbxQ1/XtcVdaEldhsEiG9XHhAOgPXF0zo9Yc0mnJnxavZ5oqlkyUzPGZ/xbzUdd2GrWVuEA4rSBdwNg/iA9sd/g04MYbb6LEYySy7kqDz6EcX3yMRmD8w1GWvKpGVULzjLrT6YbT25ptggG7ncKZsF/uYgIVycB9F3dkduqPcT0M+x7OgtFQCsCfgXLUs9Xuc7nRsAW0/5SXvrp48HYlol9sIrsQTKKkk+BE3B+WxWEK8p8fu1/n0obGrbX6FMilIL6ds7nngTtCS8Q5neAtQX2NNUHXgpXZCuQ==
Received: from MW4PR03CA0013.namprd03.prod.outlook.com (2603:10b6:303:8f::18)
 by CY4PR1201MB2487.namprd12.prod.outlook.com (2603:10b6:903:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 20:49:44 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::5f) by MW4PR03CA0013.outlook.office365.com
 (2603:10b6:303:8f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 18 Jan 2022 20:49:43 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:42 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 12:49:42 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/15] 5.4.173-rc1 review
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0dca5efa25fc42669cd284e5c3b7f6bf@HQMAIL111.nvidia.com>
Date:   Tue, 18 Jan 2022 20:49:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52cecc1a-b39a-49d0-a187-08d9dac40e0b
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2487:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB248769B9351B325F95597A98D9589@CY4PR1201MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZLnq+d8TK7k2d6ByMMym5xeRE5hYYnRQORk2rNWBAFi8tpMzdL16D9a/cBQJSvZQw14esAak2SSsXHn1dbYtcJqJjuwF8Z85iwJZurTvXPpTRvKID+69ac8T073hOx00Hl8JQnMzu8cqg5/J0wCIFmFdn3TMeHXx4k28+koUnvQfDGaQ3FrHDjknumTIS5EpDoZ6sR1OYMu87hkA2bRNMkB33gTb8+zdmMFwB/JaEM48DhkKwKwBj2ff9SxOpoSB10CbIOdLBlA/olFJRhW5QeRmKm+4FOBAAQ/0iqMj6MEomw1Vl0nFstWVxL00bfTNheguXm8pmSGDj7e6WA337lWqosVsFy6bGXiQ4NxfQzJmssGUtveBuwyygqfkn7PkdXrhwOotrAYcTzfCF/TkWMRI44PiBOLqHs2okN8u8Gye8Xm73bcliV5ocMChg+N6u6ldOVZzESOPOgb7uBwOUE2FZgRjJgvjKXk8TG+3zCvNNqweRZkK51pKRRg4n42PK4TBQb6OUr3pKwTCOcCFAfktFZS6r8TYt3dyQSRLs7Gc/J5iXzedxpcEnO3pv5JU8EBddHl2XRD8YVMHypyT+49vgV0Rpqzv+yUpwAoawu7E/PzqndXcptzNKrtzAzX4ymHLe4RCJZV0/LfTbVe+Nr6d4jfwuLYtUBo/TCAEM33u6NEcOjyGwyy0fCdyHnozpiDhy/PNTh4c4miYvxfsEFMocFJxdig9h3ZGbyQ9yOibg9BfNu5CMhN+i/aB5CnN6+1Veq8oM3l/Vw73koxwZP+1bgVOGHFz7Em28WWZa/tYMGBMB1nNSxCoUX9m3R3j49V/FVZvTUbMi09XemkxvdtKoReevhdK09MVv7i3OMe/Uk+rsLkWymceLfBc2o5
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(2906002)(7416002)(6916009)(5660300002)(108616005)(966005)(47076005)(356005)(81166007)(508600001)(36860700001)(70206006)(70586007)(82310400004)(24736004)(316002)(426003)(336012)(8676002)(86362001)(186003)(54906003)(8936002)(4326008)(26005)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:49:43.2318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cecc1a-b39a-49d0-a187-08d9dac40e0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 17:05:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.173 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.173-rc1.gz
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

Linux version:	5.4.173-rc1-g6a507169a5ff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
