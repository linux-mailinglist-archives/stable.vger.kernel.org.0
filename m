Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6C472F9B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhLMOnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:43:14 -0500
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:34784
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233094AbhLMOnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 09:43:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq6YxaZP/9UayK5CsfIv9Sdq+a3GC+zhBp6ZfGGfEdgbDKdLwidKhidmYEvyn392cuo/Er+u8858aPAY4XzCBzkkST+DWpmq2XqrJGyocPfb5DarXi4pJRXdTDotxeXzBahZeR5WJA+SKGEtMivwc+8e+lIJu6PZUrMu7RFsq9mVf/NGKyFLVeTF3cPNRpAccN7E9ZVwlm6+4Jg8Lu6x3zRbocwJPGIP1Ze3wd0Tye7XaH2Tfthjl/Jblm4iiJKWUnib24f6F7pEv0b+f3YO729LLcZnSj0uyc0mQTZ3F0KSXkT6oAGGzLxqYwkniUjzQj/P131eNaQPf/3gfnX/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCfTltzCx0D688mx/HqfnGNYInEZG3zXM79tbfXrH2M=;
 b=HjZZXMxfVwHaZluVZapD1OHHJITbB97ZcQs2zDmU3sZe+2t3b+LG02JKcQjfxDMxJMvQU0I2q3uk2N9XADBKsRgTzMbpTGSLB0Vx79H4+Ol7d1l4a+wss904VQg/Y45k0ql1UEp7qhMWPp4i6/QmS7Zhrvr71CEo9hjj0NLC2qLDkHmr+e/fDaPl6Mup2WK49rbTp58an8PptMkAzrmlzglmm40FKQe9ur7R+r/JNmV9/yZ35J4lYLEMkijCEUj9F+ObqPD5z1LYrNU5zWQvHMS6hz9ANjx5lb1DhVvhLQLtx5Rdo839LlxYICn+OjkLnfUIHNaPBHHnpkfLTfuMDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCfTltzCx0D688mx/HqfnGNYInEZG3zXM79tbfXrH2M=;
 b=qEZugc4smEHW7RVXBbz8/rK+ZjuRexjVj+hRkoxxN53ARXn1t8tAqkL9syWTztpOqWX/ND55j+GUIc8QHfTFqcZsLTmGPEtxGvySHLQdu9udWTDetTweIzEZ27MJL6Ko0DQwnTsJuLyMh0REmM9TRDYru/AHbput/U2+HS621RyfbL0ASaZfgb50nayeEHdPeaF6k424spmSwTyZC2JX0KTfLLvpWubCMgCW01Kxe7tFqaVVimnD1IrO7/H2cahKlH4w4VvbouU9T0D680sEpEBUYS3LnQ4GugVNskP95M/OPW4zRKtsz1wsyL8gz+Tg3tgI1q71lI8n0I/McP1tWQ==
Received: from MWHPR15CA0026.namprd15.prod.outlook.com (2603:10b6:300:ad::12)
 by BYAPR12MB4631.namprd12.prod.outlook.com (2603:10b6:a03:10d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Mon, 13 Dec
 2021 14:43:12 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::b2) by MWHPR15CA0026.outlook.office365.com
 (2603:10b6:300:ad::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 14:43:11 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 14:43:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Dec 2021 14:43:03 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <986ecf0457244e3e87d53c9a89d499ff@HQMAIL105.nvidia.com>
Date:   Mon, 13 Dec 2021 14:43:03 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b232e32-6cc2-476a-34d9-08d9be46e349
X-MS-TrafficTypeDiagnostic: BYAPR12MB4631:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB46314E4495B289D5341E8A12D9749@BYAPR12MB4631.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nlZi/fJETigFe2rZf13X9WqqyPqdWkOxg++SVm4dvj9jq3KrQT7RxsK37HX+zUipWuxzbgN9e6md9qM15TNhsqXieM8w/t1e+9GC49QKLTJmaX+XzeiGRcQP72kFwwxWP5dJuFcDJ0SQF2T1EWSnjZD+/tycjZdbQ28KYatUuupzoSCh3UVB7YB4Yzy3eS8GRr6TlOPlAJ7arsYbJRKE9tLTUX+AxP5A64BBuBvIsftEGi08ZJsyh8XDlm9M6DGEQTZGPy2GSNNXFOxmq4MYlcmP3rBHLXUCkueo3W1XyWmRIPortkVvkKJDMIaDy4gJezjvmMO6DRsc2OcT2ioi6t5Ie/ypDO8KhKzNmfjR5apxeIykjxk5UV6K23ltsuXiXIxNLgZhpjw6PpJnm6MCG5ylaJok0u5vr9lxUddjIFhrfCxclIdubiboFPfg/fTkP5XoXlubXpP3ZyBqFuqZx69+3uXU3BmA0XCZ5OXjf0w047ToAZ7rMNEoGOhEOhfWr0N4Tf1NL01i6qIEW+dQeEzZdS9Rd5dqMjJQbMIOn4ZX7revMNE25uVMfSpPE8vMSeRHueVcqMagN/46R5UYomkrEnVLmwfrXmhKiQg6WgTmjy/ft077r0bD1hvSgwgSRrgyqByUGD3yeQMs10a8z3HXCG4Fi4ymgSWeHVS+HiAFM5zGgsHrvh6xWvwAHQnwZ4Uw055uuc+0A2pVIPPVumOibiF5PEm5w/98NcdUKt25xvB+mavBNNjShLy6S/7mrcWHzquOVRq3act9q/sYBF7bnriD9seDXlYfBDWxDsD6f/6VFBTVwrE+WFsheB3NKEQ0FLZ/X6ZN4OVQMmNeJf3S2TwV2sG9b/5Sr+iaLK5MhywqfgaRhMKHQJzh8ay8
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(6916009)(36860700001)(47076005)(5660300002)(966005)(336012)(82310400004)(8936002)(24736004)(508600001)(7416002)(7636003)(40460700001)(8676002)(26005)(70586007)(86362001)(34070700002)(2906002)(54906003)(316002)(426003)(356005)(70206006)(186003)(4326008)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:43:11.6412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b232e32-6cc2-476a-34d9-08d9be46e349
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4631
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 10:29:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.85-rc1-gf6a609e247c6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
