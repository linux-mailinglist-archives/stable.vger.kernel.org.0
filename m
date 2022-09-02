Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D6B5AB6A7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbiIBQgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiIBQgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C3DE8682;
        Fri,  2 Sep 2022 09:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1q7ovYhmTjm9jToKwCU++ud/VsHngdb3VOkl7NVQ8EzHg/htbZLjQRp9ScpYPrjlry5rVUFPXf0mugVA2L+QV4WjwxeeSA3Gkuey8U8HYjUmTjqnIgRegxK1VEMCfNrmr+AYhCQv14iVy+9Nie/Kaagps4Rwnz3TpsQKyWEsAELmJPYQdKDDRr2wn9JSdzD37wSOqG4jwMHbRP79+HFZHxrhmvVh8+PFMsO/g+9zz9mjAnE6t2vU4QxddGPxtWn0aIFZKzqLG2iRLZSy8uRoLtxMZlJlUT/jlthYYL79FoS0Wvqfz3MbgkQ3asWyWo1SKSd393hKtdQ6T79bO8u/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjz0ZWjhW5QJR6hZau9JRB6wV47HMSQHUxDzR3H42KE=;
 b=IPL1HoZHmjXwOhyTzPIV1fjUNXnHORRqi9ROTj8/G9zmGVhfrIl7+9T/zACp4mnMNiTpz51e6F5wv/yUAeHqYtuTaiok6w0ZZ0CCgI/g0mYyYoFLD3YC05YRzMFWbrmhShfHDrJ1TPlSBX3xPR2MVFI/SyWuLtyJediNdbmqB6sOThiUTNe2Erbb9FXHIIs7P/JpaCSuPBuUdWzj+huQclgqWQBWUlbnDGzd2YbHcRB3nBOdcNlP9CQwlvHIORZSWvZD/h783aW9eLvEeNbp7ej4RO9Xg2GPsbEgb0Pq8mVWSi4K2BDBVf6IbxpX1/BkNC58uwGpZ6WnBlToxvNXBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjz0ZWjhW5QJR6hZau9JRB6wV47HMSQHUxDzR3H42KE=;
 b=WfVM5flNmG5Tcc8Hcw6m3F9SQXM6J3P476krGeYX/TbN0DnuytO6MqYhp4aBZrweAGLiyVwYfee8ttbIZ8lveUg99GIB6pUHLQ87qQoKdRml4EoAC/3IptZOUCYkPHj7lcmBRTWy+/gkspptSJb4AO9yMKlRi0RBWrRYd9Sb5SRNokGboywpvzfe5ZMx1WCzWz0isme48MFsj6p3aC74EI3ZtrBU9sp/BI1GS1Yz0vMTRGiYz52L47pvOImC0bAsgR3b7Yz1jvzq5nNzughOqc0hO7Rx66BNXMMzIwp4uUNeEOfhoVS2x8vP3Glv8xsLpLWr5cvBWrnL9vMOUByCZQ==
Received: from MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::16)
 by SA0PR12MB7073.namprd12.prod.outlook.com (2603:10b6:806:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 16:36:03 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::5a) by MW4P222CA0011.outlook.office365.com
 (2603:10b6:303:114::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12 via Frontend
 Transport; Fri, 2 Sep 2022 16:36:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:36:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Fri, 2 Sep 2022 16:36:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 2 Sep 2022 09:36:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:36:01 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/77] 5.4.212-rc1 review
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6becd98a-a250-4948-9c79-f396ad1a1c3f@drhqmail202.nvidia.com>
Date:   Fri, 2 Sep 2022 09:36:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bb5563b-6a84-4005-3243-08da8d013995
X-MS-TrafficTypeDiagnostic: SA0PR12MB7073:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrVrFgEs8asAsGRKamPqwZ/Ny2VyUUkTkpDUopVPitK5m2mNVr3IcwodFWwSzUIUXrQX0K5erUIOR1obbuAH2hpfoCL0l8XTJsBKw8Q0FrtsqSVo/R51IHDi7H4T5Z+42gU5C5rIbJt6QH++k/zUcwzhQ2jXnOI610KlZOlz0ar+inrzAIAhUwN3Ay0zwZhaGGJuri70IGqn1IpoaArynJ1VRNCcJRbj0Hr/0tuMeim9XpHHlJXLmzN8WZU6f9iE6h5aMmxZSofOo/MSACkaJKgDMKmKPlfCgenCRu6+7qzoRGeJ0D7mYJzpZecKDnPrnktKdLxH+9XHv/bt4rQkGqGAHcr8ar/2st+oDqLXrE0KqFJ9T/6PnWcYkSLBhnKNcafMKDhkadFua3Jj+3nLE8RncK9ptxHmHMnKBaomQx2Rdb07fpQMj93zglskYM8oiiM49QNv7eEyyr83b4VNbbjL7O3HB/DQCneWBSzzrpWZtwiI0Q3tLqq9Oibv/zqY8hmY1Dfs0DGR/d9EHNKH096JdxurjKidfpJAXynD2rqdcUwPZOlObsDdNkA11JrxZ+P/PGiUjga6Vgu+eJvDTW1Um6eleglHVoxn79OFd65J+9cSoZZJyPeyuoFdzj0a1Lqh85BhuDUcKwpSsZCZAdp0hoyyau0u5ko0YVpm2+739BxiYMRwWqCpxLIxOb7ZO8jHlwIX3hQCxqHGIp1wkr60Imjb4D2ezzSkC4FX6MmbLvHWNzOjsuGdC7CwmZrHbXOq841TXZy7zgMJNedxsEwwMe9OjjIhuxc2Edhn9ancINBiUt/YTVjWTlPDyEbH86A0fg+3FJszuhptd0jokzZM+8v/mgofGh87Hxffn+KPdD8g2jceu6ef4Sgnd+uN
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966006)(36840700001)(40470700004)(4326008)(186003)(86362001)(54906003)(8676002)(36860700001)(31696002)(2906002)(426003)(40480700001)(40460700003)(70206006)(70586007)(6916009)(316002)(336012)(966005)(81166007)(5660300002)(7416002)(82740400003)(8936002)(47076005)(356005)(31686004)(82310400005)(478600001)(41300700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:36:02.5815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb5563b-6a84-4005-3243-08da8d013995
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 02 Sep 2022 14:18:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
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

Linux version:	5.4.212-rc1-g35d9f706c6df
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
