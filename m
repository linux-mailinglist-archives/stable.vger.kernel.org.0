Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF87A4E9965
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243793AbiC1O0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbiC1O0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A860D2018E;
        Mon, 28 Mar 2022 07:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVrGv9iXaqcxtse7TSi7m7k/VbK0SaC17PS7hCu8zdHUPtoVdm2tnlBaLMNqd8AaMzh+YpxzaN+5fPO+Gukg/DW8wNCU0qAgvMH0zfgZTjvCNoecXOE1gMNpgej11p1JIJu4e11kOppcnsHprshzFWPiklc2vJgEAu9R/MCaKJNpKOFK+z+fWhqPO35L7h3yrhssYgtqioBVxiNlGkwz0CDEO380kEc2jmkwHYm3Ka8IRCb7lp296h5LyGDR6DukiZsh+HVm4C2ZYGLIdlYytbPE8Nmt8CU0Jw0Ad9ub+4I/sXVszTwtksGV5iD9QsllzR84/+TnUtJOjLvWWlldTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/azgRTMv++CwxuhN2mmiMwCrJFEetKSS+vZBQbLwVro=;
 b=mDOzFiFpFkQnixB3DhHS1yfocCl/5xNUEuw3QtE7dF84F96pzH90bgbXq+ObSUIU6PXjMP3mzHYVs7/aNVornYnqlvjWI7OSs72NLEK0d1Ktf4col2wb4pBJpnLyB/aJ1RrdSrTXOasp4VQ4hNS5nhdRLesE/MIbKCUYYU99nZ73iIAfUoKymiznyu9fNW2NjOCdONpGBQEJc+Hc56FdrVx6YHfcUkHo3mhrrrw7ZzzJQrFfhU3GLCcJp3M+CgoutidoJoIXz8fFEGWNZjNeuMLkmyh3nTp+n33I2qiCLJSYwtiT2vo2ZAwDiTMU6QZHCn8E5ovMz1VpMLJUVoOXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/azgRTMv++CwxuhN2mmiMwCrJFEetKSS+vZBQbLwVro=;
 b=Mme4Kfx6ZGJvbCmjzyE+q6L/sDqCslUga9AlrS8cngjilpUoSCmOmQnICf/Fi6UsRNUlKFSSo7v/UTuh9vsYUAq6cx/zJOphmHl0RH0GxbE+YLHtAabcxLpTYNapSKQlBVPQWQ1kAd7RR0v7FCYchyUl2Nsa83Q7vIfGtXTVJ5Phl+L5IEv95vjm4RSjEQJVzwZYHK3ec37w4A7xxEHJjCvHoFkx571xCAd7DMrZc+7YH8UgkKUY3kz+e5Dxm69IIh5MAZKmFnVjMw4VlubsdBhE/V+PzTo7iuQ6wJZ8Ew4aT0RFNA2Dw5XM320dyM9Q3zah87MSoXeRZKgcJeof2Q==
Received: from BN9PR03CA0607.namprd03.prod.outlook.com (2603:10b6:408:106::12)
 by BN6PR12MB1683.namprd12.prod.outlook.com (2603:10b6:405:3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Mon, 28 Mar
 2022 14:24:53 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::73) by BN9PR03CA0607.outlook.office365.com
 (2603:10b6:408:106::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17 via Frontend
 Transport; Mon, 28 Mar 2022 14:24:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:24:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:24:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:24:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:24:51 -0700
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
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <09236794-c9d0-4d53-9dec-4be440c4e64e@rnnvmail203.nvidia.com>
Date:   Mon, 28 Mar 2022 07:24:51 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c55e577-da2f-45bf-6931-08da10c6ba1e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1683:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1683574B3E6B4D2C8CE9225CD91D9@BN6PR12MB1683.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2OqidT7REKD7RKiOebMCEgWH8yy7nJfrbZ+M0gWOi2D1UjUYJ0hqn613wWikss07YMp1Bag9z49hiRuQJJlDDMGTOIyj0YRkDJ/Au0du9nmtovdPgxQ9GTb0nIPaPtEIQGMQCUFUtxdjPva2h8fBMiU0mUpfS8ObjrbzGqlbo/0TYJpPBaWVLZUHK8USyFiJ+n78VwaB/bk4OXP3+Ci3f+zsJteMQUEmzWuUrrO3azAubb5gR+bDQnWrrxdVKuTTr93Hp6aoCfI1ScYzD06094t9rP6YhTQC2UJz//+slxsfcPfJQd3R6iZ8cYDhHgC7l1xH0L/jGapyibE7ASbjUwGSpsN2QCd86gtm8+mAb6qa8DImc21nZp5kUfxJp54670a7b4SRleST3AIF2h+vSMf4HD/r54tL0JTwiDDPkKWOZT3WcsLIakiYha3pjZ2qGkpJO85q2aGY5kYrQ2n+uzGA6vG5DWrh7benpm24bfrzGF9Srt7HnmQKU+gL8RrnFrcqdJv88a7gmfzSXcicSbIclhVgBbIhkwLG+DC01oP7DcVfOkfiL573KyoS9bjQxFxNrgXxxK2UA8h04YXwywt0GUf++B+cRPbCWl97cB3R3v35l9FLdZme2fJVfMz+KDGM9nj+Mn+C9OWeeBBrdeENIVmqqLT4GTsDD4oeFFQwIvX768MXRI1++han+J0URly/0sGrypfmnIkSu1zkvtSHHYKI64CH+3wRCQ8ZkIqNUEEe28J9nG62CS2g+cYmc7deB5+YB+tFMnZWR6G6l0tVMQ322kbpzuzKWVgSy0=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(2906002)(54906003)(82310400004)(8676002)(8936002)(31696002)(86362001)(5660300002)(966005)(316002)(40460700003)(508600001)(70206006)(70586007)(426003)(7416002)(336012)(36860700001)(47076005)(31686004)(6916009)(356005)(81166007)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:24:53.6595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c55e577-da2f-45bf-6931-08da10c6ba1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1683
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:14:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
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

Linux version:	5.15.32-rc1-g6b524190f92f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
