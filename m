Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36864897F3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245116AbiAJLuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:35 -0500
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:31520
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245031AbiAJLt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdxiSQPl6gXsDEMB7gimu/CxXVpjVLRSoiKv53qtAhHYfMQOekbYy9RNtEG9FHK34XEcbnwHtCyBoOfp+9p65V/pYHnWgZS6nA429y8GK16LNL8qvFv8DYSYOB4JL8xLC98jgSt1JD8RqWrCR+XmTBNP43afog/7MbRrMERgQKS1ZePqCmND6CRvnuSO07WoQqYeubYeAoFlpJUe8r2hEgeE9YSVS5/Q3Lb2GIQkR6OWOYDdvzUIKHfW+FMW+5yzq1OPHfqJqsbBiHAtbkczdcvk9vu7ey8tHwKMIrYtDaZWBtX8ARVKIZzQRMgpB1k4uwBCndgt1OAUsHSKs4K/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+1abQZu6uDuOilJalAjFgVSsXjaSrKNtb3MVSoLBK0=;
 b=hsk3ZgvWUiSZsn1KZxkhl1mKk9r9NjlRAhpeUO5QtUJJ9OXkoL+RCclNOA6w2yTpk7v0cN9pEmy1fkLitGOCPBpacztbg7VVFcLnr3sXf9rkDXNvkePQviyhGiwXYE8nG9BCq+TL7CkIvR8xkhQdEADi0Isv/YT7slMEAM1XO1BQJMokwav6hznUQI4IF22AH/MF8kBG7Ny0vJemb1bGz6qGgu5AcPIF/cdq5Zz0r83qNx+AwhdtbpofP2A+akqtqXQea66eS3a8XAQ99eeFqAFbG7rTwX4fUiwgsc6X/Z553BlUydpexp+I6HOHGRQcrtW5QljLaoSl62DZeVIHZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+1abQZu6uDuOilJalAjFgVSsXjaSrKNtb3MVSoLBK0=;
 b=ZonXgWTIPj5qbTsPeHc8X7DPRgc3vGApqZRbCM1/n1baYMF8JQZHnWMVfJO4E80nZkc/ci/KgqWFB/tTSVkpX/hWcuOstk6VPUTUAEw3Au93e5IBkq4QyY/hi6NChBt0rdwukSu8PpIJ3oMLzZdeifb39XLt/YBZqxPcuIxFokqoW5tt3PjEHTbxRFkX7M+UzbVGlN42p7Ux6sNm4i0K2z0SIkRxZrfm9yv0QxpheAPZF67SHGATygx9Joxmt5xzkJpqorwiWS3PrOYDwSDD7ycceOnqtvcJjTojWix4DPktkyq+5t3ylWbHLzDno9hl5LuEYamKhMpiVyugnvXFVg==
Received: from MW4PR04CA0273.namprd04.prod.outlook.com (2603:10b6:303:89::8)
 by BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 11:49:25 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::b) by MW4PR04CA0273.outlook.office365.com
 (2603:10b6:303:89::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 11:49:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:23 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:23 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 03:49:23 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <26625f7fbc894d9fb81e6bd5729c2e24@HQMAIL109.nvidia.com>
Date:   Mon, 10 Jan 2022 03:49:23 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac71f334-bba3-4567-621a-08d9d42f3f8f
X-MS-TrafficTypeDiagnostic: BL0PR12MB4945:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB49452C27F2B3B725F2F72946D9509@BL0PR12MB4945.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pE8t8DktcSe3/0MiDE88SGSrG2+8S23tDqjXnLIJO3V+GGmV6SrN2pLqPBNh9kiJiTQy82s3Fg74QVOoMVBCPDrwMGXf/Wq90RNIfBgSw/o54rJr0GD4UZtNOyKyBHnml35CO1kqZ9Wc0sopgMo0JnDYizIFVhUZ6rNQobeKAU+gudKWeYYD9JEkekvWJIZgDzz+ZoCLKX8A5rL3Qz7JJnU45k4ON+K23B+8LvIlAYW6WDyZVw3OMV7g4uiG9eWnEO6e0TcETqmnO/zq71XgkwoS5oUWnme1gG91OEHKLBM9nr3SMP4NXHdGAczgnNncc6W8imB49K0dNqEksv4opp36h9shzWOq4VVBDXYYxjmYMkXc2v8z5yvZEJcPMNSsEW8OYmcsGdTVcey5Y6WtaIybtODlgd7GkYMwNA9qKGKrGsl/2jzBennrLTOFivd3O2ebLKIoylaT8JDXaFPksPQlkBvPxescmVlRRXM2kMpIocxLSBbqGaSSUCRo6nx8vwmYieTYSOUPrqUQh30A6oodEX9TAfsqQ6lPVjSdboypcyXbiX5XSdBeVmm0u2kNY+7rLxS/zwf/Z63h8VNCvAYRxTnKOlfgfaMJA6nTMIU2Q3kR76IvVvOdVPjFaRkDQOww0DWNfA9Xc7PsFmQtatDe5Vpkd/fp6uzNNNpT7molbJnSDp5JhnqtiWwbY1m/5ODreTZagP/KRjIkhwPbmPAowqdezmPHjIW+8PITWzQ0bBXK2KmY3OARu+bV6090hrBxzTc7JnvH4iqog5uGtaBgv5apa1AeVG89+N3dl75umG2fz3U4dWBjqNIquXeFYO40KRdGCtC943LzypLMsmFXH8AEXcY6IpJipjdstNop9SRfKJ9cXJaXoU8lotFC
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(7416002)(86362001)(426003)(5660300002)(108616005)(966005)(316002)(186003)(40460700001)(8676002)(26005)(24736004)(336012)(6916009)(82310400004)(2906002)(81166007)(70586007)(70206006)(54906003)(356005)(4326008)(8936002)(47076005)(508600001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:24.3611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac71f334-bba3-4567-621a-08d9d42f3f8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
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

Linux version:	5.10.91-rc1-g83e826769db7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
