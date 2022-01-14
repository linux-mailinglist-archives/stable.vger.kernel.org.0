Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB87148EFAE
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244076AbiANSKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:10:02 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:22112
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244078AbiANSKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 13:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE0VF9SOoShAql9nlsJ1q18kifBzvhD6LEGe5XxXUrQClQ5vri4tTuB9FeSocdw4HKT9pLyIzxRlvYzCT/jw8XUHkupqdT2N56Lxb7DJnyKEFQNMRbrO0gvYRCL+tJD+RhFzJ+n9ZpiXuXC4T2+bujPQW6IH7qUcx476EHfyo5wwOe800r9aD8zD6PukmGNHBuB9qkhQIh8ikBR3UzwcEsG6q9feXVmX3YiSRxBb3c91tsQVHHpNrVP5872kyB4X/kZ+q9OfvRlCIarhuxMxhhceLlCk7FbUwq397HkPWzyyd/ZFtqc73vRLQ4gIEBwFFpox2DNZ1bOneG1pgqmV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfmEE9QcQhVVr/QcUu+2hQ6fZHRoOkWCD+gtQnnu4Cg=;
 b=mNypAuiaHbtFhVaJ6ZFn0xB7KMDQn2SToYNikY9MpaONy2GuN8A0+INE1ifANk+XtE2eFD6fOTy1rtIn1y7gaM0NKrdqm8u9DPxXLx3SzWKId7X+N5zuER04QFLmtUSALIGbNWo/wXgTfQPNsaNNfgFCjg3kxlchVeo+Ex3ok7xklknNjORf6yRsdXiIdsSjkCzZ8Vi1ECqT27s9WosUv05lohmJIFPkPBrEPaHap7GIBRauYr9lA8bfdGqcSmNJUkzDp2mSyRiX3Z11OcB1d5X8WUrpgL3haUGZdUm9DVdl5vvnLFW0hz+B/tIjBNz8E+hnn3n5rjRk3u3tbAXB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfmEE9QcQhVVr/QcUu+2hQ6fZHRoOkWCD+gtQnnu4Cg=;
 b=qnaMpV90zeVxZs1uTfMErsk75F+KxaiPTnbsIHEBC3062fe33hIiad/NuEYtQ1f5bDegbHpsnhl88daRvjWCQp7YCqA+weVX5F5+96MF+qCjZ7K7QH4UZU3y0OQiPLPPzNofT4nnJyCv+XqLPGhuE9iNzh7nV9VQP7hDVHQPdpiqn058NZI3odFrOQUhUQJ9KhVpk/EOQIjAAmJ0ET6Pnc3rbiSS+mT5FtoxRxz/bHexa3VB2CT6qCj8uhK6J9XLLfnPX71LMANRav9OC+XarOa0rx9i7hwqi45rE1CebOErJtc/Z6XXfRTuRO2RJygekjAXcy1vWtNvAlDzfmO9Kw==
Received: from DM6PR08CA0023.namprd08.prod.outlook.com (2603:10b6:5:80::36) by
 DM4PR12MB5295.namprd12.prod.outlook.com (2603:10b6:5:39f::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Fri, 14 Jan 2022 18:09:59 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::2) by DM6PR08CA0023.outlook.office365.com
 (2603:10b6:5:80::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Fri, 14 Jan 2022 18:09:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Fri, 14 Jan 2022 18:09:59 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:58 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 14 Jan 2022 18:09:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cc2a3e611678474a91974b954114844b@HQMAIL101.nvidia.com>
Date:   Fri, 14 Jan 2022 18:09:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffb0f765-1109-44f0-9289-08d9d78913bd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5295:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5295F56F03F04574FB939D77D9549@DM4PR12MB5295.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0nuhNOSL12jB8DvECKM3SxopRbb8K+7dyeqnZFjvgBRQPXDOJujyTeCMBq4n4fRTBdf0ECfkHrroPHDN0Ki2v5YTrgQv/rnAGy49zU0l+hA6ahO7Z4sewbcqueCVb1WBY2UHmXTpJ59li4/N5czQDWpg71TG97ghrJ3Y97bQRS8i8gWXI9OSFGBSiWdRr4FonU7t2WDP/GbdsWPy0+qf62EwY/4sZ2q7bDYfQBscF4jiZNgkzkraK96I/ANV4mxgjcNAffd3Xdc6fmjyG3KAUUC32QVmyBjOTcOJvpPt1o0fBUeadFOiJOcn46GTBA51oMYTGJ14PZ7DDeMHyjoyLK8gCbm/MUX8uFtH5pSxTONd3FFrupqDYbXU0d6+X39NFf8C0BpX2zmWK6MPw6GehCGUEfmoE5VVd5u6viZqpC94fYOyAzciBBIJQQA9aBU9qB7q1Ytf8PpQ8PfnCu8nST11ClmSMdgbJQ/4fhot5yoLP0Y13OmWEiX5qZwPPP2leNKYq1TTTvXl7YQU5QwglziRMpdND0HK+ZJPELI5JACdvgD0462+aNO3pQLzwtScBdxZnYoJ6wP4gNIcY5f20wNnhjNjea9sd90WlsBevs668bpnOlXF3ORGEK58aHzi5X6yFW6UgIAANSuQl+nLQ8C/qZqzcj0//YQTeCNr5qYhz4y3LHUu1HMMNsNhJ95cVfY7VZR5u6h7UEEApyNBbirklWiXgAN5WT6OtBPvRinH7ud8ArQZBC/GuFVS/Jl+1+zC86CS5/aqpmGr9c7jwP9U4TspHTA9e7fP6UJ3+4zEz29uLF4gMVdjwcPXH/wAYckH102WfHD118adZMMUgs+0paAYzlZ6MW+lcCHGyvh12PLcie278atbDx3fYGhn
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(108616005)(47076005)(70206006)(6916009)(24736004)(186003)(26005)(336012)(426003)(70586007)(40460700001)(316002)(508600001)(54906003)(8676002)(86362001)(8936002)(81166007)(356005)(82310400004)(2906002)(7416002)(36860700001)(5660300002)(966005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 18:09:59.0068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb0f765-1109-44f0-9289-08d9d78913bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5295
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 09:16:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.15-rc1-gf9dc3f25c12a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
