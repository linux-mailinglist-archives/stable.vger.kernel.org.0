Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F14897EC
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245026AbiAJLuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:32 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:8288
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245027AbiAJLtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KU1MqH4ttuCjJBMAJatLz80s/c8uJcqFqXztfMkO6oPJU+Pza3ITbIjXu2y80Cz6NLfL2lSgmRGra7Gi8emYhyCEz42B8PU76pH6nKo8CzruaCdIY+DSyWHCyj8L2z0I2GReODS1Mo5g//1o6ObtJeUMDsNypb/393ZXmOkHsc0Xc++C/l0rKlukZCFSaVTegMV7vcAbQgmvIQ4nTETlQha3n07rtY51nKcz/mPZfBN4lhq59cm1WPsvuCqEjttJBtlZlgcMpBNSWYD0p2kIMpUwzU2464C49ILcrB8B2pADDc+U8LQsmK72XRKnfJnTDTMkjRYxu4RK8qST5AB2zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgLkCpyT7rV0hoilLoG6WMz4kM0xZM346HJrF5Wkm70=;
 b=Ey20HeMYzdDAExFl2glB65tSu2b4aJWnljayXdyUKinEb3SvSBLgoaSU7U8gPpYep01vzn+NWi/Ia4CR6pBmesxVudzukhEYTj50k6+2Zg6lYW0V9tqWmigsNHfHBLVHJ5iH8RbfgpgTovEpuJR3Wp3FDVOFvo8H8jDUi1+ggTCdeFC8/OCxGCpRet69z49LAw//MM9Y7nX7Xo4BEPKwhLYT6+vAWBDrGDiaW5oKQKewM9SlEoc/sutVTOYoBZsIpUmXmt8RJbleVUjk8z5SZTcE8ZP1GwWCagpU2kg1nRs9tx4tkiLn4UK4tfd5Eo+JX1wpk0xPsNgmgxgocxtokQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgLkCpyT7rV0hoilLoG6WMz4kM0xZM346HJrF5Wkm70=;
 b=Yiqvj94N/Uuy+BEtlM/2kglNz5fgQI9kJVyCHFtPOpz2YFCT/bj/x/mqRscREtJvyl2OLHSGjLn0op4pykYz5iwhzFD78mdyl3JPnzlVzIKLb0WZeVsUjrLvtsm2RUIPKH1B9s7P140Fd9HHn6YNiegArwSBhOrSQtPWxw/INtc93jeda4taayk6gNKbDFyBBgIuqc+97xWDYlnJ1wTaSDPQxSZYEWlQjqaYmfjTno9KjszZnrpueatyWP6Y/EA4QzkA6zD3mkW4KepP3xUZ0lFQp5UzZW9lYIZWQyl43QWEVdGj5gzB+u2ZoDHAwq/6PqycjUH6UXz3Q1t0XUlQAg==
Received: from MW4PR03CA0048.namprd03.prod.outlook.com (2603:10b6:303:8e::23)
 by DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 11:49:22 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::c5) by MW4PR03CA0048.outlook.office365.com
 (2603:10b6:303:8e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 11:49:22 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:21 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bf66556bb61b48418f6efe78cc3a73de@HQMAIL105.nvidia.com>
Date:   Mon, 10 Jan 2022 11:49:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f725163-a58c-4dc8-9005-08d9d42f3e81
X-MS-TrafficTypeDiagnostic: DM6PR12MB4137:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4137BA7CD8A6981BF1C5D4D3D9509@DM6PR12MB4137.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IyPSyqWMphS0avZxEO2q0c2EzWK7BFl7L+ypfy/x1flBzFJiY8O4ZeM9JrQhAWO5pVQLkhIigkuUDhlJDyGnPx3gWbSZ7ji3mGJV5MNjQGbSPZsinHrgYrQMKiGpkVzLxJ7NpWaJBHWqBAJInfrexzslzO2COqboUZOnYzQqdBLQbIMmc02IwPJW/SDCe2K30LJb6weE0H62cGXPdxp9IJSl/tbLY6tMKa5/1w/6BTQCyxcxcA8slYFilve4B7tw8LrX3cObzRB4P7sKhcGewC+SZXQaRJ8oEOoZ/eF57FThjwatxQR5teMGbo24tXX9LWVPkjhiJAnsrtRpQTFTouBQ0tWhPtkxegbUeGEztc0m/yS15nyAE3L40UuDe1WBh/MDgUW8Oi7HFWdxE1TqbsipZ8tbNxWyTeI1oXgbs2JItUI3S4arPy1+vzOckp8S1D5ApVUJxQ3NN8CZauPd13BglDSu62k4rWVT7EXOlkZoVRQ4Ra1KtBOoBGSjsX7T8CaRQIW9pIjJikapeTzWhCMdli9tAfxWTvhf5y8f+OHH/zTemZ90UUBkYHDoRo5gH1z2430NlGrpCXbKxLE+rsieVcAISEobLRBfR2JIgNAFpl/hwbob8v8koMaOQGaSahy+iKx9pCFRgk+/c4ljazJNFU+TUlm++3YvcSa8YaG4ONnLjx9K5oES2mj4elPPk631TumfGZhkq8nAzDEoXfqF6NyS1sj6mwsyRE2/K4FPlscQCJ74wzDnpClmaugnXoWxB21itgGAnbCPVyrPmux9o+RELg6ni6BYa4hmuYlV9joq51ORlI554npzIGRqBK2Iic7lbY8k/vttl2bwoHM9G2HiyCrDCgVv3RqyFk/cEK8Vc1TS1jWIXdPy4VsK
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(70206006)(47076005)(8676002)(26005)(186003)(356005)(7416002)(5660300002)(81166007)(508600001)(24736004)(108616005)(6916009)(40460700001)(86362001)(54906003)(316002)(8936002)(4326008)(336012)(2906002)(82310400004)(70586007)(426003)(36860700001)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:22.5928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f725163-a58c-4dc8-9005-08d9d42f3e81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:23:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.225-rc1.gz
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

Linux version:	4.19.225-rc1-g688dd97d1841
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
