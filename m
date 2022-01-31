Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92B64A48F8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 15:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376410AbiAaOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 09:06:40 -0500
Received: from mail-mw2nam10on2067.outbound.protection.outlook.com ([40.107.94.67]:10851
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359088AbiAaOGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 09:06:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laXAXCRXx1Ee4hzmXU7bPZpn35x1O4a911TSzb624sn9vcsq+/auEw6WkbeGp1A1hg1CmzeDwCKnEp+BbWthIcO1IwkHtflfEc9Da56W0SQJlBaGq2hAZNGokgPz9Isp3LlrI7SqNMC+oh67pZZOMsTtmo28PRtI/ZqFppib5vRy15Chil3tQQjeVl6yE5gEZnEbpd5GoDbpAF2yULSfXTiHL2tolAhMPhbu2rt8f7xze/A5dKKVwuEc6xTgPk+gZ1vrHATPVWJ9V6wBYzdRAHl3odBLzLqDcSYxG++XSIZkE3YW1x2hmPo3InagvoBi9s/clY5I+//LxRGoBHjziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdPpIuNQjKVo/aM2kVfZx/+Q8RkO2ocLTNWb1HJVZ9o=;
 b=X4c3DI5zJoht16OukHoUpbl69nss0R660HL565XgDRWERSIPsRp4rcX0Gna2yNyMLEO2nBsgS1fbkvPI5wRFrQ8hEr8HZFBLJWD58lc8PsQHzQ18h5DdUW4YAXcvmaItB8l8aBrTPWK6knvTlP+Khg377lgrd+kqfsed5MYW3H5xRy3acWqr3wjr7NSENblxqkrPpOIzYfKuEHtZHn8aldk6NypxNl6ziGiUwErovnLnfhLg1NhHBITvfdYJGVvtgpc3Q1xL4VjEhL/b82Ya2CaTLG+NCz5zNmKs90efrxMjcx8Oc7YYzWRAlINwfke7RfU8bCqi3qSssuhGGQGskg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdPpIuNQjKVo/aM2kVfZx/+Q8RkO2ocLTNWb1HJVZ9o=;
 b=bgemWsxxRRh9d4ikXMsK6g5GRSntgnIGF5JJHQ+pe+wXckkZtyr5PG1qMV5Co8tEN1NF3shLWJYx3K5QePmYUjz8EfNi9FAdY6B54rCzF/bOIqifhT5Ua+Dpnsi71Q4o9gVGOtltcfgy+amEYERpFZLkppNvhlPO7+4vlupHGqL6IP1mzheZI9s9TaWAvJ++U5Mk+vZtTq40jtkEnz6+fMkZHGlJ8hyvFPCRNHVRqsBuEoeYkEfsnrd2wxCVIkQGgYTMaI+3egLqKFDj6aeR6d9HBCnsXKnHJSqrvVOpNAZs0LpsjlDrDEGYEd7I6vOpjFynuAeYwlyekpmcV3UL8g==
Received: from MW4PR04CA0080.namprd04.prod.outlook.com (2603:10b6:303:6b::25)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 14:06:36 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::68) by MW4PR04CA0080.outlook.office365.com
 (2603:10b6:303:6b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 14:06:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 14:06:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 31 Jan 2022 14:06:35 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 06:06:35 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 31 Jan 2022 06:06:35 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b900f9e9-3a1b-442d-ae4a-c2bc7cb848e5@drhqmail201.nvidia.com>
Date:   Mon, 31 Jan 2022 06:06:35 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03fc2ff7-c529-44e6-3a11-08d9e4c2e4c2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4403:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB44039B982C774162F5380FDAD9259@DM6PR12MB4403.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZc7xMLGdStUXhqE1RS7Lw82KyqF5193Kz5V4s6dNFGOfgZzkeO/hgW1WeEx+nmeiuESXY00SYrqr7lpnfju5wI84aXNlxISGQ2gBPs33m/rNtMZyy6fVMAM29xJp60JykTMcHVBg38ywR57sciIMgr1VLN9JqYNSXF+cQMB9Ds5oOyZnjo6izKqHJVO0T1DiZ4VRUIm+O6S4gHACWvb2/6RNJd74ybQLKPb562o8mdFpCmKH7Qahv0KVrzRLjt/GwuIWsZeHPF4ugB3DG1Ib4OgftZRQNWT8yF1CYqwLL739IUJvtGz3DYz1rLURciQ/oALpmNrmvRsWmDG3Yf1jHhYB0HOXgtxPTQ1Vt7OXkrnHNonjHMhlShCLiE8brINKgSleQyvD3O+TWI7NzEN6L8iW/Mo7umhGC2Mg/CvGZMl/Edq/Ak3T/ZNRwFrbUA6td7XNRX5cyxmG7FdY4JKJBX/kdtJGEoSkDs1ZGr5OzjuQJNpW1VAfPzLNaz4Uu/4vELewW4o79snZja/rqL7xFGOINBYS5nw9Ak/5iBjEocelxl2KpWTFRa9WwiifdFJvgB81STQ3tDg+G+rlMc4FeX+hLUmZxibemu57ZemgUL19gwz+bQ7Z645o9e3Re8A0PhrVAW566nFl4dLRuir1/izDrxrNQ+yj9tR+tpMoshx+YWLb0RsnCoE4zTcysSo3TEw/l/XBjUyKGlCEhwfmdXh02MMSF6/aHQ6NtBaaqiGoQ7aS2XFrfkx1CGYFdsnNeEjyxt+zwzu8N7quY1jEKhgtffesjPwljS3ji01nWU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(966005)(426003)(81166007)(336012)(186003)(26005)(31686004)(47076005)(2906002)(8676002)(8936002)(70206006)(70586007)(31696002)(86362001)(36860700001)(4326008)(54906003)(508600001)(5660300002)(7416002)(316002)(6916009)(40460700003)(82310400004)(356005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 14:06:36.0952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03fc2ff7-c529-44e6-3a11-08d9e4c2e4c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:54:25 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
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

Linux version:	5.15.19-rc1-g39741c5e5973
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
