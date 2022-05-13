Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD1526748
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382435AbiEMQkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382434AbiEMQks (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5110A1;
        Fri, 13 May 2022 09:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVsF/U9A1TSljZWY5FvdhKl+MrHkTL89UViRkMkwZPC/iN6dQVKOlLLg8WgJzAjTnfykAqVCEt3dLKpDx4SpPMfrnjYC7+SmKnmo9vaulAWG6L9aCNxTkyD2tTi82LCVg8+bYV0CHYVt5ay3/i8A4iGR+toV37tMnrxEa/cg64SgNfzYtuu/E8x+Opq3l3zIFVl5k4/zHHRcY7lT6tHFZJRQE/wL3RP6wQRBrgHv2VhAB7jMmm/rUQzeHiYwgppypvQTRYtZ0ZkkgeTRRpvo7IPh4qxtDUJyR1OvIWFb/PcqN2qzXh/hOUv6uOLSWDiJcjMuCp86Km28YnXu286CaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPOOGTL0zTYtrzr5NfKU/yMIdWkq6MS0NDyCg+MXX3Q=;
 b=bVO+AWzWv0zX1HS1xWlaIo19X9tfPvm8k6oXz9OTlrEnlzx1BegdS/9FVynuOtMeU35cEfw8Q7iuqj/heGYNUjDJ5C/ukxTe972nlotQosLVpGR0cV5Njl6sW5inOS5m1n+GdkyWmcKPCFed5e/6wlCpRvJtYUjkjijiHealirx70a4iEbyKZ5AMKrV1G6ukRyrePnMimhC3yi4iJHu5P9biKtaz0dA9JMCcwVa6d46lf/KAQOl9g8A5D2/twbbkwLNf9BYx5ULCBdtWeECcoY3K1Z6Vpo89YuBQx80pD8RUKVGJJnE7tE+LrN4Z6wov8ScUbYcZda6f3D8AXepm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPOOGTL0zTYtrzr5NfKU/yMIdWkq6MS0NDyCg+MXX3Q=;
 b=bTAErMj8aDocicBx3jNiXk25B3fIw7FJ9tnGq9hajcywfFc7kxR3IsHDJtDlNwXRgdZHQkh15L7jCPQh4AHoi0XfwwpzdTD/7sVC1jPkFmXOXdy9kczMUpubcusxm/qso3EUXUIyO768pVfDf6sXEwXTACKuGwQFFIFLgTWZiVdYZoLwH9jAZZOgGEYV5oF6w0YmqeyY/9L+jenlKMEWthjrLufa+Y3sp5nmMGhdqbO+sF7t++jWH1GQH7mGqkjNW2/3JeNXc1985f6VTEiJsW7TCTMsmEWgCWMDF8dsCe9ZYpSHX/NF1PbDLp6w00vz/0n4U8BdCQWrbgypM76F8A==
Received: from DM6PR07CA0051.namprd07.prod.outlook.com (2603:10b6:5:74::28) by
 DM6PR12MB3148.namprd12.prod.outlook.com (2603:10b6:5:11c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Fri, 13 May 2022 16:40:46 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::62) by DM6PR07CA0051.outlook.office365.com
 (2603:10b6:5:74::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Fri, 13 May 2022 16:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 13 May 2022 16:40:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 13 May 2022 09:40:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:45 -0700
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
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dceb4818-5799-4163-b7ea-acd02cb84c55@drhqmail201.nvidia.com>
Date:   Fri, 13 May 2022 09:40:45 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49723c74-e28b-46ba-07b5-08da34ff5464
X-MS-TrafficTypeDiagnostic: DM6PR12MB3148:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3148AE1E39FBEBE79FBCE305D9CA9@DM6PR12MB3148.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iow/H9TC0mVQQhXILB4S6XmB2BxMjfbQNaAMxarIdcAkuZx/TqXNFStpBNlzd2kOfxR6DZjVKTUuJdkeEohIPnUfrEfqWxDTmwK0tkUPgmYRTroP4ex4iQD50sbKyQ8c7YJj86MpDjmNo2CdzXbluKDKwgVUp4T8Bke0oBiASQ4pTleVyqTIjI0xicxDBhfG2B7rr6cmImLGZDzvwlWMpSY6mnoGVne3wWwJUp9ep69laLYxAWMq6XRoF38KQOJTY2dkRS+cK9wzolYmaylN8gARsR/vNGDwQt/jnjWwVibwTVF7y/9akf+wdkc/TKK93s5sD641IYwe5+2NZGlUn+RQZTYGvNI6LdrXfxDOU5KnDtiWL9Ck3ouGPmsrqp3XvQTTww628ytLElz16HJAzM5PATCR245HL1GhAkFM8hZ39zFaR6OOtWGapO9x5v684cm/lGR3CyuqndhUBOfKirFVSLMllRq5DsD7qacgXzyvjwysiFDbIphZVPuTkxSSO4MziiPDEXfM7wyrObDqopgU7j08oMIQVKol3HP3sHfpLdp7y5SsZoZl6hm9fliCuB5g1P0i9xtmCbDhNpb2c9/+VLKZ0AAL1+t7Yd1aekmG8hd087qm6RNpuy3ZtP6u2yDrp1qUXOKzcTf0yW3ptuXkYx0cBECG4RKDu5IEJa6CodUATdYpxRSlaz+oACO8i4vApQHE6EYUPN/p/qDx0AjCk/GVvVz/cVrtnEkyI9VcnZ0+4iJYYnr2abk8p7zavW2M+LreSuvYVzTlrjRYmjKCauCRQ7NLD3xB+M9OWxU=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(7416002)(2906002)(8936002)(81166007)(356005)(31686004)(36860700001)(70206006)(5660300002)(186003)(31696002)(426003)(508600001)(4326008)(70586007)(8676002)(47076005)(336012)(54906003)(82310400005)(316002)(6916009)(26005)(86362001)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:46.2243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49723c74-e28b-46ba-07b5-08da34ff5464
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3148
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:24:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    130 tests:	130 pass, 0 fail

Linux version:	5.17.8-rc1-ga8480fa60862
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
