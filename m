Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C975AB6AB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiIBQg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiIBQgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:36:22 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2048.outbound.protection.outlook.com [40.107.96.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD55B5E642;
        Fri,  2 Sep 2022 09:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZbfKAUoOn3FgajOXYzQ6f5pFtMWj7DLHdSadX7YmXHjeddEWgrzBeogdr4EmKFifjcBbp+G4S7CnYiRz6Odn3xR2eALJhOCMCBTSSWFuRbfrRZrGeWwXe/HZkSXCH9QI07oKfTCM7lhBCVrLxM3Q7vb9DYQMoDNQHaiMR9Ur0Ja012j1JZB8MfjORnhLGeBKs/+EpzHi3oMkDBW2jsmeFx780OKsk7cenDwaAUmIzAgWSiNg5hbbQ4sCVZJHTW51UUA/ydUEkmSVZRkK5rQKRo/Mqn0UNQeIeej3yDhvvm35x1IbDeGt9HVSrWa1jU/XCLYWmLYhjyw4AhoUAiRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkJ3AkGz9Xf11DEsy4AF6K84ozZi9/bMpXRIvJ7IA2k=;
 b=P4fgmdyQLnD1Ld/Zib3BNkJr/385dF2IegUrPY4flXK77uiF1UwNbwy/vGlo2m7lrQFNHR5FAjKXpv4VY502iYeKlJwKy8uDM5RifDVqdxTpeTHZs1Al40qo/1mYH+UFbnp2mxM+WFBL4lAd79mcO34wL+Omx0e0GD5LyC5auZRQ/ysdeLQ1A3rvMwWyFYOiSpPhD0XeHxm8L0FjR4KjZZeO9Y5ipZqChhY1ao7+AANBrsU2unBafO7f84hJPjSO/Cb32l0/wZkXthu8z3IABdUbXy61WhX9gB5eN9IcTZiCBBZ6VaR2xDBJVUMhTfX3jA302gfjGE3sTCyqmkRXEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkJ3AkGz9Xf11DEsy4AF6K84ozZi9/bMpXRIvJ7IA2k=;
 b=ODkNiCKwPpiSAvZGxqCONSwAbOkOYAReScjkn0b6ESmdfwSmjXXtsjwZ0RuwuYX8RbYFL8qjHppLaCTq3/wnyWIzF2wVffi0DRms+54sa0DToQpR+n0fUmLwV6NaCfNg2oxtkeC6eXmLLp1ulvEhW1alw+TEfvoPQ/YM0k4rxhuCXvTAHYD71jncTKw506g45be+AITiyX67Te/r2N1cWWgpkONJCR6HLJMEb0r35UHzbgjjEaW7Qk2GyuHhGxKczoaHJIvLfMGbMVl7vKGgzwURAO3XQ4c8zKSUQXqJDWaBNcwuTs8BK5EVyV3Z4p09FBgTEtilfcvqn3fb0eN6jA==
Received: from MW2PR16CA0024.namprd16.prod.outlook.com (2603:10b6:907::37) by
 BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 16:36:20 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::be) by MW2PR16CA0024.outlook.office365.com
 (2603:10b6:907::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14 via Frontend
 Transport; Fri, 2 Sep 2022 16:36:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:36:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 2 Sep
 2022 16:36:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 2 Sep 2022
 09:36:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:36:17 -0700
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
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <14b211b3-bcce-470e-9d8a-52bb5f9812dd@rnnvmail201.nvidia.com>
Date:   Fri, 2 Sep 2022 09:36:17 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cad74f92-a2a7-4bad-b289-08da8d01437b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DYJ7HtI95zCPgvq5oOTUJox15EQkykFaTqVcTt/bAX9H9+DES+HWHLtkKwIqoisA4tWwXTjYSsw0HKdOdvHGjYRRfPcOQQfZeZc4TeH9p1UGTrvMHgj/ws/oJ9HqKXTeHLfoIpWPR6o0L/0dKO6FOd02hX1j/xlCmJ8lwPPu93UkaR4AzFHMT4MrJAaAowDQUanM5l1ijsX5r2vvTuE1o0kS3vJZ8pPdmDsWAmpncECDmabl9qQpfwz5hbGQWsBpdenjNdQuYkrBazRBnyTV4LM9Hh+w/DzrMpXFynBFwvgyw4CaEdgFQ/zlX8LLaZxHbzQ3GuG0VoHtcdUofqvi2KXSoFRdoLV8CuMCz0IUq7zv3VQx64Wa9jvHj9GT0Ewq5exbk4dnlN/7pGigYB3k5BFAN8C14vOfeCr8ji+kGxojqs74PklXHnIXyPo8QttlkHbAmbPI/xUc6baaPhgoPUGyQ+trQQGzALfVwsLGjYbCCWV0poeEN/6OvF2vgkFFRfjH1JE5jF0bVFSxGCrZuCWxb07SowV4CyqdJanfAlGoYkEof5/ZZ4EGeBD5AHpPMvblGd7zTkK8jlfz2SpuUG0GbUDcMhygcYqXyJgwz4NDQvWsm1Q2LlCCze8sn9dcWUb4ORGgUn+M5mtufpSrlCMzrKS1zq/w7/bTZoXYcQD4syyQ5fMeXPKxwc8Zufs8dDZM6zVRLyPwNwM5BUqOTWvOvTfdH5PCA4/mb/vvsA7MyyINeUwLe+FC56vZ5vQGcQQTKhkI16dvXvQxEBvavEGdD2K/D5dhJl/BLy3Sy6n+Rooe8i8OkBsmqSSyC+KBHR7DdwtTiMPmHt78/OCK1A46Ij3Y/wIaN1m7beVeHvFdYw28OKiedHx8XbY60k6l
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(40470700004)(36840700001)(31696002)(356005)(81166007)(36860700001)(40460700003)(82740400003)(4326008)(70586007)(70206006)(8676002)(82310400005)(54906003)(6916009)(40480700001)(316002)(2906002)(8936002)(5660300002)(7416002)(26005)(47076005)(426003)(186003)(336012)(966005)(41300700001)(478600001)(86362001)(31686004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:36:19.1760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cad74f92-a2a7-4bad-b289-08da8d01437b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 02 Sep 2022 14:19:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
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

Linux version:	5.10.141-rc1-gc59495de01ed
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
