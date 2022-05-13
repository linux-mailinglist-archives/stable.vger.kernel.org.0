Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959F8526745
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382433AbiEMQkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382431AbiEMQkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2040.outbound.protection.outlook.com [40.107.95.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E83214;
        Fri, 13 May 2022 09:40:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ici/21UTj+xYwPqtugGpSojd698CK7unowz8HQXMEkzoJeGotIJZUzcEtpt7ak2wsNLpbp8+yRfdKqBqakGnfqqpURbZPBqRKzb0ui0nPUUDDIq0Nt9vd0bljqNiz99+NK+sI8tALd4k8D1eq1aysjnJx1P2upTo85i1A+iHcZfuPcgDofAwnvahbrmCCG16sGL85JeXYgox6Jz5K8Y19BGJkVp88T7Wu/5gkYSSyuNIF3oPNVyf/JGKq5dtHuLgKheqs41sBE0YSCLL1Yd1gGZ3vWJoM7F/IPL2c7VA/DPH+CvJ8UMhziUr369k68fc802ApUsSn9AwNpxHakodmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+r+TQqo4imQgYCIJUEQiR8bnkLGNgOXX8zZ4yRH8Bg=;
 b=a8P/5ydQLRNF5/GmYCA6mcOfTzparBX9tQ7UeLrqwh7pY4IaHTCa8268zEC1h4euGkiJrPW2/K9DxeLuaaJSyA2+fwirUPWUROW3/BcWFUQO3+uw4Dnz4rNB9R6GaSyL6DMLM/tZL7EXCZ95nIXagwsxy2Ef24K8RBd/+rFu9MTGeAQlT+cLi5YSXVfDU7kNQvAesEqFn6b8mWzX496oRmaXPP5CIw+P9P03OWXX/V0gUpsTCcZfZEDsyZEG8VMXzUn7gkEJkJETmHVrpXkwB6qdRGzzN1toslJAKLiW0ifN1Jx1k3csLtVQpxzpV0u4779cJwEhncKWeDVdx5v23A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+r+TQqo4imQgYCIJUEQiR8bnkLGNgOXX8zZ4yRH8Bg=;
 b=N1whCT3qAcKentwFs0S3l6eu+BNUvLBLjVzLHfcBdgYfYz0d9IxRZKLWeTQk9dK5d7qjt8f9ox6YZqqL0pVOPRJveKbyr08Q4sZ2SfZMvYETnhG0Tbs0PPzcYpbeRM7cA9zMBrKuvwxZf0VW5GGZ4HexAg/lgYSAazm5oGpxe22RHuctpb9aGjsK5Qdoz+qfqNaERF6llqgYfePhCLjYk+BoQ3npJc3GNxKS+YjuQhnxj4fCLCWwrK+3Nf/JDzIlgxdsl+UXWuxJCCnRxBdtOSjX6w+QY1efNCLJnniprpzRMoWtVgmDOlAPqOBAe6HBp50gWsCxdSa93M6byrLBTQ==
Received: from BN0PR04CA0162.namprd04.prod.outlook.com (2603:10b6:408:eb::17)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 16:40:44 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::cc) by BN0PR04CA0162.outlook.office365.com
 (2603:10b6:408:eb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Fri, 13 May 2022 16:40:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 13 May
 2022 16:40:43 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 13 May
 2022 09:40:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:42 -0700
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
Subject: Re: [PATCH 5.10 00/10] 5.10.116-rc1 review
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7dae03c0-5c24-43e6-adcf-f4b3d5a2d8ac@rnnvmail205.nvidia.com>
Date:   Fri, 13 May 2022 09:40:42 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31de6931-234c-4037-c22d-08da34ff535c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2488:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24889EEA04BC9E1DAE079E72D9CA9@DM5PR1201MB2488.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC6Ik4GW0uRZQwQzmhNnsqQLnQUZqucary9h5EfiLySiHU+0RoWtcUTbngpyxcmrMRKn7cmEau85U9X7QZMa7EzQnPvPfzRIBdZyLyxnpqZO/6LgZG5sG86S8ZgrM9MiY75VoMpLkbszG5uM/xk9L+nLVLoF2onQnbcNX0ZeTQciyLPQ1VqXL+0XoLeMVKkY38tQTTKOdzL94Fyyf9upBs5M3TeBo30fwFxVQiGPiO4eZxhKu9wRlBx0qWTRWRrCsNm+uZwfkajN7Wj+dr0b2EYPxwzai879bSMuLMKk9zU/wx1u3okXjaSd0hAOBVmrGbeD1VvSB58hwrBGs95rIDb7AfszOy6AccyZ0s59opv/PT3X6hAWAw9jGCH4FDcyKxEMlNgqSWrInb7yT24L+hESaGrI6Hc6HcJbcJIfQPb0Wfr+UrT25gWXrqEl17nWEul+8X94/SbbBLO96VRsLP7rf22SugWz/oCnauG0Gf7zgpZbEk0ym8f5+0GLpuvkn0+tUK/cJqGAGwk88cdyAJaPJydJbc2pmg6vPiZL7TWR48SDAdczlaEmvpj//gChoUBv6yrlYwkTokx1WcKCEYq4U/IF1zshhmCN6ZX3nDIiV6PWAWqPTW2tlGgNT2m1WMTqjWRwvjPJ53VOorKPa3Iz3H0S2sdT0MRDjMnashYOOugqJmwfOKhRfCkGFmH1y+54BCwS/qcnm9Ws0a61P35j50dZAqOPRgiCnu53xJWQ18PZcyrLuWlS7eB9wMqlzurjFjAEjWxc+B4LZ8R8z44NFqasUOK2ITe7GK2Ch+s=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(86362001)(8676002)(26005)(356005)(54906003)(316002)(31686004)(81166007)(6916009)(966005)(508600001)(82310400005)(70206006)(70586007)(4326008)(5660300002)(7416002)(8936002)(186003)(31696002)(47076005)(40460700003)(426003)(336012)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:44.4364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31de6931-234c-4037-c22d-08da34ff535c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
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

Linux version:	5.10.116-rc1-gb770d46f2016
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
