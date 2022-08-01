Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30998586CD1
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiHAO1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiHAO1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:27:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E662B1B8;
        Mon,  1 Aug 2022 07:27:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jztLVaLPnSJZnE9hL2zXwnb55dCC8NrYc0LN2WtBOsF5pZZw1j2gy5IDFVZ2r697f9yM87UrUgZ1PIv+t2OjFes12h9JVAi2fHh9GpLKhqbjMeVTTYJTpksunU1gcVyyaOCaQSOTQ4v7nlh+0/QuXN8w0Q5QxH9ItOboRrttqdpcKqt4FwO4lZ0Lvjn/lTP7oiYaEFJy9jazbzIJGQFVDRLSMKjCSp572jW+VPJpszYgzVQ6gOQtdSZRyeZWJhWTK2fjeoS7W5xZoIg2pfZbGGc4AddqEJgSuroj0imJXPhT/FT+QSITY8INlk9VsZVMTxxzSO2uWV0+5W+oJjYDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+9JUs2e95PVFFyKTL1PNQNdc/R188ahOCMcqZzGFDY=;
 b=P087R356uybG1QQJqVXUKuDmE/vtmFMKl7aRhAbIZ0OuG/YlVcOXrpPpsP6yX4dgstZL/VPHy0dZnHy+zk9476eoTaUz4frhFKb1hl41lYHIt9EJCTR9ozD/AxyCSvqxFr8Zpejbv/191bdKvBhT9mXOb6roP40IMNbxjXDzwRFkjVRidfCtHaa5MBmjwIDBlAYdotUs/hyO/2uA5cLjv2QiHhqEs8Jh/w5WGGjGvVEPtI5jthvyhXC5/NAdHJgwA2L5UphcL671dz6W6ym4VAk2e7e7+hJpDgx5M0jJwLm9uEiVmh59ChcFpY1PGWVWNxqs4QkcD1xrPmAFtaimvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+9JUs2e95PVFFyKTL1PNQNdc/R188ahOCMcqZzGFDY=;
 b=Tqs4laDsQg3hMq80FODJJQGdCR+LzAMId6TwRt6C1asZA1Pbe2WAPC2nnBG2yGKbLACJOtuu6xy48XpA9xVPNnkWTcmUUH5L1et3yTbKgcBbIvxBp02yQDSiUSybRz55UPxG30SLK+zdKE9tZKjd9SjrUThO4FibvPcHtDyb1S7T0SO6ahrS1bClZuPm61JSifFshIcEzkPrRXhYndhj9db2M8teAtwDXa/08mwffsgrGF+NwYDEn3+hyo2OGI5DfIzhOPBj67U3QXuyfWvJ5tsHXD8XK3bnmp63vJ4HLgGLi23YvdH7jm1tTwgMomvSeLg5t3tYWq2WZ6pKhdDpeA==
Received: from MW4PR04CA0189.namprd04.prod.outlook.com (2603:10b6:303:86::14)
 by BY5PR12MB3747.namprd12.prod.outlook.com (2603:10b6:a03:1ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 14:26:59 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::15) by MW4PR04CA0189.outlook.office365.com
 (2603:10b6:303:86::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15 via Frontend
 Transport; Mon, 1 Aug 2022 14:26:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 14:26:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 1 Aug
 2022 14:26:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 1 Aug 2022
 07:26:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 07:26:56 -0700
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
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <92d2e981-f409-409a-ac31-63dcd0de1027@rnnvmail203.nvidia.com>
Date:   Mon, 1 Aug 2022 07:26:56 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 978c40f6-c929-467c-f6bb-08da73c9e4ea
X-MS-TrafficTypeDiagnostic: BY5PR12MB3747:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hIcnhp1yKjgqqtNsZb946ur7uxGgS4VdHCDhB4dAOoiwuqbHvQd/TrrcWUHbP3CvZHMnFbLiTKRRHcwts3RdzW3c8x5uVCFRYhV8vs6oFiTh5vW0qydvEdLEX1OMsc4OHwvZS+QnmOB52YA91MSFbfHuCMudLpRnjKKW43G8KlNeqS+H4NlbFEEoXjCSPMsGn5wtqim9t9DYRWbCMvlJ5fplTzgrXzWq4gujGmJYaEJx2SjGpnAIk5OCKpVAfUvpbO7ol7Gz7yip+rNl7X0yVsfw4qkuE5RAHvvUGpb2kdWLK/BIc7MF6MN/PD9WPkYfbRnrWxrMBOM4VlyMID3FfsoC7/tkV80h0Joxdf7boqIISW4C2XWSCaWOn8z+oAFCAA94wSmBE6uqOptFBDDZeubE/jhEoNzEoV/TLhE+Z/r908I7vDJo+7NmqIOmYe6R18En0mZUplZtZcppvvwxEMseqgI1I9x/h0eL33n1g4PiB5l2CvYfI1l6T/vyDs3RuO3q/430RQ625WL+uTBKp1d25GZz7nc3nwWpX0SBD+T0P8EEHc13B9DsF8ZWgzyVTzUPaGhFK9l5R9K0xGEwm9LKwaEk8Njc7ndXRyAcLdjEqMn0XHHtTKyL+NlioG5CDNIQjoHd71EC7S+kTa8jIhABMttzubfJs/Sd6eQ4ztLR8+PxzU7v5jJdJUjBpbRhoQlUXU0nRimByFx9m8OIlFgo2cef9RNCTA8vmXi5j4zQeHgS4WDCGGZX4o/B2tnfQmKEnlj8EO1l4QbRJ2CiGpE9UFS/0VoHVODFWmbA5KgYMmc1/b65DAtPXHe7LayoR6sE4NpYwSzoQuim0No3veGpxzoF7UA97PYETq2zm5gfjR+5/KV4OmvLpbifM/5DHc/4iUzvxaUgUZzFRh0Uj/XlLHHD/Ps1eoPdT1llU+g=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(376002)(40470700004)(36840700001)(46966006)(186003)(31696002)(86362001)(82740400003)(356005)(81166007)(40460700003)(426003)(336012)(36860700001)(47076005)(26005)(2906002)(41300700001)(70206006)(8676002)(31686004)(82310400005)(70586007)(7416002)(5660300002)(8936002)(6916009)(40480700001)(966005)(478600001)(316002)(54906003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:26:59.1477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 978c40f6-c929-467c-f6bb-08da73c9e4ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3747
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Aug 2022 13:46:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.59-rc1.gz
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

Linux version:	5.15.59-rc1-gf7c660e98f9b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
