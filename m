Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277E743AEDD
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 11:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhJZJTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 05:19:46 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:26848
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234189AbhJZJTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 05:19:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjshM/9wULAPL+O8PtA2vvozPVuo0mDSZbSej4j6vJcGEX6/zGYMkKRTME9FyHFEaa4a1M7bERczrCA3Oec4efujZopDFOIL5IjNTBfgPqSFY4IRTauKO5kA6VeHANHsqsLAiryd+4Lja1WfznoiEGJIMhdjvcZv2fOVi6WMPbXfkqS7du3wvD7YyWkdj3rPGPy8xBUKy6HgLkCPhtQfD8Yk6vqw9zZTtF+pX05rwcm/YXfYtspXv9JY9+qx9BxstmhsGSs2OVYcoIR3gMLXFVuWnzbIaP5JDWjr5SSZNRMoMm1aTHI8T5sh0e0dDiFfDRLtes3SmeXd7sIq6wKNGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck+QfaehUW13kHxfzCzEsdT8mleryb2HInkQmT5tthM=;
 b=R2a7FmVYdgAWVD+L04zGjizRhsbMiMI0LB4IDvdQ8SUgCZ8/j6a2oQoqv6iSv0Jvx5dUgi6Ug+B5u7MJanz5HjerxJQfJjV8DJNenPlJaVwWvbGN4o2P2texLa356hfiA1YJNjYX4KVJJjybJBU7hqpcr0+lG4uJl79lvPxON5bzEk8cubjY5cCFNQkK0DSZYb30wx5CKf0e3q1tlPhD1XFTE9G5BV1RLZyPeEtORBOp2PhkakMvWMPmxJiHbU+qLc3A4kexcJVOYhJNl6UyP7XUTBNpTRbLwP23VEltM5Uf0WI/JnkTjDZ/AbOrKoL9IdMznnCNwNdIs32ESCO/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck+QfaehUW13kHxfzCzEsdT8mleryb2HInkQmT5tthM=;
 b=tupArlQ3SrQ41/PY6KwlU+p3XqFPPA3XxBQNdxy/PhoOUabt4+WIK06bU75v+WGYvMvI+mH6JkPjZ4mTKG21OkIAPBJGSaCk0Yd09WyfAgGDkTiFP4J9i1HP1GIIiAXZ5Pwxzq9b5ooMB/wgC2e0cekeQ4eOGH80CclMNLcwTkYXEnwmdWwYrSPo7nwNLfe/qRmp+E2ILIiHxYsNxzY9Qw+iKEGZAg4L3vswclvj/tlh2XPpHSb982rWjsOvIakIMXJ+Ux+ID7xmK1J5VBBNzlpJmnn8ujAofsQYUM7v2mlGt44ThMaC4yaeSTmmqGJ/hj3hF+gqJN34XywZ/F6ebw==
Received: from BN6PR14CA0005.namprd14.prod.outlook.com (2603:10b6:404:79::15)
 by MWHPR1201MB2477.namprd12.prod.outlook.com (2603:10b6:300:e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:17:18 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::f) by BN6PR14CA0005.outlook.office365.com
 (2603:10b6:404:79::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:17:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:17:18 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:17:17 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:17:17 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <aaa0609c83f34116b3607f9e486e88a7@HQMAIL107.nvidia.com>
Date:   Tue, 26 Oct 2021 09:17:17 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55d2eb93-2886-492f-d081-08d9986168a0
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2477:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB247765C6A1304D019D0BB698D9849@MWHPR1201MB2477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UeHkeJY72CRqKDVkM5IsJpxUkxo0qbBa2Wivta8qrZoYoiJXx6IheOxqhgdvtcr1YlRzlmI/FJy5MIQ4eEdyczc58sKiU2o0BjDIyDhkSQBwZaBTAG+n31fsqmGhb6a0knueBRHl0aOEWLFesmgNyATmt4wLh//En1ymzbKR6Yb9WeRP6+2KiNjEv5DMZ0oSa63P0D+iUehfFlZHMB7VwTsz3z0M6OK8C1eqmLIbSisx29teXc6Lz9TA8TYHAGtxQYxYPokEwdzAOLSYUAjHtZus7xs/ykGS0/uJIIthIW+qcv5jR+2uZBrRAw2h1BVqukjMdIHoL7j4wN3mnaE5fyI1mSscFGlfV5jWG/4HhYzhT6tg6FlwrO0zAdTguBq/vf00+4vwmQ3zRFZsDxoojHRVEs0DTcUkF7hwCHHRnbu2kS4osN9azoI9F4GR7iqUj16C4FxydC5p3bzztcUffsFjVQhXwdn/BY1JE3H4mS9wMTEauAjLJLgw15UGfRKrj98jyzpgvJ79AwuJeoV/QRjr0+MMzdZNP/IyAjhHCh/vzxhSTJwpcqnbf9nC5ngjsw5mwUjY6vu3s2NxQwHPPeteY9qh0pRS+hz40+D9rpDVqootTTXC0QqXRO+Wughlxi1GdmBv9iFjXLjGf7BEPwoq5SL1rE/FMJDOIVOsQ4bB9wI37o6u0HocMhbdwC1/HGHpp1NXRTv5fClF3dZfszKYFlzM8RXSZERdMky07+sPkqoxwQVPQriTJJR7lhvoAzIBgR4hBay53bhp8VJLKPGpDIqxZ7ctzuMqygKpBA8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(8936002)(36860700001)(70206006)(966005)(70586007)(8676002)(108616005)(6916009)(86362001)(7636003)(508600001)(54906003)(82310400003)(356005)(316002)(2906002)(7416002)(4326008)(186003)(26005)(24736004)(426003)(336012)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:17:18.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d2eb93-2886-492f-d081-08d9986168a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2477
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 21:14:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.214-rc1.gz
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

Linux version:	4.19.214-rc1-ge9434cadcff7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
