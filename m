Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE511522F29
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiEKJSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiEKJSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:18:44 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7211D95DE4;
        Wed, 11 May 2022 02:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XprnipVi/Z77kHv/HoOx5GvetTzKzu/4H3du9nzkpJiQF06ysSMjzqT+erOshjPeaii+lNdKnb0KhO6DVec4JRBVpTzhRI+0lVQb7rxbiRI5z69987wMl6IL256XHxw/GIEi2ywcMWS3G1lOJWyI5FoU8CYbkchKcTdi9MxGTn7+Wofkmb/toYWjsEvcFdebygb68cU4iKeIHHJGaY9LbRDTnrIlOVfW38pQPgI7gWa8HkCWGNFQU8S01Q1lSaNMHotWSNUDP1nGRSYLbHmrgflFukyYkNn28zKr6DRPKz74gwiRR1BfurAEq/kIRlftuWHN+//JPaJsStBoCizpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqaIMiH8TbN49joWofSwvTq0jDqNxEfCmuYOPNFOx8U=;
 b=BMTrFte4kpNUck91BLQ7Y2NL2W1LzoEmhTIAV5U7g/zOkcH5+vO/br12ofvcgmmWslPyEZnd7BeTZBRq6TFF4Ev5do9tK7ijEKfLaYZB8axUXBaICAhVrFghXXOwn4kmufcIZ0NM0p8dzjtoMv8SXhXcenHYVbhQLNcJUWVqIaMgkwOuxhI0vOHOb9/LsI6Qfas/m2xlk9ZwZTeB0VAer3lOLUiMXHgsSuEZB3nHiqVC5QiASiHdKGGG79wxZqAsizxe8JGwOZUqnhDChSmG5WUBmrrJd4BRlm4Bq/8F1hw+A8eaAqjclaMrCGFay8Re00+sA/6mzQXrOPneylP52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqaIMiH8TbN49joWofSwvTq0jDqNxEfCmuYOPNFOx8U=;
 b=FSkr4dE4F+o1LYiJlazV1nXcoWhUVMn4SIOB5j9EpR9wHZSpkqSr7BBVb/6OpfYIcMtkpsAghhwNn40+APdK8RKGN8NKF4MzkyCZ4HqPjPHOdO6dER7EmMK6oCzsELMg5GjlqwVREcvABKm13GJPwzUssC7L8ezkWK7Cc7deeRzoa0kmvdFokd2iY6gcg8N0I5kKbza6Wx8SCbcx//ppRwCLiqNovS4bFIx2mIP7uA4X6eAk4pvY8WyCjI/xuZwiokAM0RFbViRoXVLwOyqVYgezruYGTAxoMaD0oyecwKfPRWbKgQoAmtdtRgXP41lDFTnDoT1q4fFWGFF5l2Krsg==
Received: from MW2PR2101CA0007.namprd21.prod.outlook.com (2603:10b6:302:1::20)
 by BY5PR12MB4065.namprd12.prod.outlook.com (2603:10b6:a03:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:18:41 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::9) by MW2PR2101CA0007.outlook.office365.com
 (2603:10b6:302:1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.4 via Frontend
 Transport; Wed, 11 May 2022 09:18:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 09:18:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 11 May 2022 09:18:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 11 May 2022 02:18:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 02:18:40 -0700
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
Subject: Re: [PATCH 4.14 00/78] 4.14.278-rc1 review
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <07a3c885-d2f6-4aad-98b2-43cc6727e3e4@drhqmail203.nvidia.com>
Date:   Wed, 11 May 2022 02:18:40 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfbe261a-d283-4309-44d4-08da332f3d8b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4065:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB40656B5444E7D78793EA2905D9C89@BY5PR12MB4065.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6u3zTLGb5EXx5FAoP3nhiw+TMv/5Jx2vrkHiLA+qNRrmocTvYfGwwTiDVgY9nG6686szSiOJOPohD3hfg0/lTIJI3zZgH53StQ6vJTn2GSHzb9K+Gx5gaQhqxws5yWvketWwJftt3tZ88oTa4B4uG61htX4LWxXMp+86BJGx9pspKHEp/SKIXtb+WuvjJ6Yaz6SEI8huXSKE1k7oHqIbT6H0OONAJYB3eMSZVy1NG0tAzUWBWMJif4ZUfVdRWErjRismyB7TqeKd0cbTUSwtEFwsLFMOqrr15wVsjKzzP+G4ZLSiwV4N0yd0BfCGTTYZpBmmAqQKNwzFKiOQOAPrI0+isNZvR31GVCPBSgRZK7r7uqBnvdGhNnmXj107XxGIYkDZ38kYozHhBEWBqH4VfNwWng9AKzA4DPp8KG5OxwO3rnFfzwcercF1pfmMapTvOpV0TnH1wnP5uRBB24xCun+hIEWJlmVs4MlK9fA7iuRvh6OMZlDZ06rBALYW8PZckCulm2pJNKJe68op9oojotRZwn8ZgHhz9EfnabKTMqdaB/GKt+VdrMSHTuE0PyOEv5Ocn7DbcCcQqMmOdBiyaQV3WrG/jKqmMwLRgZJPEvE0v0545AJp2O3hbtdYntAd5DEizzGpUn/toallg7TfMOP96XBcF8LI8lCbDevDmhlUtqub04CfYoG6STtIpyU7emSfkcafUg7gzxPwcDzXnhAI9siRSMOrf/wsBS3ghkhQvWvPaZa3c6S+M25oQjSaYdmw8tdqOS2JnPA/dnQQO+/ufvF2jrGAeAk9ZKZS0sc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(70586007)(7416002)(2906002)(36860700001)(966005)(31696002)(31686004)(86362001)(508600001)(316002)(4326008)(8676002)(336012)(426003)(81166007)(356005)(40460700003)(26005)(8936002)(5660300002)(186003)(47076005)(82310400005)(54906003)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:18:41.4113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbe261a-d283-4309-44d4-08da332f3d8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4065
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 15:06:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.278 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.278-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.278-rc1-ga6b67a30bbcc
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
