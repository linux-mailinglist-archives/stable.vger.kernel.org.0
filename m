Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A492426DEE
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243149AbhJHPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:46:07 -0400
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:39136
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243241AbhJHPp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:45:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tv5jRrlWVt/Mf8L+FNV24wXik8Fx3LsEgF65W3ENvxquQv5IMAkBA+Lcl1u9/4D1u90TOMWAyVJZHrFUMMEH+RTc8iOj5q9A0M91SGFDwqXBZeKtx4YE4DDLLElSQCFa7S43LkUp8b3vAd9xmuj8NPbgUCSGE6aujbSjM8D/LSpGTpDU5PXgMMXqK/DlzGD58WkGROvf4rAKtmKtE/TtH8JAf4hzySdZg6ryqAWzOGUprCNrf1bWztN+kQXBUfBth3rDLDZdHQ8MfdIdMDWxuMa3okL9/dmEAMsz/BKtu4RwBvaQwZxOJ3/MQ/K2OcWbaXvqMVLMT/RZRm34PZjzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w49apkjh+rQ8Eepu+tgkUHLQBhSq/nuQD1VHH/Kh0cY=;
 b=nQeCW8HRCgFcpKwBPQ8YpSelGKJuSholoCoejT96XDXJQNMUu+hxMRX5it1Sv4ETeBsrudreG5HPn805MfhPchEK98TL19TKz7sQ7WnpAHtRDZl/X1y1ZVE9eDCKznXAepzbt+pttNjU5EnwYFZMNOTwHrZHuFoWpbyihEWeums43DMZdg8Zmz0InEq+HOG62djCsLTamFGO3VPM52Qne3YnFOVzZHLDJJu0wt2jEk1KEmBCnbX7HD7Y+Axsbc6+xd7gwZ/+Arapt7aDubxLrF+EhXytdm6lj3+pk04952sK4VTiHk8tVtQOVzsyDfPp1NH8/n/46cRbSl0bZ8SQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w49apkjh+rQ8Eepu+tgkUHLQBhSq/nuQD1VHH/Kh0cY=;
 b=s36AYrioy8ymnus902UV28399VpgrgI+Y0njv6ktcdnlzeN5sff3d2gWm3xaKSCw9ZsNOQcj0ba0IdZD+Jyju9PKB3kXHvKO6OsBp2gX4toTaYJbG2lu9uvDvDEUE+XF8+ArUNFnjl4OpEgMkpUJZUmohUNpED9xl0Q60xvt20VLqRTejMxHmLkgtvUEx/L3YYovBg9H1ODcoUfFH3GWLWM9pZ/JSmW2K19HIpftB0RtnsgxhTa60iEl5tteKLPfLJbCe0TCSjXUwdNvlFWUP/2HGy7EqlpfLSvdKGL04+gUeNCnbhQL0+mdB078HF23A4cydzF698JRlUqXwgRCmQ==
Received: from DM5PR15CA0064.namprd15.prod.outlook.com (2603:10b6:3:ae::26) by
 MWHPR12MB1600.namprd12.prod.outlook.com (2603:10b6:301:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Fri, 8 Oct 2021 15:44:00 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::5c) by DM5PR15CA0064.outlook.office365.com
 (2603:10b6:3:ae::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:43:59 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 15:43:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 15:43:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 0/8] 4.9.286-rc1 review
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
References: <20211008112713.941269121@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5f54ad466be04544854b4f500f582a52@HQMAIL101.nvidia.com>
Date:   Fri, 8 Oct 2021 15:43:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7473e15b-ecb4-47bd-f020-08d98a7271f1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1600:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1600A1E5BF02D0E789221E2AD9B29@MWHPR12MB1600.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HxAsgh7AXgMBdHHfD0HpkQbgLplOF+nHomeZ159tnKo+zYZY3kAS1jPP5rcbMaPUbwnFJQ5AI/cRadQ/s4w4BCFmrBsDMpeLSJuYDhZtXuCFtwOV3kJrPpMEdnjy2vMER5h0P4vi74cisR2qmgm458pzPxX+h29YCTMxQ/9rq6l2+XA2rlDz/5bHa1UK70PrcT2e1FpRFKj69nrX+TiZZ4KxuPaip8IYDhjG9ykePsRVhkc9a3nEE268dHkecONzCE+JV9k53qyjW42T39+PT7krV6gFozYPr0AjKJz92Q6OulC2ZilPKwdMBCjczqsHWN18CkcjrS0wIy7HiGUPpOjIKlIFeDg/WRVPsjNXYM9mbTB0WLc69PMLViYYqI+IavyU3ecSRi4u/CvAdF0OINBppKxp2nxTM8znNXzEHc6hnF+mWbcN6lHySw+D90wx5fatue9m87xeE27l7u6AIeSPDGo0DIOxDaZ1BECKLMqnhXnmUfZMqvRhpRVQvsuWyjYLDOQNi5ZwqAQaAIzMICuMcER8Nwxu5LtTnCFa9Eaf5r8JnoWv2W0SRw3B93DXjfWNMyhGywJsx1mLHhJyLbZThenrLbj8u2j8ocHRAbVZ311nF5L/JhJGXxW+dCeR57uBDN6sFJ89Df9X28GDuG4lBCDzm/HFo+bKOQMh1diyHOBKlXSRhMwKXyuBOkIc+m7TEtPpk5ZWFZ8rDeliyICs9lxD9s7Mj1EV56hpMe8p+7rqCOPaujX6K+9u9jUQzSVDHxbmLpu4CrKmRsBmDpk3CDswp+rGj6SvZbS120=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(86362001)(82310400003)(186003)(54906003)(8936002)(508600001)(426003)(6916009)(966005)(5660300002)(316002)(336012)(108616005)(47076005)(24736004)(4326008)(2906002)(356005)(7636003)(70206006)(36860700001)(70586007)(7416002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:43:59.1142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7473e15b-ecb4-47bd-f020-08d98a7271f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1600
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 08 Oct 2021 13:27:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.286 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.286-rc1.gz
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

Linux version:	4.9.286-rc1-gb57b518625d9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
