Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7AF529B2E
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 09:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiEQHjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 03:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiEQHjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 03:39:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAB049CA7;
        Tue, 17 May 2022 00:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed6lSY+49zHntXjQcA7H6ctO9A6W+9yRjGNVOJL7/gq2pR9DHHVHpgI5bfQxoPWTbzOy1rfZHj9qLIjPcROe4AubZJMJlzindIanh1nf0bjViR8iXuqOCR2r/5CNGeHkjmtytmynvYifxNhAmW8a0EEG+tgVwmnnSpFH9jGPi5upVpHEZoi7dUBj8Opv6dlnOEb5pm7DsJ4YrWnGH6P6Z2eAWTdbYyFiC0Le2FBUMOlVDcs4HSNgLcAC6HlTZoipkE1Ht89dkb7RCQ4kD7W0eQ71ftEK9ysGpRusMXUQ/ReyvxsViV+8oGYow9KIlT+aj2z9NdEi/TFBplZpgq3niA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbGAzPXQifoA64vgrvuijsju4r7bZdLwD/wj+raygA4=;
 b=OnfC7DEyTcvR9ZRHK8KWT8a0ap8WZruITx2+cpaqT+d+DFlBmQDQaw0KhWKf0Gl0aJ8ySvyu9B36jmy+ByC+G0cnuZnnjbzUkfSvsOBo/zF8haj/2qMMH05/d87ByeOvZZclzmaldcqjr9BA6ZrSvIykxVZktiONajDvN6SGKpYjQICjcOfUmBxNqFdVUcOzmjzQb7GdIx6lzMZ9AtCMFo1oawWvyD/Chy8GTft94SvPXPlLBV4pAcjankuDKdl7VBiSvidBY+mljuSCHHoeP8pR8Crhm/4f6wvAFajfBx4kwLlWvQTj3lBEuPlE61mmocDcnpM/hQ6LAk0ktzFXYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbGAzPXQifoA64vgrvuijsju4r7bZdLwD/wj+raygA4=;
 b=N2dEGrhkvs/G2lFHPld7O2NNWKDZC8RPhTMUv98twOIWRCmD1AdWAM2nbORWoyPeOVocCX8RrPOrIaPemJjwdU6g8LtyNsFDM63x2HNU2Cj90C9oFkri8k+P72I+VLrzEQL5uE3DNJWUu4yVwnVt8dwkX6MRykz6ZRrU30lBt+yohvi6QddVep5qQEgmWatt06m+kJ1AxBd1iZueq6G1Ug2mewmghosZPxeW8lcISnlmq2/dHmsM8kKBJLONKuHU1DHRHHtPYDa2Fzs9bYfqmvBzCr2/ARz/VtecoACrqalav3gw5lxkQ8pPNFzQpllfOspS1vzCCR7tAidLR7rYjw==
Received: from DM6PR02CA0117.namprd02.prod.outlook.com (2603:10b6:5:1b4::19)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 07:37:29 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::63) by DM6PR02CA0117.outlook.office365.com
 (2603:10b6:5:1b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Tue, 17 May 2022 07:37:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:37:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 07:37:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 00:37:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 00:37:27 -0700
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
Subject: Re: [PATCH 4.9 00/19] 4.9.315-rc1 review
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
References: <20220516193613.497233635@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cc57566d-d1da-4386-a29e-20d3cad2f1af@drhqmail201.nvidia.com>
Date:   Tue, 17 May 2022 00:37:27 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd4cb9c-0741-4695-d5be-08da37d81872
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53637F9A799022DB22995170D9CE9@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1QHPBjz75K73tsakeQSdbmFlPhYCJJFpctrSAuC91YkgsIr1tGq2qsejjdF8a+hBNJ55DNU9WKeSntF2LJG35bTlqmUPXoDKIZn83BLtlZrD74rxLZTQkUwKQ+kVOelGi0OfVpbw6TPjA5IVridsbqhcZMh9053njCvux61JxxL3i60KzHkCzuaByYJjbz8AOTIKaubNZAZN7V6NVIyuE1OpgdDUDIHzxi8mLHNLSWsWmMMive0gW17vqfcPP7AvHx0ugvA4IJco7wZzmOQAsURs5fkHAk2zTRChe/RCXFV3J4ATXvrCyMrNTciinCwjT2psSByVYYP8QxQHKvy1ABzsijUOgsgNcOrEeeA2+nsRRTV1Dj9it/3N2QUwqpTCepBV5/ChWO3kc2RfexHe02Q+/4xDRgJ6u//F0nXbOVHQMVDJpZUHZ1IHJJjTM8vXfjuw6nsndMQR+Bi6GbPzqeF+HrlpuK2cadVFubV4HaegFkCnMi8bdJabBckoUhpnxFTQUJN/PJGCI5Ax9qWF/9e6Nsnr7XeKRj0R9WluFrYb+g6yKFwm1atOmcfwbN3efJXThT12+y2qOeZFnkrv+geZkCpjiS21Em2kW8zNDGT3dtIqMV9vYY57R4kGjrXd3wOm/7SZA5OSW2QVFml4Uti67ghiShAe5kYRTHCCy7bxozyoi+waZ1b8ab7FQnecx52SNx0+S/2+RW5GXrbx2L+AMfQz2I6jBLc9ABRSGXJlKtWDVr0C6t1utPxGufJGyFqMsWqqqBibiRyso9hmUen1FOXYn1479CXrDMshLg=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(186003)(2906002)(26005)(7416002)(8676002)(966005)(82310400005)(8936002)(316002)(508600001)(6916009)(31696002)(40460700003)(31686004)(4326008)(356005)(86362001)(54906003)(81166007)(70586007)(70206006)(426003)(36860700001)(47076005)(336012)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:37:28.7895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd4cb9c-0741-4695-d5be-08da37d81872
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:36:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.315 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.315-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.315-rc1-gf71a7b332169
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
