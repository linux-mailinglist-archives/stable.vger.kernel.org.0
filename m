Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A0361D31
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhDPJWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:19 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:13569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241734AbhDPJWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEd0iiRPofEv7/Gb40AJV0L1ReVEGZyOTqn8Vq4U58/3d9M2w2VH8WpuyDHTGP9wupGepR/X2HNFsZBa/jb3KPykodEFcVK1hkinjb8cyl6zeaJCp1LAdNJrnlRy4+NzJYzKwKPUHU2XmaDwWUEhc6CnN0fRWk2hDfEY0s6tpyt6zsFjMSZMrpd+UCWb5hyUBzA8jSlOl+B9KhrP5xIvcV3Linte26VK9/O57QVwlYSCZu0mEX0PX1g6p8muTjrxK+gkN0DBd7jfcEcBGY6g7vDvZCyK+qV6pdbMYNf5VvIg3x4yPVTH+fYeZ3162I+a4DQwI1Vau9MLZA1oNr2Gag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSi1tA70rGEM8pX5iOf7FdW+NR28ki/ali7halD5GQc=;
 b=YkOvFF1F8yeei7Ghbl/xLCp3wG9LKzEaWgqZXA7Et8N9iL+ldHYpPRScqK8M1XCue1jSl1bMSNbIhnJkzFVtsqCJAh3RKl1pR8X5DoTWYplJWZklO1zolxGJosmkaeBUSQ7NEbvhzpxmX5qbm9ZQG2YTzBPiIEbcHZqiuaDABJG2WH4dTEP7VfetFO5hF3QoI9WDqOKuOr4wtVncCfKDLNUWWNhQhMkmFvGt1lbBdZ5ZnR6HgDRxfCJ6CqY6a/+IPpSxNqDUssx2dk2PqwBDGtuLhaORa9BI9aUs8PFx8DvyRriMGTVnMrtmE88bvOLEVMlpxSDEOr5g298+m/4EOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSi1tA70rGEM8pX5iOf7FdW+NR28ki/ali7halD5GQc=;
 b=eJqgs+XofVI0aH7PpFdj4uncftDtxtKuZ9JBnHxkvUYeOuo7MPQ+0mVITM8W6EmCP+PGq8hmL1VJUpiOd7TAbVP9zDdZsEmlmz41jRyCtSfGcjiBTCUO80hS2rFl1PMzjkKgtvWBqfBkYDu/RnF+z6ovKvU+dVS5Bn6w1/4DzfCWNo8mmC1shF7ZcBzSJV7dQtP83jFT0R3fUEnljWom33JpGqzIyAFAQVn77Dv1QyQ6Hvcy2fKvco/2FkWCfE269msp7nEbK2AMKzszOuqyCACKVps/dIQPsHkn9M/krVmvhpw1D71xeXIkwhBmKXh37RQ5R/euA3qm/7pDio63GQ==
Received: from DS7PR03CA0043.namprd03.prod.outlook.com (2603:10b6:5:3b5::18)
 by BY5PR12MB3826.namprd12.prod.outlook.com (2603:10b6:a03:1a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 09:21:52 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::7e) by DS7PR03CA0043.outlook.office365.com
 (2603:10b6:5:3b5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:21:51 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:21:51 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/38] 4.4.267-rc1 review
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <680b1b2ec1bf4fd39e1ed4a29bd59eaa@HQMAIL101.nvidia.com>
Date:   Fri, 16 Apr 2021 09:21:51 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f856305a-8b7b-4caa-6891-08d900b91253
X-MS-TrafficTypeDiagnostic: BY5PR12MB3826:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3826AB5FE8D93D2FBB09C5E1D94C9@BY5PR12MB3826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgEsWwml9AZKwa+9njTuzf5v3kcpYR1daXeOoK8MJVsll20UqLx2xOeZSiDr57b9VijEqdKB5P6g2IkfRGhl8f4GgdMQao0sx20uIvQL7cJWMvmDZciEh2mCU3dgGNKyqfj1vQQmJG98ZBXQl57/biUPOUMM7Hhvum+nDQNfak/6YdJJw1pfs5xSVlb6O+mDGZNLTThtDCYwDp1fJQVLrOLFC9XGpDY+oDlvA9uRuN1TeLxieCMNiWLKmN107Ev0+NmAateKDZqUqY7Gs6Htq3K9mEX1PTdUYLdWbiOJBaXT9AOlvVzR/y5kVQCCMEgfvToLgyLq063qT4HGpFvrhBB/D850p8ymWq1nFfDJiliy/M2FxOmAAs6/jske5DYGLudqSLnxvxqWdtjrK7tE+eK0JSYKyGYdvjteF25OHMfusufzJKGrax9tKfTyIFfOitQKqvWds43t63DK6J81gr7mJ1iGtNM6E8yIGY/VV8KxGQbJT98RQq4Ev1zh+Cw1n72EavsSJnamIH00cGNwYwsgoMVJYlp+wPifmI3K2/guptluQnMBso76EI4599B8Pd8Qlgnz88nLJJAiA/OTo4jbAVxfB/qUB5qcZZaEOLGU1kwm7BSMGK3j+kjKP5DXCs0FFURROzmkDtZQuqYqcf/JNltGxSg0J9OAPeOClKytg3jsPVfiLWy6pWvsazk+qXo2oJYL1mZ8BxUR11hQ3K2ZWwDY7hQv8gDFRixazVA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(7416002)(4326008)(186003)(36906005)(26005)(6916009)(8936002)(316002)(70586007)(54906003)(36860700001)(70206006)(47076005)(86362001)(966005)(7636003)(82740400003)(2906002)(336012)(82310400003)(24736004)(426003)(478600001)(5660300002)(8676002)(108616005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:52.5002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f856305a-8b7b-4caa-6891-08d900b91253
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:46:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.267 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.267-rc1.gz
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

Linux version:	4.4.267-rc1-gd5830a9390f6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
