Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B114A60B4D6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJXSFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiJXSEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:04:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C849AA2223;
        Mon, 24 Oct 2022 09:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVtrx6pYsw1bdA/GbjQa72YZTTZv2kHJ3niyATy6WiLv2qVvSLEH0mCxHgnxCfulh+RG2ZN9a73XhBx0MGubI1+g2pQamdqIZQeI2U1JnaE+GzdLYiJ0JJrNZPjbkBYONdBxD11RSObxj4KU2nbR66Cwq1MTsYBivgSbhv8d8XoxweZKLeLlv1FkQpCfZ/RGfLwAaFakhlUx89yOZW1oE+zd/yzZtzZql6Yw+6na8RMN0YE4uT1roAV2a7vhTwxdcdhCwW7NXdV8nutmHLK/9Wa8HdC7V4wy5dPfXs8bkjOa0FTluI6gLPVHOBe1ZKb+OuFbnBaI6FEbhPmSXQCagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PML+9htr1RfvrnPZhsN2KOr6KipXdRSU/aY2ohocCRM=;
 b=Z8fcKah6HfVHZdVBDHZoUJ6nJJef5Msd/Ht0B3QSqnmiruAhlTvhiADDRcR7KgAUPvblFHZ6NiwcIJXcLpSA3tQRwiJT3624RMUw1ZduaF5SLo4rLXyo8hUvRBXV2EczCxDVfq/DdAcw3dDASp3EsFNu8SkZYczj8OLHLmpySJr/+B5Sz41irV+iiEhoY0Oh9GPvoocU0x1ITI90EcJaxlNilrZUOMRIKbMQ/EPmL6JZigfw0EsPlPUgNJBzUvAU/SIRC2PZlkjHu82uX3R3JaqLhPIl3ilnv8mSp7qQjpaQ73tmNUlr6PV7C7DsSAPUjBF8YvRpF3XtZ/3IvpQyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PML+9htr1RfvrnPZhsN2KOr6KipXdRSU/aY2ohocCRM=;
 b=CWIpOLV8JD0XLkQSgYooudc6cggxrIH+8kw7utjX02Me9Cs8/7fj7LZufDe0AUJGKCgyDCZHhbygHgZo5E5mA6tVh7eIEd7pPq6oHD/O/mnqUirNpaXsGHwcqZ4SUNVXTRzVvmPL9ztwDjs4wRTGuaBQRxGsQB1pOoaoGoirIb+iadCWhJePAFFR5CT0NbH7ZtMA98XR7oE1WLrjj45/Z+RzJlbRTG/FRY6PnR8u5bRflTYKpLF1Bc7TlqAdjzT7riUt6vS8rRbBtS3Fiow/bCaAzNkuwaQW89oak4381wc5NE4XEL9Kgr2fZ1PaZX5bEEY88RreHc5RkIMI5tbe1g==
Received: from MW4PR04CA0218.namprd04.prod.outlook.com (2603:10b6:303:87::13)
 by CH0PR12MB5234.namprd12.prod.outlook.com (2603:10b6:610:d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 16:42:01 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::50) by MW4PR04CA0218.outlook.office365.com
 (2603:10b6:303:87::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26 via Frontend
 Transport; Mon, 24 Oct 2022 16:42:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 16:42:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 24 Oct
 2022 09:41:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 24 Oct 2022 09:41:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Mon, 24 Oct 2022 09:41:58 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/210] 4.14.296-rc1 review
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fab57973-7bd1-4d2c-a80f-147234305ef1@drhqmail203.nvidia.com>
Date:   Mon, 24 Oct 2022 09:41:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT042:EE_|CH0PR12MB5234:EE_
X-MS-Office365-Filtering-Correlation-Id: 21af6d46-3fc1-4adb-b8a9-08dab5deac94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+UeKVw+6Kpy5ggdnX+zdIvJMemf/7x1/gTLs+4xpM+QVRBk4tZ5CF/qpRXOhYqcOW2T0284YcG6CubieNUE5huPpRzEymL6JtueAx0UMCjH1tNDZpcCD3UUIwssawUmnLWZ02NC7i+fumWLG9jBSq37Jkr3u0hXFpQzRyrJeA+XPTYCWplv8vBCO6K4huJgyeauPhbUKn+4Qrv1OLq4i4xEimcNN6il7KTdYek7ZETHlywvGDsHkSXna1V7M9cFhc+MEQsQyTpHpBgkyl6aKbDHqc6uyzYJe1X4+hEVVQcR6OBaAEDCao5Ec0mv2Yrl3/3YMvzAUw83Uqv/Ft9S2gBlHTrcXUuXpGGsbbmKDUUe6w3fJfqCpjS4T+Uz8DZnk+VjK5BRWxTicjf41d8BPPBB26Xwx7l+9d71818S2qXCFrBz7P/CiSj9p5VKQ2Bqy5hj5+Gu9zGl8dNq9yEgfSuT6WBMCdQTpf3VPxOJFinoXnfaT4JNsrSFNC0+nSq/6EDtCuDEH8pP4cbnlYG9M2w7eNR47fWliUkOJ8ptdEIzqosIKi6RtJMNd+ByGAuuo8E4rt6MYyrsmuhj9slphTPrrGWtKJ6qpLco2vBmW218732GrKlfzut7Ciu4i/NpzJFzaHQEK3xeqdxsTE41xyZhxoj7995XXn1Y31CC8g6z7ojDZwuYS1uzCGJRz0akDnDrKTRxeKv32WTHGAuN5cqvnq5DZNH6kQ46IBsb1+eqElEP4aefMsAPTCB+UEBMtyF9Ua/8Enm6iK1nj86tp48eZg5oyaVWmQ04WvUcD4A834w4+38qNp+CQI1nlfFb0Eia1lobqTL5v1FcNFwf3OepAqovTxEMPhLxkhLUtE0=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(7416002)(8936002)(5660300002)(54906003)(2906002)(6916009)(41300700001)(40460700003)(4326008)(86362001)(70586007)(966005)(70206006)(316002)(31696002)(8676002)(26005)(36860700001)(426003)(47076005)(336012)(40480700001)(186003)(82740400003)(356005)(7636003)(82310400005)(478600001)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:42:00.8047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21af6d46-3fc1-4adb-b8a9-08dab5deac94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5234
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 13:28:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.296 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.296-rc1.gz
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

Linux version:	4.14.296-rc1-ga6ecd3a0366a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
