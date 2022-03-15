Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691284D9705
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243777AbiCOJE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiCOJE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:04:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB8CDEEB;
        Tue, 15 Mar 2022 02:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9r4qWgLhShFEQNmlwsNA3/5bx/rP0v4PCb/QbVVZl7FKPe1abk9iPRM41EjMxFxCJe9QzvCTJZq2a+KrG4/YaVL7tdl3sqiB+Hv+X6PShsInGf525VjqmFAimzW1ut+YwFrm88mxWgrwSwCUwuwO+LUJnd7HrJD24+IEjisfvCM87LwiiZ+v6HOhz48Pck2vDk6s0fhcSa4TwH/5VAiM7kdqB2km7ZmgCTijWpV1uPGblx2aQ6vy8/Ic1SqjOvDDdQCtaSVc9fieP2gKYssdHHZoVn0rV7lQFa5SddRI7uyPiBl9emDLojcy59G0f96QiA1pziyrZF5XufvyYJYSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3g667BfsTkZNf1lvZlnwTSNcGxJ9GMUhDWJiV5B6N4=;
 b=a/ODAOgPZcRg+IdVoJyCJZcx5Ii4oj9rnMqCPguVb3cOO7uIP+at/GC6dONCM03XnrAVCR34GS4wAjGwIqz9vagn7Yi7epjmX357pXlf6CaU8x2l57i9zIZ4LuGz6FPQlSVfOsjnETT9REb4Yx0RwRHDhERkQd58tb0X7cZHKsxQL/Alb3UtuFxfVy73BauB7JO7alDcu5o4lr3cd8rAURDS+Mvng8Pr5ASG6fqVQylJdpOMFQfag+U023/p3WDMySh12+l/EUKayOJNrtkKHX60FPlnDeld+9gYmtI17kHyV99tFNcMHyInYd2koGaeENw2W9VFs/sAvMiOfWvLxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3g667BfsTkZNf1lvZlnwTSNcGxJ9GMUhDWJiV5B6N4=;
 b=pDtFWJ05M52VvblnPcsYXL2eHz3hmyTdGoss4S2Ap9NNfm9++VpmhiBhGabKKVY4MgMwC920cFRdmXavLLbAQ9oXHshXW9H+I+Dpj9+DhVYmdLzkETOwM/ti6PayAmr9ILB1vriA9OnVzWPgTgvjgAuNeG/spi77Iz4zQT6bhdNVJq0GXmscqJm9WbfJi28BkdYBMs2zUyvChmxsdR4YeOIvI+fmK/klp9XlZNKHT/TSb/JCO/8UwgnDwBlJKn7GdqOM+wN6pRYvu+xV3SsuB2BU4Qgjow/ujsUodnzUr1F71NnMs1ig8hdXonhbGoY1JJOMwsDw1Fkethn7uv1DFw==
Received: from BN8PR16CA0019.namprd16.prod.outlook.com (2603:10b6:408:4c::32)
 by DM5PR12MB1402.namprd12.prod.outlook.com (2603:10b6:3:73::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 09:03:45 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::3) by BN8PR16CA0019.outlook.office365.com
 (2603:10b6:408:4c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Tue, 15 Mar 2022 09:03:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 09:03:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 09:03:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 02:03:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 02:03:42 -0700
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
Subject: Re: [PATCH 4.14 00/22] 4.14.272-rc2 review
In-Reply-To: <20220314145907.257355309@linuxfoundation.org>
References: <20220314145907.257355309@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <99596c20-a01e-47c9-be0e-cb96ef875abe@rnnvmail201.nvidia.com>
Date:   Tue, 15 Mar 2022 02:03:42 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b3d4076-7799-44c2-48a6-08da0662b5ca
X-MS-TrafficTypeDiagnostic: DM5PR12MB1402:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1402DB0D72302CA124C60323D9109@DM5PR12MB1402.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niQ9fJYeqL40uIbldgB4MWnNaWAvA2kEgH4QxqsEyFQsCf7xLesUrDEu7NbSVg0P6pTxcCZurpTyoD45eI0NoajGDCINe84pxs8tnHD8kRjyiGSOO/pJEqFOzyyoYw4V8uf7H8E9SQiSXPHzI96H7lbWjAleHdsUXwF8fyq7kPLR8iNvcwc9oRGmwaVBbZcGkQARNwC4dERqbGNrepGVajH6ewDjZmeI79P5rdXucaNTYWE9CxC3eXksujN1YjUi8MYfAJn8Pt8+xbOc9apOUOPc/VIJBLqcS+Ocl6VV6Dj8HtUGm3TIpxsnbof7XyjC0FhlEV+Ua4n/HPHFx3PNHL1BxQVM8Ep9owjZYKeTZj6xFwk7iJHhWMhNDwFoTiqYTJR3P+XsDdU8CUra5w5HKf9RTublPqD/1BO2bsSR7iF+kG3hMCbNQ0YyvIApN2UBCTKwvqFdZvB/Ej2Vz+wKjAPAr4h6hogBsw4pGe3FTna1dZEc8hN+SMB94W8H6hZ7RyHAggMP13nTtoaYN+A8IiD0/5asjQDXWiILgwvrlc+dB9+YO54U6fGOLFadRnqKQzTnxa3ZWT5KLRfdAz5iYFqQL9HY0PwZN/2J8hy985jxD33eb/y86A2u693CvUTFNoDNMahFUgkVoyeZR+0oxu2wUbsP+dAcXRJGJU2POxkpmz5eu294h7ORKUhCLUjHh0VIyZa0JVl5KWTpw5unbpBw29E55rv+Z9vurHoA/9/MpOGcTNh7jPJJzQxEojuX09WmKdIzLiqmrzEIisPOnphf+87S+4VYCu8nUXxU+PM=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(31686004)(31696002)(86362001)(54906003)(966005)(8936002)(81166007)(7416002)(356005)(508600001)(40460700003)(5660300002)(82310400004)(70206006)(336012)(186003)(70586007)(8676002)(426003)(47076005)(4326008)(316002)(6916009)(2906002)(26005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:03:45.1122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3d4076-7799-44c2-48a6-08da0662b5ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1402
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 16:00:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.272 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:58:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.272-rc2.gz
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

Linux version:	4.14.272-rc2-ge991f498ccbf
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
