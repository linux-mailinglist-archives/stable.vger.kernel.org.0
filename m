Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FEF567141
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiGEOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiGEOgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:36:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA5E63AD;
        Tue,  5 Jul 2022 07:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh+AZxHji0jKQ8d5/mcHnel01RX52UJsukKuCKI7LYT7mCFokW2eeIqgR93c9zvK2JXMIvnVR6hNeI3GBtlGBwN6bPXtHYGDr1Vr2KBuraNux3kjfCtIu86mhTJ2Wl6dTYnO88mNnmPHKBEtSMeMYa2Vwmhm7pvk6kah5Gw41ytLy28N0YsgnVhDuWRMyXnvplCCi+Aw6omhez7oRrPbS7bCSpRikkBwoOkqSXbDn67q84k4AwZbY+bPGmzcdC1Ih+/2uUdANVh7ns+BkDRt3pyJ7kTt9UGIG6UEkXMCIKQcXLJAZA/xiMmpLuzbUgLCgtYNjlFi9Hd4NrErtRHAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6UqOJnNxXVLvfjwfIfwNVpYrraEBdWZcAUh5vy1MaM=;
 b=E6yP56GbpXwcTO3cHLFjJWpZC7j4aBIJYENRk/hlPjJ0CpR/xRnpz1XshKQ2kJuXHELS4rU29vsrbHe/muPOB5hlqjavNa2gFFJ+k34xpaCr/xFIs+cBqXIPok42h9/K3yC7hW9Jso/pQmJRJLkAbhNCYcmGAqy4cv/M2gy0rVXFo5nFupiIdVqSXZAnnEHAfqdWeAAGiEiRKnrDbLhGRdB2NTDO2yzULRCcuGiSfWOPYge3RDdXqliktwPfTbXx+iCOV2etUymEMvCw0ZAYq8PkZy0j6kB2wadpJJgpSb/NSuI27xqXyj1cX16+K+51lMG1p2hGt5k8fLhfZr0/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6UqOJnNxXVLvfjwfIfwNVpYrraEBdWZcAUh5vy1MaM=;
 b=GwXjR3sQC7GpAnli5nUHKZWKtoJgpOXa8em+NNE1IuuCV8Gg5dWGJZSPf8kZF5ZImewXBjAjUnVP32kVBwgaJfUSAqSInV69acuhBgerldld7WqkaqCSTs5guLMhdCIn7JB1Li3IY1ICV9+vqYgOeeuS37vwkW8Xjh51T4oZGRSdSr9FFRwqcdBz2sL/mHCb6bsIGnbO7s2PkVKvoqtARiIkWds0/ItAydYbEO0fTV7rdmN3uvYpt7lsW3KqmMsef5/XgRJRtae8RGFdBkZcJFtGHDZkfI8HuHkU+asqBh6GrHmeEUcqL2ReBqh2RB3MCuUSFtzCsUrHtcCxETs9oQ==
Received: from BN6PR13CA0011.namprd13.prod.outlook.com (2603:10b6:404:10a::21)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 14:36:03 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::78) by BN6PR13CA0011.outlook.office365.com
 (2603:10b6:404:10a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15 via Frontend
 Transport; Tue, 5 Jul 2022 14:36:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 14:35:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 14:35:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 07:35:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 07:35:49 -0700
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
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8874c35c-db5a-421c-b094-0f8fc05f9e02@drhqmail201.nvidia.com>
Date:   Tue, 5 Jul 2022 07:35:49 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cff15aed-ab9e-45ad-1a0d-08da5e93ae38
X-MS-TrafficTypeDiagnostic: LV2PR12MB5847:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDs9xhSIIFUcHB/S65x6Cer+KRz8GGLmkkiW0Up6/ZbUvy+XOZZN5eYpk4nNtB6ydZYYE0aB+A6CyhZeEj5Hc0KLzm7wz70Tw5RntwjGYhEtzwIMaHd59sh3WJhywJJTBPWnIESV2yrvlcJGG8j3FyMjwQUwqFi4NdeJo03ofmMw5pjO1eDzyXDfGc+96h0GL6kErBr95trV92bPCMBz7egDjFiQ+FPMVYEPEpNEIV04o4Df+mpRz4RQ3tBFMBhp4J+xKvQC38PYmm2t0T1jWPgsw8fIOBr69J/pAd0ImLDids0u6D8zz+R9tM/ZP/ALvCoBVFencb10axbzJO7ni9E3rgQUrwTtqDBPEP0gK1XPoWqoEIBOLYIheETHAo4JEFyorwRc97R4PW+LKRANsFVlGAX6mooveR1M80yq26PKkPWZBEWxpA9jOYKBEbJILmQd1mltnMEjyqzsQ4HXiH9t+mTVN5wBtLwOcI3X+vIqiGVqqXwJYTg1d8VJcRk+w6PnoASqHcU4aeINVUWun3yxYd6Mqr+FtY2djnyUKOy+mn+9qlm+D1HEP94Tq+P9whz9bgQ595LYbXa5v6iZhl1mRvmSvnQi4BVtUvyoz57PCIfbcXRrr+l/KunrWhsl22gxlmqmA45Q8+bhRQ4Hv+sLC0ffkLuk/gQQmJKuzDJvuHqh6td32nrS1etbXLIcEWaDM/EekDCslde/SCs4ALi/3FneczlSUZ5WBBuZt3eHN4k6pFmi3BT0pt946W2zlrCuy1X0vNoxvdgR/opavNcxTi0Bthv8YfQ2VirIwMfHv6JLXBMDeHUGBDW7GC41GRXCD6sNETCnp1P61JRGxPCKahVOpRNkMY0aWqhDaSW3U83Eik4wbePlhoaR3eniu8/+4iD6LYmAoNImPBBhTnAx7RJGjR+nYrtahaHH+TC5KVtmrK0gAqaZAPutR/aK
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(40470700004)(36840700001)(54906003)(316002)(6916009)(41300700001)(4326008)(40480700001)(478600001)(966005)(26005)(82310400005)(40460700003)(8676002)(70586007)(2906002)(70206006)(36860700001)(5660300002)(31696002)(86362001)(7416002)(82740400003)(31686004)(356005)(81166007)(47076005)(186003)(336012)(426003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:35:59.9649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cff15aed-ab9e-45ad-1a0d-08da5e93ae38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Jul 2022 13:57:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.204-rc1-g0f4cd7014f41
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
