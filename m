Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEA547B2D2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhLTSZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:46 -0500
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:43104
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236730AbhLTSZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP5dTTDvGrNqg+D012DLRSpoWfBluxRAAnZZYvsqnwfZ27Had3H256OljWTbR7i0wKQG3CzaWGniQvrQ7+eOvQbFx7hOdZCeiwfDxMC9hT9T2DAQyC8vFEKQ0zPxHDN56MvuUCV8OmKVymHdh/RABquQX9T1uO+pnH2wm5xZ2B8NAesmZtWbUX19USq4hg+4mc3gUh+CCmkehkWnbWILBvpOXRlE+5Ar85yHnd55rY+ZVK3uE54QqpASL2vqBP3fhV7qFBrJQlWz2+NR86rwBaPyFUuRxjOvhmGQQo5cyGpjtPeWuycdKA7Xx8Iw1OtQ0unRscBfye/a9rSQiPoA/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIuAUJDfpi4PszmUVc38dJ2NLa2gqRx/W4tQS3opan4=;
 b=Qk8V/f9j8dXKQy3nx3ugWU/g6r2UO9gQp2HMVGrc4c8Qngmu8B9CEsbdLNrX6cfCQPZlEIHYlLiDIOsW7XhfvNqZZQVO3zvE/79ZGdJkPRzJKqg5IGq4Grc4OijSUPnlBQzPYVp4HR5juzIqmqEabxj7uF2qJONDpge2odzNa/lucXpBUCjKMKL/25wHQ2Y0VEqT0F6tMqeC3k5Y8ePUgn099R8KcwqdO+/yDlJQZs6//oiJozHcFpVORfImbG4+O5YsT7khxnS623LjbGu8QwRCvQrHT9OU2cxbUAlr56Ixx2mglj9Q5gqw+5orpGRRawNjiCSpJ9z/lN3bZMU3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIuAUJDfpi4PszmUVc38dJ2NLa2gqRx/W4tQS3opan4=;
 b=MdoQ1tR9WlJi8Gm0gETzzJcaFA9EEQjCkUJCW8D7CNg47Z8rS0LInVPNBu27PlLnFF8yx/u6QHDBURIqC/kw684WrGn8Xm/JxdU2GmbahPIChmR3hrFZSTcvg6MaKEK4NeDjZnqWEknivDAHIAv9Rpp7zyvh4eTlYbrVS7/i8aL7lAiE+mD39v5wk1jqCRvSvwD3mc+bWSsZvt9bKvmvtnfhwq+IgLA1rgrCETBNGuonNfsLkgHpHpdoN7IFFd4FnQpMBZAALZWMjVGXgzzlnTofZOLkUtzLKNm13L1er35eEw5F/g24Suh5eWNrOgSD0b31fZnpUO3Y+4/G3wjeFw==
Received: from BN6PR14CA0005.namprd14.prod.outlook.com (2603:10b6:404:79::15)
 by SJ0PR12MB5487.namprd12.prod.outlook.com (2603:10b6:a03:301::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 18:25:43 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::47) by BN6PR14CA0005.outlook.office365.com
 (2603:10b6:404:79::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:43 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:42 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:42 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3c3401e340dd4374a9a74c0f10c8f3ea@HQMAIL101.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d6f8d13-c669-4c05-dcfc-08d9c3e62251
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5487:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5487B4244C32888A723B5E49D97B9@SJ0PR12MB5487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubaDumnOAj636u54LixEa2D4VTDiZ4byjCmJhz+PnKw/6DQVdV02ymjiC+OhSoTnanaefM/r7HEPSAyU+PmyOxiPrLipImqEXjKRd7EMKGINUGmEHlGegDKZB1LJIryjcKSlxpOf5P9mSBMD3V+y2kzeRYsKS8e8+vvppeQaMMwEk2s6S4ugVB89PAHMUn27xxuYe+/45/3Wt4hZxFCeD0cmTAdztmmN8u9wCiedVfMobji4j30sYoqwK4TLM6K2dqipBBLcNWjHDD2ZZBRCzbOz7p2O46azECuNLAd7nbViMP0Xus6ThREg+sff01Ve3jPjl91afi8PY/5e/RjDV7c5dQ4ZxaLthdGlt2Wga8eKV5LKnV0PX7y/kNF1E8TCIImG8Ifp+tufMoocH9dSMtVstI671XHEYjTQy4ciDZLNfrvH/wdAADJDtIC7rIFrYz+FUbIYqktjkNTOqXkM/1oCs/JjwhJjoQQxbUmYwOB6uy8BVMwUXHmEGPKFA0ZLcf3/oe1Iy7VdLKUzwoG0OI1iF2cmdK9BrRk9wEPnfasIsycIQ2uq/W+jW19xUrirSxz8lgnlwnVFKMOx6ieM9CKILKtTo1ynB1CnGrlmoeNII3/+OuC0dbUFAUgDDYXiaoTXDdvXX5j8hJwXumtx+N3MnFnPriaqhCltnRlBimZUuGNIzYvYqa4UTH3mTotCewYmFj4Tab9+P1QCwqi3Z/9TtPqCOml0Tsyd6nIADU0fNuzpVgxNaDqh3dfHVUDlsqXM7PRUa5d9/pnqz5Ep9nX7iyXHmJEDBsx9JRrghxMuXaL5bt+urS3SP8gip8AWJ0ma/BcfUGCpjpc2AJPR9A/zODJzMQ23tXOz+oLehLkKfzAnWZ/vUBs8Qim6hZR23o7aaF5Esz1i7c2eYU3grL5Di3tEUSDk0tAIqFmj2hQ=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(2906002)(81166007)(47076005)(336012)(4326008)(54906003)(70206006)(356005)(26005)(426003)(40460700001)(8936002)(966005)(316002)(24736004)(86362001)(186003)(70586007)(5660300002)(6916009)(508600001)(8676002)(82310400004)(34020700004)(7416002)(108616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:43.3601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6f8d13-c669-4c05-dcfc-08d9c3e62251
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:32:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.11 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.11-rc1.gz
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

Linux version:	5.15.11-rc1-g6c3eb74f1432
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
