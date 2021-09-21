Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3784133DE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhIUNQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:16:03 -0400
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:13024
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232957AbhIUNQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 09:16:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWM+4iXt0CQedvEPde11WWlj7gtjMFvIdSgiFivxS+zMVYs1jEaTxy6lsDtqoHyAnQu5gy01+V401t4xGqnbICGL9F5gMO+zJwWOwAhiu/JGOU/54jkEdxqfDagGH6DkVhND/gkAgjRqsTCxtECpkz+NGOS16PLs1MXYMkQLZxiFyhmdvO57VIyXPVO7OM0NzKIpSpHigzbt6Ort01HMbrHyySE2UKZ9P7r1d+vo4/QNM+QJ7hxB4kmqx+keEtDvGSsLNEhefXAaKfQeuGuPCP40qeEK0btNueYZj52Zm3jRKECwm9bLvz+mfmjybLZcxL2kPzbg4MmzfEtizhYl6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOad507Pevq5gwugjyyyeg1xVHbxkBSgG20OalnsyDI=;
 b=J3pwbDRBffNvH3UozzLFAMZG/qYoSQz1JjjaK4+TRgAsjVnTqv+dcFqlWLu5qsbwbu5meb5odELORJy72EFqh4feKTGB4lZVDwZUW9/b38nQ3j2JNkSfJV6gseF8hnLz/fCRbfSdhPKTFDq8Yf+XXOjOAujYRwF3qZe0QTGKMy7CSQOHhfBljsko8oNf6bKa01TuhXNGOAAuiyFhgf7S3Ek/JplRjFgfF0FKX2Bx5FNDOE/TIUJCsKrZoUAEZwyhf4nP79bzzUNGRqjVfvuRalSOnEtLxp4ze2QzbSd/x+LPCuhjnBV2OpnZsMAVC6wfqL0F36NtAaYxoHonC9GiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOad507Pevq5gwugjyyyeg1xVHbxkBSgG20OalnsyDI=;
 b=cbqkoqXDoMNBD+VR87zFmoNFyUUBxXH11zcwv/Jra0RxWTlsBXxKN0oMNk7XcvByc5eLMeDbKoRbYqEF+sEe/dMYfR7aulEa1CPAimrnv5ktEdDgyI5Ez7fuIzCCUPEU7BDsE0HTNISUPDCgk5hv6VDaGmNeXIAKmUycg+aH1z1bMFlNQEH/JRtSZq6Y130txkZM5DoTp9xfhEiiykattQO/9ZD+THnMJ14RGZV+0vMM0camvIqKtlEwAkL0nxhr1kOkyNtNGKqJT6kO4rbHY1vcHpn/qaCq5nnXMY16Zc5IizfqscrL9HQx5GDxeZ+2TsF3PUVLwfRJhDNPsW6lFA==
Received: from MW4PR04CA0056.namprd04.prod.outlook.com (2603:10b6:303:6a::31)
 by DM5PR12MB2565.namprd12.prod.outlook.com (2603:10b6:4:b8::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 21 Sep
 2021 13:14:33 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::62) by MW4PR04CA0056.outlook.office365.com
 (2603:10b6:303:6a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 21 Sep 2021 13:14:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 13:14:32 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Sep
 2021 13:14:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 21 Sep 2021 06:14:32 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <195b5c6fdc8347b78934d863cbc73cd2@HQMAIL109.nvidia.com>
Date:   Tue, 21 Sep 2021 06:14:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1e2296a-9c66-4051-7dff-08d97d01c093
X-MS-TrafficTypeDiagnostic: DM5PR12MB2565:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2565A9AFB19C06663EF63611D9A19@DM5PR12MB2565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AX8D4GK62fdavxQgf8eJSx9+M6hLVRBsu+pCcYGI0FWryJ2TEachfzw9OCnrgyQ6KNQ6A5JwISynb7MVsjoKl011vde2r3nS0n/YafPAGsJvU1mtebwqbg3aik+MQCOPujpBg8/J7pibSBC/5Yq2VQKY1fs4rIwaOIgHOTP7Q9BpP2YalGZzHSDOrLp8GvdvGJdSwH2xu56agS3xhxy+9EkwkVMF0u+ylKpgSO5NSxgxc/dysoYTTL06eTXypGt01N8Su+wJKtYWFKfGg9q7OHCOMkpwJlZ2aUxzvX/fiKgd+nuWuizyk6LFkxvBHDlsk3XtlE9tKUbTetocJhIc4LJcFtiei/HOV7e/TZZ8dp1taizV016qbZzmKrIjzL5logzR04DmKppFwxeEYEz1fXtNgJ2B5jkJKueiiNzyGyT3jrhj0Hx67yZqJQ97m0uhdBLu7MrPUYyulANz4RcDSyXveJr9m0y9JjNF0f0a3tSWRPJF27e4ZwqeiAdGReSKLvnYXpZTZvaKsrBuQBcp5/QOkNbsxCiL81/Cu/WpL/aTQVQfT9u5/IDwQOILrBcM18FiESPXcOK9nWgAKsjIdsUDdBPKg/rs7bGBAt53bJZxT8ZPWDYTykobcNU8ttADe4b1/JXIb1n5dEIorIJGaQ8PJLWFuR0B1snpC0ob5UP768UDezL7UDeGzBOYnUjYLitSZHnOxppZUxhtTnAniw267FyiimHzGvME09N70FNf13vmbs426dKNg4EDglv5ksAUXM7/TwDSoXYfHGHVR2sCq0FXJwF2YmQsBJsHxqs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(316002)(966005)(186003)(6916009)(426003)(24736004)(8676002)(86362001)(26005)(47076005)(508600001)(82310400003)(8936002)(108616005)(70206006)(5660300002)(356005)(70586007)(7636003)(7416002)(36860700001)(36906005)(2906002)(54906003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:14:32.7537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e2296a-9c66-4051-7dff-08d97d01c093
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2565
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 18:42:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
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

Linux version:	5.10.68-rc1-gbb6d31464809
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
