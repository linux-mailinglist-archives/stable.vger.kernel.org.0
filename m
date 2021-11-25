Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7D45E1B4
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbhKYUlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:41:42 -0500
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:52321
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243975AbhKYUjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 15:39:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuAT6m0HKUhK0GxEFGq243ejTJmzZ/khX2rMv+Ve08FiBfWnrym2eQngDHE6ZNRzkUAJu9mByxvYt80qszwl5SSVZxZBgM6NOFQ8/J4jRJNPuKgWbDPyBkGFR5OU+QkTAcK0zT7/M5PDjos1Isu3wWQelBe/CXzp/nUCwOU26o1+h9U8WPyZA6+RrjyI4byTv0pDO6J/OYRMJlIOsMIqvtrRj1vt/ZmjN5nB1EzyFXTMRE4fcwpyD1xEZ1viD2FICvs1nNgMjUe3hmE92Pz83nJapnmFUIW1GnaQ6udU3nDgMkL8AvZ71QSbUWPJ3kVHaMK+Nno5GlqAB7xaQGeSwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/OrbPValF3N0cYBEnxhBzrFbMycamIr7yZMv7MUFOM=;
 b=Sex+j3isLT+p8GOFeAyTmWmxephcKSGvVLZiCJIM9THzgvKZ3tQ8/jwhBrg2Mc0SZ2hANvSmzXmR9Tvtis3qJKay5R5RI6ihHYCEkrCC77wiCzYPBGhMQjzuHeaOa5XJH49/Gk5bJ9R2DCm7OreVHZ11XWp/kzQmOhC4jJRVehM1hbw9BnBRubB367QhazDzLyIymc+N9Y8k1Pbd1jM4vpDhk09n+/kOQHidbZf+Dv/MzdbkAuHPRhSKG4Da3UyutOwVWueQI/ZHOYAZdNWRClNtDzmka5Td7mmJq2g37HJuiIH9678A+Pzetp4xr7DcIoFFJeFJdtuu1Qe+5jLUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/OrbPValF3N0cYBEnxhBzrFbMycamIr7yZMv7MUFOM=;
 b=LUCOmwebnJH02/TpMlkRVjlvTqZu9LYn043iAfg1pF/+q9ruzVuU5Yw0U5CyGHMHIdyuxrArNLVMhowK91UqSqri74ph2WkqdqP3lYCA5gd3DAeV87pYQKlOmDixWjKirhlNqetT3JTuUIBK/WWJjUwoTW3J7t74sLlxo0gkuBWvYruCVEwmd89HIJ3vebUXokqdcybUf3wh+c2JhEC+kgmAejLMjS4whsIljUa5L+xKl/J43W5xFu6Lii5czvi/pBTCB2UQHjJFjZvD8+Q5jvpkOYWz5D9T8hIyl28D7bvwA+EH3v8vTOJZeDd8Gy8pIyR/0kvQ1NitOGK/zSaq5w==
Received: from DM3PR14CA0129.namprd14.prod.outlook.com (2603:10b6:0:53::13) by
 CH0PR12MB5219.namprd12.prod.outlook.com (2603:10b6:610:d2::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.24; Thu, 25 Nov 2021 20:36:28 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::49) by DM3PR14CA0129.outlook.office365.com
 (2603:10b6:0:53::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:36:28 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 20:36:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/320] 4.19.218-rc3 review
In-Reply-To: <20211125160544.661624121@linuxfoundation.org>
References: <20211125160544.661624121@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <907409c4b06c426b875e8c1aae46f7a5@HQMAIL107.nvidia.com>
Date:   Thu, 25 Nov 2021 20:36:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0d6a04c-b16a-4960-9b01-08d9b05341ca
X-MS-TrafficTypeDiagnostic: CH0PR12MB5219:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5219DF6FE7A22FFA6F451811D9629@CH0PR12MB5219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LAYpeUX7opvwmJlF1K3kBXtcgbT/ag/x3AMtVjihbNlnHU+sbLGUFr9hgyUDRq0IfgN6fM3AcvuRdeQ86dL6gbxeL1Fvy0KeGboGCMbnktYIHj7O2VA3Fnl9EPaM4S7+K54afyhOI9vWWHgAqsvDLsg66eZbECMnBVMaNuT7PdRM5F9T91fMBUwHrHaxiAUGnNJi+2M8NC6nxLqkaDsS93oPbZ7jN34L16HPiBsQEucpRDgV2f0pIEKm8ST2afps/Y5YVqxbqbC8+8CXSFbHpU0CgY4km75vvqH+VlfoRXG1Rw/IJwqiKqp4i9P6X1IBreZMK0NgKskLBscsE2h5JWhtdrJAg1IJmTnlpvnPpE6ajIpKZ/WOw3gR8F1b9vqNxVjBR9rkZDmst83lOdYdiAqUPyfErVKgQz2mTSl+66eBgMr4ycu1fG+9ioQltVz+BhIy0DQtXwtGOApL1IwqHMuo5yJq5/dUgAXBK2O5W0qcKba2/ZwjcDgAGcmsCg84SXyAxYNsyp0Bs8ogZ89HA0hggjJvKa1lEVt2ii5KifonP7FGK8zsePyq5ZuPp5jHFe7k0BQv201BZVrtvILvuz61z6h5PUr3wOL7AqI2/QjVKTcdjZR2lPz5HDJ1PHMgTYmfgB5XjZ98HF0yPt7dOPljK5RhhADuCYy28SQ+z9oGmvbycVFC1Z2qW4tzoWjknjFaFnjOCVvRmO0S1rCE7E87WtrtojLWNpfNh0JYdDF45k8CHk1W8Nj2pd/ZB7Oqhzy8qBGxawENB6lemkAumlLYLNIiFG0XfwnYaYvUjk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(186003)(4326008)(36860700001)(7416002)(2906002)(426003)(26005)(966005)(108616005)(24736004)(8936002)(82310400004)(336012)(316002)(5660300002)(47076005)(8676002)(70206006)(54906003)(7636003)(6916009)(356005)(70586007)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:36:28.1047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d6a04c-b16a-4960-9b01-08d9b05341ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5219
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 17:07:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc3.gz
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

Linux version:	4.19.218-rc3-g616d1abb6238
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
