Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0D84897EA
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245059AbiAJLua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:30 -0500
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:27489
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245026AbiAJLtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5SCNjfel0kGehih/3I5dj+sZq5IMM9oEyeIRhSoC0SaqSF+gQ3zv7+p9u2TvROhLroLP09P7rz1f1rTCfzCaYR+BFttb8LAhnd2E+gG6f4dljY0+/UR+cA0snatgQCynGAHdhPXQRPeOlb7QCK/LVhYDR2LF1Wm1LzlGwJ7mbz8iERpqtjRseSQ5ylDZY9TUV+DQZMIpC9Yf4+YfRYzLDawOqsxUrwidJJC11P1lbcKQ2GgMHTpXiyrIsJpD7GoSs31DAjABKHR/2u4Rx/n+eMCqJr9DW1xySVrlqYdYBU0Inb+YsaabVu500XBKPUni46LkgPrYS+X2BzhXOsZEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktdGL4A55HhAt76fRN+UKul+ZfZAUa/S6PbRq0lIeDM=;
 b=iZSBDvkoo17fDX7kfcNbT/D4kSZ1Bm7+qRWILi0dkCfrgShL8KxKnQhXI+EmfoHrP0HB4KTXpzN/HeplGuR5HWH2x5NOwNBaXSHHHsvFo3P5V3tMDQv8AIPzQkQb6Zzmn5PyHyc7wZBsLgOW/pKd/fPgO8QC6AamxCWgc9+aqyg43BkeqdloJYQxDo5GoBs4FQ2xV3OWIywbXm6CtHI/esACOEWclMgb513Iz1yYWuIgWLiTJLjEe+G2dh5dpyICkTxamqvUkPrTDWqfVJgj7kZSuS3R/G7R2IDPfRqlWNvf6hdu/I2uKbhzlVx2j/WykmUp3voSE9BdpfAqAMkKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktdGL4A55HhAt76fRN+UKul+ZfZAUa/S6PbRq0lIeDM=;
 b=c3iz6usiuI0uYQXe92zq4Qw2FUxyULBKKUrGaniVKKz0rf7HPtp376S7Txy+T4wFwDI8DWrSajWXucfjmrV5KNy6CDufPCa1/TSI5p8d87+IRXhLQ+LbKVOQnHp2kmHWIp9N3dG1Ju7kVJ/ea7Cuoq5SmjiH/WWcvrgbNACRPWs1DqlUHAG3/I+5TVZVzlX3fsqGCcEM3dJ/uyzwMHmTeuucHWHBNWmIaJQhLjp43skPuAekjWb1E591kJSQRLVpelvVM8jblGlqq+30QakDBv+DlrsOtwl/zbdY//SkVYwAnmxiHH/7QnQWbqdliaVzvah4bTK2kHQTsNEFyJAaog==
Received: from MW4PR03CA0042.namprd03.prod.outlook.com (2603:10b6:303:8e::17)
 by BN7PR12MB2706.namprd12.prod.outlook.com (2603:10b6:408:2a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 11:49:22 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::89) by MW4PR03CA0042.outlook.office365.com
 (2603:10b6:303:8e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 11:49:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:21 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 03:49:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 03:49:20 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/22] 4.14.262-rc1 review
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
References: <20220110071814.261471354@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4360e54d8dae4e00a664531e38e34cd5@HQMAIL109.nvidia.com>
Date:   Mon, 10 Jan 2022 03:49:20 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73705771-2c7e-41ff-d567-08d9d42f3de1
X-MS-TrafficTypeDiagnostic: BN7PR12MB2706:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2706E053ACFCA324158A1B1CD9509@BN7PR12MB2706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q6MJDcNJJ6l4qjETHeIuyBbb+ZXRf1Pzb8b8iMmIkI8MTUYUSJZrHsvTbr7Me2TQK4/aK98CZMcpJaT7lhYE7jpEy3UjqGTy+bJQU1c7v3y/JmbsLot9p1jro73IRmtBygm0FeMa4GQRQJ5lPfc0Y4ryKqazYSGdRPbpD3SoacEeho25+EJeuBpWBkOotJxnNcZY2hnKgA1BG6CkaaLD4DgSROzGK41tFcFP5XkEx8XxCJPd2ybu4fBIYZvHjyU2Z1HS/xQYO5n9ZWQfXKA6a+SRvf4Ycby5ReAt/pvm975PboPT0XbNezGLxQA9OXgkyeMNmPE6UOhYXEDDnzDS5uUlpEQAhOvV0M0vqIGSB4vBhNiNPRUJ6Xc4yTCCzUjn/r1oE8oY48wYYqDgjV+PQ0NAopzhLlo34BMFCjB4P+0re6AxQy/5nHbrCOg4Akd86HP2CB5ZcFO9rAg38UJihPSeawOv/AFDbG8kMBcqnXRhglquZkDPW+afrk0ga1dcgtH8ZFgXtFtts8yukQXT05/C7Jc0S8yekw0Cx7STD7pEwMUi8TlCbNT4/XJXCTkIIfRwOLAnEybDwNCXm2n3SejNZjszNEvDyWNXLm6gf/tgnlCjxJZbPnZSaZhdYvNPxPEHp0gfrpxelWoB6TLvawpI8Ji7woTqJoX4NJAQQlsxQeIaQLYHGVnLOrTGkjOtfitQoFdT6FjLUcD+8jmubqs1Ub8hm5o8LzjSS1AtalEnsVNCFekWvAWWo+1amfHt3vS4gC4jTZBtu8CIDxkJ97ynpAeoUUxT1JxJ8uW7FL0nnlXmZ70gv6x3s2pgYwzrY9Yk6/GnY7MQmKEcr8saxUsKu3xgwAej5f6LFEM7clMR/7NTUcR6wa6zJhhgpXPb
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(7416002)(8936002)(47076005)(86362001)(81166007)(70206006)(36860700001)(70586007)(40460700001)(5660300002)(4326008)(186003)(336012)(316002)(426003)(966005)(24736004)(108616005)(26005)(8676002)(356005)(54906003)(2906002)(508600001)(6916009)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:21.5304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73705771-2c7e-41ff-d567-08d9d42f3de1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2706
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.262 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.262-rc1.gz
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

Linux version:	4.14.262-rc1-g96488a6934b1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
