Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE6349F813
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348118AbiA1LTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:19:07 -0500
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:36705
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348078AbiA1LTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:19:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4Pnjdy1echYbX6RYqC9ieOLs0yujcsS2Du5m5jxnJwHEEaT4tpd4Stb/FtjJqoCli18oc8EKz8UkNQOtStWIBJsEn2+oRDZRFDxaBivtAMf0zBBxtOr6ayIFsTVa3at3r4ZXGNQPYFqxbi3Ai43qJMgaZCMY5z0HNE/QZhcyOga0g0/hQO/qWhySMr6iLZO19PQhUHTHm3FdGmoIrKuCfK5phYcMdST0njKUnvnJ+Ykmf+ye4F35qIu3Z2wK03hVkCBzY2L5/LCT8XG5JgNWAkMJcUHnH49ZTnUOcD3CpMKmGwE+jbwIXY3Lg5k2DAhddrdvmzGK3Ixa7FWfTJspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJoZjNJ6IaT6Ym2FUTqAFPNp2TJfWqAlw7HuUFi25DI=;
 b=dkbH4+hNeae5ENnHXnxUdEwhTsBSSzRJO/oGsQUNbXmmHYCp2LN1gUAGFveJQC9DedKrxW+ZlCbHWboFzUSGnyDj7bYKdsKMYRCSpynizwbkjAqr7uxzVWadwNYdIHAPq0JekfpptkWLr8KK+ciXhTNcYQROZvtOGW31FgEL2ldOlVORG8M5x0/ha7tIWCf+SYatQrDtZp5ybCPNnm3aD1nKfwuJrtwNRcc6+ytKEUhkmR5b7jydOgtyrEKCsiwLaTLXGtrTZlrMp5EMdLrIKchYzf/JDiRrNwLWWTnBWbdOw0Jyz7aA/ZgiJftmcRvCnmNTi+XqBbkgQN4jxV6uvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJoZjNJ6IaT6Ym2FUTqAFPNp2TJfWqAlw7HuUFi25DI=;
 b=eVN61hMhoCEATrdDktIlIRE3TuzjQcGCI1qhSwb9jdVRHEp2gxiBf21ET7x8dZCoez3Df0Rs7CeGg8x+PcQwaIc/kNRdS+zD/nnCnR0H7AFJHaHtugYNGvejMZPQZyaSOuCJh9qWZ3d9Kku3339WcM5lmi12ITaz0vKpHGbi4aM6ZZj1u/Y1DcKDrp2SaytMPaPG23c4+xuLs1Qz4KpJUEBvo9NsPJN4kMxDfLWbgGqSczII+kjiF5rTq7jlgM+RwuHE3HOF7BSa9kNhkNiRvQgT3EpYW+jpxJpAmhNyAVO1Gn3gSh+aCXRmkrjzCRNcktC4AJFDHw4qjIBH5yuIaw==
Received: from DM5PR05CA0022.namprd05.prod.outlook.com (2603:10b6:3:d4::32) by
 DM6PR12MB2826.namprd12.prod.outlook.com (2603:10b6:5:76::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Fri, 28 Jan 2022 11:19:04 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::ab) by DM5PR05CA0022.outlook.office365.com
 (2603:10b6:3:d4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.7 via Frontend
 Transport; Fri, 28 Jan 2022 11:19:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:19:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:19:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:19:03 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:19:03 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 0/9] 4.9.299-rc1 review
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
References: <20220127180257.225641300@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <743a845b-6d28-4afb-84e1-d334bc7c4958@drhqmail203.nvidia.com>
Date:   Fri, 28 Jan 2022 03:19:03 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e242e859-48fd-4476-6c89-08d9e24ffe1b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2826:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2826D554F6BAC335048E156DD9229@DM6PR12MB2826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvrNlk2+IMhqWnuGhfetBa8TUFui1ePLVK/PPzrxlGKLy66nwT/70apvqRBvlGLD4a5/FVcavtpWQMS+piQLb35zEnXHeUxjT8QKytUtaxA6nyv/1W2f42uuqtpLHbdQd8LMj5VNucpC0iDO2a3woOftrfz2j75qtQaibQcHglY/X+ppAV5j/o3C/DjB1S6ACx8mfdLcpMAylwQlyi3KNhcbS44ChgiemHdqxxdZhJOxgCBzQS8KUZawpVLs86OexZ+46Iil/tJk5+XUromxM9f2Www0/F7HxfBjy5RZHQRmw6bJaYuvnyS3cIDdA/ElI/DB4/htsmFNEpNtkjObQFNZfFxWOjWcfSYIQeO2CKgEg+X73qclK4WmGib9vDelw2CsjRfnoblYV6/bWeUyiMAxEIDtgqnRQyTyKDoBbaX0oSmZWy+J7r9Q/uz+Gcg7BcgJ4sxhd9vTXBnTM05zoA+gNATnn63CHT/Jfg6Ve6pdXyjekuczPAHZ4OxZuY9Ac1PUqgH2hH3sAqCvphmdCUsj66TWwRLin/ElakvIKLJrLY0LQ/qUqSzKWrrOafL2a3NbKjFtcY2ZtEf6kCkHqyGPpdmMT8LAUSrFsV/smJF0mmGMmhy6PpsCR8bmIUooxamkswUoeaZHXR5XAFvwzbeDhNsSThdjr0OZse01tZCJUjlvGEMLPMXF8w+G+JM25fVvcLM+klPKllP1XEvh1jfU1Hlsvp9i6YvQA9RLfIiIyOZsJIp52QD/KG+pHLiIJA7IV6sKXASD0WEyr4oXgw/0ekaE3OMi31tPx0+KMao=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(31696002)(47076005)(86362001)(2906002)(31686004)(508600001)(36860700001)(40460700003)(186003)(54906003)(6916009)(70586007)(70206006)(26005)(356005)(7416002)(966005)(8936002)(82310400004)(81166007)(336012)(426003)(4326008)(5660300002)(316002)(8676002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:19:04.1889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e242e859-48fd-4476-6c89-08d9e24ffe1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:08:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.299 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.299-rc1-gf4e33f5b11f3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
