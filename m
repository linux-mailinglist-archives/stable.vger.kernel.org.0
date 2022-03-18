Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED44DDA4D
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiCRNP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiCRNP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:15:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF40C2921CC;
        Fri, 18 Mar 2022 06:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKak55sW2rAJmX+tTEjejSFIsCLLN7Rtnj+ndhxeUXc0dV9aFRZaLPpAmC6k9B+9tZ98FUjqUMV/0BTOJVPZioRbgpQFl/P3J7cHLtdsZOP46h6IOnZWrWV7vTYHft4CpUYZ3ulPFsV1afUsLteFxqsoEMiKkhyk85JWkXPIQsXldQuOZ48KtU4qpvrsENl/nmGLBBe6ZiCankPzIrp6cfhVhS2RSpigAavxN0StTajPZKMgnMJegvBODhiNwBKb+LtlDje3WcCv9XXn6kjKOm5GkK1LbeK2nnnwAc0HT+9kM40IGV/QOo76d8ntctBsKrTKZxyFN+cu1FTPXJT9nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cJmtEnZJiuBoRiObfxbH+RE77wKx76yDylJ701Ac2k=;
 b=Fajto62Y8l49fplhQBjAo5GFq4lMRwb+tf2vfGzbUAYJi7A/5fWwdDAy4yQNSaLx/b314rsqlxdgZPOaK6E6Q8T5Fpz63L+G2hqkbrqSbs3EInsr4nD+qI7liTjFB0tSuBmvrihr7eyjN+9D/E4tw18hxP906N4N8wJPy4WNiJ0EzyizN0q+T59cscp69GnafXesWBO7JUuIFLshehSVcTHeGWqnWX8fxOP+Fc8mFNtJ+GIkH/x0Hntlqrc5B6VRFV2oPMdNQ53I2kvS22/NZT6hPvnu6LgoElwtd1sRw9JShmC1D0bjxw0AYHju+YZCNCw4PiAheT29Qq0A6gN7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cJmtEnZJiuBoRiObfxbH+RE77wKx76yDylJ701Ac2k=;
 b=c8lCxbLIS6ZMuzh26opEl9RE7r8HWRGg7gbz9tbwtcGG/y8z47Q8zJgou5N/t8Qt+aMb/vFV/8CkqGRFteo986IlRy1MCZVQioCyII0XniAEAcuc6j1n8Qa0KAfKSkuOzzv2D+avUENjYcBn+lrH/UAnb6W2DyedsMycffzoWFCQmn4XL5eaetkJms900kGitteXloOgO21uj/y5WR226J7JKiXjIj/iFuNY5onsPsZDDQXnFiiJLDYk0jVx44fTCYqcLImwFQrqOQ9/XHLHHdlh0HsBMpTr6mxNB/FfbXqrxQUygfmbcm/Rwr0rLJNPddtrBGoSLi/YHKECY8w71w==
Received: from DM5PR15CA0039.namprd15.prod.outlook.com (2603:10b6:4:4b::25) by
 BN6PR12MB1747.namprd12.prod.outlook.com (2603:10b6:404:106::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Fri, 18 Mar
 2022 13:14:37 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::81) by DM5PR15CA0039.outlook.office365.com
 (2603:10b6:4:4b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18 via Frontend
 Transport; Fri, 18 Mar 2022 13:14:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Fri, 18 Mar 2022 13:14:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 18 Mar
 2022 13:14:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 18 Mar
 2022 06:14:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 18 Mar 2022 06:14:33 -0700
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
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e745d908-46a2-46d0-a8a4-e6d6c69c18a1@rnnvmail201.nvidia.com>
Date:   Fri, 18 Mar 2022 06:14:33 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 682f2012-3f40-47c2-87d5-08da08e13fc7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1747:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1747611324B8F8377ADAB574D9139@BN6PR12MB1747.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aWf5cMwQF1BQla29mKNkwPlaYPGcxh9ejeRwZYHyMTswZAMndOe+1Traxu7yM3NGx2fOEu7C+8n43mRAWNmpZ94xFV2sHdJXVP3wlWWvxKy2Te+M1+lRwtFNCeKBRaO+DrrllNfFHdatlTGXZahh5bMaDcxIgIPV9lgtVNYbbEzVHpz2gYq278xsgaVlbxl6+N5e/fT0fwGoaVTU1PS9Q+/CaIn0Ts8Pzhw+yv9BjLg7Fame4QQsgXMgIE6f4tI7ksJa4sjckdwKOTwTIk2zynmb7gJRSJhaQ8zOZ3KjObsCerw24xjO20FY0bk+lhBVqYr2faahiEYO54aCiD8SaFH97bfZWRAXgaZ9s4vfXxVlrbuKX4KS1Cej/NUT8svBV/acDJfmu7RYACatTuuiAkUwRj4LM+kf8eKq/9N3+SPt1LOguFti3qYfTN8z/JMa8lEnGwIB1kU14oCdBLAJbewWtjKXNVxeWbl09ajNUe+QGYaqEUGpJjhD1FNgkxQAM5dSmtDTJOxI7EZsav3wlEvBcmtU1+ARYlxRoYE8zoD9Qkv3CR9rlKArtUbq+WiJMfsFbFjPgLqm36lt/4pY7GQjjzrav0XKZMNJV+k6tR40bqjax9yumGbzKEKftEsA1xMZYn97iCFQMFKy8ItuqZMeSaYZeZbi/6dIml9rW8ug+uJepjkBnwl16+Nl5BB3U9SF7ZHohuZ7RiJZQ/CsesepIi6cQDZcGyUjgYdfHmcNj+QklM88tcGRGYSorb8e1jc1idhfZj4oRfSEADDCP7xKNhpXx+3rfp/AgTu3TCM=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(47076005)(508600001)(36860700001)(426003)(82310400004)(186003)(26005)(336012)(966005)(31696002)(356005)(2906002)(316002)(31686004)(86362001)(40460700003)(8936002)(7416002)(5660300002)(4326008)(8676002)(70206006)(81166007)(70586007)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:14:35.5957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 682f2012-3f40-47c2-87d5-08da08e13fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1747
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 13:45:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.16-rc1-g106ac438092e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
