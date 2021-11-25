Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101E945E1B1
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbhKYUlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:41:40 -0500
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:20065
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243212AbhKYUjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 15:39:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1nJnCS/W1dOrY5KZa8jxReXOBWyZmuaF1JF8VdGoBAlvjKe73hK9W3/MhLFC7nmOLAwHo6gJ/lKYouFjUk00GauMjbdLsiB5EdW+wBCsUMoqZQUBhIYa8xvmcoDBfG/1uBYxSntONduhc0nGTP5ckAHvYb8rvNUaKqP7PF8FaAwHwwaFGIjYecJRSGBDiFd7ibx3yZqt81SCDAB6SKfPcmguSpECei5KQ2ZwUGz3SfWSv4ZhC99ZLfOHuOIPfwh/n3LV5IwnoZRqpHVpw6w6z8bXr6/UYUp1iyxiTBf9WoiI0yV0MmjwuOQ1aS6WbNxf7h9qQkqfOv00EMgNkcLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DY4Z/M8fUoTCCO3eU4fYHdZD2EbfGjvkN2jiCiVQgM=;
 b=fzXbeR5Rfe1kaIH6u52/jCWEUgYr3B3lFfK/j+Xbo0IDEtlML29DCwc3Qq1AiG56q9GJSFmP5cgu6GuAWfksEatP4xcYMU7XLx4XVc1CFXpT9qq/DxphJHWavGbsmnC1HccK6KXz+UCbyPnSYKxSGaqKlyqXFSbXOPyJNUeMLqs9qGiTHLtqeqrlounZ43rGgrKd22NKdb6cQT3eiOtC3jF2l+3Gi8FGVdwsDpm3nAzypx54rT6WV320MHlMvAQeZffJvJlUJJjn8zG71ysGvk4cfKDLak0kNYxN2kzUZMqgk01h26ikqFfNOeh3kLmmkV7ezp/rVeeS+z8JwQrzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DY4Z/M8fUoTCCO3eU4fYHdZD2EbfGjvkN2jiCiVQgM=;
 b=HeNX6objw1J3dUI07RXOGEIxwvX+bOO8t62NMK3hjrp9W9PWwb+YmLPkJaT37TUrrz4i+SMkEvpjqOj8QaSu4HywRzxHVSNPlDMN07VIxhb2n1dspINCkuEunlBaYucDyyQEcXRGmdAFOI3KpmZmAn6XEyZyGVXJTPP2peWh22ah6YswZQplvpgi+dbP0wZp5KobYloz+PBFWTczHzz1plHsqZz1T0Szu3Fn5ClthvRYnJaEJvnx69vpC0ZlY1+Np5ZkY1IXRt0w0j53KGX56dWXfzVf8tMZx9MRGIUSh4OPZ72xxFN0igtxdZgR2yWKT5Y6VnqeDmm7/IXwan/V+g==
Received: from DM6PR03CA0028.namprd03.prod.outlook.com (2603:10b6:5:40::41) by
 SN1PR12MB2416.namprd12.prod.outlook.com (2603:10b6:802:2f::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Thu, 25 Nov 2021 20:36:26 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::11) by DM6PR03CA0028.outlook.office365.com
 (2603:10b6:5:40::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:36:26 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 12:36:25 -0800
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Thu, 25 Nov 2021 20:36:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/204] 4.9.291-rc3 review
In-Reply-To: <20211125160515.184659981@linuxfoundation.org>
References: <20211125160515.184659981@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <10bc944d9ae0489085f10c81325c977e@HQMAIL111.nvidia.com>
Date:   Thu, 25 Nov 2021 20:36:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979314ad-b882-4e71-4dc1-08d9b0534091
X-MS-TrafficTypeDiagnostic: SN1PR12MB2416:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2416AE44382C0CEEE1C56FC5D9629@SN1PR12MB2416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+YAnplWv/3l+K7mvAGlUaJx8f6UV4NelGNMib/LtOkxye2DAgN0B5TBsB1AXuMy5X96kgT77Ku5KxCiTfZSQV2ejCj7LlzfvcHlPRB5IdZsWZ9b11gc1c95KPFD/xaGlZmQbfz6s/TD9gX8dHuRKPvTRD/lbHdjZ9aFyKjEt3O3ENjZWg87JiAHWScHn80NSoGgi3CAq6yIw1mos+H5FGneiBfTYhQglOf6OVlLcZw1djJ6KiASblLmjpzngVxadwtYTlIiS69hOgl7bWNO7Qsq37kJmKdlvAzWnqmOvNAfzXq9vQEUlq2Xp9M2P3G+rj442UQ/FiWlieLPTkjIYacbUZ58NKlbxX9UN+YBOLvaPwQR2fhNkrxJB4PwQoCYjfbsbHZlJaO0BvN177dXns56CXTHI0/9/aV37FcBrVy7axrLf/5yU9zGeRdpvDCYJDH28sIXO8CHs639O6OBWKhqLp/xSBhJpLY0ZEKqVwgaTrsm/znw7Kag6X952cU0GAWceJwOMOdsziSUofHKEuVxO5YQICeUWP1W8yjTumOT2mlPKObHg2k61LyIFi+u4tpGQj9vlN21XH6UMBEuJqe3xB24t6hMKraLOgQwJTA7z/wtRngGTPhPwAY+EHoVVMd7tKsmuvZJHjyluiTVu0Xa+s1zSn4P2WwM8MTbSAg3jIcZKBF4h9DyV/QpccWevPf82SEwNnmO3r0kJYzibi+SMpH/caQ5UJd12/mnUrB7SF34bmpym12oDdVzFyXnpJyQ0KvV27R/leI4bg3g9278ccQEQsEZ0R17Kjjwb30=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(8936002)(5660300002)(7636003)(8676002)(508600001)(336012)(86362001)(7416002)(186003)(36860700001)(26005)(2906002)(70586007)(316002)(356005)(70206006)(6916009)(54906003)(82310400004)(4326008)(426003)(966005)(108616005)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:36:26.0694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 979314ad-b882-4e71-4dc1-08d9b0534091
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2416
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 17:07:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.291-rc3.gz
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

Linux version:	4.9.291-rc3-g54bc9d253e82
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
