Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2AA5FF1CA
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJNPzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJNPzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:55:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406A236DCA;
        Fri, 14 Oct 2022 08:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocCnwXL7KZbuXKn1Dy4pELD0OniJm4tmMDOcRwul5rN0ejTugCcPGSWx4pG4Gc5ch5GyY44rsEThEl1mfO/WIoMryEZAwpENSQEZ+89Xx580YRGK/0s93dUIE+bA7sCybbU0y9H7Ttr8gxzd8ku4ezNH4JS9hEZhr/B24JtRgSWaKftxh2+IQCbWDV1jWSpgsEf7EcY3CU8PTfR3W7L+T1LW4UXCq75hZZuhfNqtEkgDDvqZ5PPScwwtDvLwq/gRdcJE3Phboq7hSB6eWOzq/osed5LoA2l8mhRQhZjGKhU2I7yj7gJleXV1I3T1AjjJz03oXDrixnuyaVHOhhr7yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfL/FIborkYjpdOy33NHyBPUk/1u9/qH7+xEafV3H6k=;
 b=gq26qbBiT4yXC6j9V+1YWk8mO+Vnb61wlt0UNf64X1/NxsStezzLhSXUrbcpxe77UuXgKVHiofiGMeRAnRsw04B/hesijdDLNHeiuJP7FNzFSX34q6jHvRrZPAz0VAYxjipOrtEHd3PC+KIvCVMKdA5l3OmofYla/znzrm/qio7zmruu+tRnP/lcedgWmnP7OnZAzKeyOa8UIbylVCq/riJ3IP4kb+Tm2AOLevOzL1mhl06rJj2FLLX9/Sh/uyv49h/BqS5AYr0gIJerj1MR5ugu5KFTbgisk8/K9k16BFKpD2T7bjdOOYBs4KYtSggb13OHgO446lry5pYMVJKz9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfL/FIborkYjpdOy33NHyBPUk/1u9/qH7+xEafV3H6k=;
 b=QoXvG7qCkMF7+xMg+vHb5KCtcd+W813mY6lfAPUR2gyWVSSsDK/sUGVbN99t5izjK1DIuzsiJjkEWW7bslMBM3Z5c7+lMnOGKEsOU5b9IyYkQ54PVe0q79LxYGEzQtqj2W2JK5Zk781PdMn6kB+gw2dLQTgMso/AAzuO3EtrpUM67guAJyuSMGFy9YubxZIcb9xNeC8HHT1i6tnUtIwNIfP7BHJ8FRxGR4yKo5hvFq3rYoAH4UCm4QPDLcMuTNaZVP40IgANYPBQ6jRg+XORC3BnqWlOg2hzJRPbc93YBYoVW/ovJIvnJmKhx6aZ5zJVOvvRdU0DV/mgEUQ0VsFLEw==
Received: from BN6PR17CA0054.namprd17.prod.outlook.com (2603:10b6:405:75::43)
 by SN7PR12MB7132.namprd12.prod.outlook.com (2603:10b6:806:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 14 Oct
 2022 15:55:09 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::bb) by BN6PR17CA0054.outlook.office365.com
 (2603:10b6:405:75::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Fri, 14 Oct 2022 15:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 15:55:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 14 Oct
 2022 08:54:59 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 14 Oct 2022 08:54:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 14 Oct 2022 08:54:59 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e3c2d80e-71cb-46db-9aca-7bc1cd9259ad@drhqmail203.nvidia.com>
Date:   Fri, 14 Oct 2022 08:54:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT063:EE_|SN7PR12MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: 26aa41bc-f4cc-4e1b-7886-08daadfc78b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rc53a72lFJkZ0qRyfuzPZPDftdV/4OQRUHWN2TsSu0Hloy6QshgvY234+x7DGdQvjPRXjQsXkgomODzy6873QU2pEX76NuFQxAvyIDAjyIVY/xIWzJF1Ndq7uu9VH6JzIlGAVjrdbKxKLXaoXEhYOB+9LnK5lL//gaHgvOpcpzGHYjCFAcmli2NxbZWTlma+IJZLnhN75Te1fsksKOE33/fx4w/n6sj3vOSLBMq8J/3f5iqkRTo8IS2CtJorEKDXwDAvW0DyhgcBIT8j2MK3PfiG6EmLElkTfRjKeVv1fheXTScU0NSCxGg3dxgYQwOZ7U080WNv8eQEA/COUBm/mSJmLvHfPMbEfVJzwqGGrJzsvTPS9xZcF74gZd5SgK7i6j18ieD5Lz0IHCwLWD5cgStLtpZH+coUi4MVV4PQORd4VmQ4D6z0iMGJXsIbyxi/RafLSYfx7Hdqm3J7KUISWgdYgHSX01aFOKhukbnNIbot0nFUy06KYw4LvUr37B39HwW0pf8BFGVxFLqXrrMgWSyQgCPrU/2Jd8LsGg8pOGCVrM1VrvySdx7OUPbJp1eVWQKhyS7SfVqSu+MJkHb+p2hBVF3rKEyuEy9yUZXJuwMzA8G71TfC/AiKD/jeKnTjhf4OEMynlY1OjdJMErvRiFj6+Zuxr+hBVXgUYFri/naBV7qSGEbP4bBOFqXa+ev1/CDkzuAhkOrNxtIFEeqaC5hknpD3S+Yc35ssUW5E7rp/FugGb/dFBbkOdQzkvQ0WMqZduRG+aaxo9uKYEDuZ1Py7vJ5Un0sJb6zCmOqNV4aTafxsjDVhfQSEyeAkTAUpZ7852pWpdTPbEa916MsaaAEyA0MSmiMv9fimFZOp0PY=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(70206006)(4326008)(8676002)(70586007)(478600001)(36860700001)(966005)(426003)(26005)(41300700001)(7416002)(82740400003)(336012)(316002)(7636003)(356005)(40480700001)(47076005)(31686004)(6916009)(40460700003)(86362001)(54906003)(5660300002)(82310400005)(186003)(8936002)(2906002)(31696002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:55:09.3125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26aa41bc-f4cc-4e1b-7886-08daadfc78b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7132
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Oct 2022 19:51:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
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

Linux version:	5.10.148-rc1-g4ff6e9bba3ff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
