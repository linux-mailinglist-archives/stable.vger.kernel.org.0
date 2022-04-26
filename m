Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49871510320
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352924AbiDZQXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352928AbiDZQXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:23:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9147565CC;
        Tue, 26 Apr 2022 09:20:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PF0+cMpZ9OlElb/g4wsqf2jpnIoOX3Qz//u4SShm8yMFGo2/z5csElFIOSsNzxLNAFYJamk0d3jSWdOnJA7BP6EQvv9cvHgMI8b830zwaCSxFRJgCoyXW224RUS1kXTLNwqqUzSKchkjUDzOI5iZZlWUzzvXmz0cBVTMYSKLK++rbTzlR+0r0chqRJflsqVK0KBZV+4xp7pi26f5oHRpaTX1n3KmA7aEn65k32BFiXSP0VVn3kJnd09+9e4dQmB9x4lzhUSZ/oL4lHSiZPdo4+TPYJLkdffJfmbYR+o8DQiMZ9pUrpQunnP7uT7p89mQyLFGk/UOa6kltLJw3i0kDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTFHvc4nyo8qD4eUbL1Z2djWzQoFThWmlN+LWwGIs+c=;
 b=EZtqb4dgJD3sWu4R9YPTdQD9+I9JI1E4moEwFsZtNVSDFHvpRVjq+UTYVQZ8+URr+CgKx55B0CSS4uKiuoGMaOZAY41M72rmAo/yVw/Rqjms5QiiSpEXE6lDYXBkN8pb5cPbC+8RT6OtK/cRIeDW9gchWy38qLxuwIby9vwrzGXSWKy3Ufx0NYM8IUu9MMJayV21WPjWFo2e5DkHEfdw1sHfxmPH5zbwmJzRTBQm1wNcVOBe92kR+NOjeD+VgPqKjuh6vp3+Bb9zhQQL3ECPqFUtRS3HYYtuTDJsBuj2eqsMZ7zuexttqyYygjRXzuXtWPS+PjDD3vaoD/o3BQ2qCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTFHvc4nyo8qD4eUbL1Z2djWzQoFThWmlN+LWwGIs+c=;
 b=uhKvg6jBuvdULH8VfayosZefVE7Omp3BtWUy/ELZgfEy9QVNvQcjiB9D5zPOPgKVl8C4rSw5obXoR8L8VgeuSsQzy55bjkPtNCj3G3uvyZEJiuHNXGAZvnS9ucNt9kfiQxIpb0pD4hMW1rjx5I08bzK9obel1qaBaTqwyZJ46zj7JUAjwpDNAkr8MAA4X2r9Z8eE5AbRBrd/JIrUkecG5XS9xpmiWk0I4gO6FowB+eWToY93T84oFrHzoNe6pggqboYo6/YJL3AK7MqTVmJpRxgZ6syDynl+Ra+ARcfFjZCqY0lbh6ksgqXAtGUbcHSWzXIY9KGrwpYHVVxhAlVvQA==
Received: from MW4PR04CA0306.namprd04.prod.outlook.com (2603:10b6:303:82::11)
 by MN2PR12MB3008.namprd12.prod.outlook.com (2603:10b6:208:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 16:20:22 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::5d) by MW4PR04CA0306.outlook.office365.com
 (2603:10b6:303:82::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Tue, 26 Apr 2022 16:20:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 26 Apr 2022 16:20:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 26 Apr 2022 16:20:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 09:20:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:10 -0700
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
Subject: Re: [PATCH 4.14 00/43] 4.14.277-rc1 review
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c3caeb3f-9b7a-4f20-94a4-a450164d8959@drhqmail203.nvidia.com>
Date:   Tue, 26 Apr 2022 09:20:10 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36496985-a52a-40b9-97a2-08da27a0a9e0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3008:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3008479CAA87EE9C460CFB9FD9FB9@MN2PR12MB3008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NUNEk11unKXoiSB+KmuwNcsJWOgD8lJLOh/UoGmUBHK2ewNPNb6D+nYGz8kWlkpmgI/AdV6Dz4weoDEaS+7B+SW+lKSv9+MYwX8bfFKtKCspFYmKHBB0T8/VRKz3maz6ERwq6SUz4C679Js5VymUaZ2qGF7klWAYMeA2hCqciFiKYqXCFbj31eDqXoZHuP8o7kqJgtdaaRzcKuh+W2dxRm9T14MTjxrcq2ZjvRofG437UENDfAzMDLKq5qVzpoJohTdZLMJSd8MBzLJwLMBotGtESNx00bq7n2Q2ueHREUphvqqyV2s1G6AjjKRxAQprW7zeXyvcs/1M4fHX+MnjqAu5KgpaS0s5oapjeS0lA73UKZaS1JJ1RI67vXjqv1a0iWrrGZaI8KFczsiCu6oiRwD7YU+oa89kqcuPeddkPLhwliIRru/Gwn7f5BoD1qJTxC/IlSwDjMD1mxTiVngewqc1AebT3GpKyZQhHLJxFDZSqp2r5RYJj659bXT1BdIG/1PluToYGUVLWNnXC/xXNWgDKQGpsQC0RpUGdvgVJiQswxdn01yR75pff8zy6pL4HKc70lWbF7WAEJckQXMRpB7//L/5OuqPGQQbm0U9ygWXFRNY4ks1zqu6PD4jPkkjSs2FKryKb7puwQ7XDCfD9g8ERouu8fXSUxGIAEUd5uM7lKFo4ETUy88TLHTY60jeeaGdiP+NpnkCyMlTXfvlil2GQCZKjUobgBbATSGwDM/x1KjNQsxRLRgF2uCoa7yuXBXumMfLetC8GGuqdvivxeizEjW9e5luVh/7zKZ/l2I=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(6916009)(70586007)(70206006)(81166007)(8936002)(26005)(40460700003)(54906003)(47076005)(316002)(4326008)(356005)(966005)(31696002)(508600001)(86362001)(7416002)(5660300002)(82310400005)(8676002)(336012)(426003)(36860700001)(186003)(2906002)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 16:20:22.1697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36496985-a52a-40b9-97a2-08da27a0a9e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3008
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 10:20:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.277 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.277-rc1.gz
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

Linux version:	4.14.277-rc1-g29ecac2778fb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
