Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E854897E6
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbiAJLu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:50:28 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:21900
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245019AbiAJLtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 06:49:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0hD/cBMryYEUbNk2yTmhS0WVN6TvFWprW5GvFRj5c1g4VdmZaYEKrj7d2WQFnDEPkLxNpHpelsMNK5pb9uaX2IzHhGDh4iwd2hdQ0eLIrVakDQQh3NaqdVPA7nZWhym5A1Iume2k8VZJT7CjJRMYTGJE1ANCkJw4o278X92o2PBKwSefuSuXArAxeJAxmOUDz/FnsIqbzHos8rdIRJUHnzQOAWLUPIW9WT3vLhfqa1DYlUr6foHinnXBMjn39yH2LnuJWv4W3Vg9MdRG8PwJRfrUds0Nbq9ap8a68K/982g97fs3EZDMCwUbaD0w6Dyp+W/Vpy+Vz0udxg3Z0t4Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ma86d1hcA8VFUjS7bQXMgG6JqQuOHkK0gqd7qFyn2EQ=;
 b=G20OPF404pHJFqVRp8zRkLe12odSrvJTj0zlEs+OqA/tQv7+x99EZk1x1EtuGzMl1MMwML7CWUwhg9t63A519HieasPutAgnW5XT0SjjbDdaBo/iDgxntFHR3CZrvg27XfjZ6Ah1lPuSsBgmTQDzkPTvA3uEVbBt82LA3UEgAUiseGORY/5DyNpkJNiqsTSlcMCbqridnZXejVWZsPl8EtAM5NC7lg34/v7mfU6EIZB7k8axqDYNq7LTo1H/fPbGbDvyriAGPhRmHBpPiWw/NgmjTlYiKedAHTXCVB906fCDHyhe3P30LGBC1NW/rIVtyp6SjnQBpohTceEv1BFmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ma86d1hcA8VFUjS7bQXMgG6JqQuOHkK0gqd7qFyn2EQ=;
 b=cBl4DoMl3QVf8SZretHxExAOUjK2NoO1uEryEi+cB9TlUBLgzVWWi8zKh7VayrafM6GlpeqsbFnNzwhoNmK6sBMLMxZRwMInyaaDV1zbP5KIYkNfl0NVfh4VbhNAq12B4ci2gH/uyV7PwL7TGmA2mV5J5R6Vd8jczDWLozXBHueLIGDOEiHzzCxyJcqDGuzZpY8dL4NmGbxAq1TUVcgeHbP7LeqcDMxz6vllp0k+T1Ach5D6Ft1SERAD2H8KoWjrgYO7vG57WejfFmORZhlhCGtj8fZ19JUXLq+VNtOPuiFiEOQBD4r3BdgOKB3a7QikYFyUQK+tEwD8zzxAYSL88Q==
Received: from MW4PR04CA0075.namprd04.prod.outlook.com (2603:10b6:303:6b::20)
 by MN2PR12MB3567.namprd12.prod.outlook.com (2603:10b6:208:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 11:49:20 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::5) by MW4PR04CA0075.outlook.office365.com
 (2603:10b6:303:6b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.7 via Frontend Transport; Mon, 10 Jan 2022 11:49:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 10 Jan
 2022 11:49:19 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 10 Jan 2022 11:49:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/14] 4.4.299-rc1 review
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ec89a3d944bc4c5c8e61a31621656289@HQMAIL107.nvidia.com>
Date:   Mon, 10 Jan 2022 11:49:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9e0a56a-e449-4159-6ff4-08d9d42f3cea
X-MS-TrafficTypeDiagnostic: MN2PR12MB3567:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB356796CE398416F4D178246CD9509@MN2PR12MB3567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1vQdNu1xOivePwBoWPILnDBFmh0bqn51HdTvCUMAVTY5TT6NFFALoHFcb/1dDwtO0TLGIHzvK6M+Z+mIF9Jy1G39Wz/HrkLTV4scHhwwxwtMIrOR856sGvXTykNcWUZIWpGTPPnKXFwVfSnv9n5UtV1fDxySDang4h8zyeh2KvrVy+X7Ds7z/UuiAgFiA9d5Q0hakdVVcAfTOsyGSv5LztDz41wqUyBc53esboIE+DPJGYy6Z4qVmpPJVakAuYVn4+xM1ccgUPm0AW3TOo1W4fyMFFjz3fvIcsMF/5Cz9HLzolt7DwLaJXIXVCpneprw6MOONjw6mZqHx+NLYS2e91W/gL8d6M7SriKqVni1+TZnU8YP6l+fBplCDVv9f6EwHlNiaquqeAISKOwjleExGhCKXkkmcp9pq7zB998ZfvClpiBCT04lrqrvZWV1M1C/D2ANO6k6zuvNxkycGkzqwfz2eyB5mHTYAXhOfpLytwsnQ+vTI0oy6nK/CpmLZLDtovF5A99HOXu8YgfD2zfH7IbgzklbS9Q1hgGOzCcq17Hn1kf5X2WgwNtC3rwZLazxSA/rQeLind1OT34shP5kTUh7J6aQrJ8yWGQBOqXFz0GP4LKoAHs/8S6OMK6r3PHktyTz7w1e6zcKlZAfd3m5Sg4jHMPEExBSOkVIBffAHy7JIkxgkMDK6sHeZwqePAq1gdDyeSYySaIABzHmmUSQ+Jc/1bawwa65LtwWfMAJwKM3Oh14cfon3Yui4/kq9JzpjUbKC8QH2l0uKYCFZLIZRsD0IraGEcPzH8xKapOExshlzIFnUW7SUe+jJ4mOfZ6xQMrnR3+QwsTJXI263PlgqjpquV4rZHWDePiMLMUIags+n8HznUGUo7fjkHBo6gv
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(86362001)(426003)(5660300002)(7416002)(316002)(966005)(40460700001)(26005)(8676002)(336012)(108616005)(24736004)(6916009)(186003)(82310400004)(2906002)(81166007)(70586007)(70206006)(54906003)(356005)(4326008)(8936002)(47076005)(36860700001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:49:19.8934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e0a56a-e449-4159-6ff4-08d9d42f3cea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3567
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.299 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.299-rc1-g039b69cc9b15
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
