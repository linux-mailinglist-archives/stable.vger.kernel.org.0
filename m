Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C4F47B2C5
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhLTSZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:11 -0500
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:7744
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236695AbhLTSZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQ2k9d95EA6l8i7jtNj5NsnFvwFovIn+JTttVh9ltwkzKaTwsgwJAze0EGKLyW+9P56abAKDQYSkO7lyiXbRP/pMWE1azQ3Wyuvs8GdHWZjJZs3dJvVravHd7UAk0RaWZitKOo+rGnp1Qm0dcno/CzaxCz2XTNB3y/6dYim2dRgy05bioFwRpPT/TjeR6LIMkM/RsWrNWsr0Y6OSfA/dFITmgZroTj95hjoSjasciefHPs9gQyELik5G0T0KR5CTgTCpQv1ZdLwagnfrpY/Fkq1ffxM8EYES4KDNsoZy/7w2XVFGbSClJs8rz0jfdQ6J46+MgjypFB4TsjkMJg3bnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBF2nmiqDqsNyMSJEEztzQY0OPjkttRgUUbNEJ/C4r8=;
 b=EGjq6iwyPX3U60ZfOAXD1uBN+CFTgrtFzMZvUHmp3n5cKx4eowgM1U8ZboCxq3CaDPrtDRr3CR0ZbKM1ffH/1pVEuFYr6ndwpmSoXHjarR/quDRiBgtXR4PhFD2xMIO/hUwWwYxnXryniXQ16885V8k44B3avatraPrEl5XedlAZ7y/CODyXhe0BvsCJfL2d3WjbcPVfjjGy5WiLFYeyvD0C8KFqa+YQIq5HxaKxmpJDBb3qkBD1XmdCNTELMNhWARIGBftloqD1bmrdKP2EUHuThsJ7cPc4NWsCWVupGcjdic2Npa8+wft2+13WVz9rY8Z6ECOAl7VZfQNjFCOOmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBF2nmiqDqsNyMSJEEztzQY0OPjkttRgUUbNEJ/C4r8=;
 b=Zvzv+wmqN/ArlB17twk91UcSQtcGejjeYC7PGUleYAbzUyrANFRwk3mIDIlUoCA+W1VvaT0AMqZOa1VSUDthU7ygVkw1c23hxcycCacKfL3ZrJTzSBjm7diPOKMDoJO93RJVnXMaHtaGb+WzhZHvYqJY60nGn8capU5IY13wq9doGwSzTipjzwpwhVbnVD5jAiuS3GXpHiN70teIEctvqN+8a6mCVOLE/19+/5Jhf2X0dnhhjBn/fbNkb26wXj7CaJV5Nx1mB89TqqhxRJZJjPQTvthEPOJmgqp3nGPtCWy1m7NKbMAW0Y+iE6HOt8GZ1ilmPpMNEb7Xy0BHth0egQ==
Received: from DM5PR07CA0095.namprd07.prod.outlook.com (2603:10b6:4:ae::24) by
 CH2PR12MB5019.namprd12.prod.outlook.com (2603:10b6:610:6a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Mon, 20 Dec 2021 18:25:09 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::cc) by DM5PR07CA0095.outlook.office365.com
 (2603:10b6:4:ae::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:09 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:08 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:08 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:08 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/23] 4.4.296-rc1 review
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <882622219d8e40149bb067230a68789c@HQMAIL101.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:08 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43a403b4-fbf2-4563-a9c0-08d9c3e60dea
X-MS-TrafficTypeDiagnostic: CH2PR12MB5019:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB50194E1BA1F45162D14B1B7CD97B9@CH2PR12MB5019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+ssUUMbnj+iS3lXUSMj8uY4OWi87gPwlPjYEj2q4ngQh52a2W+4O1VBZCnv9sTw+J80DMl3oflBjsS9GO1Ek8OzNzA1fGuD/ucWCDeIBUeoL8P1JOvkKWlPy987Lf83gwCS+mbQRTJrL9nfZonb2xC8Ezf8UNbBTB5jvE4ytZYmJ4hGY+fAfhuLwy7Emq/JwX6L5j/xSw3kw102vUde9xqn57Vm2dwWfLNGt7dk1j5yXoxI2BJ3+ZTHTWhDZWBNQgviEwZYunXcoBSbv7glA9CpxEXK4GF3Y2uSRXyegVWAD50E1iCt68pC6wFaySItl/WdAV442T74AMTomLnLcXwkHLiBjLBi3cI6On9fWfhKWJ9lOYYxvkc7MyxyTMEqJP120YgHzklFkJRMFmgYCS4OeyaMl1SyFdlR35T5sdeFLCXAG5L/Uxm5r/819cH+QXrSg269suYmP7+fGCskAUHvsJaLGGSwmGjJNepAVDorVMeRhPtjlXPC6kFeJ4CuWKgFf4UzuHfdcEjrJNizcqU5E2E2mQmAvpiYg8o6h9ze01fAHGaHNxwTSlT5N73lju7zQqPxsKA7AV08OhXyIIjZ268GUgQbrKuNz7yGbuwScKVokmJ17K1cOLTHPZ/HZCmfTDGnOHnzyav8XzgCgaZBhYvI5syM9vz2fDDjF46RzALWvSz+aTplHp185CftcAEzO98T1MarQyKTNDk5Bo4Tv12ytxeLsKOAG38bMQbAgRLjiY34wF2NS+L5nsXVKomjVt/2cJ/qKr6VG6Phk5Cr4pNhtg+2nFt71Pzqx4/1Uxmth100S18zYowKdDu6QurqGXKiEXq6eg4XsYttSmFuMEGYZlUYMZyVXlC6scJCBIxkXJ1Uza6EdLYAEmt7/jCanvrwWomPzeQ88IO6PGgQsvg732bCrmNqCgugDWU=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(47076005)(86362001)(6916009)(4326008)(316002)(8676002)(426003)(34020700004)(36860700001)(26005)(186003)(40460700001)(356005)(336012)(70206006)(70586007)(82310400004)(81166007)(5660300002)(54906003)(108616005)(24736004)(508600001)(8936002)(2906002)(966005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:09.1763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a403b4-fbf2-4563-a9c0-08d9c3e60dea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5019
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:34:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.296 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.296-rc1.gz
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

Linux version:	4.4.296-rc1-gf46f7fed4810
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
