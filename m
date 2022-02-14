Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3E4B5324
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355118AbiBNOWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:22:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiBNOWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:22:15 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB384A3F8;
        Mon, 14 Feb 2022 06:22:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5yXDmsCEL+rPP+YY1YZ3FniaVUVpH1YOqqQueQqG7Q6EPdVMaVDg1i1h4K9DEEcXpv9xz+WtYxzbjeOjTC7oghhfIrHrHlEBeJHjI3B2y0qBjXBXE9kRRu6bU9b5tdIrnTIopYf9Ghwh5PmxN7whepI1s41BF/fp/taviemdOhcNkCukQsmwEtCLh0Z1XbU1DfDx6vij51TjzBln9RytforaeqborZ8dzFci0I7gjx7CSt8Eilhvg+uzIxU6BdRtLvdurEGP68PLglIW6Ni/x/b7nIRPllCQvHea4Mjj3mAzEvMo26UK7nVzKTw3GFd8G1BHHnrsNmLCRNP55plGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUivm8PCr37zVEctdvtbw0FV8MIpaciPuPfcwInwL9k=;
 b=Q8Z+uvJvWXKPJgGpXkZgSW+FODS0kTChdo++FpBzanVBIU3rwz4Y9Swa7anubTHFx0TK4VwEzrnF1esbQul8BjcLCp6Sg2UNWHzvRwJjSwqv34eczc4OPkysFNWrekVBPLovKmom7/GxY6aIuIpnT75Q6QJPLLfDHxt8PbAyls2bw8G393YJnnn/b478rlk4qEkyZF0k2DIs5Ac0CiQYmq/9bLyfpAKh55ZCW+rVWd2PTqpGHPpBz7btfKjARdfBPtFmZWjEEsp+U55Pv0BBoAKCX0/FYQ04MhopbEj3WrgiIU1K10HpE3nOlyQ6HrIt5lrAYZtj8p/E8U+YxRaCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUivm8PCr37zVEctdvtbw0FV8MIpaciPuPfcwInwL9k=;
 b=FTntFIgN+pNlaqnGQbHP2s3fraaAqHNHtvwogPwp7LYaIpMZL0cpDQoz8RYDE528O9svrfw3fd97XvXGjQ0lGoAT4HGa1MNgMjTvCyWUCocnSSJcTzs9ZRrnoyYHsU8Hp5D5wTBUCElvZxkQiSCkLsRo+CemUwHTV8rxDTSvOafVKHTI6cmh/T21TDOk/7/GyGtjhEqbF9wvMfjWgJKB20i66UYbqlAyv3D+U4JEvX+8hbS1yDKyy3U3G5EXbncfWwwyepFo499VPkz51N/CA5QBcfMnYvzy5XNBaYQJtx4tfzEljyMS9wrycq8Q4VVun8gPuqAZOaBjHvAFXpCl+A==
Received: from DS7PR05CA0091.namprd05.prod.outlook.com (2603:10b6:8:56::12) by
 DM5PR12MB2374.namprd12.prod.outlook.com (2603:10b6:4:b4::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Mon, 14 Feb 2022 14:22:06 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::94) by DS7PR05CA0091.outlook.office365.com
 (2603:10b6:8:56::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.7 via Frontend
 Transport; Mon, 14 Feb 2022 14:22:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 14:22:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 14:22:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 06:22:04 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Mon, 14 Feb 2022 06:22:04 -0800
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
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7db08e3d-409d-4fd9-9982-55d9f3faa51f@rnnvmail203.nvidia.com>
Date:   Mon, 14 Feb 2022 06:22:04 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 541148d6-7e0c-4bda-ad21-08d9efc560fe
X-MS-TrafficTypeDiagnostic: DM5PR12MB2374:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB23748FBE823E31C69B601A0CD9339@DM5PR12MB2374.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABNnx1ezPe5zl4FibPCPrSin2wmUCoLtB61+pTKs4W0X5QweS4C3JgXDjYgEqnwnU8+ee5RV7v4d88UgihZaokGstoRlViiM4KILODbWWkAd+4PQbus/gQGENlcj3z6H0DJFVothrdTHeR7WLxQtffW5WxQkTlo2HrUjUyFG9fBrFavR89ocJUNPr/Vvof+MJBBlncdRXoq5P78LrRWKiVPVdTrcU2KTRpI4BKa9lsrz3z16JCUzzqt4WhkmLI4KZ7oqMU6B3I/5WPLqqQiFfJoxZuFG+22uTGr8ASi/hh7exZceRNKanbTKOp87H8kPBm0MnmoeJbAFy62PI3MkA4ppl6gDNXA9VILI2I5iUdUwxf8XV2ijaq8kPOEBfvn36VWmJQf0a2K7mFMDvs2G6l4mEDiQnWSAtUJKPAnXPQaEWVF6tXPm1GnBmSF6FFS0DwHoM9oStYSqHwDtKQIXzJu3PZ6Sx0y/e0SfPpHn3h8HcfMdE7TqWY9oJfiTKl8Z8NVmgaYA8Mni9BFGHOD+zmR5hDe8m/WEebrZ/B/HJ9Idmjos6s2vxfdk6TS45NT0157jrFpdWocfkJJiY2cLrAbF7/TX8ueJYKKft/z+Dm45EWD0xYQq0vTxH4Q7RChNyq9kyOcig0q3zRH6YcfaGn5tDERu/qWsojAJ3P7os7noONPxcmdQ3afjOzih/56xdoudFVox1eNsUsfV8NsEWAkblvF4vRM52Hd6hqZJIji24MfSxr2CKEaOHvDfzLosb4Zj3N/eiZG6gmtnyhmG/Ha+d+PRz1A5EGXdTkBKPq0=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8676002)(47076005)(36860700001)(8936002)(31696002)(4326008)(186003)(70206006)(5660300002)(26005)(70586007)(82310400004)(40460700003)(86362001)(2906002)(7416002)(336012)(54906003)(6916009)(508600001)(316002)(356005)(31686004)(966005)(426003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:22:06.3284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 541148d6-7e0c-4bda-ad21-08d9efc560fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2374
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 10:25:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.230-rc1-g6343a97197f0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
