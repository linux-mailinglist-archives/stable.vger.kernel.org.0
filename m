Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD614E9968
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiC1O0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbiC1O0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:26:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180CE1EECF;
        Mon, 28 Mar 2022 07:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1/mBImBhhveM8SZG5DjdLF2Pu11BDFU4R9J4dfpoA+fLymRflEST2aIzjLOBEf6GCRKa/mVukkpHehcJr/gWCH5E2RlXNKqcuIF8NZzIyG9mKS4V/OfwSSFVXoAa7ZDoiZISQBss4Ecrxu6taj1al4B/OU6Mx7T21TwzAbKDFf1tRJJLC7PXK2tCplsSrQir7yVTA3Tf7JKaIy/YklBhrTjiIJVF7JCuJFvicmgyB96cNr+7MydzsNaM0bGzHu9GsSZpQJwi4d9jmRqRz95ZMZPNICPDe3XsfPHpRd79spA3uX25FCmKRKn8mQwOrFjQEha2RcyEbgAjm3jenh86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBy+US8ejgjumVL3wdHyXLd95fjtt8Jk8/6jRNV/3nQ=;
 b=D2LjacscHjwsRuVz5F99XT0YGurMTi+zZBFT/lxx0/+3eyk5d4VKIPVMKri2ym0lIenq8Lsni7vDvFaQBqkmm/2DoX3PkFfVOTIIwwEImDX/dez3yHiaiwWy4nYhzhbkk6aMe7Bbp+3sI4b/LM5KDAlK8ZKCsTKBGBQVlTxQ20GoR4mysGwxXPMJtEpwvT0NYMz6CccaFf89Ui3R6ZQgqrZWAJ5UBp1P+n2L5B0Kq2yoGu3rtYc8+lLW9svU79jfox1fP50+dy56KEXGtWA2BB/L3mmelLQviCJGLn0BV0IkntusB53RBtsN0SjP0EEJIdQ9i/LP2bL9n7UpMsazaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBy+US8ejgjumVL3wdHyXLd95fjtt8Jk8/6jRNV/3nQ=;
 b=bXpRqRpQGcgC07z/jAbHvWa8DY4KwpaAq1/fbRPdnrb/gEIlj5WSc63/TavcAkL460ij2PDgfw1mpWfU++niFKtxJycmqODWT2PRSqQGVLO44HpEXaYynzDSd1uGKHK1W2BjFUq1X2eomWP//npHWpWx5dfjCZodAIKlL1rh/b3xqQTrl05IPUh1BNoJCtHLDHGIhFXkOgNqQzInknOVX1IrLCZG0toIzzqpeYfPmwS4mIraiqNARVPI0/r+1vR+FMG7w5rxYKsIWLa+Hcx0DHw+MlKJ1MS8c6kGxiCuh3jiQC+GFxVl8VomMFPUHrP9Tl5COJN74PT2xeJPTTGUyg==
Received: from DS7PR03CA0106.namprd03.prod.outlook.com (2603:10b6:5:3b7::21)
 by DM5PR1201MB0185.namprd12.prod.outlook.com (2603:10b6:4:55::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.21; Mon, 28 Mar
 2022 14:25:05 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::55) by DS7PR03CA0106.outlook.office365.com
 (2603:10b6:5:3b7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Mon, 28 Mar 2022 14:25:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Mon, 28 Mar 2022 14:25:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 28 Mar
 2022 14:25:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 07:25:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 28 Mar 2022 07:25:04 -0700
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
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2435d8b-82d0-4bfd-aaa5-c155cdb3621c@rnnvmail201.nvidia.com>
Date:   Mon, 28 Mar 2022 07:25:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b35aefaa-aa35-40d3-22ec-08da10c6c12f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0185:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0185C7A6F010AE137FC89F58D91D9@DM5PR1201MB0185.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6oi3GfV/F/XPuxOiX7kN77XsD3vF2imv/sLMXCYMKZHJzfaH4/ULN+fpgwbklYXQvgDMMJ1dcJqF9ECAnQdjgUus8qwMqI2An4GLjqWDIT9zQk4LxVghNguuQUYIiehTC1ECIVfRFG1EuTuj3IHVnXkASS4PEpNUDy+A4m1TvbqRYYblYx8088GxyhbOP7SPAuwyWPb4ggmSaeuC7kTVJ4tzJb1a7aXb7jpmGkyh2483H/l5GJmwCzE2Si5MyX1RAv1Hp8qNR6nbszeXQA0aD8i9pRjcGEZJVHI+JDCnfOP9bdzPjBqD25gYHvHqmIpcoK/VO2hOa+fhSJ3///nyBcp61I0CMV71/S8o1lOuMPPGLd4nF9o4jDlBg0A5GUEjvXM/LjW/oCxNEpDvOJrxHzj6lfGDII2RGOGvkRd5rKRodTLEnf37G216xnM93THL3wGoxwzyvYaV4VgkSFcQieGjFxbLlYJLgXOx3HRookaJ8X0zcmAD4Ga3zNy1raxYnKEqftLFbot5cIwv8k9o5pZ3RkSWI9xXQ1pxhetwJECHcHruFIs/gn706TdSJJ+Iix1NGiane2rMgiSIeZeqApginTmsuflqCPL2I83fjSUwh92FV0V3IMlt08+jCQ3A3NDqHmtlYJbFVRSh/xU+f8IC0ZEraVu/os+6aYnG82iqIsR/Ahr7phws3IHIYWHVA72iWRiNRfRFEgHoJx5C0Ra5chcmjJk3GetT9hSHMT71KiLBij9wQKukzBXaiz11QBRb8wL18MYYGVA7vlcF6NkHiOcaazfucHTdmKmQdE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400004)(70586007)(70206006)(8676002)(4326008)(356005)(81166007)(8936002)(316002)(40460700003)(54906003)(7416002)(5660300002)(6916009)(508600001)(47076005)(86362001)(966005)(2906002)(36860700001)(31696002)(186003)(31686004)(426003)(336012)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 14:25:05.5601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b35aefaa-aa35-40d3-22ec-08da10c6c12f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0185
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:14:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.18-rc1-gf6cd6b12e190
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
