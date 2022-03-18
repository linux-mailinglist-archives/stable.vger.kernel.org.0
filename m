Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59694DDA40
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiCRNPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiCRNPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:15:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1DA1F0459;
        Fri, 18 Mar 2022 06:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAjato1Faa+UqIbAziZODWxt0AccY1x3j1mJO+P+3odW7G50HY0UPmHTrGTiuK3b+m5WvQ5IvwMOLsovhXGW80WJan10mTAL2KlI3otkLr0aW3TOi/WsKHicF3UnjeMUBvXenqN2vLL8tZIh99idL/QOL8yJ1Fd8d3RG4kD3KNoJUdmcZJYpxxgqkwnhwypVce+EZTROIEhiqjp0Fr9TGIt4X5Ar8g+YmaY8s+sUdT3f40nrvYXjH5WDIkXJ5zFMVpOnbHSu4wI3/nwTVQtrhHg4Vixj2ktJg1Cnd5tS7k3uFFztpbRML76SQbXNPo1QUMTjF23gCZIlzPntXwDMcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqjxr1ceyq0qWCdVIavx5a4HXPCqZnbTLqvj4ExY0hA=;
 b=AOTPMQS+xF8XeQAVQbTnFw0PDQP8hjUl0o36aVWNb45B8QwK0duimE+2XIKwj5TLo972cXm97Z5st7H/cdnmWy/uM6ZqsF4Nq69WL2Kx+eNQrE1WYQYSwJL9JGaINI37MgcGk3R3OAB/t/Fh30mVehec8C901l6qZOAzBG6Y2hNERySWMItEOIlL2it1zr8e83s4IS46oMzO47FYb1l/N1s35P54mlnUI17TMVVDMj7jKj+zK2H1PZBUQ7+vQ/cBgBAO/5O3WEmO7/LILCTmgubIJyeZ/KbxuXPCfcEM/YlGG776iup8tXikZG+CpMlgXV5Sd1+3JCYwm56SL960vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqjxr1ceyq0qWCdVIavx5a4HXPCqZnbTLqvj4ExY0hA=;
 b=bKImfe1kYQMYrNvIr3AZAsePYAGcvyKBqTpFSKZPtOOxaOaBd3znC5C5cp13kvY5fw6rK+UqG4VbDOFEvD/m1pJ3SdiZBNX1IYPdpKsACxOLd2U4ExKhJ/Ml96/T0i+6vflKyfW4ClnUbvyDqkIFvpO2QlC/uKtJW+fIrweeRHJnpFJqgOhdD6uGgNsZTRmmKD/umDKMWHa2ea+YcC563o50p03/PE9vA2Yz+dQL4TA7vpEU1buk1jJSoJspKFuXaWddOMfC/ZmdVBpehv4ExII/ybIiadMxAVY01aBM8VDQy8X4EGfpdC4LAjm25L7W1C24w4TtIc0bxrj410xh6w==
Received: from BN8PR15CA0068.namprd15.prod.outlook.com (2603:10b6:408:80::45)
 by DM5PR12MB1723.namprd12.prod.outlook.com (2603:10b6:3:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 13:14:01 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::92) by BN8PR15CA0068.outlook.office365.com
 (2603:10b6:408:80::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18 via Frontend
 Transport; Fri, 18 Mar 2022 13:14:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5081.14 via Frontend Transport; Fri, 18 Mar 2022 13:13:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 18 Mar
 2022 13:13:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 18 Mar
 2022 06:13:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 18 Mar 2022 06:13:47 -0700
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
Subject: Re: [PATCH 5.4 00/43] 5.4.186-rc1 review
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <11683c62-bea0-4801-abb6-2eff2c1ff5fd@rnnvmail201.nvidia.com>
Date:   Fri, 18 Mar 2022 06:13:47 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd42cc9-08b9-4625-4d4a-08da08e12afe
X-MS-TrafficTypeDiagnostic: DM5PR12MB1723:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1723F60475F65F9561905073D9139@DM5PR12MB1723.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqMGt9AI5PTu/yjBXRlZVyvKLHZpY8BO3AThmJnfgH1pU3peX3cOxqNZtfzZzc9diAaZSx2cAsdP7WzBDbv0V2ZZN0emDdn6wL+MEvf58t30naMPSNLQr6E+Rqv2AbZ2sgj2t4uEy416gUTlZLkw5DXZzBZ7+gLbDhJwmBRHQzyKkd5ms8cJEQqeFO3Q6Aw1lJvhVO3KuhRVMIcr64lUuEHDsI7r6B5Y+g+90/jI2srbUy8Do8T9X6FFA0LKta18HApFBsJuZk/8HOX+wf2YPMBgUvKL4fvm+IEtt/4nkvJ86OfA436SvawEdiS1qw3T0VKF/3pP9anwLYR6otVtwbD33UaypJT4zo2JyrjqeG2z6QlsqlOswLAWc4mGnKJsOZ2+XcoKJIV7TjtXZYk4oJmXcvu0C4OWAHbwVoYYMs8D+vc1NbQTARizWuBWVXFI1LSHV3ClLJhyKebvZzpohqnQ+rjs9Uqr83SlYHQ89bMKwolvpHvNVmAx+KIsql3etMzYZ0s8yJLscZpYpafrFBWlxdhY7EiRpw6sSh5Cct4vr8WnZdo8H58tItlSZTrGbm4X0xenURze/W0qfwrY3zdvAZVbZUO7l6zYhYNQAuy/tpMJpLjCfDpKaUbGSi3/s7AdAKbltUiEupEA/Vid/C+iRVqSKKFCj/T23++a0jiG4KVYRjMmfGLyWWK0NtoElt1LDqm4loF2ffYuAAdjNlzHu9MxFavdO0TUMxrt6UgTLATjCaYxuYofatE8wDrRNdMJVSM3bmqmWFosAiMcKZ+CQL+aCCUTyI+AEuUuOcQ=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(4326008)(70586007)(70206006)(36860700001)(31696002)(86362001)(8676002)(5660300002)(7416002)(40460700003)(2906002)(54906003)(47076005)(316002)(6916009)(426003)(336012)(26005)(8936002)(186003)(81166007)(966005)(31686004)(356005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:13:53.6135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd42cc9-08b9-4625-4d4a-08da08e12afe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1723
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 13:45:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.186 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.186-rc1-g4eb765392859
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
