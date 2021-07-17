Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432A23CC1AE
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 09:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhGQHee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 03:34:34 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:53057
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhGQHed (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 03:34:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxtjWIuFz+iZc6C+T3l9g3lkdJtKZJPgbsE24tnRA1rwC7RIqxuXlCBOIPTNHfqpSxmldGmnbLDWmNIT+7PVeuFy7ypPNAZjvBvq5tvp2AmGOdEi+3geRyTCS50jsppObKfy8Pw34ElkcWU60hpg1UNCoonAnwZIJk8LJFFey+FR1ejZvVMsi3Dc4cgDtZ0ZFLljivdYtXKOLQQkk/4ilwVk8q50SK+/yeB9goy9fKclFJQKmlIe3P03sh/PBr2BiemU9704QniyWGRf5S9gpEjVEgeR8EE7Qu0+SJH3Y/2VORI9+6hGyyPhcOWuTUGi+bb4q8T7kvga81DWdb7qfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RT899xkJcKQXBrBFxyFVfgBsjR0AJmrQjR1ndBiofRU=;
 b=UwyndKNmkKh05N00vi0tH78HV+GUgk9+YcA5GvdQHloXaHdjRUz9A/Zf0xO9wCynZuc8vFYllM1cZXfn9z/YhwQSgrCdXKJ1GNjYOv3ZCfefkqqnu0G5BA7StNDA0yBtuMegBQL6xGPgMH46L+RQr9RuaAV4kEkKoR7Gd2HWhKKsENN/VYj5MhCm7O0HsdmDV1/ulcekqjDveAcurA6qqTTV2manhyVZgopELmv7koDxsphbdlCm3dREg3QfP361l4NGI20bmYSHjYxKuYFqL8M8OqfFmRr8m65MBla41oomSZ6nl5ejvnRE/J/yrT/yAn9WHUfUwTdyM9exostbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RT899xkJcKQXBrBFxyFVfgBsjR0AJmrQjR1ndBiofRU=;
 b=omaJGHYwBar8DRbrbsb+EUOmrex+KKE00308fMeWj0cuzh3f05JWI2kPvHaTrhdFWzC+UejxnQCDOgEZTG2OtGW1VEEzFrqLdf+d1Je+07/yxvwEGbBJAYqXQtRpbSpfxQGK1xNJWAxKhSEMGG/bR+LhEF3vaLDIakcmswkCQr3pV94V7X1UPiGblh3GS+C699eWmyAAKv3rl35qTaTR3sHU+F3WmhC4qRIhnB5LAVErmvriNWE3y4zcEnqBP2pKLR2tOmHFIwJLcO7arI14LkzUUjmfGf0EUMcfYm9IdRfhwfmUExZkx15pUNJjkw2+HxZRqSJbvssA0Ny9Fu5G7A==
Received: from MW4PR03CA0239.namprd03.prod.outlook.com (2603:10b6:303:b9::34)
 by CH2PR12MB3910.namprd12.prod.outlook.com (2603:10b6:610:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Sat, 17 Jul
 2021 07:31:35 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::88) by MW4PR03CA0239.outlook.office365.com
 (2603:10b6:303:b9::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Sat, 17 Jul 2021 07:31:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Sat, 17 Jul 2021 07:31:35 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Jul
 2021 07:31:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Sat, 17 Jul 2021 00:31:34 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/258] 5.13.3-rc2 review
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
References: <20210716182150.239646976@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e7d353dfdbd54c18912f58991b20acf6@HQMAIL109.nvidia.com>
Date:   Sat, 17 Jul 2021 00:31:34 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46243806-a1a6-4f49-aaf7-08d948f4e806
X-MS-TrafficTypeDiagnostic: CH2PR12MB3910:
X-Microsoft-Antispam-PRVS: <CH2PR12MB39108B7D381439E1F7E379EDD9109@CH2PR12MB3910.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUbFhbkWqmAO2z2v976Iz8Fya17Zs0CXkpeeU+A1qMAZEI5VIsgiZ7dEr9iP91yTSWIPCaJNOTWX53roY91cyoHFXeYCQpIdvl3F+QDiYe7kImJDkvfBI3rSfhakkynKto0fJHOK6StdHHPaUx/Rg2ZwqccyRFakxL3jLo/TS9BgXc65sydt7hhGz0eLtqvG+Egw6lR0e6ke2rsFPOw8HIBjI+SFPCvu9CosOqP5zySkSxgd55oK5ryraoB8LUYwQ1Ca5qtiDFnqucrx4g8wiv5V/C8ZHOauZ5xVZuy7qSfn/pnFdj0sDlY/7vXSXBJUZ5kyjfGDhQ19aphsB2wK/aARyYTQthiuakiYt89QEm4ZlThoLlCrA3yWY1+ie0Uv9RgZEU78Hf+8efdUsxtRDNpp+nzgEHqYan15DEUmqOgleKMnGkuZcEmMCwSHTN6nqyrPEujjygv3pX/qf1gcvkps9+4MRuvIOtctBOyqMDEnuyr1c7cHcb0gcEKTdBnyqvqNQDTlLLdF+PZGsc2RV64lhkucJy8Oa8poLScLz0zU1mBkrs9r1jShHcBjhEw5hgY8RGsD9uZUuo87t819uYgu7zwGvNqJa4ac7oUYQu3u/dD1NGfIQeo7/I+1aKhNnzHI0/gpUe1Rohtg5JJ8dDmbZ42v54xWl8ii9wEH2ZTNaOKy3F0ZkEvEFvOuArvxDHfNM2wIvnpeV3aFYgvRO4rrYuxxFxxi5ADY8Dye3wuYQQO1G0idWnb5uUcvoyI2tZfgzXlQZvbRVoEvpDob8Vv8YKTXNjZ4n0YM58JhP4+PcPr5c5HQYiQBHhllSF8L
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(336012)(36906005)(82740400003)(6916009)(426003)(86362001)(5660300002)(36860700001)(316002)(54906003)(7636003)(356005)(26005)(2906002)(34020700004)(966005)(47076005)(7416002)(70206006)(70586007)(8676002)(24736004)(478600001)(108616005)(82310400003)(4326008)(186003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2021 07:31:35.0457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46243806-a1a6-4f49-aaf7-08d948f4e806
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3910
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 20:29:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.3-rc2-gdf7d40fdca4b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
