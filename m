Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB56571581
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiGLJS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiGLJS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:18:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98D7823F;
        Tue, 12 Jul 2022 02:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Si7/mfJicwjd4sMTvYfjGIdaKmwKnr97jFKWr+k2rpUxX8gpheZF9pEg4eKFHrgUOAJBLdSTTqnHE7t6jt4nQQGkKn3e0eP/gp2mkXuQN17zYm4sM8fcakLrsEfCB3lF90Nx1LxFnMnhUWR+tb/7K01PYqnO4sGs8/+eNRGrv6QXmI/qRAOlGurTIJTMVI7lMv+q7EfStJcJgrubn4YRPE5eMArct2PfO3SSTUWT5wR/J2VuGRZVus7UWXl05qOBqAjRwXsO9Q2yBL78GLyxeLxJ1ZkKgSdKoMttdmYkICkr7r6shDSKVj47SrJYVjQoxKkWfJdKcjvAFv4dmj9Hlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSTpGPjEvK5w//KiuEc1ElFR52E1vuSkAomtw9rgJU0=;
 b=STIJOlnvpMhtZzSClFfNMfr40/TJNjpMT8CyLHJf61zz7QiCCKu19dtzocKZnB2/AcDB8zkbEPRET6mkIIXDnhnnm0nDSZkN+Q4sD8Pon6AW+to5K+5Y1UYnaw/MV2pRu+Jt0lAbiVvCCg2ImrQFWa9AbKzSdMaCLJL/R/jqiMVjzWY1iRTF8/PbuaSEfJ6IBRBgL9ltpzYrlZ7K3eNgw8Q7835Qx6ODEwclvdd7lBSnPW8elc0NoxqlAGQamM4QMvGDqMILyCZG37iOQziN7xCO/aGdH/QOKkeG47fT2rsRSxNoSUkAZIR4/ZxhNrUx3SmRMCYo3FVfeqoVExTEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSTpGPjEvK5w//KiuEc1ElFR52E1vuSkAomtw9rgJU0=;
 b=IQxjClrcyd5Sc1wVmrLvZPuzhZjVPWHQXiR8pBsOJQaWVPBfvTqglVMCaYOc++q+dqTxmJXL9EDN+7YxvLAHkOP7tZ1SXdwye46GoebS2WjwkyO8nqmK14YlDqVS2XYibbWLQX4xY7TBZBKt60S60PrCH8w4OUMWdtU9UKfYQlFlQhK9WPDpg0/AXwCNqNTKrfvRaHB/B5lWm7b0DOUtRnHAS6/dKIQjdJHwLVSaOMg+cHswFEWAt0VlirwwMsk6TxO5vGPuPxu6siBl/L24oEEWNMkRQmgMc/V0Iqf3ty6Zp9a0xUqMOqbrOGvuTE+6Aa4adNP6+d3DDzwiXZJ+ZQ==
Received: from DS7PR03CA0030.namprd03.prod.outlook.com (2603:10b6:5:3b8::35)
 by DM5PR12MB2520.namprd12.prod.outlook.com (2603:10b6:4:b9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Tue, 12 Jul
 2022 09:18:25 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::40) by DS7PR03CA0030.outlook.office365.com
 (2603:10b6:5:3b8::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Tue, 12 Jul 2022 09:18:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 12 Jul 2022 09:18:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 12 Jul 2022 02:18:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Tue, 12 Jul 2022 02:18:24 -0700
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
Subject: Re: [PATCH 4.9 00/14] 4.9.323-rc1 review
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <56c1bbfb-4fca-48d1-9ec4-974adf9366d5@drhqmail203.nvidia.com>
Date:   Tue, 12 Jul 2022 02:18:24 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f1bdc9e-37ab-4faa-749f-08da63e77995
X-MS-TrafficTypeDiagnostic: DM5PR12MB2520:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VfvCbY+knAtKFhWDJZfh0jdNEsjS84NQwBPaTsfIogbfBKZ1rKUlNRbTz5O6FYAqfj1rYOjId9Qwi61XlB5KiAtYXRjFwktU7vrG+BJ11r1CnmzL4VernOsx/KpI4A0BOr+1l5eKG3wQXOl4xlXb0sk1DXWx93hTEj/LDl1/DT41HPXO4jqkGvtmSnUQQOhnipE+Sw1Sy9/JmSAkxisEo/KpI9HdaNkophhuDUGNGxJfJgwGttl2YmEpDPPehaGkNDu6eBHQOcNZAB4bOtu3JJptM4nccvFemQPGkgkxEPBBwu0h/HodkP9vzZwXlw6sDg0N28uv3E2qS8J6OfvimAqHyRALvUn42mTvgQcAw825BfkIPUBtAEEtfmhqyKEtyUk18JdT6+0bccl8nnDWtDA2z061PQtyTiLA+sETPJ8WTzXM6DHxpXPUgHnyjQKPMzjsMeDxZ+lk0etyf2lObAmKL97+7u+y4FAREN9cQrBn83eHXBkxNCQwSnprPorW3Cs//1BVnrfrAG87FZYQ8m3OBfaZ1XkOgsQ1kH9os548Qhpwhg+BwGK5Nxk85JJkcjhjcL3KGlQ2YnSL8cV2Y3mwkSRKUea1ZhM3RFSIqthKK62hUmdZUX5ZEVPjzhOH38szvu88z0m/XecxJOVE7JbK7aP5VsCLGpaSAvFIyDFSZMASjhwy4m0gMIbMJbAl6MjPaMXCu7yegmPNIzju93ihxj/jvBmCm6PY3rdwBbYjaSK9w/dXy15x9sMRyTxHmDID9sotVBme/IVR3vtrbfNWYYQB0FawlSvKuc3stsat7XoStDPyiSDAnSHmx168cQS2+PW5oRAA8JaG1xCrF/xrkFwWSrFLBTBC1KNAffadNB6AnNxqU+YPvKeGwN7gdn4pD/zmttgXjoyu4qvrQC4+XydhbeBByeWDPbprNg26dZBfwRlZycM1Sli54wR3
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(46966006)(40470700004)(36840700001)(40480700001)(82740400003)(86362001)(26005)(8936002)(7416002)(36860700001)(31686004)(54906003)(6916009)(41300700001)(40460700003)(5660300002)(2906002)(70586007)(316002)(70206006)(8676002)(81166007)(426003)(4326008)(336012)(478600001)(966005)(31696002)(47076005)(186003)(356005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:18:25.3529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1bdc9e-37ab-4faa-749f-08da63e77995
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2520
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 11:06:19 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.323 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.323-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.323-rc1-g7df08530a33b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
